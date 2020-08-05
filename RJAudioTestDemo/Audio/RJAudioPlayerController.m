//
//  RJAudioPlayerController.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioPlayerController.h"
#import "RJAudioRemoteControlHelper.h"

@interface RJAudioPlayerController () <RJAudioPlayerDelegate, RJAudioPlayerControlViewDelegate> {
    RJAudioPlayerControlView *_controlView;
}

@end

@implementation RJAudioPlayerController

#pragma mark - Init Methods

+ (instancetype)playerWithPlayer:(RJAudioPlayer *)player containerView:(UIView *)containerView {
    return [[self alloc] initWithPlayer:player containerView:containerView];
}

- (instancetype)initWithPlayer:(RJAudioPlayer *)player containerView:(UIView *)containerView {
    self = [self init];
    if (self) {
        self.currentPlayer = player;
        self.containerView = containerView;
    }
    return self;
}

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Private Methods

- (void)layoutPlayerSubviews {
    if (!self.containerView) {
        return;
    }
    
    [self.containerView addSubview:self.controlView];
    self.controlView.frame = self.containerView.bounds;
    self.controlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - RJAudioPlayerDelegate Methods

- (void)audioPlayer:(RJAudioPlayer *)player currentTime:(NSTimeInterval)current totalTime:(NSTimeInterval)total {
    [self.controlView currentTime:current totalTime:total];
    [RJAudioRemoteControlHelper setupLockScreenMediaInfo:self];
}

- (void)audioPlayer:(RJAudioPlayer *)player beginPlayWithURL:(NSURL *)url {
    [self.controlView play];
}

- (void)audioPlayer:(RJAudioPlayer *)player didPausedPlayWithURL:(NSURL *)url {
    [self.controlView pause];
}

- (void)audioPlayer:(RJAudioPlayer *)player didResumedPlayWithURL:(NSURL *)url {
    [self.controlView play];
}

- (void)audioPlayer:(RJAudioPlayer *)player didStopedPlayWithURL:(NSURL *)url {
    [self.controlView pause];
}

- (void)audioPlayer:(RJAudioPlayer *)player didPlayeToEndTimeWithURL:(NSURL *)url {
    if (self.playOrder == RJAudioPlayOrderSingleCircle) {
        [self play];
        return;
    }
    [self playNextSong];
}

- (void)audioPlayer:(RJAudioPlayer *)player failedToPlayToEndTimeWithURL:(NSURL *)url error:(NSError *)error {
    NSLog(@"播放出错, %@ error:%@", url, error);
}

#pragma mark - RJAudioPlayerControlViewDelegate Methods

- (void)controlView:(RJAudioPlayerControlView *)controlView didClickPlayOrPauseButton:(BOOL)isPlay {
    if (isPlay) {
        if (self.currentPlayer.playbackState == RJAudioPlayerPlaybackStatePaused) {
            [self.currentPlayer resume];
        } else {
            [self play];
        }
        
    } else {
        [self.currentPlayer pause];
    }
}

- (void)controlViewDidClickNextButton:(RJAudioPlayerControlView *)controlView {
    [self playNextSong];
}

- (void)controlViewDidClickPreviousButton:(RJAudioPlayerControlView *)controlView {
    [self playPreviousSong];
}

- (void)controlViewDidClickDownloadButton:(RJAudioPlayerControlView *)controlView {
    
}

- (void)controlViewDidClickPlayOrderButton:(RJAudioPlayerControlView *)controlView playOrder:(RJAudioPlayOrder)playOrder {
    self.playOrder = playOrder;
}

- (void)controlViewDidClickPlayMenuButton:(RJAudioPlayerControlView *)controlView {
    
}

- (void)controlView:(RJAudioPlayerControlView *)controlView sliderDidTapped:(CGFloat)value {
    NSTimeInterval time = self.currentPlayer.totalTime * value;
    [self.currentPlayer seekToTime:time completionHandler:^(BOOL finished) {
        NSLog(@"滑动条跳跃:%@", finished ? @"成功" : @"失败");
    }];
}

- (void)controlView:(RJAudioPlayerControlView *)controlView sliderValueDidChanged:(CGFloat)value {
    
}

- (void)controlView:(RJAudioPlayerControlView *)controlView sliderTouchDidEnded:(CGFloat)value completionHandler:(void (^)(BOOL finished))completionHandler  {
    NSTimeInterval time = self.currentPlayer.totalTime * value;
    [self.currentPlayer seekToTime:time completionHandler:^(BOOL finished) {
        completionHandler(finished);
        NSLog(@"滑动条拖拽:%@", finished ? @"成功" : @"失败");
    }];
}

#pragma mark - Public Methods

- (RJAudioAssertItem *)currentAssertItem {
    if (self.audioAsserts.count == 0) {
        return nil;
    }
    
    return self.audioAsserts[_currentPlayIndex];
}

- (void)play {
    if (self.audioAsserts.count == 0) {
        return;
    }
    
    RJAudioAssertItem *item = self.audioAsserts[self.currentPlayIndex];
    [self.currentPlayer playWithURL:item.assertURL];
    [self.controlView showTitle:item.title albumURL:item.albumIconURL];
}

- (void)playNextSong {
    if (self.audioAsserts.count == 0) {
        return;
    }
    NSInteger count = self.audioAsserts.count;
#warning 暂时这样实现随机播放
    if (self.playOrder == RJAudioPlayOrderRandom) {
        _currentPlayIndex = [self randomPlayIndex:count current:_currentPlayIndex];
    } else {
        _currentPlayIndex = MAX((self.currentPlayIndex + 1) % count, 0);
    }
    
    [self playWithIndex:_currentPlayIndex];
}

- (NSUInteger)randomPlayIndex:(NSUInteger)count current:(NSInteger)current {
    NSInteger newIndex = current;
    while (newIndex == current) {
        newIndex = arc4random_uniform(count);
    }
    return newIndex;
}

- (void)playPreviousSong {
    if (self.audioAsserts.count == 0) {
        return;
    }
    
    NSInteger count = self.audioAsserts.count;
    if (self.playOrder == RJAudioPlayOrderRandom) {
        _currentPlayIndex = [self randomPlayIndex:count current:_currentPlayIndex];
    } else {
        _currentPlayIndex = MAX((self.currentPlayIndex - 1  + count) % count, 0);
    }
    
    [self playWithIndex:_currentPlayIndex];
}

- (void)playWithIndex:(NSInteger)index {
    if (self.audioAsserts.count == 0 || index < 0 || index >= self.audioAsserts.count) {
        return;
    }
    
    _currentPlayIndex = index;
    [self play];
}

#pragma mark - Property Methods

- (void)setContainerView:(UIView *)containerView {
    _containerView = containerView;
    if (!containerView) {
        return;
    }
    
    containerView.userInteractionEnabled = YES;
    [self layoutPlayerSubviews];
}



#pragma mark - Property Methods

- (RJAudioPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[RJAudioPlayerControlView alloc] init];
        _controlView.delegate = self;
    }
    return _controlView;
}

- (void)setCurrentPlayer:(RJAudioPlayer *)currentPlayer {
    _currentPlayer = currentPlayer;
    currentPlayer.delegate = self;
}

@end
