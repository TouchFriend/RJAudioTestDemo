//
//  RJAudioPlayerViewControllerProtocol.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/13.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RJAudioPlayerViewControllerProtocol <NSObject>

/// <#Desription#>
@property (nonatomic, strong) NSNumber *isPlay;

- (void)downloadAudio:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
