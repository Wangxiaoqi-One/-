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
#import "SelectCityViewController.h"
#import "SearchViewController.h"
#import "ActivityDetailViewController.h"
#import "ThemeViewController.h"
#import "ClasssifyViewController.h"
#import "GoodActivityViewController.h"
#import "HotActivityViewController.h"


@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数据
@property (nonatomic, strong) NSMutableArray *listArray;
//推荐活动数据
@property (nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数据
@property (nonatomic, strong) NSMutableArray *themeArray;
//广告
@property(nonatomic, strong) NSMutableArray *adArray;
//轮播图
@property(nonatomic ,strong) UIScrollView *carouselView;
//小圆点
@property(nonatomic, strong) UIPageControl *pageControl;
//定时器用于图像滚动播放
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIButton *activityBtn;

@property (nonatomic, strong) UIButton *themeBtn;

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
    //网络请求
//    [self requestModel];
    //启动定时器
    [self startTimer];
}

#pragma mark ----------UITableViewDataSource
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
    mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mainCell;
}

#pragma mark  --------------UITableViewDelegate---



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 203;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 16;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 14)];
    if (section == 0) {
         sectionView.image = [UIImage imageNamed:@"home_recommed_ac"];;
        
    }else{
         sectionView.image = [UIImage imageNamed:@"home_recommd_rc"];
    }
    [view addSubview:sectionView];
   
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MainModel *mainModel = self.listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        ActivityDetailViewController *activityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"activityDetailId"];
        activityVC.activityId = mainModel.activityId;
        [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        themeVC.themeId = mainModel.activityId;
        [self.navigationController pushViewController:themeVC animated:YES];
    }
}

#pragma mark ------------Custom Method-----------

//搜索关键字
- (void)searchActivityAction:(UIButton *)btn{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

//选择城市
- (void)selectCityAction:(UIBarButtonItem *)barBtn{
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc] init];
    [self.navigationController presentViewController:selectCityVC animated:YES completion:nil];
}

//自定义tableView头部
- (void)configTableViewHeaderView{
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 343)];
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, 186)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i][@"url"]] placeholderImage:nil];
        [self.carouselView addSubview:imageView];
        
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = imageView.frame;
        touchBtn.tag = 100 + i;
        [touchBtn addTarget:self action:@selector(touchAdvertiseMent:) forControlEvents:UIControlEventTouchUpInside];
        [self.carouselView addSubview:touchBtn];
    }
    [tableViewHeaderView addSubview:self.carouselView];

    self.pageControl.numberOfPages = self.adArray.count;
    [tableViewHeaderView addSubview:self.pageControl];

    //按钮
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * kScreenWidth / 4, 186, kScreenWidth / 4, kScreenWidth / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_icon_%02d", i + 1];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewHeaderView addSubview:btn];
    }
    //精选活动&热门专题
    [tableViewHeaderView addSubview:self.activityBtn];
    [tableViewHeaderView addSubview:self.themeBtn];
    self.tableView.tableHeaderView = tableViewHeaderView;
}

//网络请求
- (void)requestModel{
    NSString *urlString = kMainDataList;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        WXQLog(@"%lld", downloadProgress.totalUnitCount);
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
                NSDictionary *dicti = @{@"url":dict[@"url"], @"type": dict[@"type"], @"id":dict[@"id"]};
                [self.adArray addObject:dicti];
            }
            //拿到数据之后重新刷新headerView
            [self configTableViewHeaderView];
            
            NSString *cityName = dic[@"cityname"];
            
            //已请求回来的城市作为导航栏按钮标题
            self.navigationItem.leftBarButtonItem.title = cityName;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WXQLog(@"%@", error);
    }];
}

-(void)mainActivityButtonAction:(UIButton *)btn{
    ClasssifyViewController *classifyVC = [[ClasssifyViewController alloc] init];
    classifyVC.classifyListType = btn.tag - 100 + 1;
    [self.navigationController pushViewController:classifyVC animated:YES];
}

//精选活动

-(void)goodActivityButtonAction:(UIButton *)btn{
    GoodActivityViewController *goodActivityVC = [[GoodActivityViewController alloc] init];
    [self.navigationController pushViewController:goodActivityVC animated:YES];
}

//热门专题
-(void)hotActivityButtonAction:(UIButton *)btn{
    HotActivityViewController *hotActivityVC = [[HotActivityViewController alloc] init];
    [self.navigationController pushViewController:hotActivityVC animated:YES];
}

