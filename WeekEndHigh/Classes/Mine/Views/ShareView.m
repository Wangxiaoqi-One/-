//
//  ShareView.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/14.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ShareView.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "WXApi.h"

@interface ShareView ()<WXApiDelegate>

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIView *shareView;

@end


@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configShareView];
    }
    return self;
}

- (void)configShareView{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0.0;
    [window addSubview:self.blackView];
    
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
    self.shareView.backgroundColor = [UIColor whiteColor];
    [window addSubview:self.shareView];
    
    //weibo
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(50, 40, 60, 60);
    [weiboBtn setImage:[UIImage imageNamed:@"ic_com_sina_weibo_sdk_logo"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(weiboShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:weiboBtn];
    
    UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 100, 70, 30)];
    weiboLabel.text = @"新浪微博";
    weiboLabel.textAlignment = NSTextAlignmentCenter;
    weiboLabel.font = [UIFont systemFontOfSize:13.0];
    [self.shareView addSubview:weiboLabel];
    
    //朋友圈
    UIButton *friendsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendsBtn.frame = CGRectMake(150, 40, 60, 60);
    [friendsBtn setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    [friendsBtn addTarget:self action:@selector(friendsShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:friendsBtn];
    
    UILabel *friendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 100, 70, 30)];
    friendsLabel.text = @"微信朋友圈";
    friendsLabel.textAlignment = NSTextAlignmentCenter;
    friendsLabel.font = [UIFont systemFontOfSize:13.0];
    [self.shareView addSubview:friendsLabel];
    
    //friend
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(250, 40, 60, 60);
    [friendBtn setImage:[UIImage imageNamed:@"micro_messenger"] forState:UIControlStateNormal];
    [friendBtn addTarget:self action:@selector(friendShare) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:friendBtn];
    
    UILabel *friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(245, 100, 70, 30)];
    friendLabel.text = @"微信朋友";
    friendLabel.textAlignment = NSTextAlignmentCenter;
    friendLabel.font = [UIFont systemFontOfSize:13.0];
    [self.shareView addSubview:friendLabel];
    
    //remove
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.frame = CGRectMake(0, 170, kScreenWidth, 30);
    [removeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [removeBtn setBackgroundColor:[UIColor redColor]];
    [removeBtn addTarget:self action:@selector(removeShareView) forControlEvents:UIControlEventTouchUpInside];
    [self.shareView addSubview:removeBtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.blackView.alpha = 0.8;
        self.shareView.frame = CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200);
    }];
    
}



//微博分享
- (void)weiboShare{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    AppDelegate *myDelegate = [UIApplication sharedApplication].delegate;
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom":@"MineViewController"};
    [WeiboSDK sendRequest:request];
    [UIView animateWithDuration:0.4 animations:^{
        self.blackView.alpha = 0.0;
        self.shareView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 200);
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
        [self.shareView removeFromSuperview];
    }];
//    
//    WBProvideMessageForWeiboResponse *response = [WBProvideMessageForWeiboResponse responseWithMessage:[self messageToShare]];
//    [WeiboSDK sendResponse:response];
    
}

- (WBMessageObject *)messageToShare{
    WBMessageObject *message = [WBMessageObject message];
//    message.text = @"分享你喜欢的文章";
    //    WBImageObject *image = [WBImageObject object];
    //    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"" ofType:@"png"]];
    //    message.imageObject = image;
    WBWebpageObject *page = [WBWebpageObject object];
    page.objectID = @"identifier1";
    page.title = @"分享网页标题";
    page.description = @"这是分享的网页";
    page.webpageUrl = @"http://weibo.com/u/1645851277?from=feed&loc=nickname&is_all=1";
    message.mediaObject = page;
    
    return message;
}

//微信朋友分享

- (void)friendShare{
    
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
    request.text = @"这是测试发送的内容";
    request.bText = YES;
    request.scene = WXSceneSession;
    [WXApi sendReq:request];
    
}

//微信朋友圈分享

- (void)friendsShare{
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc] init];
    request.text = @"请输入你要分享的内容";
    request.bText = YES;
    request.scene = WXSceneTimeline;
    [WXApi sendReq:request];
}


//取消按钮
- (void)removeShareView{
    [UIView animateWithDuration:0.4 animations:^{
        self.blackView.alpha = 0.0;
        self.shareView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 200);
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
        [self.shareView removeFromSuperview];
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
