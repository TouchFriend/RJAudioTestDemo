//
//  RJSliderView.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/31.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJSliderView.h"

// 滑动按钮宽高
static CGFloat const RJSliderButtonWH = 19.0;
// 进度高度
static CGFloat const RJProgressHeight = 1.0;

@implementation RJSliderButton

// 增加按钮的点击范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -20, -20);
    return CGRectContainsPoint(bounds, point);
}

@end

@interface RJSliderView ()

/// 背景进度（总共大小）
@property (nonatomic, strong) UIImageView *bgProgressView;
/// 缓存进度
@property (nonatomic, strong) UIImageView *bufferProgressView;
/// 滑动进度
@property (nonatomic, strong) UIImageView *sliderProgressView;
/// 滑动按钮
@property (nonatomic, strong) RJSliderButton *sliderBtn;
/// 点击手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation RJSliderView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.allowTapped = YES;
        [self addAllSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat viewX = 0;
    CGFloat viewY = 0;
    CGFloat viewWidth = 0;
    CGFloat viewHeight = 0;
    CGFloat maxWidth = CGRectGetWidth(self.frame);
    CGFloat maxHeight = CGRectGetHeight(self.frame);
    
    viewX = 0;
    viewY = 0;
    viewWidth = maxWidth;
    viewHeight = self.sliderHeight;
    self.bgProgressView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    self.bgProgressView.center = CGPointMake(self.bgProgressView.center.x, maxHeight * 0.5);
    
    viewX = 0;
    viewY = 0;
    viewWidth = self.thumSize.width;
    viewHeight = self.thumSize.height;
    self.sliderBtn.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    self.sliderBtn.center = CGPointMake(CGRectGetWidth(self.bgProgressView.frame) * self.value, maxHeight * 0.5);
    
    viewX = 0;
    viewY = 0;
    viewWidth = self.sliderBtn.center.x;
    viewHeight = self.sliderHeight;
    self.sliderProgressView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    self.sliderProgressView.center = CGPointMake(self.sliderProgressView.center.x, maxHeight * 0.5);
    
    viewX = 0;
    viewY = 0;
    viewWidth = maxWidth * self.bufferValue;
    viewHeight = self.sliderHeight;
    self.bufferProgressView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    self.bufferProgressView.center = CGPointMake(self.bufferProgressView.center.x, maxHeight * 0.5);
}

#pragma mark - Add Subviews

- (void)addAllSubviews {
    self.thumSize = CGSizeMake(RJSliderButtonWH, RJSliderButtonWH);
    self.sliderHeight = RJProgressHeight;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgProgressView];
    [self addSubview:self.bufferProgressView];
    [self addSubview:self.sliderProgressView];
    UIImage *sliderImage = [[UIImage imageNamed:@"audio_slider"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.sliderBtn setImage:sliderImage  forState:UIControlStateNormal];
    self.sliderBtn.tintColor = [UIColor colorWithRed:36.0 / 255.0 green:153.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
    [self addSubview:self.sliderBtn];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:self.tapGesture];
    
    UIPanGestureRecognizer *sliderGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slider:)];
    [self addGestureRecognizer:sliderGesture];
}

#pragma mark - Public Methods

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    [self.sliderBtn setBackgroundImage:image forState:state];
}

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state {
    [self.sliderBtn setImage:image forState:state];
}

#pragma mark - Target Methods

- (void)tapped:(UITapGestureRecognizer *)tapGesture {
    CGPoint point = [tapGesture locationInView:self.bgProgressView];
    CGFloat value = point.x / CGRectGetWidth(self.bgProgressView.frame);
    value = MIN(MAX(value, 0), 1.0);
    self.value = value;
    if ([self.delegate respondsToSelector:@selector(sliderTapped:value:)]) {
        [self.delegate sliderTapped:self value:self.value];
    }
}

- (void)slider:(UIPanGestureRecognizer *)sliderGesture {
    switch (sliderGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self sliderBtnTouchBegin:self.sliderBtn];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self sliderBtnDragMoving:self.sliderBtn point:[sliderGesture locationInView:self.bgProgressView]];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self sliderBtnTouchEnd:self.sliderBtn];
        }
            break;
            
        default:
            break;
    }
}

- (void)sliderBtnTouchBegin:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(sliderTouchBegan:value:)]) {
        [self.delegate sliderTouchBegan:self value:self.value];
    }
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

- (void)sliderBtnTouchEnd:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(sliderTouchEnded:value:)]) {
        [self.delegate sliderTouchEnded:self value:self.value];
    }
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformIdentity;
    }];
}

- (void)sliderBtnDragMoving:(UIButton *)btn point:(CGPoint)touchPoint {
    CGPoint point = touchPoint;
    CGFloat value = point.x / CGRectGetWidth(self.bgProgressView.frame);
    value = MIN(MAX(value, 0), 1.0);
    if (value == self.value) {
        return;
    }
    
    self.value = value;
    if ([self.delegate respondsToSelector:@selector(sliderValueChanged:value:)]) {
        [self.delegate sliderValueChanged:self value:self.value];
    }
}

