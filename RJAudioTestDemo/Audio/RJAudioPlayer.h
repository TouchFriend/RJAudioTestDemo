//
//  RJAudioPlayer.h
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/30.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RJAudioPlayer;

@protocol RJAudioPlayerDelegate <NSObject>

/// 当前播放进度。如果timeObserverQueue不为NULL，可能不在主队列回调。
/// @param player 播放器
/// @param current 当前播放时间
/// @param total 全部播放时间
- (void)audioPlayer:(RJAudioPlayer *_Nonnull)player currentTime:(NSTimeInterval)current totalTime:(NSTimeInterval)total;

/// 开始播放
/// @param player 播放器
/// @param url 播放地址
- (void)audioPlayer:(RJAudioPlayer *_Nonnull)player beginPlayWithURL:(NSURL *_Nonnull)url;

/// 暂停播放
/// @param player 播放器
/// @param url 播放地址
- (void)audioPlayer:(RJAudioPlayer *_Nonnull)player didPausedPlayWithURL:(NSURL *_Nonnull)url;

/// 恢复播放
/// @param player 播放器
/// @param url 播放地址
- (void)audioPlayer:(RJAudioPlayer *_Nonnull)player didResumedPlayWithURL:(NSURL *_Nonnull)url;

/// 停止播放
/// @param player 播放器
/// @param url 播放地址
- (void)audioPlayer:(RJAudioPlayer *_Nonnull)player didStopedPlayWithURL:(NSURL *_Nonnull)url;

/// 播放到末尾
/// @param player 播放器
/// @param url 播放地址
- (void)audioPlayer:(RJAudioPlayer *_Nonnull)player didPlayeToEndTimeWithURL:(NSURL *_Nonnull)url;

/// 播放失败
/// @param player 播放器
/// @param url 播放地址
/// @param error 错误
- (void)audioPlayer:(RJAudioPlayer *_Nonnull)player failedToPlayToEndTimeWithURL:(NSURL *_Nonnull)url error:(NSError *_Nonnull)error;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RJAudioPlayer : NSObject

/// 代理
@property (nonatomic, weak) id <RJAudioPlayerDelegate> delegate;
/// 播放地址
@property (nonatomic, strong, readonly, nullable) NSURL *url;
/// 是否正在播放
@property (nonatomic, assign, readonly, getter=isPlaying) BOOL playing;
/// 当前时间
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
/// 全部时间
@property (nonatomic, assign, readonly) NSTimeInterval totalTime;
/// 时间观察队列，只能是串行队列，如果是并发队列，可能会造成未知问题。 为Null，则使用主队列
@property (nonatomic, strong, nullable) dispatch_queue_t timeObserverQueue;


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

/// 播放
- (void)play;

/// 暂停播放
- (void)pause;

/// 恢复播放
- (void)resume;

/// 停止播放
- (void)stop;

/// 从指定时间播放
/// @param time 时间
/// @param completionHandler 完成回调
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL finished))completionHandler;

@end

NS_ASSUME_NONNULL_END