#pragma mark -------------- 轮播图

- (void)startTimer{
    //防止定时器重复创建
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(rollAnimation) userInfo:nil repeats:YES];
}


//每两秒执行一次，图片自动轮播
- (void)rollAnimation{
    //把page当前页加1;
    if (self.adArray.count > 0) {
     NSInteger page = (self.pageControl.currentPage + 1) % self.adArray.count;
    //计算出scrollView应该滚动的X轴坐标
    self.pageControl.currentPage = page;
    CGFloat offsetx = self.pageControl.currentPage * kScreenWidth;
    [self.carouselView setContentOffset:CGPointMake(offsetx, 0) animated:YES];
    }
}

//当手动去滑动scrollView的时候，定时器依然在计算时间，可能我们刚滑到下一页，定时器时间又刚好触发，导致当前页停留的时间不够2秒
//解决方案 在scrollView开始移动的时候结束定时器
//在scrollView移动完毕的时候再启动定时器

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

- (UIScrollView *)carouselView{
    if (_carouselView == nil) {
        self.carouselView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 186)];
        self.carouselView.contentSize = CGSizeMake(self.adArray.count * kScreenWidth, 186);
           self.carouselView.delegate = self;
        self.carouselView.pagingEnabled = YES;  //整屏滑动
        //不显示水平方向滚动条
        self.carouselView.showsHorizontalScrollIndicator = NO;
        self.carouselView.bounces = NO;
    }
    return _carouselView;
}

- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        //创建小圆点
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 156, kScreenWidth, 30)];
        self.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
        [self.pageControl addTarget:self action:@selector(pageSelectAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (UIButton *)activityBtn{
    if (_activityBtn == nil) {
        //精选活动&热门专题
        self.activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.activityBtn.frame = CGRectMake(0, 186 + kScreenWidth / 4, kScreenWidth / 2, 157 - kScreenWidth / 4);
        [self.activityBtn setImage:[UIImage imageNamed:@"home_huodong"] forState:UIControlStateNormal];
        self.activityBtn.tag = 104;
        [self.activityBtn addTarget:self action:@selector(goodActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _activityBtn;
}

- (UIButton *)themeBtn{
    if (_themeBtn == nil) {
        self.themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.themeBtn.frame = CGRectMake(kScreenWidth / 2, 186 + kScreenWidth / 4, kScreenWidth / 2, 157 - kScreenWidth / 4);
        [self.themeBtn setImage:[UIImage imageNamed:@"home_zhuanti"] forState:UIControlStateNormal];
        self.themeBtn.tag = 105;
        [self.themeBtn addTarget:self action:@selector(hotActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _themeBtn;
}

- (void)touchAdvertiseMent:(UIButton *)addButton{
    //从数组中的字典里取出type类型
    NSString *type = self.adArray[addButton.tag - 100][@"type"];
    if ([type integerValue] == 1) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        //活动ID
        ActivityDetailViewController *activityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"activityDetailId"];
        
        NSLog(@"%@",self.adArray[addButton.tag - 100]);
        activityVC.activityId = self.adArray[addButton.tag - 100][@"id"];
        [self.navigationController pushViewController:activityVC animated:YES];
    }else{
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        themeVC.themeId = self.adArray[addButton.tag - 100][@"id"];
        [self.navigationController pushViewController:themeVC animated:YES];

    }

}

#pragma mark ---------首页轮播图


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //第一步：获取scrollView页面的宽度
    CGFloat pageWidth = self.carouselView.frame.size.width;
    //第二步：获取scrollView停止时候的偏移量
    CGPoint Offset = self.carouselView.contentOffset;
    //第三步：通过偏移量和页面宽度计算当前页数
    NSInteger pageNumber = Offset.x / pageWidth;
    self.pageControl.currentPage = pageNumber;
}

- (void)pageSelectAction:(UIPageControl *)pageControl{
    NSInteger pageNumber = self.pageControl.currentPage;
    CGFloat pageWidth = self.carouselView.frame.size.width;
    self.carouselView.contentOffset = CGPointMake(pageNumber * pageWidth, 0);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止定时器
    [self.timer invalidate],self.timer = nil;//停止定时器后并置为nil，重新启动定时器才能正常执行
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //取消隐藏tabBar
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
