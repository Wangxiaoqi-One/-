//
//  GoodActivityTableViewCell.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "GoodActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GoodActivityTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;

@property (strong, nonatomic) IBOutlet UILabel *activityTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *activityDistanceLabel;

@property (strong, nonatomic) IBOutlet UILabel *activityPriceLabel;

@property (strong, nonatomic) IBOutlet UIButton *loveCountButton;

@property (strong, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation GoodActivityTableViewCell

- (void)setGoodModel:(GoodActivityModel *)goodModel{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.image] placeholderImage:nil];
    self.activityTitleLabel.text = goodModel.title;
    self.ageLabel.text = goodModel.age;
    self.activityPriceLabel.text = goodModel.price;
    [self.loveCountButton setTitle:[NSString stringWithFormat:@"%@", goodModel.counts] forState:UIControlStateNormal];
    self.activityDistanceLabel.text = @"4513km";
}

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kScreenWidth, 90);
    self.ageLabel.layer.cornerRadius = 12.5;
    self.ageLabel.layer.borderColor = [UIColor cyanColor].CGColor;
    self.ageLabel.layer.borderWidth = 0.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
