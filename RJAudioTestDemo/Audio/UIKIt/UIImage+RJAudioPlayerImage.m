//
//  UIImage+RJAudioPlayerImage.m
//  RJFormDemo
//
//  Created by TouchWorld on 2019/8/12.
//  Copyright © 2019 RJSoft. All rights reserved.
//

#import "UIImage+RJAudioPlayerImage.h"
#import "NSBundle+RJAudioPlayerBundle.h"

@implementation UIImage (RJAudioPlayerImage)

+ (instancetype)rj_imageNamedFromMyBundle:(NSString *)name
{
    NSBundle *imageBundle = [NSBundle rj_formBundle];
    name = [name stringByAppendingString:@"@2x"];
    NSString *imagePath = [imageBundle pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (!image)
    {
        //兼容业务方自己设置图片的方式
        name = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
        image = [UIImage imageNamed:name];
    }
    return image;
}

@end
