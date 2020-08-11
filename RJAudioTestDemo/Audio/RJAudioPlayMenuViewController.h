//
//  RJAudioPlayMenuViewController.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/11.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJAudioGlobalConst.h"

@protocol RJAudioPlayMenuProtocol <NSObject>

@optional

- (void)playOrderDidChange:(RJAudioPlayOrder)playOrder;

- (void)playIndexDidChange:(NSInteger)playIndex;

@end

@class RJAudioAssertItem;

NS_ASSUME_NONNULL_BEGIN

@interface RJAudioPlayMenuViewController : UIViewController

/// delegate
@property (nonatomic, weak) id <RJAudioPlayMenuProtocol> delegate;
/// 播放顺序
@property (nonatomic, assign) RJAudioPlayOrder playOrder;
/// 音频资源
@property (nonatomic, strong) NSArray<RJAudioAssertItem *> *audioAsserts;
/// 播放索引
@property (nonatomic, assign) NSUInteger playIndex;


- (void)changeAudioAsserts:(NSArray<RJAudioAssertItem *> *)audioAsserts playIndex:(NSInteger)playIndex;

- (void)changePlayIndex:(NSInteger)playIndex;

@end

NS_ASSUME_NONNULL_END
