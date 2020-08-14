//
//  RJAudioPlayerController.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/3.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioPlayerController.h"
#import "RJAudioRemoteControlHelper.h"
#import "RJAudioPlayMenuViewController.h"
#import "RJAudioPlayerViewController.h"

@interface RJAudioPlayerController () <RJAudioPlayerDelegate, RJAudioPlayerControlViewDelegate, RJAudioPlayMenuProtocol, RJAudioPlayerMiniControlViewDelegate> {
    
    RJAudioPlayerControlView *_controlView;
    RJAudioPlayerMiniControlView *_miniControlView;
    Class <RJAudioPlayerViewControllerProtocol> _modalViewControllerClass;
}

/// <#Desription#>
@property (nonatomic, weak) RJAudioPlayMenuViewController *playMenuViewController;
/// <#Desription#>
@property (nonatomic, strong) RJAudioRemoteControlHelper *remoteControlHelper;


@end

@implementation RJAudioPlayerController

#pragma mark - Init Methods

+ (instancetype)sharedInstance {
    static RJAudioPlayerController *_playerController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _playerController = [[RJAudioPlayerController alloc] initWithPlayer:[RJAudioPlayer player] viewController:nil containerView:nil];
    });
    
    return _playerController;
}

+ (instancetype)playerWithPlayer:(RJAudioPlayer *)player viewController:(UIViewController *)viewController containerView:(UIView *)containerView {
    return [[self alloc] initWithPlayer:player viewController:viewController containerView:containerView];
}

- (instancetype)initWithPlayer:(RJAudioPlayer *)player viewController:(UIViewController *)viewController containerView:(UIView *)containerView {
    self = [self init];
    if (self) {
        self.currentPlayer = player;
        self.containerView = containerView;
        self.viewController = viewController;
        [self.remoteControlHelper setupLockScreenRemoteControl];
    }
    return self;
}

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Private Methods

