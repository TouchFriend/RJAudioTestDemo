//
//  RJAudioPlayer.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/30.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface RJAudioPlayer ()

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
    self.player = nil;
}

#pragma mark - Public Methods

- (void)playWithURL:(NSURL *)url {
    [self stop];
    _url = url;
    [self play];
}

- (void)play {
    [self stop];
    if (!self.url || self.url.absoluteString.length == 0) {
        return;
    }
    
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
    
    self.playerItem = [AVPlayerItem playerItemWithURL:self.url];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    
    [self addNotificationObserver];
    __weak typeof(self) weakSelf = self;
    // 播放进度改变回调
    CMTime interval = CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC);
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:self.timeObserverQueue usingBlock:^(CMTime time) {
        
        NSTimeInterval currentTime = CMTimeGetSeconds(time);
        NSTimeInterval totalTime = weakSelf.totalTime;
        if (!isnan(currentTime)&& !isnan(totalTime)) {
            if ([weakSelf.delegate respondsToSelector:@selector(audioPlayer:currentTime:totalTime:)]) {
                [weakSelf.delegate audioPlayer:weakSelf currentTime:currentTime totalTime:totalTime];
            }
        }
        
    }];
    
    if ([self.delegate respondsToSelector:@selector(audioPlayer:beginPlayWithURL:)]) {
        [self.delegate audioPlayer:self beginPlayWithURL:self.url];
    }
    
    [self.player play]; // 播放
    // 标记为正在播放
    _playing = YES;
}

- (void)pause {
    if (!_playing) {
        return;
    }
    
    [self.player pause];
    _playing = NO;
    if ([self.delegate respondsToSelector:@selector(audioPlayer:didPausedPlayWithURL:)]) {
        [self.delegate audioPlayer:self didPausedPlayWithURL:self.url];
    }
}

- (void)resume {
    if (_playing) {
        return;
    }
    
    [self.player play];
    _playing = YES;
    if ([self.delegate respondsToSelector:@selector(audioPlayer:didResumedPlayWithURL:)]) {
        [self.delegate audioPlayer:self didResumedPlayWithURL:self.url];
    }
}

- (void)stop {
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    
    if (_playing) {
        _playing = NO;
        if ([self.delegate respondsToSelector:@selector(audioPlayer:didStopedPlayWithURL:)]) {
            [self.delegate audioPlayer:self didStopedPlayWithURL:self.url];
        }
    }
    
    [self removeNotificationObserver];
    self.playerItem = nil;
    
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
    
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL finished))completionHandler {
    CMTime seekTime = CMTimeMake(time, 1);
    [self.player seekToTime:seekTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
}

#pragma mark - Private Methods

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

#pragma mark - Target Methods

- (void)didPlayeToEndTime {
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


@end
