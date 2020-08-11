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

@interface RJAudioMenuTableViewCell ()

/// <#Desription#>
@property (nonatomic, weak) UILabel *titleLbl;

@end

@implementation RJAudioMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupInit];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat titleLblX = 10.0;
    self.titleLbl.frame = CGRectMake(titleLblX, 0, self.contentView.rj_width - titleLblX, self.contentView.rj_height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.titleLbl.textColor = selected ? RJAudioThemeColor : [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
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
}

#pragma mark - Public Methods

- (void)changeTitle:(NSString *)title {
    self.titleLbl.text = title;
}

@end
