//
//  UIView+RJAudioFrame.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/11.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (RJAudioFrame)

/********* x坐标 *********/
@property (nonatomic, assign) CGFloat rj_x;
/******** * y坐标 *********/
@property(nonatomic, assign) CGFloat rj_y;
/********* width坐标 *********/
@property (nonatomic, assign) CGFloat rj_width;
/********* height坐标 *********/
@property (nonatomic, assign) CGFloat rj_height;
/********* 中心x坐标 *********/
@property (nonatomic, assign) CGFloat rj_centerX;
/********* 中心y坐标 *********/
@property (nonatomic, assign) CGFloat rj_centerY;
/********* 最大x值 *********/
@property (nonatomic, assign) CGFloat rj_maxX;
/********* 最大y值 *********/
@property (nonatomic, assign) CGFloat rj_maxY;
/********* size *********/
@property (nonatomic, assign) CGSize rj_size;
/********* origin *********/
@property (nonatomic, assign) CGPoint rj_origin;

@end

NS_ASSUME_NONNULL_END
