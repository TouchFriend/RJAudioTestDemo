//
//  RJAudioPlayerMiniControlView.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/12.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioPlayerMiniControlView.h"
#import "RJAudioMiniSoundColumnView.h"
#import "UIView+RJAudioFrame.h"
#import "RJAudioConst.h"
#import "UIImage+RJAudioPlayerImage.h"

static CGFloat const RJProgressLineWidth = 2.8;
CGFloat const RJMiniControlViewMargin = 15.0;

@interface RJAudioPlayerMiniControlView ()

/// 音柱容器
@property (nonatomic, weak) UIView *soundColumnContainerView;
/// 迷你音柱
@property (nonatomic, weak) RJAudioMiniSoundColumnView *miniSoundColumnView;
/// 播放或暂停按钮
@property (nonatomic, weak) UIButton *playOrPauseBtn;
/// 关闭按钮
@property (nonatomic, weak) UIButton *closeBtn;
/// 上一个点
@property (nonatomic, assign) CGPoint lastPoint;
/// 进度图层
@property (nonatomic, weak) CAShapeLayer *progressLayer;

@end

@implementation RJAudioPlayerMiniControlView

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window) {
        if (self.isPlaying) {
            [self play];
        } else {
            [self pause];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInit];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat soundColumnContainerViewWH = self.rj_height;
    self.soundColumnContainerView.frame = CGRectMake(0, 0, soundColumnContainerViewWH, soundColumnContainerViewWH);
    
    CGFloat miniSoundColumnViewMargin = 3.0;
    CGFloat miniSoundColumnViewWH = self.soundColumnContainerView.rj_height - 2 * miniSoundColumnViewMargin;
    self.miniSoundColumnView.frame = CGRectMake(miniSoundColumnViewMargin, miniSoundColumnViewMargin, miniSoundColumnViewWH, miniSoundColumnViewWH);
    self.miniSoundColumnView.layer.cornerRadius = self.miniSoundColumnView.rj_height * 0.5;
    self.miniSoundColumnView.layer.masksToBounds = YES;
    
    CGPoint center = self.soundColumnContainerView.center;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:self.soundColumnContainerView.rj_width * 0.5 - RJProgressLineWidth * 0.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    self.progressLayer.path = path.CGPath;
    
    CGFloat playOrPauseBtnHeight = self.rj_height;
    CGFloat playOrPauseBtnWidth = 40.0;
    self.playOrPauseBtn.frame = CGRectMake(self.miniSoundColumnView.rj_maxX + miniSoundColumnViewMargin, 0, playOrPauseBtnWidth, playOrPauseBtnHeight);
    
    CGFloat closeBtnWidthHeight = self.rj_height - 2 * miniSoundColumnViewMargin;
    CGFloat closeBtnWidth = 38.0;
    self.closeBtn.frame = CGRectMake(self.rj_width - miniSoundColumnViewMargin - closeBtnWidth, miniSoundColumnViewMargin, closeBtnWidth, closeBtnWidthHeight);
    self.closeBtn.layer.cornerRadius = self.closeBtn.rj_height * 0.5;
    self.closeBtn.layer.masksToBounds = YES;
}

#pragma mark - Setup Init

- (void)setupInit {
    self.backgroundColor = [UIColor colorWithRed:185.0 / 255.0 green:189.0 / 255.0 blue:196.0 / 255.0 alpha:1.0];
    
    UIView *soundColumnContainerView = [[UIView alloc] init];
    [self addSubview:soundColumnContainerView];
    self.soundColumnContainerView = soundColumnContainerView;
    soundColumnContainerView.backgroundColor = [UIColor clearColor];
    
    RJAudioMiniSoundColumnView *miniSoundColumnView = [[RJAudioMiniSoundColumnView alloc] init];
    [soundColumnContainerView addSubview:miniSoundColumnView];
    self.miniSoundColumnView= miniSoundColumnView;
    miniSoundColumnView.backgroundColor = [UIColor whiteColor];
    
    CAShapeLayer *progressLayer = [[CAShapeLayer alloc] init];
    [soundColumnContainerView.layer addSublayer:progressLayer];
    self.progressLayer = progressLayer;
    progressLayer.strokeColor = [UIColor colorWithRed:217.0 / 255.0 green:217.0 / 255.0 blue:217.0 / 255.0 alpha:1.0].CGColor;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.lineWidth = RJProgressLineWidth;
    progressLayer.lineCap = kCALineCapRound;
    progressLayer.strokeEnd = 0.0;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeBtn];
    self.closeBtn = closeBtn;
    [closeBtn setImage:[UIImage rj_imageNamedFromMyBundle:@"audio_mini_close_icon"] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [closeBtn setBackgroundColor:[UIColor clearColor]];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:playOrPauseBtn];
    self.playOrPauseBtn = playOrPauseBtn;
    [playOrPauseBtn setImage:[UIImage rj_imageNamedFromMyBundle:@"audio_mini_play_icon"] forState:UIControlStateNormal];
    [playOrPauseBtn setImage:[UIImage rj_imageNamedFromMyBundle:@"audio_play_pause"] forState:UIControlStateSelected];
    [playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panGesture];

}

