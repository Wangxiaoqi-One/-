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
@property (nonatomic, strong) NSString *typeid;

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
//    [self.tableView launchRefreshing];
    //第一次进入分类列表中，请求全部的接口数据
    [self getFourRequest];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _pageCount = 1;
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
    [sessionManager GET:[NSString stringWithFormat:kClassifyList, [NSString stringWithFormat:@"%ld",  _pageCount], self.typeid] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            
            if (self.refreshing) {
                if (self.showDataArray.count > 0) {
                    [self.showDataArray removeAllObjects];
                }
            }
            NSArray *array = dict[@"acData"];
            for (NSDictionary *dictn in array) {
                GoodActivityModel *goodModel = [[GoodActivityModel alloc] initWithDictionary:dictn];
                [self.showDataArray addObject:goodModel];
            }
            //刷新tableView，他会重新执行tableView的所有代理方法
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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




#pragma mark -----------------CustomMethod

- (void)getFourRequest {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //演出剧目
    [sessionManager GET:[NSString stringWithFormat:kClassifyList, @(1), @(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@", responseObject);
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            NSArray *array = dict[@"acData"];
            for (NSDictionary *dictn in array) {
                GoodActivityModel *goodModel = [[GoodActivityModel alloc] initWithDictionary:dictn];
                [self.showArray addObject:goodModel
                 ];
            }
//             [self showPreviousSelectButton];
        }else{
            
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WXQLog(@"%@", error);
    }];
    
    //typeid = 23 景点场馆
    [sessionManager GET:[NSString stringWithFormat:kClassifyList, @(1), @(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            
            NSArray *array = dict[@"acData"];
            for (NSDictionary *dictn in array) {
                GoodActivityModel *goodModel = [[GoodActivityModel alloc] initWithDictionary:dictn];
                [self.touristArray addObject:goodModel
                 ];
            }
//             [self showPreviousSelectButton];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WXQLog(@"%@", error);
    }];
    //typeid = 22 学习益智
    [sessionManager GET:[NSString stringWithFormat:kClassifyList, @(1), @(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            
            NSArray *array = dict[@"acData"];
            for (NSDictionary *dictn in array) {
                GoodActivityModel *goodModel = [[GoodActivityModel alloc] initWithDictionary:dictn];
                [self.studyArray addObject:goodModel
                 ];
            }
//             [self showPreviousSelectButton];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WXQLog(@"%@", error);
    }];
    //typeid = 21 亲子旅游
    [sessionManager GET:[NSString stringWithFormat:kClassifyList, @(1), @(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dict = dic[@"success"];
            
            NSArray *array = dict[@"acData"];
            for (NSDictionary *dictn in array) {
                GoodActivityModel *goodModel = [[GoodActivityModel alloc] initWithDictionary:dictn];
                [self.familyArray addObject:goodModel
                 ];
            }
            
        }else{
            
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WXQLog(@"%@", error);
    }];
    //根据上一页选择的按钮，确定显示第几页数据
    [self showPreviousSelectButton];
}


- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    self.classifyListType = segmentCtrl.selectedSegmentIndex + 1;
    [self showPreviousSelectButton];
}

- (void)showPreviousSelectButton{
    switch (self.classifyListType) {
        case ClassifyTypeShowRepertorie:{
            self.showDataArray = self.showArray;
            self.typeid = @"6";
        }
            break;
        case ClassifyTypeTouristPlace:
        {
            self.showDataArray = self.touristArray;
            self.typeid = @"23";
        }
            break;
        case ClassifyTypeStudyPUZ:
        {
            self.showDataArray = self.studyArray;
            self.typeid = @"22";
        }
            break;
        case ClassifyTypeFamilyTravel:
        {
            self.showDataArray = self.familyArray;
            self.typeid = @"21";
        }
            break;
    }
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


//- (PullingRefreshTableView *)tableView

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
