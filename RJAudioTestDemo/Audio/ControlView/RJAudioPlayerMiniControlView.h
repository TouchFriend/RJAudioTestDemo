//
//  RJAudioPlayerMiniControlView.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/12.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const RJMiniControlViewMargin;

@class RJAudioPlayerMiniControlView;

@protocol RJAudioPlayerMiniControlViewDelegate <NSObject>

@optional

- (void)miniControlViewDidTapped:(RJAudioPlayerMiniControlView *_Nonnull)controlView;

- (void)miniControlView:(RJAudioPlayerMiniControlView *_Nonnull)controlView didClickPlayOrPauseButton:(BOOL)isPlay;

- (void)miniControlViewDidClosed:(RJAudioPlayerMiniControlView *_Nonnull)controlView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RJAudioPlayerMiniControlView : UIView

/// 代理
@property (nonatomic, weak) id <RJAudioPlayerMiniControlViewDelegate> delegate;
/// 进度
@property (nonatomic, assign) CGFloat progress;
/// <#Desription#>
@property (nonatomic, assign) BOOL isPlaying;


- (void)show;

- (void)dismiss;

- (void)hidden;

- (void)play;

- (void)pause;

@end

NS_ASSUME_NONNULL_END
