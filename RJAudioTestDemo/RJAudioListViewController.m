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
#import <KTVHTTPCache/KTVHTTPCache.h>
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
    
    [self setupHTTPCache];
    
    UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:jumpBtn];
    jumpBtn.bounds = CGRectMake(0, 0, 100, 60.0);
    jumpBtn.center = self.view.center;
    [jumpBtn setBackgroundColor:[UIColor orangeColor]];
    [jumpBtn setTitle:@"跳转" forState:UIControlStateNormal];
    [jumpBtn addTarget:self action:@selector(jumpBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupHTTPCache {
    [KTVHTTPCache logSetConsoleLogEnable:YES]; // 控制器输出日志
    [KTVHTTPCache logSetRecordLogEnable:NO]; // 记录日志到文件中
    NSError *startError = nil;
    [KTVHTTPCache proxyStart:&startError];
    if (startError) {
        NSLog(@"proxy start error:%@.", startError);
    } else {
        NSLog(@"proxy start success.");
    }
    
    [KTVHTTPCache downloadSetTimeoutInterval:30.0];
    NSLog(@"cacheMaxCacheLength:%lld", [KTVHTTPCache cacheMaxCacheLength]);
    NSLog(@"cacheTotalCacheLength:%lld", [KTVHTTPCache cacheTotalCacheLength]);
    [KTVHTTPCache encodeSetURLConverter:^NSURL *(NSURL *URL) {
        NSLog(@"URL Filter reviced URL : %@", URL);
        return URL;
    }];
    
    [KTVHTTPCache downloadSetUnacceptableContentTypeDisposer:^BOOL(NSURL *URL, NSString *contentType) {
        NSLog(@"Unsupport Content-Type Filter reviced URL : %@, %@", URL, contentType);
        return NO;
    }];
}

- (void)jumpBtnClick {
    [self setupAudioAsserts];
    RJAudioPlayerViewController *playerVC = [[RJAudioPlayerViewController alloc] init];
    playerVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:playerVC animated:YES completion:nil];
}

- (void)setupAudioAsserts {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"蒲公英的约定" ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:path];
    RJAudioAssertItem *item = [[RJAudioAssertItem alloc] init];
    item.title = @"蒲公英的约定";
    item.assertURL = url;
    NSString *urlString = @"https://mr3.doubanio.com/f229d8a03ba08bde8969de3899f773d2/0/fm/song/p1390309_128k.mp4";
    NSURL *originalURL = [NSURL URLWithString:urlString];
    NSURL *completedURL = [KTVHTTPCache cacheCompleteFileURLWithURL:originalURL];
    NSURL *proxyURL = nil;
    if (completedURL) {
        proxyURL = completedURL;
        NSLog(@"completedURL:%@", completedURL);
    } else {
        proxyURL = [KTVHTTPCache proxyURLWithOriginalURL:originalURL];
    }
//    NSString *urlString = [[NSBundle mainBundle] pathForResource:@"偏爱" ofType:@"mp4"];
    RJAudioAssertItem *item2 = [[RJAudioAssertItem alloc] init];
    item2.title = @"偏爱";
    item2.assertURL = proxyURL;
    
    RJAudioPlayerController *playerController = [RJAudioPlayerController sharedInstance];
    playerController.audioAsserts = @[item, item2];
    NSInteger playIndex = 0;
    if (playerController.currentPlayIndex == playIndex) {
        [playerController playOrResume];
    } else {
        [playerController playWithIndex:playIndex];
    }
    
}

- (RJAudioPlayerMiniControlView *)miniControlView {
    if (!_miniControlView) {
        _miniControlView = [[RJAudioPlayerMiniControlView alloc] init];
        _miniControlView.delegate = self;
    }
    
    return _miniControlView;
}

@end
