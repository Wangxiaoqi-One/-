//
//  LoginViewController.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/15.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>

@interface LoginViewController ()

- (IBAction)addDataAction:(id)sender;

- (IBAction)delegDataAction:(id)sender;

- (IBAction)modeifyDataAction:(id)sender;

- (IBAction)selectDataAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackButton];
    self.navigationController.navigationBar.barTintColor = MainColor;
}

- (void)backButtonAction:(UIButton *)button{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)addDataAction:(id)sender {
    //往User表添加一条数据user_name,user_age,user
    BmobObject *user = [BmobObject objectWithClassName:@"Memberuser"];
    [user setObject:@"小明" forKey:@"user_Name"];
    [user setObject:@18 forKey:@"user_Age"];
    [user setObject:@"男" forKey:@"user_Gender"];
    [user setObject:@"1860323114" forKey:@"user_cellPhone"];
    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
        WXQLog(@"恭喜注册成功");
    }];
}

- (IBAction)delegDataAction:(id)sender {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Memberuser"];
    [bquery getObjectInBackgroundWithId:@"1572692a42" block:^(BmobObject *object, NSError *error){
        if (error) {
            //进行错误处理
        }
        else{
            if (object) {
                //异步删除object
                [object deleteInBackground];
            }
        }
    }];
}

- (IBAction)modeifyDataAction:(id)sender {
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Memberuser"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"1572692a42" block:^(BmobObject *object,NSError *error){
        //没有返回错误
        if (!error) {
            //对象存在
            if (object) {
                BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                //设置cheatMode为YES
                [obj1 setObject:@"sun" forKey:@"user_Name"];
                //异步更新数据
                [obj1 updateInBackground];
            }
        }else{
            //进行错误处理
        }
    }];

}

- (IBAction)selectDataAction:(id)sender {
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Memberuser"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"b60e47ae95" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                NSString *userName = [object objectForKey:@"user_Name"];
                NSString *cellPhone = [object objectForKey:@"user_cellPhone"];

                NSLog(@"%@----%@",userName,cellPhone);
            }
        }
    }];
}
@end
