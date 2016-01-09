//
//  HotThemeTableViewCell.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "HotThemeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HotThemeTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *themeImageView;
@property (strong, nonatomic) IBOutlet UIButton *loveCountButton;

@end

@implementation HotThemeTableViewCell

- (void)setDataDic:(NSDictionary *)dataDic{
    [self.themeImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"img"]] placeholderImage:nil];
    [self.loveCountButton setTitle:[NSString stringWithFormat:@"%@", dataDic[@"counts"]] forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
