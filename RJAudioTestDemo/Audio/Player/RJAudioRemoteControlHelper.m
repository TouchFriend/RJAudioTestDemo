//
//  RJAudioRemoteControlHelper.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/5.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioRemoteControlHelper.h"
#import "RJAudioPlayerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RJAudioAssertItem.h"
#import "RJAudioPlayerController.h"

@implementation RJAudioRemoteControlHelper

+ (instancetype)helperWithPlayer:(RJAudioPlayerController *)playerController {
    RJAudioRemoteControlHelper *helper = [[self alloc] init];
    helper.playerController = playerController;
    return helper;
}

- (void)setupLockScreenRemoteControl {
    __weak typeof(self) weakSelf = self;
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"播放音频");
        [weakSelf.playerController.currentPlayer play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"暂停音频");
        [weakSelf.playerController.currentPlayer pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.stopCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"停止音频");
        [weakSelf.playerController.currentPlayer stop];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"下一首音频");
        [weakSelf.playerController playNextSong];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"上一首音频");
        [weakSelf.playerController playPreviousSong];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    if (@available(iOS 9.1, *)) {
        [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            NSLog(@"改变进度条");
            MPChangePlaybackPositionCommandEvent *positionCommandEvent = (MPChangePlaybackPositionCommandEvent *)event;
            NSLog(@"%lf", positionCommandEvent.positionTime);
            [weakSelf.playerController.currentPlayer seekToTime:positionCommandEvent.positionTime completionHandler:^(BOOL finished) {
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
        RJAudioPlayer *player = weakSelf.playerController.currentPlayer;
        if ([player isPlaying]) {
            [player pause];
        } else {
            [player play];
        }
        [weakSelf.playerController playPreviousSong];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}

+ (void)setupLockScreenMediaInfo:(RJAudioPlayerController *)playerController {
    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    RJAudioAssertItem *item = [playerController currentAssertItem];
    NSMutableDictionary *playInfo = [NSMutableDictionary dictionary];
    playInfo[MPMediaItemPropertyTitle] = item.title; // 歌曲名
    playInfo[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"audio_play_spin_icon"]]; // 专辑图片
    playInfo[MPNowPlayingInfoPropertyPlaybackRate] = [NSNumber numberWithFloat:1.0]; // 播放速度
    playInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = [NSNumber numberWithFloat:playerController.currentPlayer.currentTime]; // 当前播放时间
    playInfo[MPMediaItemPropertyPlaybackDuration] = [NSNumber numberWithFloat:playerController.currentPlayer.totalTime]; // 总共时间
    if (@available(iOS 10.0, *)) {
        playInfo[MPNowPlayingInfoPropertyPlaybackProgress] = [NSNumber numberWithFloat:playerController.currentPlayer.currentTime / playerController.currentPlayer.totalTime]; // 当前播放进度
    } else {
        // Fallback on earlier versions
    }
    infoCenter.nowPlayingInfo = playInfo;
    
}

@end
