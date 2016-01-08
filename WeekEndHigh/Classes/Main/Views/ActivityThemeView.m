//
//  ActivityThemeView.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ActivityThemeView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ActivityThemeView ()
{
    //保存上一次图片底部的高度
    CGFloat _previousImageBottom;
}

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong, nonatomic) UIImageView *headImageView;
@end

@implementation ActivityThemeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView{
    [self addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.headImageView];
}
//在set方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    //活动详情
    _previousImageBottom = 186;
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
                CGFloat width = [dict[@"width"] integerValue];
                CGFloat imageHeight = [dict[@"height"] integerValue];
                UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _previousImageBottom + 10, kScreenWidth - 20, (kScreenWidth - 20) / width * imageHeight)];
                [imagView sd_setImageWithURL:[NSURL URLWithString:dict[@"url"]] placeholderImage:nil];
                [self.mainScrollView addSubview:imagView];
                
                //每次都保留最新的图片底部坐标
                _previousImageBottom = imagView.bottom;
            }
        }
    }
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, _previousImageBottom + 20);
}

#pragma mark --------懒加载
- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 186)];
        
    }
    return _headImageView;
}

- (UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.mainScrollView.backgroundColor = [UIColor whiteColor];
        self.mainScrollView.showsVerticalScrollIndicator = NO;
    }
    return _mainScrollView;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
