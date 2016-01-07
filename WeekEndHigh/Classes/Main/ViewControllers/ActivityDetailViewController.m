//
//  ActivityDetailViewController.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "ActivityDetailView.h"

@interface ActivityDetailViewController ()

@property (strong, nonatomic) IBOutlet ActivityDetailView *activityDetailView;

@property (strong, nonatomic) NSString *phoneNumber;

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"活动详情";
    [self showBackButton];
   
    //去地图页面
    [self.activityDetailView.mapButton addTarget:self action:@selector(mapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //打电话
    [self.activityDetailView.makeCallButton addTarget:self action:@selector(makeCallButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getModel];
}


#pragma mark ----------Custom Method

- (void)getModel{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [sessionManager GET:[NSString stringWithFormat:kActicityDetail, _activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        WXQLog(@"%lld", downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        WXQLog(@"%@", responseObject);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dic= responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
        
            NSDictionary *successDic = dic[@"success"];
            self.activityDetailView.dataDic = successDic;
        }else{
        
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        WXQLog(@"%@", error);
    }];
}

//去地图页
- (void)mapButtonAction:(UIButton *)mapButton{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://maps.google.com/map"]];
}

//打电话
- (void)makeCallButtonAction:(UIButton *)makeCallButton{
//程序内打电话，打完电话之后返回当前应用程序
    UIWebView *cellPhoneNumber = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _phoneNumber]]];
    [cellPhoneNumber loadRequest:request];
    [self.view addSubview:cellPhoneNumber];
    //程序外打电话，打完电话之后不返回当前应用程序
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _phoneNumber]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
