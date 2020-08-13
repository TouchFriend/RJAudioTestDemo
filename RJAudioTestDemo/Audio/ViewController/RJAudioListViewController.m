//
//  RJAudioListViewController.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/12.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioListViewController.h"
#import "RJAudioPlayerMiniControlView.h"
#import "RJAudioPlayerViewController.h"
#import "RJAudioPlayerController.h"

@interface RJAudioListViewController () <RJAudioPlayerMiniControlViewDelegate>

/// <#Desription#>
@property (nonatomic, strong) RJAudioPlayerMiniControlView *miniControlView;


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
    
    UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:jumpBtn];
    jumpBtn.bounds = CGRectMake(0, 0, 100, 60.0);
    jumpBtn.center = self.view.center;
    [jumpBtn setBackgroundColor:[UIColor orangeColor]];
    [jumpBtn setTitle:@"跳转" forState:UIControlStateNormal];
    [jumpBtn addTarget:self action:@selector(jumpBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)jumpBtnClick {
    RJAudioPlayerViewController *playerVC = [[RJAudioPlayerViewController alloc] init];
    playerVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:playerVC animated:YES completion:nil];
}

- (RJAudioPlayerMiniControlView *)miniControlView {
    if (!_miniControlView) {
        _miniControlView = [[RJAudioPlayerMiniControlView alloc] init];
        _miniControlView.delegate = self;
    }
    
    return _miniControlView;
}

@end
