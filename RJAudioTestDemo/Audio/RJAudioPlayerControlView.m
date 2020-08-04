//
//  RJAudioPlayerControlView.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/31.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioPlayerControlView.h"
#import "RJSliderView.h"
#import "RJAudioConst.h"
#import <UIImageView+WebCache.h>

static NSString * const RJPlayerIconRotationAnimationKey = @"player_Icon_Rotation";

@interface RJAudioPlayerControlView () <RJSliderViewDelegate>

/// 标题
@property (nonatomic, strong) UILabel *titleLbl;
/// 专辑图片
@property (nonatomic, strong) UIImageView *albumIconImageV;
/// 操作view
@property (nonatomic, strong) UIView *actionView;
/// 进度view
@property (nonatomic, strong) UIView *progressView;
/// 进度条
@property (nonatomic, strong) RJSliderView *sliderView;
/// 播放当前时间
@property (nonatomic, strong) UILabel *currentTimeLbl;
/// 播放总时间
@property (nonatomic, strong) UILabel *totalTimeLbl;
/// 播放操作view
@property (nonatomic, strong) UIView *playActionView;
/// 播放/暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 下一首按钮
@property (nonatomic, strong) UIButton *nextBtn;
/// 上一首按钮
@property (nonatomic, strong) UIButton *previousBtn;
/// 下载按钮
@property (nonatomic, strong) UIButton *downloadBtn;
/// 播放顺序按钮
@property (nonatomic, strong) UIButton *playOrderBtn;
/// 播放菜单按钮
@property (nonatomic, strong) UIButton *playMenuBtn;
/// <#Desription#>
@property (nonatomic, strong) CABasicAnimation *rotationAnimation;


@end

@implementation RJAudioPlayerControlView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
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
    CGFloat homeIndicatorHeight = HOME_INDICATOR_HEIGHT;
    
    // 播放操作
    viewHeight = 96.0;
    viewY = maxHeight - viewHeight - homeIndicatorHeight;
    viewX = 0;
    viewWidth = maxWidth;
    self.playActionView.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    
    viewWidth = 62.0;
    viewHeight = viewWidth;
    viewX = (CGRectGetWidth(self.playActionView.frame) - viewWidth) * 0.5;
    viewY = (CGRectGetHeight(self.playActionView.frame) - viewHeight) * 0.5;
    self.playOrPauseBtn.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    
    viewWidth = 40.0;
    viewHeight = 40.0;
    viewX = (CGRectGetMinX(self.playOrPauseBtn.frame) - viewWidth) * 0.5 + 3.0;
    viewY = (CGRectGetHeight(self.playActionView.frame) - viewHeight) * 0.5;
    self.previousBtn.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    
    viewWidth = 40.0;
    viewHeight = 40.0;
    viewX = CGRectGetMaxX(self.playOrPauseBtn.frame) + (CGRectGetWidth(self.playActionView.frame) - CGRectGetMaxX(self.playOrPauseBtn.frame)) * 0.5 - viewWidth * 0.5 - 3.0;
    viewY = (CGRectGetHeight(self.playActionView.frame) - viewHeight) * 0.5;
    self.nextBtn.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    
    // 播放进度
    viewHeight = 60.0;
    viewY = CGRectGetMinY(self.playActionView.frame) - viewHeight;
    viewX = 0;
    viewWidth = maxWidth;
    self.progressView.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    
    viewHeight = 60.0;
    viewY = 0;
    viewX = 20;
    viewWidth = CGRectGetWidth(self.progressView.frame) - 2 * viewX;
    self.sliderView.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    
    viewHeight = 13.0;
    viewX = CGRectGetMinX(self.sliderView.frame);
    viewY = CGRectGetMaxY(self.sliderView.frame) - viewHeight;
    viewWidth = 50;
    self.currentTimeLbl.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    
    viewWidth = CGRectGetWidth(self.currentTimeLbl.frame);
    viewX = CGRectGetMaxX(self.sliderView.frame) - viewWidth;
    viewY = CGRectGetMinY(self.currentTimeLbl.frame);
    viewHeight = CGRectGetHeight(self.currentTimeLbl.frame);
    self.totalTimeLbl.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    
    // 操作
    viewHeight = 59.0;
    viewY = CGRectGetMinY(self.progressView.frame) - viewHeight;
    viewX = 0;
    viewWidth = maxWidth;
    self.actionView.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    
    viewWidth = 30;
    viewHeight = 30;
    viewX = (CGRectGetWidth(self.actionView.frame) - viewWidth) * 0.5;
    viewY = (CGRectGetHeight(self.actionView.frame) - viewHeight) * 0.5;
    self.downloadBtn.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    
    viewWidth = 30;
    viewHeight = 30;
    viewX = (CGRectGetMinX(self.downloadBtn.frame) - viewWidth) * 0.5 - 8;
    viewY = (CGRectGetHeight(self.actionView.frame) - viewHeight) * 0.5;
    self.playOrderBtn.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    
    viewWidth = 30;
    viewHeight = 30;
    viewX = CGRectGetMaxX(self.downloadBtn.frame) + (CGRectGetWidth(self.actionView.frame) - CGRectGetMaxX(self.downloadBtn.frame)) * 0.5 - viewWidth * 0.5 + 8;
    viewY = (CGRectGetHeight(self.actionView.frame) - viewHeight) * 0.5;
    self.playMenuBtn.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    
    // 标题
    viewX = 0;
    viewY = 152;
    viewWidth = maxWidth;
    viewHeight = 25.0;
    self.titleLbl.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    
    // 歌手图标
    viewWidth = 126.0;
    viewHeight = viewWidth;
    viewX = (maxWidth - viewWidth) * 0.5;
    viewY = CGRectGetMaxY(self.titleLbl.frame) + 60.0;
    self.albumIconImageV.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
}

