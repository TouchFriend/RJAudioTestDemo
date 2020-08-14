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
#import "RJAudioPlayerMiniControlView.h"
#import "RJAudioPlayerViewControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RJAudioPlayerController : NSObject

/// 要modal的
@property (nonatomic, strong) Class <RJAudioPlayerViewControllerProtocol> modalViewControllerClass;

/// modal播放列表的控制器
@property (nonatomic, weak, nullable) UIViewController <RJAudioPlayerViewControllerProtocol> *viewController;
/// 容器view
@property (nonatomic, strong, nullable) UIView *containerView;
/// 播放器
@property (nonatomic, strong, nullable) RJAudioPlayer *currentPlayer;
/// 控制view
@property (nonatomic, strong, readonly) RJAudioPlayerControlView *controlView;
/// mini控制view
@property (nonatomic, strong, readonly) RJAudioPlayerMiniControlView *miniControlView;
/// 音频资源
@property (nonatomic, strong) NSArray<RJAudioAssertItem *> *audioAsserts;

/// 当前播放索引，默认为0
@property (nonatomic, assign, readonly) NSInteger currentPlayIndex;
/// 播放顺序
@property (nonatomic, assign) RJAudioPlayOrder playOrder;


+ (instancetype)playerWithPlayer:(RJAudioPlayer *_Nullable)player viewController:(UIViewController *_Nullable)viewController containerView:(UIView *_Nullable)containerView;

- (instancetype)initWithPlayer:(RJAudioPlayer *_Nullable)player viewController:(UIViewController *_Nullable)viewController containerView:(UIView *_Nullable)containerView;

/// 单例
+ (instancetype)sharedInstance;

- (RJAudioAssertItem *)currentAssertItem;

- (void)play;

- (void)playOrResume;

- (void)playNextSong;

- (void)playPreviousSong;

- (void)playWithIndex:(NSInteger)index;

- (void)pause;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
