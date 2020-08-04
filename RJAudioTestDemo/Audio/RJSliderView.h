//
//  RJSliderView.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/31.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJSliderView;

@protocol RJSliderViewDelegate <NSObject>

@optional

/// 滑块滑动开始
- (void)sliderTouchBegan:(RJSliderView *_Nonnull)sliderView value:(float)value;
/// 滑块滑动中
- (void)sliderValueChanged:(RJSliderView *_Nonnull)sliderView value:(float)value;
/// 滑块滑动结束
- (void)sliderTouchEnded:(RJSliderView *_Nonnull)sliderView value:(float)value;
/// 滑杆点击
- (void)sliderTapped:(RJSliderView *_Nonnull)sliderView value:(float)value;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RJSliderButton : UIButton

@end

@interface RJSliderView : UIView

/// 代理
@property (nonatomic, weak) id <RJSliderViewDelegate> delegate;
/// 默认滑杆颜色
@property (nonatomic, strong) UIColor *maximumTrackTintColor;
/// 滑杆进度颜色
@property (nonatomic, strong) UIColor *minimumTrackTintColor;
/// 缓存进度颜色
@property (nonatomic, strong) UIColor *bufferTrackTintColor;
/// 默认滑杆图片
@property (nonatomic, strong) UIImage *maximumTrackImage;
/// 滑杆进度的图片
@property (nonatomic, strong) UIImage *minimumTrackImage;
/// 缓存进度的图片
@property (nonatomic, strong) UIImage *bufferTrackImage;

/// 滑杆进度
@property (nonatomic, assign) CGFloat value;
/// 缓存进度
@property (nonatomic, assign) CGFloat bufferValue;
/// 滑杆高度
@property (nonatomic, assign) CGFloat sliderHeight;
/// 滑杆半径
@property (nonatomic, assign) CGFloat sliderRadius;
/// 滑动按钮大小
@property (nonatomic, assign) CGSize thumSize;
/// 是否允许点击，默认YES
@property (nonatomic, assign) BOOL allowTapped;
/// 是否正在拖拽
@property (nonatomic, assign) BOOL isdragging;



/// 设置滑块背景色
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;

/// 设置滑块图片
- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
