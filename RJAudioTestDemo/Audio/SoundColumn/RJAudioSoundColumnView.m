//
//  RJAudioSoundColumnView.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/11.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioSoundColumnView.h"
#import "RJAudioConst.h"
#import "UIView+RJAudioFrame.h"
#import "RJAudioColumnItem.h"

static NSString * const RJAnimationScaleYKey = @"RJAnimationScaleYKey";
static NSString * const RJItemScaleKey = @"scale";
static NSString * const RJItemAnimationFromValueKey = @"animationFromValue";
static NSString * const RJItemAnimationToValueKey = @"animationToValue";
static NSString * const RJItemAnimationDurationKey = @"animationDuration";

@interface RJAudioSoundColumnView ()

/// <#Desription#>
@property (nonatomic, strong) NSArray<UIView *> *soundColumns;
/// <#Desription#>
@property (nonatomic, strong) NSArray<RJAudioColumnItem *> *columnItems;

@end

@implementation RJAudioSoundColumnView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInit];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat columnViewX = 0;
    CGFloat columnViewXWidth = 2.0;
    CGFloat margin = 3.0;
    for (NSInteger i = 0; i < self.columnItems.count; i++) {
        RJAudioColumnItem *item = self.columnItems[i];
        NSNumber *scale = item.scale;
        UIView *columnView = self.soundColumns[i];
        CGFloat width = i == 1 ? columnViewXWidth - 0.5 : columnViewXWidth;
        CGFloat columnViewHeight = self.rj_height * scale.floatValue;
        columnView.frame = CGRectMake(columnViewX, self.rj_height - columnViewHeight, width, columnViewHeight);
        columnView.layer.anchorPoint = CGPointMake(0.5, 1.0);
        columnViewX += columnViewXWidth + margin;
    }
}

#pragma mark - Setup Init

- (void)setupInit {
    self.backgroundColor = [UIColor clearColor];
    
    for (UIView *columnView in self.soundColumns) {
        [self addSubview:columnView];
    }
}

#pragma mark - Public Methods

- (void)beginAnimation {
    if ([self.soundColumns.firstObject.layer animationForKey:RJAnimationScaleYKey]) {
        return;;
    }
    
    for (NSInteger i = 0; i < self.soundColumns.count; i++) {
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

- (void)removeAnimation {
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
                RJItemScaleKey : @0.5, RJItemAnimationFromValueKey : @0.8, RJItemAnimationToValueKey : @1.2, RJItemAnimationDurationKey : @0.5
            },
            @{
                RJItemScaleKey : @1.0, RJItemAnimationFromValueKey : @1.0, RJItemAnimationToValueKey : @0.4, RJItemAnimationDurationKey : @0.25
            },
            @{
                RJItemScaleKey : @0.7, RJItemAnimationFromValueKey : @1.0, RJItemAnimationToValueKey : @0.357, RJItemAnimationDurationKey : @0.5
            },
            @{
                RJItemScaleKey : @0.25, RJItemAnimationFromValueKey : @1.0, RJItemAnimationToValueKey : @2.8, RJItemAnimationDurationKey : @0.5
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