#pragma mark - Add Subviews

- (void)addAllSubviews {
    [self addSubview:self.titleLbl];
    [self addSubview:self.albumIconImageV];
    
    [self addSubview:self.actionView];
    [self.actionView addSubview:self.downloadBtn];
    [self.actionView addSubview:self.playOrderBtn];
    [self.actionView addSubview:self.playMenuBtn];
    
    [self addSubview:self.progressView];
    [self.progressView addSubview:self.currentTimeLbl];
    [self.progressView addSubview:self.totalTimeLbl];
    [self.progressView addSubview:self.sliderView];
    
    [self addSubview:self.playActionView];
    [self.playActionView addSubview:self.playOrPauseBtn];
    [self.playActionView addSubview:self.nextBtn];
    [self.playActionView addSubview:self.previousBtn];
    
    
}

#pragma mark - Private Methods

- (NSString *)convertTimeFormate:(NSTimeInterval)interval {
    NSInteger minute = interval / 60;
    NSInteger second = interval - minute * 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", minute, second];
}

/// 开始旋转动画
- (void)beginRotationAnimation {
    [self resumeLayer:_albumIconImageV.layer];
}

// 停止旋转动画
- (void)stopRotationAnimation {
    [self pauseLayer:_albumIconImageV.layer];
    
}

