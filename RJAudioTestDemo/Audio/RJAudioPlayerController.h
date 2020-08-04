//
//  RJAudioPlayerController.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RJAudioPlayer.h"
#import "RJAudioPlayerControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RJAudioPlayerController : NSObject

/// 容器view
@property (nonatomic, strong) UIView *containerView;
/// 播放器
@property (nonatomic, strong) RJAudioPlayer *currentPlayer;
/// 控制view
@property (nonatomic, strong, readonly) RJAudioPlayerControlView *controlView;

+ (instancetype)playerWithPlayer:(RJAudioPlayer *)player containerView:(UIView *)containerView;

- (instancetype)initWithPlayer:(RJAudioPlayer *)player containerView:(UIView *)containerView;


@end

NS_ASSUME_NONNULL_END
