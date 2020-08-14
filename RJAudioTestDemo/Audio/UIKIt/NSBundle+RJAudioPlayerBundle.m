//
//  NSBundle+RJAudioPlayerBundle.m
//  RJFormDemo
//
//  Created by TouchWorld on 2019/8/12.
//  Copyright © 2019 RJSoft. All rights reserved.
//

#import "NSBundle+RJAudioPlayerBundle.h"
#import "RJAudioPlayer.h"

@implementation NSBundle (RJAudioPlayerBundle)

+ (instancetype)rj_formBundle
{
    static NSBundle *formBundle = nil;
    if (formBundle == nil)
    {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        NSBundle *bundle = [NSBundle bundleForClass:[RJAudioPlayer class]];
        formBundle = [NSBundle bundleWithPath:[bundle pathForResource:@"RJAudioPlayerKit" ofType:@"bundle"]];
    }
    return formBundle;
}

@end
