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

{
    //保存上一次图片底部的高度
    CGFloat _previousImageBottom;
}

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
    //活动图片
    NSArray *urls = dataDic[@"urls"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urls[0]] placeholderImage:nil];
    //活动标题
    self.activityLabel.text = dataDic[@"title"];
    //喜欢人数
    self.activityFavoriteLabel.text = [NSString stringWithFormat:@"%@人已喜欢", dataDic[@"fav"]];
    //活动价值
    self.activityPriceLabel.text = dataDic[@"price"];
    //活动地址
    self.activityAddressLabel.text = dataDic[@"address"];
    //活动电话
    self.activityPhoneNumberLabel.text = dataDic[@"tel"];
    //活动起止时间
    NSString *startTime = [HWTools getDateFromString:dataDic[@"new_start_date"]];
    NSString *endTime = [HWTools getDateFromString:dataDic[@"new_end_date"]];
    self.activityTimeLabel.text = [NSString stringWithFormat:@"起止时间：%@-%@",startTime, endTime];
    //活动详情
    _previousImageBottom = 444;
    [self showContentWithArray:dataDic[@"content"]];
}

- (void)showContentWithArray:(NSArray *)contentArray{

    for (NSDictionary *dic in contentArray) {
        //如果标题存在,标题的高度应该是上次图片的底部高度
        NSString *title = dic[@"title"];
        if (title != nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _previousImageBottom, kScreenWidth, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下边详细信息label显示的时候，高度的坐标应该在title的bottom下再加20，也就是标题的高度减10；
            _previousImageBottom += 20;
        }
        CGFloat height = [HWTools getTextHeightWithText:dic[@"description"] bigestSize:CGSizeMake(kScreenWidth, 1000) textFont:15.0];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _previousImageBottom + 10, kScreenWidth, height)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        NSArray *urlsArray = dic[@"urls"];
        _previousImageBottom = label.bottom;
        
        if (urlsArray == nil) {
            _previousImageBottom = label.bottom + 10;
        }else{
        for (NSDictionary *dict in urlsArray) {
            UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _previousImageBottom + 10, kScreenWidth - 20, [dict[@"height"] integerValue] / 2)];
            [imagView sd_setImageWithURL:[NSURL URLWithString:dict[@"url"]] placeholderImage:nil];
            [self.mainScrollView addSubview:imagView];
            
            //每次都保留最新的图片底部坐标
            _previousImageBottom = imagView.bottom;
        }
        }
    }
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, _previousImageBottom + 74);
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
