//
//  RJAudioPlayer.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/30.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

static NSString * const RJPlayerItemObserverStatusKey = @"status";
static NSString * const RJPlayerItemObserverLoadedTimeRangesKey = @"loadedTimeRanges";
static NSString * const RJPlayerItemObserverPlaybackBufferEmptyKey = @"playbackBufferEmpty";
static NSString * const RJPlayerItemObserverPlaybackLikelyToKeepUpKey = @"playbackLikelyToKeepUp";

@interface RJAudioPlayer ()

/// url资源
@property (nonatomic, strong) AVURLAsset *urlAsset;
/// 播放器模型
@property (nonatomic, strong) AVPlayerItem *playerItem;
/// 播放器
@property (nonatomic, strong) AVPlayer *player;
/// 时间观察者
@property (nonatomic, strong) id timeObserver;


@end

@implementation RJAudioPlayer

#pragma mark - Init Methods

+ (instancetype)player {
    return [self playerWithURL:nil];
}

+ (instancetype)playerWithURL:(NSURL *)url {
    return [[self alloc] initWithURL:url];
}

#pragma mark - Life Cycle

- (instancetype)initWithURL:(NSURL *)url {
    self = [self init];
    if (self) {
        _url = url;
        _shouldAutoPlay = YES;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _playing = NO;
        _timeObserverQueue = NULL;
    }
    return self;
}

- (void)dealloc {
    [self stop];
}

#pragma mark - Public Methods

- (void)playWithURL:(NSURL *)url {
    if (self.player) {
        [self stop];
    }
    _url = url;
    [self prepareToPlay];
}

- (void)prepareToPlay {
    if (!self.url || self.url.absoluteString.length == 0) {
        return;
    }
    
    _isPreparedToPlay = YES;
    [self initializePlayer];
    
    if (self.shouldAutoPlay) {
        [self play]; // 自动播放
    }
    self.loadState = RJAudioPlayerLoadStatePrepare;
}

- (void)play {
    if (!_isPreparedToPlay) {
        [self prepareToPlay];
    } else {
        [self.player play]; // 播放
        // 标记为正在播放
        _playing = YES;
        self.playbackState = RJAudioPlayerPlaybackStatePlaying;
    }
}

- (void)pause {
    [self.player pause];
    _playing = NO;
    self.playbackState = RJAudioPlayerPlaybackStatePaused;
    [_playerItem cancelPendingSeeks];
    [_urlAsset cancelLoading];
}

- (void)stop {
    [self removeItemObserving]; // 移除监听
    self.playbackState = RJAudioPlayerPlaybackStatePlayStopped;
    self.loadState = RJAudioPlayerLoadStateUnknow;
    if (self.player.rate != 0) {
        [self.player pause];
    }
    [_playerItem cancelPendingSeeks];
    [_urlAsset cancelLoading];
    
    [self.player replaceCurrentItemWithPlayerItem:nil];
    _playing = NO;
    _isPreparedToPlay = NO;
    _urlAsset = nil;
    _playerItem = nil;
    _player = nil;
    _bufferTime = 0;
}

- (void)replay {
    __weak typeof(self) weakSelf = self;
    [self seekToTime:0 completionHandler:^(BOOL finished) {
        if (finished) {
            [weakSelf play];
        }
    }];
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL finished))completionHandler {
    CMTime seekTime = CMTimeMake(time, 1);
    [self.player seekToTime:seekTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
}

#pragma mark - Private Methods

- (void)initializePlayer {
    // 设置后台播放
    NSError *categoryError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&categoryError];
    if (categoryError) {
        NSLog(@"AVAudioSession设置AVAudioSessionCategoryPlayback失败:%@", categoryError);
        return;
    }
    
    NSError *audioSessionActiveError = nil;
    [[AVAudioSession sharedInstance] setActive:YES error:&audioSessionActiveError];
    if (audioSessionActiveError) {
        NSLog(@"AVAudioSession启动失败:%@", audioSessionActiveError);
        return;
    }
    
    self.urlAsset = [AVURLAsset URLAssetWithURL:self.url options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    
    if (@available(iOS 10.0, *)) {
        self.playerItem.preferredForwardBufferDuration = 5.0; // 缓存几秒开始播放
    }
    self.playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = NO; // 停止时不允许加载
    
    [self addItemObserving]; // 监听值改变
}

- (void)addItemObserving {
    [_playerItem addObserver:self forKeyPath:RJPlayerItemObserverLoadedTimeRangesKey options:NSKeyValueObservingOptionNew context:nil];
    
    __weak typeof(self) weakSelf = self;
    // 播放进度改变回调
    CMTime interval = CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC);
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:self.timeObserverQueue usingBlock:^(CMTime time) {
        
        NSArray<NSValue *> *loadedTimeRanges = weakSelf.playerItem.loadedTimeRanges;
        if (loadedTimeRanges.count > 0) {
            if ([weakSelf.delegate respondsToSelector:@selector(audioPlayer:currentTime:totalTime:)]) {
                [weakSelf.delegate audioPlayer:weakSelf currentTime:weakSelf.currentTime totalTime:weakSelf.totalTime];
            }
        }
    }];
    [self addNotificationObserver];
    
}