#pragma mark - Target Methods

- (void)pan:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.lastPoint = [panGesture locationInView:self.superview];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentPoint = [panGesture locationInView:self.superview];
            CGRect frame = self.frame;
            frame.origin.x += currentPoint.x - self.lastPoint.x;
            frame.origin.y += currentPoint.y - self.lastPoint.y;
            // 判断移动范围
            frame.origin.x = MIN(MAX(frame.origin.x, 0), self.superview.rj_width - frame.size.width);
            frame.origin.y = MIN(MAX(frame.origin.y, STATUS_BAR_HEIGHT), self.superview.rj_height - frame.size.height);
            self.frame = frame;
            self.lastPoint = currentPoint;
        }
            break;
        default:
        {
            CGRect frame = self.frame;
            // 判断停留点
            frame.origin.x = CGRectGetMidX(frame) <= self.superview.rj_width * 0.5 ? RJMiniControlViewMargin : self.superview.rj_width - RJMiniControlViewMargin - frame.size.width;
            frame.origin.y = MIN(MAX(frame.origin.y, NAVIGATION_BAR_Max_Y + RJMiniControlViewMargin), self.superview.rj_height - frame.size.height - NAVIGATION_BAR_Max_Y - RJMiniControlViewMargin);
            self.frame = frame;
            self.lastPoint = CGPointZero;
        }
            break;
    }
}

- (void)tapped:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"%s", __func__);
    if ([self.delegate respondsToSelector:@selector(miniControlViewDidTapped:)]) {
        [self.delegate miniControlViewDidTapped:self];
    }
}

- (void)playOrPauseBtnClick:(UIButton *)playOrPauseBtn {
    playOrPauseBtn.selected = !playOrPauseBtn.selected;
    if (playOrPauseBtn.selected) {
        [self.miniSoundColumnView beginAnimation];
    } else {
        [self.miniSoundColumnView stopAnimation];
    }
    
    if ([self.delegate respondsToSelector:@selector(miniControlView:didClickPlayOrPauseButton:)]) {
        [self.delegate miniControlView:self didClickPlayOrPauseButton:playOrPauseBtn.selected];
    }
}

- (void)closeBtnClick:(UIButton *)closeBtn {
    [self dismiss];
}

#pragma mark - Public Methods

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].windows.lastObject;
    if ([keyWindow.subviews containsObject:self]) {
        self.hidden = NO;
        return;
    }
    
    self.hidden = NO;
    [keyWindow addSubview:self];
    CGFloat height = 46.0;
    self.frame = CGRectMake(RJMiniControlViewMargin, keyWindow.rj_height - height - NAVIGATION_BAR_Max_Y - RJMiniControlViewMargin, 120, height);
    self.layer.cornerRadius = height * 0.5;
    self.layer.masksToBounds = YES;
}

- (void)dismiss {
    [self removeFromSuperview];
    
    self.playOrPauseBtn.selected = NO;
    [self.miniSoundColumnView stopAnimation];
    self.progress = 0;
    
    if ([self.delegate respondsToSelector:@selector(miniControlViewDidClosed:)]) {
        [self.delegate miniControlViewDidClosed:self];
    }
}

- (void)hidden {
    self.hidden = YES;
}

- (void)play {
    self.isPlaying = YES;
    if (!self.window) {
        return;
    }
    
    self.playOrPauseBtn.selected = YES;
    [self.miniSoundColumnView beginAnimation];
}

- (void)pause {
    self.isPlaying = NO;
    if (!self.window) {
        return;
    }
    
    self.playOrPauseBtn.selected = NO;
    [self.miniSoundColumnView stopAnimation];
}

#pragma mark - Property Methods

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.progressLayer.strokeEnd = progress;
}

@end
