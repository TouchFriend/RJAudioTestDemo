//
//  RJAudioPlayer.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/30.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

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
/// 是否已经注册KVO观察者
@property (nonatomic, assign, getter=isRegistedObserver) BOOL registedKVO_Observer;
/// 是否准备好去播放
@property (nonatomic, assign) BOOL isReadyToPlay;
/// 是否正在缓存
@property (nonatomic, assign) BOOL isBuffering;


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
        _registedKVO_Observer = NO;
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
    _isReadyToPlay = NO;
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
    if (self.totalTime > 0) {
        CMTime seekTime = CMTimeMake(time, 1);
        [self.player seekToTime:seekTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
    } else {
        self.seekTime = time;
    }
    
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
    if (self.registedKVO_Observer) {
        [self removeItemObserving];
    }
    
    [self addKVO_Observer];
    
    __weak typeof(self) weakSelf = self;
    // 播放进度改变回调
    CMTime interval = CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC);
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:self.timeObserverQueue usingBlock:^(CMTime time) {
        
        NSArray<NSValue *> *loadedTimeRanges = weakSelf.playerItem.loadedTimeRanges;
        if (loadedTimeRanges.count > 0) {
            if ([weakSelf.delegate respondsToSelector:@selector(audioPlayerPlayTimeChanged:currentTime:totalTime:)]) {
                [weakSelf.delegate audioPlayerPlayTimeChanged:weakSelf currentTime:weakSelf.currentTime totalTime:weakSelf.totalTime];
            }
        }
    }];
    
    [self addNotificationObserver];
}

- (void)removeItemObserving {
    if (self.registedKVO_Observer) {
        [self removeKVO_Observer];
    }
    
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
    [self removeNotificationObserver];
}

/// 添加KVO观察者
- (void)addKVO_Observer {
    [_playerItem addObserver:self forKeyPath:RJPlayerItemObserverStatusKey options:NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:RJPlayerItemObserverLoadedTimeRangesKey options:NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:RJPlayerItemObserverPlaybackBufferEmptyKey options:NSKeyValueObservingOptionNew context:nil];
    [_playerItem addObserver:self forKeyPath:RJPlayerItemObserverPlaybackLikelyToKeepUpKey options:NSKeyValueObservingOptionNew context:nil];
    self.registedKVO_Observer = YES;
}

/// 移除KVO观察者
- (void)removeKVO_Observer {
    [_playerItem removeObserver:self forKeyPath:RJPlayerItemObserverStatusKey];
    [_playerItem removeObserver:self forKeyPath:RJPlayerItemObserverLoadedTimeRangesKey];
    [_playerItem removeObserver:self forKeyPath:RJPlayerItemObserverPlaybackBufferEmptyKey];
    [_playerItem removeObserver:self forKeyPath:RJPlayerItemObserverPlaybackLikelyToKeepUpKey];
    self.registedKVO_Observer = NO;
}

- (void)addNotificationObserver {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didPlayeToEndTime) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
}

- (void)removeNotificationObserver {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyPath isEqualToString:RJPlayerItemObserverStatusKey]) {
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                if (!self.isReadyToPlay) {
                    self.isReadyToPlay = YES;
                    self.loadState = RJAudioPlayerLoadStatePlayThroughOK;
                    if ([self.delegate respondsToSelector:@selector(audioPlayer:readyToPlayForURL:)]) {
                        [self.delegate audioPlayer:self readyToPlayForURL:self.url];
                    }
                }

                if (self.seekTime) {
                    if (self.shouldAutoPlay) {
                        [self.player pause];
                    }
                    [self seekToTime:self.seekTime completionHandler:^(BOOL finished) {
                        if (finished && self.shouldAutoPlay) {
                            [self play];
                        }
                    }];
                    self.seekTime = 0;
                }
//                else if (self.shouldAutoPlay) {
//                    [self play];
//                }
                NSArray<NSValue *> *loadedTimeRanges = self.player.currentItem.loadedTimeRanges;
                if (loadedTimeRanges.count > 0) {
                    if ([self.delegate respondsToSelector:@selector(audioPlayerPlayTimeChanged:currentTime:totalTime:)]) {
                        [self.delegate audioPlayerPlayTimeChanged:self currentTime:self.currentTime totalTime:self.totalTime];
                    }
                }
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
                self.playbackState =  RJAudioPlayerPlaybackStatePlayFailed;
                self->_playing = NO;
                NSError *error = self.player.currentItem.error;
                if ([self.delegate respondsToSelector:@selector(audioPlayer:playFailedForURL:error:)]) {
                    [self.delegate audioPlayer:self playFailedForURL:self.url error:error];
                }
            }
        } else if ([keyPath isEqualToString:RJPlayerItemObserverLoadedTimeRangesKey]) {
            NSTimeInterval bufferTime = [self availableBufferDuration];
            NSLog(@"缓存时间改变:%lf", bufferTime);
            self->_bufferTime = bufferTime;
            if ([self.delegate respondsToSelector:@selector(audioPlayerBufferTimeDidChanged:bufferTime:)]) {
                [self.delegate audioPlayerBufferTimeDidChanged:self bufferTime:bufferTime];
            }
        } else if ([keyPath isEqualToString:RJPlayerItemObserverPlaybackBufferEmptyKey]) {
            if (self.playerItem.playbackBufferEmpty) {
                self.playbackState = RJAudioPlayerLoadStateStalled;
                [self bufferingSomeSecond];
            }
        } else if ([keyPath isEqualToString:RJPlayerItemObserverPlaybackLikelyToKeepUpKey]) {
            if (self.playerItem.playbackLikelyToKeepUp) {
                self.loadState = RJAudioPlayerLoadStatePlayable;
                if (self.isPlaying) {
                    [self.player play];
                }
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

/// 缓存几秒
- (void)bufferingSomeSecond {
    if (self.isBuffering || self.playbackState == RJAudioPlayerPlaybackStatePlayStopped) {
        return;
    }
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        return;
    }
    
    self.isBuffering = YES;
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (!self.isPlaying && self.loadState == RJAudioPlayerLoadStateStalled) {
            self.isBuffering = NO;
            return;
        }
        
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        self.isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) {
            [self bufferingSomeSecond];
        }
    });
}


#pragma mark - Target Methods

- (void)didPlayeToEndTime {
    self.playbackState = RJAudioPlayerPlaybackStatePlayStopped;
    if ([self.delegate respondsToSelector:@selector(audioPlayer:didPlayeToEndTimeWithURL:)]) {
        [self.delegate audioPlayer:self didPlayeToEndTimeWithURL:self.url];
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
