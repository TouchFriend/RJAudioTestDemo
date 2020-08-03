//
//  RJCMTimeTestViewController.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/31.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJCMTimeTestViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RJCMTimeTestViewController ()

@end

@implementation RJCMTimeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    CMTime t1 = CMTimeMake(5, 1);
//    CMTime t2 = CMTimeMake(3000, 600);
//    CMTime t3 = CMTimeMake(5000, 1000);
//    CMTimeShow(t1);
//    CMTimeShow(t2);
//    CMTimeShow(t3);
//
//    CMTimeShow(CMTimeSubtract(t1, CMTimeMake(20, 10)));
    CMTimeShow(CMTimeMakeWithSeconds(5, 600));
}



@end
