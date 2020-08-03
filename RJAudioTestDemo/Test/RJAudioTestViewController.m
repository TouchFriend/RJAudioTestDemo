//
//  RJAudioTestViewController.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/27.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioTestViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "RJPerson.h"
#import "RJLargeTapRangeButton.h"

@interface RJAudioTestViewController ()

@end

@implementation RJAudioTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *testView = [[UIView alloc] init];
    [self.view addSubview:testView];
//    testView.frame = CGRectMake(100, 100, 50, 50);
//    testView.center = CGPointMake(200, 100);
    testView.bounds= CGRectMake(0, 0, 100, 100);
    testView.frame = CGRectMake(0, 0, 10, 10);
    testView.backgroundColor = [UIColor redColor];
    
}

- (void)addButtonTapRange {
    UIView *rangeView = [[UIView alloc] init];
    rangeView.bounds = CGRectMake(0, 0, 100, 100);
    rangeView.center = self.view.center;
    [self.view addSubview:rangeView];
    rangeView.backgroundColor = [UIColor redColor];
    
    RJLargeTapRangeButton *btn = [RJLargeTapRangeButton buttonWithType:UIButtonTypeCustom];
    btn.bounds = CGRectMake(0, 0, 50, 50);
    btn.center = self.view.center;
    [self.view addSubview:btn];
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick {
    NSLog(@"%s", __func__);
}

- (void)pointTest {
    RJPerson *person = [[RJPerson alloc] init];
    person->_age = 18;
    NSLog(@"%@--%ld", person.name, person->_age);
}

- (void)volumeViewTest {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    volumeView.bounds = CGRectMake(0, 0, 300, 20.0);
    volumeView.center = self.view.center;
    [self.view addSubview:volumeView];
    volumeView.showsVolumeSlider = YES;
    volumeView.showsRouteButton = NO;
    [volumeView setMinimumVolumeSliderImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
    [volumeView setMaximumVolumeSliderImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
    [volumeView setVolumeThumbImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
    volumeView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
    volumeView.layer.cornerRadius = 4.0;
    volumeView.layer.masksToBounds = YES;
}



@end
