//
//  RJAudioRemoteControlHelper.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/5.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RJAudioPlayerController;
NS_ASSUME_NONNULL_BEGIN

@interface RJAudioRemoteControlHelper : NSObject

+ (void)setupLockScreenMediaInfo:(RJAudioPlayerController *)playerController;

@end

NS_ASSUME_NONNULL_END