#pragma mark - Property Methods

- (UIImageView *)bgProgressView {
    if (!_bgProgressView) {
        _bgProgressView = [[UIImageView alloc] init];
        _bgProgressView.backgroundColor = [UIColor colorWithRed:220.0 / 255.0 green:220.0 / 255.0 blue:220.0 / 255.0 alpha:1.0];
        _bgProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _bgProgressView.clipsToBounds = YES;
    }
    return _bgProgressView;
}

- (UIImageView *)bufferProgressView {
    if (!_bufferProgressView) {
        _bufferProgressView = [[UIImageView alloc] init];
        _bufferProgressView.backgroundColor = [UIColor colorWithRed:200.0 / 255.0 green:200.0 / 255.0 blue:200.0 / 255.0 alpha:1.0];
        _bufferProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _bufferProgressView.clipsToBounds = YES;
    }
    return _bufferProgressView;
}

- (UIImageView *)sliderProgressView {
    if (!_sliderProgressView) {
        _sliderProgressView = [[UIImageView alloc] init];
        _sliderProgressView.backgroundColor = [UIColor colorWithRed:36.0 / 255.0 green:153.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
        _sliderProgressView.contentMode = UIViewContentModeScaleAspectFill;
        _sliderProgressView.clipsToBounds = YES;
    }
    return _sliderProgressView;
}

- (RJSliderButton *)sliderBtn {
    if (!_sliderBtn) {
        _sliderBtn = [RJSliderButton buttonWithType:UIButtonTypeCustom];
        [_sliderBtn setAdjustsImageWhenHighlighted:NO];
    }
    return _sliderBtn;
}

- (void)setValue:(CGFloat)value {
    if (isnan(value)) {
        return;
    }
    
    value = MIN(MAX(value, 0), 1.0);
    _value = value;
    self.sliderBtn.center = CGPointMake(CGRectGetWidth(self.bgProgressView.frame) * _value, self.sliderBtn.center.y);
    CGRect sliderProgressViewFrame = self.sliderProgressView.frame;
    sliderProgressViewFrame.size.width = CGRectGetMidX(self.sliderBtn.frame);
    self.sliderProgressView.frame = sliderProgressViewFrame;
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    _maximumTrackTintColor = maximumTrackTintColor;
    self.bgProgressView.backgroundColor = maximumTrackTintColor;
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    _minimumTrackTintColor = minimumTrackTintColor;
    self.sliderProgressView.backgroundColor = minimumTrackTintColor;
}

- (void)setBufferTrackTintColor:(UIColor *)bufferTrackTintColor {
    _bufferTrackTintColor = bufferTrackTintColor;
    self.bufferProgressView.backgroundColor = bufferTrackTintColor;
}

- (void)setMaximumTrackImage:(UIImage *)maximumTrackImage {
    _maximumTrackImage = maximumTrackImage;
    self.bgProgressView.image = maximumTrackImage;
    self.maximumTrackTintColor = [UIColor clearColor];
}

- (void)setMinimumTrackImage:(UIImage *)minimumTrackImage {
    _minimumTrackImage = minimumTrackImage;
    self.sliderProgressView.image = minimumTrackImage;
    self.minimumTrackTintColor = [UIColor clearColor];
}

- (void)setBufferTrackImage:(UIImage *)bufferTrackImage {
    _bufferTrackImage = bufferTrackImage;
    self.bufferProgressView.image = bufferTrackImage;
    self.bufferTrackTintColor = [UIColor clearColor];
}

- (void)setSliderHeight:(CGFloat)sliderHeight {
    _sliderHeight = sliderHeight;
    CGRect bgProgressViewFrame = self.bgProgressView.frame;
    bgProgressViewFrame.size.height = sliderHeight;
    self.bgProgressView.frame = bgProgressViewFrame;
    
    CGRect sliderProgressViewFrame = self.sliderProgressView.frame;
    sliderProgressViewFrame.size.height = sliderHeight;
    self.sliderProgressView.frame = sliderProgressViewFrame;
    
    CGRect bufferProgressViewFrame = self.bufferProgressView.frame;
    bufferProgressViewFrame.size.height = sliderHeight;
    self.bufferProgressView.frame = bufferProgressViewFrame;
}

- (void)setSliderRadius:(CGFloat)sliderRadius {
    _sliderRadius = sliderRadius;
    self.bgProgressView.layer.cornerRadius = sliderRadius;
    self.bgProgressView.layer.masksToBounds = YES;
    self.sliderProgressView.layer.cornerRadius = sliderRadius;
    self.sliderProgressView.layer.masksToBounds = YES;
    self.bufferProgressView.layer.cornerRadius = sliderRadius;
    self.bufferProgressView.layer.masksToBounds = YES;
    
}

- (void)setAllowTapped:(BOOL)allowTapped {
    _allowTapped = allowTapped;
    if (!allowTapped) {
        [self removeGestureRecognizer:self.tapGesture];
    }
}

@end
