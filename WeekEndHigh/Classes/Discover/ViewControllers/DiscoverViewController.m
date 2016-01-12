//
//  DiscoverViewController.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewCell.h"
#import "PullingRefreshTableView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import "DiscoverModel.h"
#import "ActivityDetailViewController.h"

@interface DiscoverViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>

@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) UILabel *headLabel;

@property (nonatomic, strong) NSMutableArray *showArray;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    self.navigationController.navigationBar.translucent = NO;
//    这句话的意思就是让导航栏不透明且占空间位置，所以我们的坐标就会从导航栏下面开始算起。
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    //    此属性默认为YES，这样UIViewController下如果只有一个UIScollView或者其子类，那么会自动留出空白，让scollview滚动经过各种bar下面时能隐约看到内容。但是每个UIViewController只能有唯一一个UIScollView或者其子类，如果超过一个，需要将此属性设置为NO,自己去控制留白以及坐标问题。
    //
    //    [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0  //如果当前ios版本小于7
    //    通过该判断你可以写出针对于ios7的分支代码出来，对于一些细节的问题非常有用。
    //    在ios7中viewController使用了全屏布局的方式，也就是说导航栏和状态栏都是不占实际空间的，状态栏默认是全透明的，导航栏默认是毛玻璃的透明效果。
    //    self.navigationController.navigationBar.translucent = NO;
    //    这句话的意思就是让导航栏不透明且占空间位置，所以我们的坐标就会从导航栏下面开始算起。
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headLabel;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoverTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView launchRefreshing];
    
}


#pragma mark --------UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.discoverModel = self.showArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showArray.count;
}

#pragma mark --------UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ActivityDetailViewController *activityVC = [storyboard instantiateViewControllerWithIdentifier:@"activityDetailId"];
    DiscoverModel *model = self.showArray[indexPath.row];
    
    activityVC.activityId =model.activityId;
    [self.navigationController pushViewController:activityVC animated:YES];
}

#pragma mark -------PullingRefreshTableViewDelegate

//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

- (void)loadData{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];
    [sessionManager GET:kDiscover parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载成功"];
        
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *array = successDic[@"like"];
            for (NSDictionary *dict in array) {
                DiscoverModel *model = [[DiscoverModel alloc ] initWithDictionary:dict];
                [self.showArray addObject:model];
            }
        }else{
        
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error]];
        WXQLog(@"%@", error);
    }];
    
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
}

- (NSDate *)pullingTableViewLoadingFinishedDate{
    return [HWTools getSystemNowDate];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark -------CustomMethod


#pragma mark -------LazyLoading
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 120;
        //只执行下拉刷新
//        [self.tableView setHeaderOnly:YES];
        //只执行上拉加载
//        [self.tableView setFooterOnly:YES];
        self.tableView.headerOnly = YES;
    }
    return _tableView;
}

- (NSMutableArray *)showArray{
    if (_showArray == nil) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;
}

- (UILabel *)headLabel{
    if (_headLabel == nil) {
        self.headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        self.headLabel.text = @"大家都喜欢";
        self.headLabel.font = [UIFont systemFontOfSize:20];
    }
    return _headLabel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
