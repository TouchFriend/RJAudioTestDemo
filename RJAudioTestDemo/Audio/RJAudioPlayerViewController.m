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
}

#pragma mark - Setup Init

- (void)setupInit {
    [self setupPlayerController];
    [self setupLockScreenRemoteControl];

}

- (void)setupPlayerController {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"蒲公英的约定" ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:path];
        RJAudioAssertItem *item = [[RJAudioAssertItem alloc] init];
        item.title = @"蒲公英的约定";
        item.assertURL = url;
        NSString *urlString = @"https://mr3.doubanio.com/f229d8a03ba08bde8969de3899f773d2/0/fm/song/p1390309_128k.mp4";
    //    NSString *urlString = [[NSBundle mainBundle] pathForResource:@"偏爱" ofType:@"mp4"];
        RJAudioAssertItem *item2 = [[RJAudioAssertItem alloc] init];
        item2.title = @"偏爱";
        item2.assertURL = [NSURL fileURLWithPath:urlString];
        self.audioPlayerController = [RJAudioPlayerController playerWithPlayer:[RJAudioPlayer player] containerView:self.view];
        self.audioPlayerController.audioAsserts = @[item, item2];
        [self.audioPlayerController play];
}

- (void)setupLockScreenRemoteControl {
    __weak typeof(self) weakSelf = self;
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"播放音频");
        [weakSelf.audioPlayerController.currentPlayer resume];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"暂停音频");
        [weakSelf.audioPlayerController.currentPlayer pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.stopCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"停止音频");
        [weakSelf.audioPlayerController.currentPlayer stop];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"下一首音频");
        [weakSelf.audioPlayerController playNextSong];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"上一首音频");
        [weakSelf.audioPlayerController playPreviousSong];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    if (@available(iOS 9.1, *)) {
        [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            NSLog(@"改变进度条");
            MPChangePlaybackPositionCommandEvent *positionCommandEvent = (MPChangePlaybackPositionCommandEvent *)event;
            NSLog(@"%lf", positionCommandEvent.positionTime);
            [weakSelf.audioPlayerController.currentPlayer seekToTime:positionCommandEvent.positionTime completionHandler:^(BOOL finished) {
                NSLog(@"远程控制拖动进度条%@", finished ? @"成功" : @"失败");
            }];
            return MPRemoteCommandHandlerStatusSuccess;
        }];
    } else {
        // Fallback on earlier versions
    }
    
    // 播放和暂停按钮（耳机）
    [commandCenter.togglePlayPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"切换暂停和恢复");
        RJAudioPlayer *player = weakSelf.audioPlayerController.currentPlayer;
        if ([player isPlaying]) {
            [player pause];
        } else {
            [player resume];
        }
        [weakSelf.audioPlayerController playPreviousSong];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}




- (void)setupPlayer {
    // https://mr3.doubanio.com/f229d8a03ba08bde8969de3899f773d2/0/fm/song/p1390309_128k.mp4
        NSString *urlString = @"https://mr3.doubanio.com/f229d8a03ba08bde8969de3899f773d2/0/fm/song/p1390309_128k.mp4";
        
//        self.player = [RJAudioPlayer playerWithURL:[NSURL URLWithString:urlString]];
        
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"蒲公英的约定" ofType:@"mp3"];
    //    self.player = [RJAudioPlayer playerWithURL:[NSURL fileURLWithPath:path]];
}



@end
