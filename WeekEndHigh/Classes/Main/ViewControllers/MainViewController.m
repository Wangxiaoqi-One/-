//
//  MainViewController.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MainModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数据
@property (nonatomic, strong) NSMutableArray *listArray;
//推荐活动数据
@property (nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数据
@property (nonatomic, strong) NSMutableArray *themeArray;
//广告
@property(nonatomic, strong) NSMutableArray *adArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    //left
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(selectCityAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    
    //right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 18, 18);
    [rightBtn setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchActivityAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    //注册cell
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //自定义tableViewt头部
    [self configTableViewHeaderView];
//    //网络请求
    [self requestModel];
    
}

#pragma marks ----------UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.activityArray.count;
    }
    return self.themeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableArray *array = self.listArray[indexPath.section];
    mainCell.mainModel = array[indexPath.row];
    return mainCell;
}

#pragma marks --------UITableViewDelegate



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 203;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 16;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 160, 5, 320, 16)];
    if (section == 0) {
         sectionView.image = [UIImage imageNamed:@"home_recommed_ac"];;
        
    }else{
         sectionView.image = [UIImage imageNamed:@"home_recommd_rc"];
    }
    [view addSubview:sectionView];
   
    return sectionView;
}

#pragma marks ------------Custom Method

//搜索关键字
- (void)searchActivityAction:(UIButton *)btn{

}

//选择城市
- (void)selectCityAction:(UIBarButtonItem *)barBtn{

}

//自定义tableView头部
- (void)configTableViewHeaderView{
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 343)];
    
    
    UIScrollView *carouselView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 186)];
    carouselView.contentSize = CGSizeMake(self.adArray.count * [UIScreen mainScreen].bounds.size.width, 186);
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, 186)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i]] placeholderImage:nil];
        [carouselView addSubview:imageView];
    }
    [tableViewHeaderView addSubview:carouselView];
    
    
    //按钮
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * [UIScreen mainScreen].bounds.size.width / 4, 186, [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_icon_%02d", i + 1];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewHeaderView addSubview:btn];
    }
    
    //精选活动&热门专题
    UIButton *activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    activityBtn.frame = CGRectMake(0, 191 + [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 2, 343 - 186 - [UIScreen mainScreen].bounds.size.width / 4 - 8);
    [activityBtn setImage:[UIImage imageNamed:@"home_huodong"] forState:UIControlStateNormal];
    activityBtn.tag = 104;
    [activityBtn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeaderView addSubview:activityBtn];
    
    UIButton *themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    themeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2, 191 + [UIScreen mainScreen].bounds.size.width / 4, [UIScreen mainScreen].bounds.size.width / 2, 343 - 186 - [UIScreen mainScreen].bounds.size.width / 4 - 8);
    [themeBtn setImage:[UIImage imageNamed:@"home_zhuanti"] forState:UIControlStateNormal];
    themeBtn.tag = 105;
    [themeBtn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewHeaderView addSubview:themeBtn];
    
    self.tableView.tableHeaderView = tableViewHeaderView;
}

//网络请求
- (void)requestModel{
    NSString *urlString = @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%lld", downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            //推荐活动
            NSArray *acDataArray = dic[@"acData"];
            for (NSDictionary *dict in acDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dict];
                [self.activityArray addObject:model];
            }
            [self.listArray addObject:self.activityArray];
            //推荐专题
            NSArray *rcDataArray = dic[@"rcData"];
            for (NSDictionary *dict in rcDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dict];
                [self.themeArray addObject:model];
            }
            [self.listArray addObject:self.themeArray];
            //刷新tableView数据
            [self.tableView reloadData];
            //广告
            NSArray *adDataArray = dic[@"adData"];
            for (NSDictionary *dict in adDataArray) {
                [self.adArray addObject:dict[@"url"]];
            }
            //拿到数据之后重新刷新headerView
            [self configTableViewHeaderView];
            
            NSString *cityName = dic[@"cityname"];
            
            //已请求回来的城市作为导航栏按钮标题
            self.navigationItem.leftBarButtonItem.title = cityName;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

-(void)mainActivityButtonAction:(UIButton *)btn{

}


#pragma mark ----------lazy loading

//懒加载
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}

- (NSMutableArray *)activityArray{
    if (_activityArray == nil) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;
}

- (NSMutableArray *)themeArray{
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
}

- (NSMutableArray *)adArray{
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;
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
