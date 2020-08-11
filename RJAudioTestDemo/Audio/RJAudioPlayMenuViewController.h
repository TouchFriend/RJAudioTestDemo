//
//  RJAudioPlayMenuViewController.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/11.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJAudioGlobalConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface RJAudioPlayMenuViewController : UIViewController

/// 播放顺序
@property (nonatomic, assign) RJAudioPlayOrder playOrder;

@end

NS_ASSUME_NONNULL_END
