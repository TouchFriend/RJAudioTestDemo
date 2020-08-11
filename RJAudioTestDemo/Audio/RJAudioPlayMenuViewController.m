//
//  RJAudioPlayMenuViewController.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/11.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioPlayMenuViewController.h"
#import "RJAudioConst.h"
#import "UIView+RJAudioFrame.h"
#import "RJAudioMenuTableViewCell.h"
#import "RJAudioAssertItem.h"

static NSString * const RJCellIdentifier = @"RJAudioMenuTableViewCell";

@interface RJAudioPlayMenuViewController () <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>

/// contentView
@property (nonatomic, weak) UIView *contentView;
/// 头部view
@property (nonatomic, weak) UIView *topView;
/// 播放顺序按钮
@property (nonatomic, weak) UIButton *playOrderBtn;
/// 播放顺序图片
@property (nonatomic, strong) NSArray<UIImage *> *playOrderImages;
/// 底部view
@property (nonatomic, weak) UIView *bottomView;
/// 关闭按钮
@property (nonatomic, weak) UIButton *closeBtn;
/// 底部分割线
@property (nonatomic, weak) UIView *bottomSeperatorLine;
/// 菜单
@property (nonatomic, weak) UITableView *menuTableView;

@end

@implementation RJAudioPlayMenuViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupInit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changePlayIndex:_playIndex];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat contentViewHeight = self.view.rj_height * 0.8;
    self.contentView.frame = CGRectMake(0, self.view.rj_height - contentViewHeight, self.view.rj_width, contentViewHeight);
    
    self.topView.frame = CGRectMake(0, 0, self.contentView.rj_width, 50.0);
    
    self.playOrderBtn.frame = CGRectMake(0, 0, [self currentCircleButtonWidth], self.topView.rj_height);
    
    CGFloat bottomViewHeight = 44.0 + HOME_INDICATOR_HEIGHT;
    self.bottomView.frame = CGRectMake(0, self.contentView.rj_height - bottomViewHeight, self.contentView.rj_width, bottomViewHeight);
    
    self.closeBtn.frame = CGRectMake(0, 0, self.bottomView.rj_width, 44.0);
    
    self.bottomSeperatorLine.frame = CGRectMake(0, 0, self.bottomView.rj_width, 0.5);
    
    self.menuTableView.frame = CGRectMake(0, self.topView.rj_maxY, self.contentView.rj_width, self.contentView.rj_height - self.topView.rj_height - self.bottomView.rj_height);
}

#pragma mark - Setup Init

- (void)setupInit {
    self.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    [self setupContentView];
}

- (void)setupContentView {
    UIView *contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    [self setupTopView];
    [self setupBottomView];
    
    [self setupTableView];
}