/// 恢复图层动画
/// @param layer 图层
- (void)resumeLayer:(CALayer *)layer {
    CFTimeInterval pausedTime = layer.timeOffset;
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

/// 暂停图层动画
/// @param layer 图层
- (void)pauseLayer:(CALayer *)layer {
    CFTimeInterval pausedTime = [self.albumIconImageV.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

#pragma mark - Public Methdos

- (void)showTitle:(NSString *)title playerIcon:(UIImage *)playerIcon currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    self.titleLbl.text = title;
    self.albumIconImageV.image = playerIcon ? playerIcon : [UIImage imageNamed:@"audio_play_spin_icon"];
    self.currentTimeLbl.text = [self convertTimeFormate:currentTime];
    self.totalTimeLbl.text = [self convertTimeFormate:totalTime];
}

- (void)showTitle:(NSString *)title albumURL:(NSURL *)albumURL {
    self.titleLbl.text = title;
    UIImage *placeholder = [UIImage imageNamed:@"audio_play_spin_icon"];
    if (!albumURL || albumURL.absoluteString.length == 0) {
        self.albumIconImageV.image = placeholder;
    } else {
        [self.albumIconImageV sd_setImageWithURL:albumURL placeholderImage:placeholder];
    }
}

- (void)currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    if (self.sliderView.isdragging) {
        return;
    }
    
    if (isnan(currentTime) || currentTime < 0) {
        currentTime = 0;
    }
    if (isnan(totalTime) || totalTime < 0) {
        totalTime = 0;
    }
    
    self.totalTime = totalTime;
    self.currentTimeLbl.text = [self convertTimeFormate:currentTime];
    self.totalTimeLbl.text = [self convertTimeFormate:totalTime];
    self.sliderView.value = currentTime * 1.0 / totalTime;
}

- (void)play {
    self.playOrPauseBtn.selected = YES;
    [self beginRotationAnimation];
}

- (void)pause {
    self.playOrPauseBtn.selected = NO;
    [self stopRotationAnimation];
}

#pragma mark - Target Methods

- (void)playOrPauseBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(controlView:didClickPlayOrPauseButton:)]) {
        [self.delegate controlView:self didClickPlayOrPauseButton:btn.selected];
    }
}

- (void)nextBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickNextButton:)]) {
        [self.delegate controlViewDidClickNextButton:self];
    }
}

- (void)previousBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickPreviousButton:)]) {
        [self.delegate controlViewDidClickPreviousButton:self];
    }
}

- (void)downloadBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickDownloadButton:)]) {
        [self.delegate controlViewDidClickDownloadButton:self];
    }
}

- (void)playOrderBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickPlayOrderButton:playOrder:)]) {
        [self.delegate controlViewDidClickPlayOrderButton:self playOrder:self.playOrder];
    }
}

- (void)playMenuBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(controlViewDidClickPlayMenuButton:)]) {
        [self.delegate controlViewDidClickPlayMenuButton:self];
    }
}



#pragma mark - RJSliderViewDelegate Methods

- (void)sliderTouchBegan:(RJSliderView *)sliderView value:(float)value
{
    self.sliderView.isdragging = YES;
}

- (void)sliderValueChanged:(RJSliderView *)sliderView value:(float)value {
    self.sliderView.isdragging = YES;
    NSTimeInterval currentTime = self.totalTime * value;
    self.currentTimeLbl.text = [self convertTimeFormate:currentTime];
    if ([self.delegate respondsToSelector:@selector(controlView:sliderValueDidChanged:)]) {
        [self.delegate controlView:self sliderValueDidChanged:value];
    }
}

- (void)sliderTouchEnded:(RJSliderView *)sliderView value:(float)value {
    if (self.totalTime > 0) {
        self.sliderView.isdragging = YES;
        if ([self.delegate respondsToSelector:@selector(controlView:sliderTouchDidEnded:completionHandler:)]) {
            [self.delegate controlView:self sliderTouchDidEnded:value completionHandler:^(BOOL finished) {
                self.sliderView.isdragging = NO;
            }];
        }
    } else {
        self.sliderView.isdragging = NO;
        self.sliderView.value = 0;
    }
    
    
}

- (void)sliderTapped:(RJSliderView *)sliderView value:(float)value {
    if ([self.delegate respondsToSelector:@selector(controlView:sliderDidTapped:)]) {
        [self.delegate controlView:self sliderDidTapped:value];
    }
}

#pragma mark - Property Methods

- (UIView *)playActionView {
    if (!_playActionView) {
        _playActionView = [[UIView alloc] init];
        _playActionView.backgroundColor = [UIColor clearColor];
    }
    return _playActionView;;
}

- (UIView *)progressView {
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = [UIColor clearColor];
    }
    return _progressView;
}

