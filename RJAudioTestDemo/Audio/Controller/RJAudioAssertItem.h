//
//  RJAudioAssertItem.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/4.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJAudioAssertItem : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;
/// 专辑图片地址
@property (nonatomic, strong) NSURL *albumIconURL;
/// 资源地址
@property (nonatomic, strong) NSURL *assertURL;




@end

NS_ASSUME_NONNULL_END
