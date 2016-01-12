//
//  ClasssifyViewController.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ClasssifyViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "VOSegmentedControl.h"
#import "PullingRefreshTableView.h"
#import "GoodActivityTableViewCell.h"
#import "ActivityDetailViewController.h"
#import "GoodActivityModel.h"
#import "ProgressHUD.h"

@interface ClasssifyViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}

@property (nonatomic, strong) PullingRefreshTableView *tableView;

@property (nonatomic, strong) VOSegmentedControl *segmentControl;

//用来负责展示数据的数组
@property (nonatomic, strong) NSMutableArray *showDataArray;
@property (nonatomic, strong) NSMutableArray *showArray;
@property (nonatomic, strong) NSMutableArray *touristArray;
@property (nonatomic, strong) NSMutableArray *studyArray;
@property (nonatomic, strong) NSMutableArray *familyArray;

@property (nonatomic, assign) BOOL refreshing;

@end

@implementation ClasssifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"分类列表";
    self.tabBarController.tabBar.hidden = YES;
    [self showBackButton];
    
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _pageCount = 1;
    [self chooseResquest];
}

#pragma mark -----------------UITableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodActivityTableViewCell *goodCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    goodCell.goodModel = self.showDataArray[indexPath.row];
    return goodCell;
}

#pragma mark -----------------UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ActivityDetailViewController *activityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"activityDetailId"];
    GoodActivityModel *goodModel = self.showDataArray[indexPath.row];
    activityVC.activityId = goodModel.activityId;
    [self.navigationController pushViewController:activityVC animated:YES];
}

#pragma mark -----------------PullingRefreshTableViewDelegate

//tableView下拉刷新开始的时候使用
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(chooseResquest) withObject:nil afterDelay:1.f];
}

//tableView上拉加载开始的时候使用
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(chooseResquest) withObject:nil afterDelay:1.f];
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




#pragma mark -----------------CustomMethod

- (void)chooseResquest{
    switch (self.classifyListType) {
        case ClassifyTypeShowRepertorie:{
                [self getShowRequest];
        }
            break;
        case ClassifyTypeTouristPlace:
        {
            [self getSTouristRequest];
        }
            break;
        case ClassifyTypeStudyPUZ:
        {
            [self getStudyRequest];
        }
            break;
        case ClassifyTypeFamilyTravel:
        {
            [self getFamilyRequest];
        }
            break;
        default:
            break;
    }
}