- (void)setupTopView {
    UIView *topView = [[UIView alloc] init];
    [self.contentView addSubview:topView];
    self.topView = topView;
    topView.backgroundColor = [UIColor whiteColor];
    
    UIButton *playOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:playOrderBtn];
    self.playOrderBtn = playOrderBtn;
    [self updatePlayOrderAppearance];
    playOrderBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [playOrderBtn setTitleColor:[UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    playOrderBtn.titleLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular];
    [playOrderBtn addTarget:self action:@selector(playOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupBottomView {
    UIView *bottomView = [[UIView alloc] init];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:closeBtn];
    self.closeBtn = closeBtn;
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottomSeperatorLine = [[UIView alloc] init];
    [bottomView addSubview:bottomSeperatorLine];
    self.bottomSeperatorLine = bottomSeperatorLine;
    bottomSeperatorLine.backgroundColor = [UIColor colorWithRed:234.0 / 255.0 green:234.0 / 255.0 blue:234.0 / 255.0 alpha:1.0];
}

- (void)setupTableView {
    UITableView *menuTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.contentView addSubview:menuTableView];
    self.menuTableView = menuTableView;
    menuTableView.delegate = self;
    menuTableView.dataSource = self;
    menuTableView.backgroundColor = [UIColor whiteColor];
    menuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    menuTableView.sectionFooterHeight = 0.1;
    menuTableView.estimatedRowHeight = 0.0;
    menuTableView.estimatedSectionHeaderHeight = 0.0;
    menuTableView.estimatedSectionFooterHeight = 0.0;
    [menuTableView registerClass:[RJAudioMenuTableViewCell class] forCellReuseIdentifier:RJCellIdentifier];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.audioAsserts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RJAudioAssertItem *item = self.audioAsserts[indexPath.row];
    RJAudioMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RJCellIdentifier forIndexPath:indexPath];
    [cell changeTitle:item.title];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger newPlayIndex = indexPath.row;
    if (newPlayIndex != self.playIndex) {
        if ([self.delegate respondsToSelector:@selector(playIndexDidChange:)]) {
            [self.delegate playIndexDidChange:newPlayIndex];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.contentView];
    if ([self.contentView pointInside:location withEvent:nil]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Target Methods

- (void)tapped:(UITapGestureRecognizer *)tapGesture {
    [self closeBtnClick];
}

- (void)playOrderBtnClick:(UIButton *)circleBtn {
    self.playOrder = (self.playOrder + 1) % 3;
    [self updatePlayOrderAppearance];
    if ([self.delegate respondsToSelector:@selector(playOrderDidChange:)]) {
        [self.delegate playOrderDidChange:self.playOrder];
    }
}

- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)updatePlayOrderAppearance {
    [self.playOrderBtn setImage:self.playOrderImages[self.playOrder] forState:UIControlStateNormal];
    NSString *title = nil;
    switch (self.playOrder) {
        case RJAudioPlayOrderSequence:
        {
            title = @"顺序播放(30首)";
        }
            break;
        case RJAudioPlayOrderSingleCircle:
        {
            title = @"单曲循环";
        }
            break;
        case RJAudioPlayOrderRandom:
        {
            title = @"随机播放(30首)";
        }
            break;
            
        default:
            break;
    }
    [self.playOrderBtn setTitle:title forState:UIControlStateNormal];
    // 重新计算宽度
    self.playOrderBtn.rj_width = [self currentCircleButtonWidth];
}


- (CGFloat)currentCircleButtonWidth {
    NSDictionary *attributes = @{
        NSFontAttributeName : self.playOrderBtn.titleLabel.font
    };
    CGFloat titleWidth = [[self.playOrderBtn titleForState:UIControlStateNormal] sizeWithAttributes:attributes].width;
    return self.playOrderBtn.rj_width = titleWidth + [self.playOrderBtn imageForState:UIControlStateNormal].size.width + self.playOrderBtn.titleEdgeInsets.left + 20.0;;
}

#pragma mark - Public Methods

- (void)changeAudioAsserts:(NSArray<RJAudioAssertItem *> *)audioAsserts playIndex:(NSInteger)playIndex {
    self.audioAsserts = audioAsserts;
    [self changePlayIndex:playIndex];
}

- (void)changePlayIndex:(NSInteger)playIndex {
    self.playIndex = playIndex;
}

#pragma mark - Property Methods

- (NSArray<UIImage *> *)playOrderImages {
    if (!_playOrderImages) {
        _playOrderImages = @[[UIImage imageNamed:@"audio_play_order_circle"], [UIImage imageNamed:@"audio_play_single_circle"], [UIImage imageNamed:@"audio_play_random_circle"]];
    }
    
    return _playOrderImages;
}

- (void)setAudioAsserts:(NSArray<RJAudioAssertItem *> *)audioAsserts {
    _audioAsserts = audioAsserts;
    [self.menuTableView reloadData];
}

- (void)setPlayIndex:(NSUInteger)playIndex {
    _playIndex = playIndex;
    [self.menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:playIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

@end
