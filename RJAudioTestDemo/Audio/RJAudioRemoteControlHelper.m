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

@implementation RJAudioRemoteControlHelper

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
