//
//  RJAudioConst.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#ifndef RJAudioConst_h
#define RJAudioConst_h


#define RJAudioThemeColor [UIColor colorWithRed:36.0 / 255.0 green:153.0 / 255.0 blue:255.0 / 255.0 alpha:1.0]

/*************** 适配iPhone X *********************/

// 判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iPhoneXr  iPhone11
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iPhoneXs  iPhone11 pro
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iPhoneXs Max  iPhone11 pro max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size): NO)

//是否是FaceID
#define IS_FaceID (IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES)

// 状态栏高度
#define STATUS_BAR_HEIGHT (IS_FaceID ? 44.0 : 20.0)
// 导航条高度
#define NAVIGATION_BAR_HEIGHT 44.0
// 导航栏高度
#define NAVIGATION_BAR_Max_Y (IS_FaceID ? 88.0 : 64.0)
// tabBar高度
#define TAB_BAR_HEIGHT (IS_FaceID ? 83.0 : 49.0)
// home indicator
#define HOME_INDICATOR_HEIGHT (IS_FaceID ? 34.0 : 0)

/*************** 适配iPhone X *********************/

#endif /* RJAudioConst_h */