- (RJSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[RJSliderView alloc] init];
        _sliderView.value = 0.0;
        _sliderView.bufferValue = 0.0;
        _sliderView.sliderHeight = 3;
        _sliderView.sliderRadius = _sliderView.sliderHeight * 0.5;
        _sliderView.thumSize = CGSizeMake(9.0, 9.0);
        _sliderView.delegate = self;
    }
    return _sliderView;
}

- (UILabel *)currentTimeLbl {
    if (!_currentTimeLbl) {
        _currentTimeLbl = [[UILabel alloc] init];
        _currentTimeLbl.font = [UIFont systemFontOfSize:12.0];
        _currentTimeLbl.textColor = [UIColor colorWithRed:57.0 / 255.0 green:57.0 / 255.0 blue:57.0 / 255.0 alpha:1.0];
        _currentTimeLbl.textAlignment = NSTextAlignmentLeft;
        _currentTimeLbl.text = @"00:00";
    }
    return _currentTimeLbl;
}

- (UILabel *)totalTimeLbl {
    if (!_totalTimeLbl) {
        _totalTimeLbl = [[UILabel alloc] init];
        _totalTimeLbl.font = [UIFont systemFontOfSize:12.0];
        _totalTimeLbl.textColor = [UIColor colorWithRed:57.0 / 255.0 green:57.0 / 255.0 blue:57.0 / 255.0 alpha:1.0];
        _totalTimeLbl.textAlignment = NSTextAlignmentRight;
        _totalTimeLbl.text = @"00:00";
    }
    return _totalTimeLbl;
}

- (UIView *)actionView {
    if (!_actionView) {
        _actionView = [[UIView alloc] init];
        _actionView.backgroundColor = [UIColor clearColor];
    }
    return _actionView;
}

- (UIImageView *)albumIconImageV {
    if (!_albumIconImageV) {
        _albumIconImageV = [[UIImageView alloc] init];
        _albumIconImageV.backgroundColor = [UIColor clearColor];
        _albumIconImageV.image = [UIImage imageNamed:@"audio_play_spin_icon"];
        [_albumIconImageV.layer addAnimation:self.rotationAnimation forKey:RJPlayerIconRotationAnimationKey];
        [self stopRotationAnimation]; // 停止旋转
    }
    return _albumIconImageV;;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
        _titleLbl.textColor = [UIColor colorWithRed:57.0 / 255.0 green:57.0 / 255.0 blue:57.0 / 255.0 alpha:1.0];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.text = @"音乐标题";
    }
    return _titleLbl;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"audio_play_start"] forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"audio_play_pause"] forState:UIControlStateSelected];
        [_playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playOrPauseBtn;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setImage:[UIImage imageNamed:@"audio_next_song"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UIButton *)previousBtn {
    if (!_previousBtn) {
        _previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previousBtn setImage:[UIImage imageNamed:@"audio_previous_song"] forState:UIControlStateNormal];
        [_previousBtn addTarget:self action:@selector(previousBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previousBtn;
}

- (UIButton *)downloadBtn {
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadBtn setImage:[UIImage imageNamed:@"audio_download_icon"] forState:UIControlStateNormal];
        [_downloadBtn addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadBtn;
}

- (UIButton *)playOrderBtn {
    if (!_playOrderBtn) {
        _playOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrderBtn setImage:[UIImage imageNamed:@"audio_play_order_circle"] forState:UIControlStateNormal];
        [_playOrderBtn addTarget:self action:@selector(playOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playOrderBtn;
}

- (UIButton *)playMenuBtn {
    if (!_playMenuBtn) {
        _playMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playMenuBtn setImage:[UIImage imageNamed:@"audio_music_list"] forState:UIControlStateNormal];
        [_playMenuBtn addTarget:self action:@selector(playMenuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playMenuBtn;
}

- (CABasicAnimation *)rotationAnimation {
    if (!_rotationAnimation) {
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.fromValue = @(0);
        rotationAnimation.toValue = @(M_PI * 2);
        rotationAnimation.duration = 15.0;
        rotationAnimation.repeatCount = CGFLOAT_MAX;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _rotationAnimation = rotationAnimation;
    }
    return _rotationAnimation;
}


@end
