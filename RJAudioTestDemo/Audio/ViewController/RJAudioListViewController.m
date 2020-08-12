//
//  RJAudioListViewController.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/12.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioListViewController.h"
#import "RJAudioPlayerMiniControlView.h"

@interface RJAudioListViewController ()

/// <#Desription#>
@property (nonatomic, weak) RJAudioPlayerMiniControlView *miniControlView;

@end

@implementation RJAudioListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

#pragma mark - Setup Init

- (void)setupInit {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].windows.lastObject;
    RJAudioPlayerMiniControlView *miniControlView = [[RJAudioPlayerMiniControlView alloc] init];
    [keyWindow addSubview:miniControlView];
    miniControlView.frame = CGRectMake(RJMiniControlViewMargin, 200, 150, 50.0);
    miniControlView.layer.cornerRadius = 25.0;
    miniControlView.layer.masksToBounds = YES;
    self.miniControlView = miniControlView;
    
}


@end
