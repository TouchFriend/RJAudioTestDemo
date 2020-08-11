//
//  RJAudioPlayer.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/30.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RJAudioPlayerPlaybackState) {
    RJAudioPlayerPlaybackStateUnknow = 0,       // 未知
    RJAudioPlayerPlaybackStatePlaying,          // 正在播放
    RJAudioPlayerPlaybackStatePaused,           // 暂停
    RJAudioPlayerPlaybackStatePlayFailed,       // 播放失败
    RJAudioPlayerPlaybackStatePlayStopped       // 停止
};

typedef NS_ENUM(NSUInteger, RJAudioPlayerLoadState) {
    RJAudioPlayerLoadStateUnknow = 0,           // 未知
    RJAudioPlayerLoadStatePrepare,              // 准备
    RJAudioPlayerLoadStatePlayable,             // 可播放
    RJAudioPlayerLoadStatePlayThroughOK,        // 在这个状态会自动开始播放
    RJAudioPlayerLoadStateStalled               // 在这个状态会自动暂停播放
};

@class RJAudioPlayer;

@protocol RJAudioPlayerDelegate <NSObject>

@optional

/// 当前播放进度。如果timeObserverQueue不为NULL，可能不在主队列回调。
/// @param player 播放器
/// @param current 当前播放时间
/// @param total 全部播放时间
- (void)audioPlayerPlayTimeChanged:(RJAudioPlayer *_Nonnull)player currentTime:(NSTimeInterval)current totalTime:(NSTimeInterval)total;

/// 缓存时间改变
/// @param player 播放器
/// @param bufferTime 缓存时间
- (void)audioPlayerBufferTimeDidChanged:(RJAudioPlayer *_Nonnull)player bufferTime:(NSTimeInterval)bufferTime;

/// 播放状态改变
/// @param player 播放器
/// @param url 播放地址
/// @param state 播放状态
- (void)audioPlayer:(RJAudioPlayer *_Nonnull)player forURL:(NSURL *_Nonnull)url playStateChanged:(RJAudioPlayerPlaybackState)state;

/// 加载状态改变
/// @param player 播放器
/// @param url 播放地址
/// @param loadState 加载状态
- (void)audioPlayer:(RJAudioPlayer *_Nonnull)player forURL:(NSURL *_Nonnull)url loadStateChanged:(RJAudioPlayerLoadState)loadState;

/// 准备好播放
/// @param player 播放器
/// @param url 播放地址
- (void)audioPlayer:(RJAudioPlayer *_Nonnull)player readyToPlayForURL:(NSURL *_Nonnull)url;

/// 播放到末尾
/// @param player 播放器
/// @param url 播放地址
- (void)audioPlayer:(RJAudioPlayer *_Nonnull)player didPlayeToEndTimeWithURL:(NSURL *_Nonnull)url;

/// 播放失败
/// @param player 播放器
/// @param url 播放地址
/// @param error 错误
- (void)audioPlayer:(RJAudioPlayer *_Nonnull)player playFailedForURL:(NSURL *_Nonnull)url error:(NSError *_Nonnull)error;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RJAudioPlayer : NSObject

/// 代理
@property (nonatomic, weak) id <RJAudioPlayerDelegate> delegate;
/// 播放地址
@property (nonatomic, strong, readonly, nullable) NSURL *url;
/// 是否准备好可以播放
@property (nonatomic, assign, readonly) BOOL isPreparedToPlay;
/// 是否允许自动播放，默认YES
@property (nonatomic, assign) BOOL shouldAutoPlay;

/// 是否正在播放
@property (nonatomic, assign, readonly, getter=isPlaying) BOOL playing;
/// 当前时间
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
/// 全部时间
@property (nonatomic, assign, readonly) NSTimeInterval totalTime;
/// 缓存时间
@property (nonatomic, assign, readonly) NSTimeInterval bufferTime;
/// 播放器的seek time
@property (nonatomic, assign) NSTimeInterval seekTime;

/// 时间观察队列，只能是串行队列，如果是并发队列，可能会造成未知问题。 为Null，则使用主队列
@property (nonatomic, strong, nullable) dispatch_queue_t timeObserverQueue;
/// 播放状态
@property (nonatomic, assign) RJAudioPlayerPlaybackState playbackState;
/// 加载状态
@property (nonatomic, assign) RJAudioPlayerLoadState loadState;


/// 构造方法
+ (instancetype)player;

/// 构造方法
/// @param url 播放地址
+ (instancetype)playerWithURL:(NSURL *_Nullable)url;

/// 构造方法
/// @param url 播放地址
- (instancetype)initWithURL:(NSURL *_Nullable)url;

/// 播放音频
/// @param url 播放地址
- (void)playWithURL:(NSURL *)url;

/// 准备播放
- (void)prepareToPlay;

/// 播放
- (void)play;

/// 暂停播放
- (void)pause;

/// 停止播放
- (void)stop;

/// 重头开始播放
- (void)replay;

/// 从指定时间播放
/// @param time 时间
/// @param completionHandler 完成回调
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL finished))completionHandler;

@end

NS_ASSUME_NONNULL_END