- (void)layoutPlayerSubviews {
    if (!self.containerView) {
        return;
    }
    
    [self.containerView addSubview:self.controlView];
    self.controlView.frame = self.containerView.bounds;
    self.controlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - RJAudioPlayerDelegate Methods

- (void)audioPlayerPlayTimeChanged:(RJAudioPlayer *)player currentTime:(NSTimeInterval)current totalTime:(NSTimeInterval)total {
    [self.controlView changeCurrentTime:current totalTime:total];
    [RJAudioRemoteControlHelper setupLockScreenMediaInfo:self];
}

- (void)audioPlayerBufferTimeDidChanged:(RJAudioPlayer *)player bufferTime:(NSTimeInterval)bufferTime {
    [self.controlView changeBufferTime:bufferTime];
}

- (void)audioPlayer:(RJAudioPlayer *)player forURL:(NSURL *)url playStateChanged:(RJAudioPlayerPlaybackState)state {
    BOOL isPlay = NO;
    switch (state) {
        case RJAudioPlayerPlaybackStatePlaying:
        {
            [self.controlView play];
            [self.miniControlView play];
            isPlay = YES;
        }
            break;
        case RJAudioPlayerPlaybackStatePaused:
        {
            [self.controlView pause];
            [self.miniControlView pause];
            isPlay = NO;
        }
            break;
        case RJAudioPlayerPlaybackStatePlayStopped:
        {
            [self.controlView pause];
            [self.miniControlView pause];
            isPlay = NO;
            
        }
            break;
            
        default:
            break;
    }
    
    if (self.playMenuViewController) {
        [self.playMenuViewController changePlayState:isPlay];
    }
}

- (void)audioPlayer:(RJAudioPlayer *)player didStopedPlayWithURL:(NSURL *)url {
    [self.controlView pause];
}

- (void)audioPlayer:(RJAudioPlayer *)player didPlayeToEndTimeWithURL:(NSURL *)url {
    if (self.playOrder == RJAudioPlayOrderSingleCircle) {
        [self play];
        return;
    }
    [self playNextSong];
}

- (void)audioPlayer:(RJAudioPlayer *)player playFailedForURL:(NSURL *)url error:(NSError *)error {
    NSLog(@"播放出错, %@ error:%@", url, error);
}

#pragma mark - RJAudioPlayerControlViewDelegate Methods

- (void)controlViewDidClickBackButton:(RJAudioPlayerControlView *)controlView {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)controlView:(RJAudioPlayerControlView *)controlView didClickPlayOrPauseButton:(BOOL)isPlay {
    if (isPlay) {
        if (!self.currentPlayer.url) {
            [self play];
        } else {
            [self.currentPlayer play];
        }
    } else {
        [self.currentPlayer pause];
    }
}

- (void)controlViewDidClickNextButton:(RJAudioPlayerControlView *)controlView {
    [self playNextSong];
}

- (void)controlViewDidClickPreviousButton:(RJAudioPlayerControlView *)controlView {
    [self playPreviousSong];
}

- (void)controlViewDidClickDownloadButton:(RJAudioPlayerControlView *)controlView {
    if ([self.viewController respondsToSelector:@selector(downloadAudio:)]) {
        RJAudioAssertItem *item = self.audioAsserts[self.currentPlayIndex];
        [self.viewController downloadAudio:item.assertURL];
    }
}

- (void)controlViewDidClickPlayOrderButton:(RJAudioPlayerControlView *)controlView playOrder:(RJAudioPlayOrder)playOrder {
    self.playOrder = playOrder;
}

- (void)controlViewDidClickPlayMenuButton:(RJAudioPlayerControlView *)controlView {
    RJAudioPlayMenuViewController *vc = [[RJAudioPlayMenuViewController alloc] init];
    vc.playOrder = self.playOrder;
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [vc changeAudioAsserts:self.audioAsserts playIndex:self.currentPlayIndex];
    [vc changePlayState:self.currentPlayer.isPlaying];
    self.playMenuViewController = vc;
    [self.viewController presentViewController:vc animated:YES completion:nil];
}

- (void)controlView:(RJAudioPlayerControlView *)controlView sliderDidTapped:(CGFloat)value {
    NSTimeInterval time = self.currentPlayer.totalTime * value;
    [self.currentPlayer seekToTime:time completionHandler:^(BOOL finished) {
        NSLog(@"滑动条跳跃:%@", finished ? @"成功" : @"失败");
    }];
}

- (void)controlView:(RJAudioPlayerControlView *)controlView sliderValueDidChanged:(CGFloat)value {
    
}

- (void)controlView:(RJAudioPlayerControlView *)controlView sliderTouchDidEnded:(CGFloat)value completionHandler:(void (^)(BOOL finished))completionHandler  {
    NSTimeInterval time = self.currentPlayer.totalTime * value;
    [self.currentPlayer seekToTime:time completionHandler:^(BOOL finished) {
        completionHandler(finished);
        NSLog(@"滑动条拖拽:%@", finished ? @"成功" : @"失败");
    }];
}

#pragma mark - RJAudioPlayMenuProtocol Methods

- (void)playOrderDidChange:(RJAudioPlayOrder)playOrder {
    self.playOrder = playOrder;
}

- (void)playIndexDidChange:(NSInteger)playIndex {
    [self playWithIndex:playIndex];
}

#pragma mark - RJAudioPlayerMiniControlViewDelegate Methods

- (void)miniControlViewDidTapped:(RJAudioPlayerMiniControlView *)controlView {
    Class modalClass = self.modalViewControllerClass;
    UIViewController *rootViewController = [UIApplication sharedApplication].windows.lastObject.rootViewController;
    UIViewController <RJAudioPlayerViewControllerProtocol> *modalViewController = [[modalClass alloc] init];
    modalViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [rootViewController presentViewController:modalViewController animated:YES completion:nil];
}

- (void)miniControlView:(RJAudioPlayerMiniControlView *)controlView didClickPlayOrPauseButton:(BOOL)isPlay {
    if (isPlay) {
        if (!self.currentPlayer.url) {
            [self play];
        } else {
            [self.currentPlayer play];
        }
    } else {
        [self.currentPlayer pause];
    }
}

- (void)miniControlViewDidClosed:(RJAudioPlayerMiniControlView *)controlView {
    [self stop];
}

#pragma mark - Public Methods

- (RJAudioAssertItem *)currentAssertItem {
    if (self.audioAsserts.count == 0) {
        return nil;
    }
    
    return self.audioAsserts[_currentPlayIndex];
}

- (void)play {
    if (self.audioAsserts.count == 0) {
        return;
    }
    
    RJAudioAssertItem *item = self.audioAsserts[self.currentPlayIndex];
    [self.currentPlayer playWithURL:item.assertURL];
    [self.controlView showTitle:item.title albumURL:item.albumIconURL];
}

- (void)playOrResume {
    if (self.audioAsserts.count == 0) {
        return;
    }
    
    if (!self.currentPlayer.isPlaying) {
        if (!self.currentPlayer.url) {
            [self play];
        } else {
            [self.currentPlayer play];
        }
    }
}

- (void)playNextSong {
    if (self.audioAsserts.count == 0) {
        return;
    }
    NSInteger count = self.audioAsserts.count;
#warning 暂时这样实现随机播放
    if (self.playOrder == RJAudioPlayOrderRandom) {
        _currentPlayIndex = [self randomPlayIndex:count current:_currentPlayIndex];
    } else {
        _currentPlayIndex = MAX((self.currentPlayIndex + 1) % count, 0);
    }
    
    [self playWithIndex:_currentPlayIndex];
}

- (NSUInteger)randomPlayIndex:(NSUInteger)count current:(NSInteger)current {
    NSInteger newIndex = current;
    while (newIndex == current) {
        newIndex = arc4random_uniform(count);
    }
    return newIndex;
}

- (void)playPreviousSong {
    if (self.audioAsserts.count == 0) {
        return;
    }
    
    NSInteger count = self.audioAsserts.count;
    if (self.playOrder == RJAudioPlayOrderRandom) {
        _currentPlayIndex = [self randomPlayIndex:count current:_currentPlayIndex];
    } else {
        _currentPlayIndex = MAX((self.currentPlayIndex - 1  + count) % count, 0);
    }
    
    [self playWithIndex:_currentPlayIndex];
}

- (void)playWithIndex:(NSInteger)index {
    if (self.audioAsserts.count == 0 || index < 0 || index >= self.audioAsserts.count) {
        return;
    }
    
    _currentPlayIndex = index;
    if (self.playMenuViewController) {
        [self.playMenuViewController changePlayIndex:_currentPlayIndex];
    }
    [self play];
}

- (void)pause {
    [self.currentPlayer pause];
}

- (void)stop {
    [self.currentPlayer stop];
    [self.controlView changeCurrentTime:0 totalTime:0];
}

#pragma mark - Property Methods

- (void)setContainerView:(UIView *)containerView {
    _containerView = containerView;
    if (!containerView) {
        return;
    }
    
    containerView.userInteractionEnabled = YES;
    [self layoutPlayerSubviews];
}

- (RJAudioPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[RJAudioPlayerControlView alloc] init];
        _controlView.delegate = self;
    }
    return _controlView;
}

