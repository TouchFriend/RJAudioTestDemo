//
//  RJAudioColumnItem.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/12.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJAudioColumnItem : NSObject

/// 比例
@property (nonatomic, strong) NSNumber *scale;
/// 动画fromValue
@property (nonatomic, strong) NSNumber *animationFromValue;
/// 动画ToValue
@property (nonatomic, strong) NSNumber *animationToValue;
/// 动画持续时间
@property (nonatomic, strong) NSNumber *animationDuration;

@end

NS_ASSUME_NONNULL_END
