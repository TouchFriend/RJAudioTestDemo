//
//  RJAudioPlayerViewController.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/30.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioPlayerViewController.h"
#import "RJAudioPlayerController.h"
#import "RJAudioAssertItem.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <KTVHTTPCache/KTVHTTPCache.h>

@interface RJAudioPlayerViewController ()

/// <#Desription#>
@property (nonatomic, strong) RJAudioPlayerController *audioPlayerController;

@end


@implementation RJAudioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.audioPlayerController.miniControlView hidden];
}

- (void)dealloc {
    [self.audioPlayerController.miniControlView show];
    NSLog(@"RJAudioPlayerViewControlleri is dead");
}

#pragma mark - Setup Init

- (void)setupInit {
    
    [self setupPlayerController];

}

- (void)setupPlayerController {
    self.audioPlayerController = [RJAudioPlayerController sharedInstance];
    self.audioPlayerController.containerView = self.view;
    self.audioPlayerController.viewController = self;
}

- (void)downloadAudio:(NSURL *)url {
    NSLog(@"下载音频:%@", url.absoluteString);
    [self.audioPlayerController.controlView changeDownloadState:YES];
}

@end
