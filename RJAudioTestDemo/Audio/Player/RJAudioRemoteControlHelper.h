//
//  RJAudioRemoteControlHelper.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/5.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RJAudioPlayerController;

@class RJAudioPlayerController;
NS_ASSUME_NONNULL_BEGIN

@interface RJAudioRemoteControlHelper : NSObject

/// <#Desription#>
@property (nonatomic, weak) RJAudioPlayerController *playerController;

+ (instancetype)helperWithPlayer:(RJAudioPlayerController *)playerController;

- (void)setupLockScreenRemoteControl;

+ (void)setupLockScreenMediaInfo:(RJAudioPlayerController *)playerController;

@end

NS_ASSUME_NONNULL_END
