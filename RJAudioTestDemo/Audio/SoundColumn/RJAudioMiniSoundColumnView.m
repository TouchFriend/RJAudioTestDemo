//
//  RJAudioMiniSoundColumnView.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/12.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioMiniSoundColumnView.h"
#import "RJAudioConst.h"
#import "UIView+RJAudioFrame.h"
#import "RJAudioColumnItem.h"

static NSString * const RJAnimationScaleYKey = @"RJAnimationScaleYKey";
static NSString * const RJItemScaleKey = @"scale";
static NSString * const RJItemAnimationFromValueKey = @"animationFromValue";
static NSString * const RJItemAnimationToValueKey = @"animationToValue";
static NSString * const RJItemAnimationDurationKey = @"animationDuration";

@interface RJAudioMiniSoundColumnView ()

/// 音柱
@property (nonatomic, strong) NSArray<UIView *> *soundColumns;
/// 音柱模型
@property (nonatomic, strong) NSArray<RJAudioColumnItem *> *columnItems;

@end

@implementation RJAudioMiniSoundColumnView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInit];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat middleCenterX = self.rj_width * 0.5;
    CGFloat columnViewXWidth = 3.0;
    CGFloat margin = 3.0;
    NSInteger middle = ceil(self.columnItems.count / 2.0) - 1;
    for (NSInteger i = 0; i < self.columnItems.count; i++) {
        RJAudioColumnItem *item = self.columnItems[i];
        CGFloat centerX = middleCenterX + (i - middle) * (margin + columnViewXWidth);
        NSNumber *scale = item.scale;
        UIView *columnView = self.soundColumns[i];
        CGFloat columnViewHeight = self.rj_height * scale.floatValue;
        columnView.bounds = CGRectMake(0, 0, columnViewXWidth, columnViewHeight);
        columnView.center = CGPointMake(centerX, self.rj_height * 0.5);
        columnView.layer.cornerRadius = columnView.rj_width * 0.5;
        columnView.layer.masksToBounds = YES;
    }
}

- (void)dealloc {
  
}

#pragma mark - Setup Init

- (void)setupInit {
    self.backgroundColor = [UIColor clearColor];
    
    for (UIView *columnView in self.soundColumns) {
        [self addSubview:columnView];
    }
    
#warning 处理进入后台，再进入前台，动画停止的问题
    
}

#pragma mark - Public Methods

- (void)beginAnimation {
    if ([self.soundColumns.firstObject.layer animationForKey:RJAnimationScaleYKey]) {
        return;
    }
    
    NSInteger middle = ceil(self.columnItems.count / 2.0) - 1;
    for (NSInteger i = 0; i < self.soundColumns.count; i++) {
        if(i == middle) {
            continue;
        }
        
        UIView *columnView = self.soundColumns[i];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        RJAudioColumnItem *item = self.columnItems[i];
        animation.fromValue = item.animationFromValue;
        animation.toValue = item.animationToValue;
        animation.duration = item.animationDuration.floatValue;
        animation.repeatCount = CGFLOAT_MAX;
        animation.autoreverses = YES;
        [columnView.layer addAnimation:animation forKey:RJAnimationScaleYKey];
    }
}

- (void)stopAnimation {
    for (UIView *columnView in self.soundColumns) {
        [columnView.layer removeAnimationForKey:RJAnimationScaleYKey];
    }
}

#pragma mark - Property Methods

- (NSArray<UIView *> *)soundColumns {
    if (!_soundColumns) {
        NSMutableArray *columns = [NSMutableArray array];
        for (NSInteger i = 0; i < self.columnItems.count; i++) {
            UIView *tempColumView = [[UIView alloc] init];
            tempColumView.backgroundColor = RJAudioThemeColor;
            [columns addObject:tempColumView];
        }
        
        _soundColumns = [NSArray arrayWithArray:columns];
    }
    
    return _soundColumns;
}

- (NSArray<RJAudioColumnItem *> *)columnItems {
    if (!_columnItems) {
        NSArray *columnValue = @[
            @{
                RJItemScaleKey : @0.4, RJItemAnimationFromValueKey : @1.0, RJItemAnimationToValueKey : @0.7, RJItemAnimationDurationKey : @0.1
            },
            @{
                RJItemScaleKey : @0.23, RJItemAnimationFromValueKey : @1.0, RJItemAnimationToValueKey : @1.4, RJItemAnimationDurationKey : @0.2
            },
            @{
                RJItemScaleKey : @0.52, RJItemAnimationFromValueKey : @1.0, RJItemAnimationToValueKey : @1.0, RJItemAnimationDurationKey : @0.5
            },
            @{
                RJItemScaleKey : @0.23, RJItemAnimationFromValueKey : @1.0, RJItemAnimationToValueKey : @1.4, RJItemAnimationDurationKey : @0.2
            },
            @{
                RJItemScaleKey : @0.4, RJItemAnimationFromValueKey : @1.0, RJItemAnimationToValueKey : @0.7, RJItemAnimationDurationKey : @0.1
            }
        ];
        
        NSMutableArray *items = [NSMutableArray array];
        for (NSDictionary *dic in columnValue) {
            RJAudioColumnItem *item = [[RJAudioColumnItem alloc] init];
            item.scale = dic[RJItemScaleKey];
            item.animationFromValue = dic[RJItemAnimationFromValueKey];
            item.animationToValue = dic[RJItemAnimationToValueKey];
            item.animationDuration = dic[RJItemAnimationDurationKey];
            [items addObject:item];
        }
        
        _columnItems = [NSMutableArray arrayWithArray:items];
    }
    
    return _columnItems;
}

@end
