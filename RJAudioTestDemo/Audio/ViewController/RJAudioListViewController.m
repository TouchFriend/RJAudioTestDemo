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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.miniControlView.frame = CGRectMake(100, 100, 150, 50.0);
    self.miniControlView.layer.cornerRadius = 25.0;
    self.miniControlView.layer.masksToBounds = YES;
}

#pragma mark - Setup Init

- (void)setupInit {
    self.view.backgroundColor = [UIColor whiteColor];
    
    RJAudioPlayerMiniControlView *miniControlView = [[RJAudioPlayerMiniControlView alloc] init];
    [self.view addSubview:miniControlView];
    self.miniControlView = miniControlView;
    
}


@end
