//
//  HotActivityViewController.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "HotActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "HotThemeTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ThemeViewController.h"

@interface HotActivityViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}

@property (nonatomic, strong) PullingRefreshTableView *tableView;

@property (nonatomic, assign) BOOL refreshing;

@property (nonatomic ,strong) NSMutableArray *rcArray;

@end

@implementation HotActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"热门专题";
    self.tabBarController.tabBar.hidden = YES;
    [self showBackButton:@"back"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HotThemeTableViewCell" bundle:nil] forCellReuseIdentifier:@"hotCell"];
    [self.view addSubview:self.tableView];
    [self.tableView launchRefreshing];
}

#pragma mark ------------UITableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rcArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotThemeTableViewCell *hotCell = [self.tableView dequeueReusableCellWithIdentifier:@"hotCell" forIndexPath:indexPath];
    hotCell.dataDic = self.rcArray[indexPath.row];
    return hotCell;
}

#pragma mark ------------UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeViewController *themeVC = [[ThemeViewController alloc] init];
    themeVC.themeId = self.rcArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:themeVC animated:YES];
}

#pragma mark ------------PullingRefreshTableViewDelegate


//tableView下拉刷新开始的时候使用
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

//tableView上拉加载开始的时候使用
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:kHotTheme, _pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *array = dict[@"rcData"];
            if (self.refreshing) {
                if (self.rcArray.count > 0) {
                    [self.rcArray removeAllObjects];
                }
            }
            for (NSDictionary *dictn in array) {
                [self.rcArray addObject:dictn];
            }
            [self.tableView reloadData];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WXQLog(@"%@", error);
    }];
    
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
}
//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    
    return [HWTools getSystemNowDate];
}


#pragma mark ------------lazyLoading

- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:self.view.frame pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 190;
    }
    return _tableView;
}

- (NSMutableArray *)rcArray{
    if (_rcArray == nil) {
        self.rcArray = [NSMutableArray new];
    }
    return _rcArray;
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
