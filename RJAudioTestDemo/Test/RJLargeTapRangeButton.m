//
//  RJLargeTapRangeButton.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/28.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJLargeTapRangeButton.h"

@implementation RJLargeTapRangeButton

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat radius = 25;
    CGRect bounds = self.bounds;
    // 扩大点击区域
    bounds = CGRectInset(bounds, -radius, -radius);
    if (CGRectContainsPoint(bounds, point)) {
        return YES;
    }

    return [super pointInside:point withEvent:event];
}


@end
