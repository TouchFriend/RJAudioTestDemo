//
//  RJAudioPlayerControlView.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/31.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJAudioGlobalConst.h"

@class RJAudioPlayerControlView;

@protocol RJAudioPlayerControlViewDelegate <NSObject>

@optional

- (void)controlViewDidClickBackButton:(RJAudioPlayerControlView *_Nonnull)controlView;

- (void)controlView:(RJAudioPlayerControlView *_Nonnull)controlView didClickPlayOrPauseButton:(BOOL)isPlay;

- (void)controlViewDidClickNextButton:(RJAudioPlayerControlView *_Nonnull)controlView;

- (void)controlViewDidClickPreviousButton:(RJAudioPlayerControlView *_Nonnull)controlView;

- (void)controlViewDidClickDownloadButton:(RJAudioPlayerControlView *_Nonnull)controlView;

- (void)controlViewDidClickPlayOrderButton:(RJAudioPlayerControlView *_Nonnull)controlView playOrder:(RJAudioPlayOrder)playOrder;

- (void)controlViewDidClickPlayMenuButton:(RJAudioPlayerControlView *_Nonnull)controlView;

- (void)controlView:(RJAudioPlayerControlView *_Nonnull)controlView sliderDidTapped:(CGFloat)value;

- (void)controlView:(RJAudioPlayerControlView *_Nonnull)controlView sliderValueDidChanged:(CGFloat)value;

- (void)controlView:(RJAudioPlayerControlView *_Nonnull)controlView sliderTouchDidEnded:(CGFloat)value completionHandler:(void (^_Nonnull)(BOOL finished))completionHandler;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RJAudioPlayerControlView : UIView

/// 代理
@property (nonatomic, weak) id <RJAudioPlayerControlViewDelegate> delegate;
/// 播放顺序
@property (nonatomic, assign) RJAudioPlayOrder playOrder;
/// 全部时间
@property (nonatomic, assign) NSTimeInterval totalTime;

- (void)showTitle:(NSString *)title albumURL:(NSURL *)albumURL;

- (void)showTitle:(NSString *)title albumURL:(NSURL *)albumURL currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime bufferTime:(NSTimeInterval)bufferTime;

- (void)showTitle:(NSString *)title albumURL:(NSURL *)albumURL placeholder:(UIImage * _Nullable)placeholder currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime bufferTime:(NSTimeInterval)bufferTime;

- (void)changeCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;

- (void)changeBufferTime:(NSTimeInterval)bufferTime;

- (void)play;

- (void)pause;

- (void)changeDownloadState:(BOOL)isDownloaded;

@end

NS_ASSUME_NONNULL_END
