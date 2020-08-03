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

@interface RJAudioPlayerControlView () <RJSliderViewDelegate>

/// 标题
@property (nonatomic, strong) UILabel *titleLbl;
/// 歌手图片
@property (nonatomic, strong) UIImageView *playerIconImageV;
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
    
    viewWidth = 30.0;
    viewHeight = 30.0;
    viewX = (CGRectGetMinX(self.playOrPauseBtn.frame) - viewWidth) * 0.5 + 3.0;
    viewY = (CGRectGetHeight(self.playActionView.frame) - viewHeight) * 0.5;
    self.previousBtn.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    
    viewWidth = 30.0;
    viewHeight = 30.0;
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
    self.playerIconImageV.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
}

#pragma mark - Add Subviews

- (void)addAllSubviews {
    [self addSubview:self.titleLbl];
    [self addSubview:self.playerIconImageV];
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


#pragma mark - Target Methods

- (void)playOrPauseBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
}

#pragma mark - RJSliderViewDelegate Methods

- (void)sliderValueChanged:(RJSliderView *)sliderView value:(float)value {
    
}

- (void)sliderTapped:(RJSliderView *)sliderView value:(float)value {
    
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
        _sliderView.value = 0.2;
        _sliderView.bufferValue = 0.5;
        _sliderView.sliderHeight = 3;
        _sliderView.sliderRadius = 1.5;
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

- (UIImageView *)playerIconImageV {
    if (!_playerIconImageV) {
        _playerIconImageV = [[UIImageView alloc] init];
        _playerIconImageV.backgroundColor = [UIColor clearColor];
        _playerIconImageV.image = [UIImage imageNamed:@"audio_play_spin_icon"];
    }
    return _playerIconImageV;;
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
    }
    return _nextBtn;
}

- (UIButton *)previousBtn {
    if (!_previousBtn) {
        _previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previousBtn setImage:[UIImage imageNamed:@"audio_previous_song"] forState:UIControlStateNormal];
    }
    return _previousBtn;
}

- (UIButton *)downloadBtn {
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadBtn setImage:[UIImage imageNamed:@"audio_download_icon"] forState:UIControlStateNormal];
    }
    return _downloadBtn;
}

- (UIButton *)playOrderBtn {
    if (!_playOrderBtn) {
        _playOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrderBtn setImage:[UIImage imageNamed:@"audio_play_order_circle"] forState:UIControlStateNormal];
    }
    return _playOrderBtn;
}

- (UIButton *)playMenuBtn {
    if (!_playMenuBtn) {
        _playMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playMenuBtn setImage:[UIImage imageNamed:@"audio_music_list"] forState:UIControlStateNormal];
    }
    return _playMenuBtn;
}



@end
