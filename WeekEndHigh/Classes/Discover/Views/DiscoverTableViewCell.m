//
//  DiscoverTableViewCell.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "DiscoverTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DiscoverTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;

@property (strong, nonatomic) IBOutlet UILabel *titlelabel;


@end

@implementation DiscoverTableViewCell

- (void)setDiscoverModel:(DiscoverModel *)discoverModel{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:discoverModel.image] placeholderImage:nil];
    self.titlelabel.text = discoverModel.title;
}

- (void)awakeFromNib {
    // Initialization code
    self.headImageView.layer.cornerRadius = 45;
    self.headImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
