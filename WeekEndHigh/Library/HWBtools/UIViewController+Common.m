//
//  UIViewController+Common.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "UIViewController+Common.h"
#import "AppDelegate.h"

@implementation UIViewController (Common)

//导航栏添加返回按钮
- (void)showBackButton:(NSString *)imageName{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    if ([imageName isEqualToString:@"back"]) {
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }else{
        [backBtn setImage:[UIImage imageNamed:@"camera_cancel_up"] forState:UIControlStateNormal];
    }

    [backBtn addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}

- (void)backButtonAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
