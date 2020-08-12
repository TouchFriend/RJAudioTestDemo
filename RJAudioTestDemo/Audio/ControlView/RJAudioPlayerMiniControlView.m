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

static CGFloat const RJProgressLineWidth = 3.8;
static CGFloat const RJMiniControlViewMargin = 15.0;

@interface RJAudioPlayerMiniControlView ()

/// <#Desription#>
@property (nonatomic, weak) UIView *soundColumnContainerView;
/// <#Desription#>
@property (nonatomic, weak) RJAudioMiniSoundColumnView *miniSoundColumnView;
/// <#Desription#>
@property (nonatomic, weak) UIButton *playOrPauseBtn;
/// <#Desription#>
@property (nonatomic, weak) UIButton *closeBtn;
/// 上一个点
@property (nonatomic, assign) CGPoint lastPoint;
/// <#Desription#>
@property (nonatomic, weak) CAShapeLayer *progressLayer;

@end

@implementation RJAudioPlayerMiniControlView

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
    
    CGFloat miniSoundColumnViewMargin = 4.0;
    CGFloat miniSoundColumnViewWH = self.soundColumnContainerView.rj_height - 2 * miniSoundColumnViewMargin;
    self.miniSoundColumnView.frame = CGRectMake(miniSoundColumnViewMargin, miniSoundColumnViewMargin, miniSoundColumnViewWH, miniSoundColumnViewWH);
    self.miniSoundColumnView.layer.cornerRadius = self.miniSoundColumnView.rj_height * 0.5;
    self.miniSoundColumnView.layer.masksToBounds = YES;
    
    CGPoint center = self.soundColumnContainerView.center;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:self.soundColumnContainerView.rj_width * 0.5 - RJProgressLineWidth * 0.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    self.progressLayer.path = path.CGPath;
    
    CGFloat playOrPauseBtnWH = self.rj_height;
    self.playOrPauseBtn.frame = CGRectMake(self.miniSoundColumnView.rj_maxX + miniSoundColumnViewMargin, 0, playOrPauseBtnWH, playOrPauseBtnWH);
    
    CGFloat closeBtnWidthHeight = self.rj_height - 2 * miniSoundColumnViewMargin;
    self.closeBtn.frame = CGRectMake(self.rj_width - miniSoundColumnViewMargin - closeBtnWidthHeight, miniSoundColumnViewMargin, closeBtnWidthHeight, closeBtnWidthHeight);
    self.closeBtn.layer.cornerRadius = self.closeBtn.rj_height * 0.5;
    self.closeBtn.layer.masksToBounds = YES;
}

#pragma mark - Setup Init

- (void)setupInit {
    self.backgroundColor = [UIColor colorWithRed:157.0 / 255.0 green:161.0 / 255.0 blue:167.0 / 255.0 alpha:1.0];
    
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
    
    progressLayer.strokeColor = [UIColor colorWithRed:207.0 / 255.0 green:207.0 / 255.0 blue:207.0 / 255.0 alpha:1.0].CGColor;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.lineWidth = RJProgressLineWidth;
    progressLayer.lineCap = kCALineCapRound;
    progressLayer.strokeEnd = 0.0;
    
    UIButton *playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:playOrPauseBtn];
    self.playOrPauseBtn = playOrPauseBtn;
    [playOrPauseBtn setImage:[UIImage imageNamed:@"audio_play_start"] forState:UIControlStateNormal];
    [playOrPauseBtn setImage:[UIImage imageNamed:@"audio_play_pause"] forState:UIControlStateSelected];
    [playOrPauseBtn addTarget:self action:@selector(playOrPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeBtn];
    self.closeBtn = closeBtn;
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [closeBtn setBackgroundColor:[UIColor orangeColor]];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
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

- (void)playOrPauseBtnClick:(UIButton *)playOrPauseBtn {
    playOrPauseBtn.selected = !playOrPauseBtn.selected;
    if (playOrPauseBtn.selected) {
        [self.miniSoundColumnView beginAnimation];
        self.progress = MIN(self.progress + 0.1, 1.0);
        
    } else {
        [self.miniSoundColumnView removeAnimation];
    }
    
}

- (void)closeBtnClick:(UIButton *)closeBtn {
    [self removeFromSuperview];
}

#pragma mark - Property Methods

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.progressLayer.strokeEnd = progress;
}

@end
