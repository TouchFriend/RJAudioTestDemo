//
//  RJAudioPlayerViewController.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/30.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioPlayerViewController.h"
#import "RJAudioPlayer.h"
#import "RJAudioPlayerControlView.h"

@interface RJAudioPlayerViewController ()

/// <#Desription#>
@property (nonatomic, strong) RJAudioPlayer *player;


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
    
    RJAudioPlayerControlView *controlView = [[RJAudioPlayerControlView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:controlView];
    
//    [self setupPlayer];
}

- (void)setupPlayer {
    // https://mr3.doubanio.com/f229d8a03ba08bde8969de3899f773d2/0/fm/song/p1390309_128k.mp4
        NSString *urlString = @"https://mr3.doubanio.com/f229d8a03ba08bde8969de3899f773d2/0/fm/song/p1390309_128k.mp4";
        self.player = [RJAudioPlayer playerWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
//        self.player = [RJAudioPlayer playerWithURL:[NSURL URLWithString:urlString]];
        
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"蒲公英的约定" ofType:@"mp3"];
    //    self.player = [RJAudioPlayer playerWithURL:[NSURL fileURLWithPath:path]];
}

- (void)play {
    [self.player play];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ![self.player isPlaying] ? [self play] : [self.player stop];
    
}

@end
