//
//  MineViewController.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MineViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <MessageUI/MessageUI.h>
#import "ProgressHUD.h"
#import "WeiboSDK.h"

@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *headImageButton;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) UILabel *nikeNameLabel;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageArray = @[@"clear",@"user", @"banben",@"value", @"share"];
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除缓存", @"用户反馈", @"当前版本1.0", @"给我评分", @"分享给好友",nil];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self setUpTableViewHeaaderView];
}

#pragma mark ----------UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    NSString *title = self.titleArray[indexPath.row];
    cell.textLabel.text = title;
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

#pragma mark ----------UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            //清除缓存
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            [imageCache clearDisk];
            [self.titleArray replaceObjectAtIndex:0 withObject:@"清除缓存"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case 1:
        {
            [self sendEmail];
        }
            break;
        case 2:
        {
            //检测当前版本
            [ProgressHUD show:@"正在检测版本中"];
            [self performSelector:@selector(checkAppVersion) withObject:nil afterDelay:2.0];
        }
            break;
        case 3:
        {
            //appStore评分
            NSString *str = [NSString stringWithFormat:
                             
                             @"itms-apps://itunes.apple.com/app"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 4:
        {
            [self share];
        }
            break;
        default:
            break;
    }
 
}

#pragma mark ----------CustomMethod

- (void)setUpTableViewHeaaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    headerView.backgroundColor = MainColor;
    self.tableView.tableHeaderView = headerView;
    [headerView addSubview:self.headImageButton];
    [headerView addSubview:self.nikeNameLabel];
}

- (void)loginRegister{

}

- (void)sendEmail{
    Class mailClass = NSClassFromString(@"MFMailComposeViewController");
    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            //设置主题
            [picker setSubject:@"用户信息反馈"];
            //设置收件人
            NSArray *toRecipients = [NSArray arrayWithObjects:@"1535607759@qq.com", nil];
            [picker setToRecipients:toRecipients];
            //设置发送内容
            NSString *text = @"请留下您宝贵的意见";
            [picker setMessageBody:text isHTML:NO];
            [self presentViewController:picker animated:YES completion:nil];
            
        } else {
            WXQLog(@"未配置邮箱账号");
        }
    } else {
        WXQLog(@"当前设备不能发送");
    }}

//邮件发送完成调用的方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result)
    {
        case MFMailComposeResultCancelled: //取消
            NSLog(@"MFMailComposeResultCancelled-取消");
            break;
        case MFMailComposeResultSaved: // 保存
            NSLog(@"MFMailComposeResultSaved-保存邮件");
            break;
        case MFMailComposeResultSent: // 发送
            NSLog(@"MFMailComposeResultSent-发送邮件");
            break;
        case MFMailComposeResultFailed: // 尝试保存或发送邮件失败
            NSLog(@"MFMailComposeResultFailed: %@...",[error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkAppVersion{
    [ProgressHUD showSuccess:@"恭喜你，已是最新版本"];
    
}

- (void)share{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(30, kScreenHeight - 350, kScreenWidth - 60, 300)];
    shareView.backgroundColor = MainColor;
    [window addSubview:shareView];
    
    //weibo
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(30, 40, 70, 70);
    [weiboBtn setImage:[UIImage imageNamed:@"ic_com_sina_weibo_sdk_logo"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(weiboShare) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:weiboBtn];
    
    //朋友圈
    UIButton *friendsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendsBtn.frame = CGRectMake(120, 40, 70, 70);
    [friendsBtn setImage:[UIImage imageNamed:@"icon_weixin"] forState:UIControlStateNormal];
    [friendsBtn addTarget:self action:@selector(friendsShare) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:friendsBtn];
    
    //friend
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(210, 40, 70, 70);
    [friendBtn setImage:[UIImage imageNamed:@"icon_weixin"] forState:UIControlStateNormal];
    [friendsBtn addTarget:self action:@selector(friendShare) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:friendBtn];
    
    
    //remove
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(120, 130, 70, 70);
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn addTarget:self action:@selector(removeShareView:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:removeBtn];
    [UIView animateWithDuration:1.0 animations:^{
        
    }];
}

//微博分享
- (void)weiboShare{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SS0_From":@"MineViewController"};
    [WeiboSDK sendRequest:request];
    
}

- (WBMessageObject *)messageToShare{
    WBMessageObject *message = [WBMessageObject message];
    message.text = @"微博分享";
    return message;
}


//微信朋友分享

- (void)friendShare{

}

//微信朋友圈分享

- (void)friendsShare{
    
}


//取消按钮
- (void)removeShareView:(UIButton *)btn{
    UIView *view = [btn superview];
    [view removeFromSuperview];
}

#pragma mark ----------lazyLoading
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate =self;
        self.tableView.rowHeight = 50;
    }
    return _tableView;
}

- (UIButton *)headImageButton{
    if (_headImageButton == nil) {
        self.headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headImageButton.frame=CGRectMake(20, 40, 130, 130);
        self.headImageButton.layer.cornerRadius=65;
        self.headImageButton.clipsToBounds=YES;
        [self.headImageButton setTitle:@"登陆/注册" forState:UIControlStateNormal];
        [self.headImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.headImageButton addTarget:self action:@selector(loginRegister) forControlEvents:UIControlEventTouchUpInside];
        self.headImageButton.backgroundColor=[UIColor whiteColor];
    }
    return _headImageButton;
}

- (UILabel *)nikeNameLabel{
    if (_nikeNameLabel == nil) {
        self.nikeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 75, kScreenWidth - 200, 60)];
        self.nikeNameLabel.text = @"欢迎来到周末去哪嗨";
        self.nikeNameLabel.numberOfLines = 0;
        self.nikeNameLabel.textColor = [UIColor whiteColor];
        self.nikeNameLabel.backgroundColor = MainColor;
    }
    return _nikeNameLabel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除图片缓存(%02fM)", (float)cacheSize/1024/1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