- (void)getShowRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //演出剧目
    [ProgressHUD show:@"拼命加载..."];
    [sessionManager GET:[NSString stringWithFormat:kClassifyList, _pageCount, @(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *array = dict[@"acData"];
            if (self.refreshing) {
                if (self.showArray.count > 0) {
                    [self.showArray removeAllObjects];
                }
            }
            for (NSDictionary *dictn in array) {
                GoodActivityModel *goodModel = [[GoodActivityModel alloc] initWithDictionary:dictn];
                [self.showArray addObject:goodModel
                 ];
            }
            //网络请求是异步请求，若放在请求外面会先执行下面的方法先刷新tableView，在请求完成就不刷新了
             [self showPreviousSelectButton];
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        WXQLog(@"%@", error);
        [ProgressHUD showSuccess:[NSString stringWithFormat:@"%@", error]];
    }];
}
- (void)getSTouristRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //typeid = 23 景点场馆
    [ProgressHUD show:@"正在拼命加载"];
    [sessionManager GET:[NSString stringWithFormat:kClassifyList, _pageCount, @(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          [ProgressHUD showSuccess:@"数据加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            
            NSArray *array = dict[@"acData"];
            if (self.refreshing) {
                if (self.touristArray.count > 0) {
                    [self.touristArray removeAllObjects];
                }
            }
            for (NSDictionary *dictn in array) {
                GoodActivityModel *goodModel = [[GoodActivityModel alloc] initWithDictionary:dictn];
                [self.touristArray addObject:goodModel
                 ];
            }
              [self showPreviousSelectButton];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        WXQLog(@"%@", error);
         [ProgressHUD showSuccess:[NSString stringWithFormat:@"%@", error]];
    }];
  
}
- (void)getStudyRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //typeid = 22 学习益智
     [ProgressHUD show:@"正在拼命加载"];
    [sessionManager GET:[NSString stringWithFormat:kClassifyList, _pageCount, @(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           [ProgressHUD showSuccess:@"数据加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            
            NSArray *array = dict[@"acData"];
            if (self.refreshing) {
                if (self.studyArray.count > 0) {
                    [self.studyArray removeAllObjects];
                }
            }
            for (NSDictionary *dictn in array) {
                GoodActivityModel *goodModel = [[GoodActivityModel alloc] initWithDictionary:dictn];
                [self.studyArray addObject:goodModel
                 ];
            }
             [self showPreviousSelectButton];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        WXQLog(@"%@", error);
         [ProgressHUD showSuccess:[NSString stringWithFormat:@"%@", error]];
    }];
   
    
}
- (void)getFamilyRequest{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //typeid = 21 亲子旅游
    [ProgressHUD show:@"正在拼命加载"];
    [sessionManager GET:[NSString stringWithFormat:kClassifyList, _pageCount, @(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           [ProgressHUD showSuccess:@"数据加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            
            NSArray *array = dict[@"acData"];
            if (self.refreshing) {
                if (self.familyArray.count > 0) {
                    [self.familyArray removeAllObjects];
                }
            }
            for (NSDictionary *dictn in array) {
                GoodActivityModel *goodModel = [[GoodActivityModel alloc] initWithDictionary:dictn];
                [self.familyArray addObject:goodModel
                 ];
            }
            //根据上一页选择的按钮，确定显示第几页数据
            [self showPreviousSelectButton];
        }else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [ProgressHUD showSuccess:[NSString stringWithFormat:@"%@", error]];
    }];

}


- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    self.classifyListType = segmentCtrl.selectedSegmentIndex + 1;
    [self chooseResquest];
}

- (void)showPreviousSelectButton{
    if (self.refreshing) {//下拉删除原来的数据
        if (self.showDataArray.count > 0) {
            [self.showDataArray removeAllObjects];
        }
    }
    switch (self.classifyListType) {
        case ClassifyTypeShowRepertorie:{
            self.showDataArray = self.showArray;
        }
            break;
        case ClassifyTypeTouristPlace:
        {
            self.showDataArray = self.touristArray;
        }
            break;
        case ClassifyTypeStudyPUZ:
        {
            self.showDataArray = self.studyArray;
        }
            break;
        case ClassifyTypeFamilyTravel:
        {
            self.showDataArray = self.familyArray;
        }
            break;
    }
    [self.tableView tableViewDidFinishedLoading];
     self.tableView.reachedTheEnd = NO;
     [self.tableView reloadData];
}

#pragma mark ----------lazy loading

- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 64 - 40) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 90;
    }
    return _tableView;
}

- (VOSegmentedControl *)segmentControl{
    if (_segmentControl == nil) {
        self.segmentControl = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"演出剧目"},@{VOSegmentText:@"景点场馆"},@{VOSegmentText:@"学习益智"},@{VOSegmentText:@"亲子旅游"}]];
        self.segmentControl.contentStyle = VOContentStyleTextAlone;
        self.segmentControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segmentControl.backgroundColor = [UIColor whiteColor];
        self.segmentControl.selectedSegmentIndex = self.classifyListType - 1;
        self.segmentControl.selectedBackgroundColor = self.segmentControl.backgroundColor;
        self.segmentControl.allowNoSelection = NO;
        self.segmentControl.frame = CGRectMake(0, 0, kScreenWidth, 40);
        self.segmentControl.indicatorThickness = 4;
        [self.segmentControl setIndexChangeBlock:^(NSInteger index) {
           
        }];
        [self.segmentControl addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (NSMutableArray *)showDataArray{
    if (_showDataArray == nil) {
        self.showDataArray = [NSMutableArray new];
    }
    return _showDataArray;
}

- (NSMutableArray *)showArray{
    if (_showArray == nil) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;
}

- (NSMutableArray *)touristArray{
    if (_touristArray == nil) {
        self.touristArray = [NSMutableArray new];
    }
    return _touristArray;
}

- (NSMutableArray *)studyArray{
    if (_studyArray == nil) {
        self.studyArray = [NSMutableArray new];
    }
    return _studyArray;
}

- (NSMutableArray *)familyArray{
    if (_familyArray == nil) {
        self.familyArray = [NSMutableArray new];
    }
    return _familyArray;
}

//在页面消失的时候进度消失
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ProgressHUD dismiss];
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
