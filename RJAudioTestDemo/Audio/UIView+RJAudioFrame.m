//
//  UIView+RJAudioFrame.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/11.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "UIView+RJAudioFrame.h"

@implementation UIView (RJAudioFrame)

- (void)setRj_x:(CGFloat)rj_x
{
    CGRect frame = self.frame;
    frame.origin.x = rj_x;
    self.frame = frame;
}
- (CGFloat)rj_x
{
    return self.frame.origin.x;
}

- (void)setRj_y:(CGFloat)rj_y
{
    CGRect frame = self.frame;
    frame.origin.y = rj_y;
    self.frame = frame;
}
- (CGFloat)rj_y
{
    return self.frame.origin.y;
}

- (void)setRj_width:(CGFloat)rj_width
{
    CGRect frame = self.frame;
    frame.size.width = rj_width;
    self.frame = frame;
}
- (CGFloat)rj_width
{
    return self.frame.size.width;
}

- (void)setRj_height:(CGFloat)rj_height
{
    CGRect frame = self.frame;
    frame.size.height = rj_height;
    self.frame = frame;
}

- (CGFloat)rj_height
{
    return self.frame.size.height;
}

- (void)setRj_centerX:(CGFloat)rj_centerX
{
    CGPoint point = self.center;
    point.x = rj_centerX;
    self.center = point;
}

- (CGFloat)rj_centerX
{
    return self.center.x;
}

- (void)setRj_centerY:(CGFloat)rj_centerY
{
    CGPoint point = self.center;
    point.y = rj_centerY;
    self.center = point;
}


- (CGFloat)rj_centerY
{
    return self.center.y;
}

- (void)setRj_maxX:(CGFloat)rj_maxX
{
    CGRect frame = self.frame;
    frame.origin.x = rj_maxX - frame.size.width;
    self.frame = frame;
}

- (CGFloat)rj_maxX
{
    return CGRectGetMaxX(self.frame);
}


- (CGFloat)rj_maxY
{
    return CGRectGetMaxY(self.frame);
}
- (void)setRj_maxY:(CGFloat)RJ_maxY
{
    CGRect frame = self.frame;
    frame.origin.y = RJ_maxY - frame.size.height;
    self.frame = frame;
}

- (CGSize)rj_size
{
    return self.frame.size;
}

- (void)setRj_size:(CGSize)rj_size
{
    CGRect frame = self.frame;
    frame.size = rj_size;
    self.frame = frame;
}

- (CGPoint)rj_origin
{
    return self.frame.origin;
}

- (void)setRj_origin:(CGPoint)rj_origin
{
    CGRect frame = self.frame;
    frame.origin = rj_origin;
    self.frame = frame;
}


@end
