//
//  MainTableViewCell.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface MainTableViewCell ()
//活动图片
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
//活动名字
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;
//活动价格
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
//活动距离
@property (weak, nonatomic) IBOutlet UIButton *activityDistanceBtn;

@end

@implementation MainTableViewCell

- (void)setMainModel:(MainModel *)mainModel{
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:mainModel.image_big] placeholderImage:nil];
    self.activityNameLabel.text = mainModel.title;
    if ([mainModel.type integerValue] != recommendTypeActivity) {
        self.activityPriceLabel.hidden = YES;
        self.activityDistanceBtn.hidden = YES;
    }else{
        self.activityDistanceBtn.hidden = NO;
        self.activityPriceLabel.hidden = NO;
    }
    self.activityPriceLabel.text = mainModel.price;
}

//获取cell时若无可重用cell，将创建新的cell并调用其中的awakeFromNib方法，可通过重写这个方法添加更多页面内容

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
