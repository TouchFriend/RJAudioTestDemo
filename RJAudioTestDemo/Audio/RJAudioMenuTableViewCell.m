//
//  RJAudioMenuTableViewCell.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/8/11.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJAudioMenuTableViewCell.h"
#import "UIView+RJAudioFrame.h"
#import "RJAudioConst.h"
#import "RJAudioSoundColumnView.h"

@interface RJAudioMenuTableViewCell ()

/// 标题
@property (nonatomic, weak) UILabel *titleLbl;
/// 音柱
@property (nonatomic, weak) RJAudioSoundColumnView *soundColumnView;

@end

@implementation RJAudioMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupInit];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.soundColumnView.hidden = YES;
    [self.soundColumnView removeAnimation];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10.0;
    CGFloat soundColumnViewWidth = 20.0;
    CGFloat soundColumnViewMargin = 15.0;
    NSDictionary *attributes = @{
        NSFontAttributeName : self.titleLbl.font
    };
    CGSize titleLblSize = [self.titleLbl.text sizeWithAttributes:attributes];
    CGFloat titleLblWidth = MIN(titleLblSize.width, self.contentView.rj_width - margin - soundColumnViewWidth - soundColumnViewMargin);
    self.titleLbl.frame = CGRectMake(margin, (self.contentView.rj_height - titleLblSize.height) * 0.5, titleLblWidth, titleLblSize.height);
    
    CGFloat soundColumnViewY = 10.0;
    self.soundColumnView.frame = CGRectMake(self.titleLbl.rj_maxX + soundColumnViewMargin, soundColumnViewY, soundColumnViewWidth, self.titleLbl.rj_maxY - soundColumnViewY);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.titleLbl.textColor = selected ? RJAudioThemeColor : [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
    self.soundColumnView.hidden = !selected;
    
    if (selected && self.isPlay) {
        [self.soundColumnView beginAnimation];
    } else {
        [self.soundColumnView removeAnimation];
    }
}

#pragma mark - Setup Init

- (void)setupInit {
    UILabel *titleLbl = [[UILabel alloc] init];
    [self.contentView addSubview:titleLbl];
    self.titleLbl = titleLbl;
    titleLbl.font = [UIFont systemFontOfSize:16.0];
    titleLbl.text = @"";
    titleLbl.textColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    
    RJAudioSoundColumnView *soundColumnView = [[RJAudioSoundColumnView alloc] init];
    [self.contentView addSubview:soundColumnView];
    self.soundColumnView = soundColumnView;
}

#pragma mark - Public Methods

- (void)changeTitle:(NSString *)title {
    self.titleLbl.text = title;
    [self.contentView layoutIfNeeded];
}



@end