- (RJAudioPlayerMiniControlView *)miniControlView {
    if (!_miniControlView) {
        _miniControlView = [[RJAudioPlayerMiniControlView alloc] init];
        _miniControlView.delegate = self;
    }
    
    return _miniControlView;
}

- (void)setCurrentPlayer:(RJAudioPlayer *)currentPlayer {
    _currentPlayer = currentPlayer;
    currentPlayer.delegate = self;
}

- (void)setPlayOrder:(RJAudioPlayOrder)playOrder {
    _playOrder = playOrder;
    self.controlView.playOrder = playOrder;
}

- (RJAudioRemoteControlHelper *)remoteControlHelper {
    if (!_remoteControlHelper) {
        _remoteControlHelper = [RJAudioRemoteControlHelper helperWithPlayer:self];
    }
    
    return _remoteControlHelper;
}

- (void)setModalViewControllerClass:(Class<RJAudioPlayerViewControllerProtocol>)modalViewControllerClass {
    Class modalClass = modalViewControllerClass;
    id modalViewController = [[modalClass alloc] init];
    if (![modalViewController isKindOfClass:[UIViewController class]]) {
        NSLog(@"------------------modalViewControllerClass需要是UIViewController类或者子类");
        return;
    }
    
    _modalViewControllerClass = modalViewControllerClass;
}

- (Class<RJAudioPlayerViewControllerProtocol>)modalViewControllerClass {
    if (!_modalViewControllerClass) {
        _modalViewControllerClass = [RJAudioPlayerViewController class];
    }
    
    return _modalViewControllerClass;
}

@end
