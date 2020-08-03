//
//  RJAudioPlayerController.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioPlayerController.h"

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

#pragma mark - Property Methods

- (void)setContainerView:(UIView *)containerView {
    _containerView = containerView;
    if (!containerView) {
        return;
    }
    
    containerView.userInteractionEnabled = YES;
    [self layoutPlayerSubviews];
}

- (void)setControlView:(RJAudioPlayerControlView *)controlView {
    if (controlView && controlView != _controlView) {
        [_controlView removeFromSuperview];
    }
    _controlView = controlView;
    if (!controlView) {
        return;
    }
    
    [self layoutPlayerSubviews];
}

@end
