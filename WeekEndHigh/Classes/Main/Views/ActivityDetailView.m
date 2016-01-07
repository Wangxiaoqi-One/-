//
//  ActivityDetailView.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ActivityDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ActivityDetailView ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityFavoriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UILabel *activityAddressLabel;

@property (strong, nonatomic) IBOutlet UILabel *activityPhoneNumberLabel;


@end

@implementation ActivityDetailView

//set方法赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    self.activityLabel.text = dataDic[@"title"];
    self.activityFavoriteLabel.text = [NSString stringWithFormat:@"%@人已喜欢", dataDic[@"fav"]];
    self.activityPriceLabel.text = dataDic[@"price"];
    self.activityAddressLabel.text = dataDic[@"address"];
    self.activityPhoneNumberLabel.text = dataDic[@"tel"];
}

- (void)awakeFromNib{
   self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, 1000);
   
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
