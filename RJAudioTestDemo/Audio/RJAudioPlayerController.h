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
#import "RJAudioAssertItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface RJAudioPlayerController : NSObject

/// modal播放列表的控制器
@property (nonatomic, weak) UIViewController *viewController;
/// 容器view
@property (nonatomic, strong) UIView *containerView;
/// 播放器
@property (nonatomic, strong) RJAudioPlayer *currentPlayer;
/// 控制view
@property (nonatomic, strong, readonly) RJAudioPlayerControlView *controlView;
/// 音频资源
@property (nonatomic, strong) NSArray<RJAudioAssertItem *> *audioAsserts;

/// 当前播放索引，默认为0
@property (nonatomic, assign, readonly) NSInteger currentPlayIndex;
/// 播放顺序
@property (nonatomic, assign) RJAudioPlayOrder playOrder;


+ (instancetype)playerWithPlayer:(RJAudioPlayer *)player viewController:(UIViewController *)viewController containerView:(UIView *)containerView;

- (instancetype)initWithPlayer:(RJAudioPlayer *)player viewController:(UIViewController *)viewController containerView:(UIView *)containerView;

- (RJAudioAssertItem *)currentAssertItem;

- (void)play;

- (void)playNextSong;

- (void)playPreviousSong;

- (void)playWithIndex:(NSInteger)index;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
