//
//  RJAudioPlayerController.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioPlayerController.h"

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
        [self.controlView showTitle:@"" playerIcon:nil currentTime:player.currentTime totalTime:player.totalTime];
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
    
}

- (void)audioPlayer:(RJAudioPlayer *)player failedToPlayToEndTimeWithURL:(NSURL *)url error:(NSError *)error {
    
}

#pragma mark - RJAudioPlayerControlViewDelegate Methods

- (void)controlView:(RJAudioPlayerControlView *)controlView didClickPlayOrPauseButton:(BOOL)isPlay {
    if (isPlay) {
        if (self.currentPlayer.playbackState == RJAudioPlayerPlaybackStatePaused) {
            [self.currentPlayer resume];
        } else {
            [self.currentPlayer play];
        }
        
    } else {
        [self.currentPlayer pause];
    }
}

- (void)controlViewDidClickNextButton:(RJAudioPlayerControlView *)controlView {
    
}

- (void)controlViewDidClickPreviousButton:(RJAudioPlayerControlView *)controlView {
    
}

- (void)controlViewDidClickDownloadButton:(RJAudioPlayerControlView *)controlView {
    
}

- (void)controlViewDidClickPlayOrderButton:(RJAudioPlayerControlView *)controlView playOrder:(RJAudioPlayOrder)playOrder {
    
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