- (void)removeItemObserving {
    [_playerItem removeObserver:self forKeyPath:RJPlayerItemObserverLoadedTimeRangesKey];
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
    [self removeNotificationObserver];
}

- (void)addNotificationObserver {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didPlayeToEndTime) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [center addObserver:self selector:@selector(failedToPlayToEndTime:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.playerItem];
}

- (void)removeNotificationObserver {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [center removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.playerItem];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyPath isEqualToString:RJPlayerItemObserverLoadedTimeRangesKey]) {
            NSTimeInterval bufferTime = [self availableBufferDuration];
            NSLog(@"缓存时间改变:%lf", bufferTime);
            self->_bufferTime = bufferTime;
            if ([self.delegate respondsToSelector:@selector(audioPlayer:bufferTimeDidChange:)]) {
                [self.delegate audioPlayer:self bufferTimeDidChange:bufferTime];
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    });
}


/// 计算缓冲进度
- (NSTimeInterval)availableBufferDuration{
    NSArray<NSValue *> *loadedTimeRanges = _playerItem.loadedTimeRanges;
    CMTime currentTime = [_player currentTime];
    BOOL foundRange = NO;
    CMTimeRange timeRange = {0};
    if (loadedTimeRanges.count > 0) {
        timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        if (CMTimeRangeContainsTime(timeRange, currentTime)) {
            foundRange = YES;
        }
    }
    
    if (foundRange) {
        CMTime maxTime = CMTimeRangeGetEnd(timeRange);
        NSTimeInterval playableDuration = CMTimeGetSeconds(maxTime);
        if (playableDuration > 0) {
            return playableDuration;
        }
    }
    return 0;
}






#pragma mark - Target Methods

- (void)didPlayeToEndTime {
    self.playbackState = RJAudioPlayerPlaybackStatePlayStopped;
    if ([self.delegate respondsToSelector:@selector(audioPlayer:didPlayeToEndTimeWithURL:)]) {
        [self.delegate audioPlayer:self didPlayeToEndTimeWithURL:self.url];
    }
}

- (void)failedToPlayToEndTime:(NSNotification *)notification {
    NSError *error = notification.userInfo[AVPlayerItemFailedToPlayToEndTimeErrorKey];
    if ([self.delegate respondsToSelector:@selector(audioPlayer:failedToPlayToEndTimeWithURL:error:)]) {
        [self.delegate audioPlayer:self failedToPlayToEndTimeWithURL:self.url error:error];
    }
}

#pragma mark - Property Methods

- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:nil];
    }
    return _player;
}

- (NSTimeInterval)totalTime {
    NSTimeInterval time = CMTimeGetSeconds(self.player.currentItem.duration);
    if (isnan(time)) {
        return 0;
    }
    
    return time;
}

- (NSTimeInterval)currentTime {
    NSTimeInterval time = CMTimeGetSeconds(self.player.currentItem.currentTime);
    if (isnan(time) || time < 0) {
        return 0;
    }
    
    return time;
}

- (void)setPlaybackState:(RJAudioPlayerPlaybackState)playbackState {
    _playbackState = playbackState;
    if ([self.delegate respondsToSelector:@selector(audioPlayer:forURL:playStateChanged:)]) {
        [self.delegate audioPlayer:self forURL:self.url playStateChanged:playbackState];
    }
}

- (void)setLoadState:(RJAudioPlayerLoadState)loadState {
    _loadState = loadState;
    if ([self.delegate respondsToSelector:@selector(audioPlayer:forURL:loadStateChanged:)]) {
        [self.delegate audioPlayer:self forURL:self.url loadStateChanged:loadState];
    }
}

@end
