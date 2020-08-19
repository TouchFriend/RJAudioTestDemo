//
//  RJAudioPlayViewController.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/30.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioPlayViewController.h"
#import "RJAudioAssertItem.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface RJAudioPlayViewController ()

/// <#Desription#>
@property (nonatomic, strong) RJAudioPlayerController *audioPlayerController;

@end


@implementation RJAudioPlayViewController

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
    self.audioPlayerController.delegate = self;
    self.audioPlayerController.containerView = self.view;
    self.audioPlayerController.viewController = self;
}

#pragma mark - RJAudioPlayerControllerDelegate Methods

- (void)playerController:(RJAudioPlayerController *)controller playIndexDidChange:(NSInteger)playIndex item:(RJAudioAssertItem * _Nonnull)item {
    NSLog(@"索引改变--%ld, %@", playIndex, item.assertURL.absoluteString);
}

- (void)playerController:(RJAudioPlayerController *)controller fileToDownload:(RJAudioAssertItem * _Nonnull)item {
    NSLog(@"下载音频:%@", item.assertURL.absoluteString);
}

- (void)playerController:(RJAudioPlayerController *)controller playFailed:(RJAudioAssertItem *)item error:(NSError *)error {
    NSLog(@"播放错误:%@, error:%@", item.assertURL, error);
}

@end
