//
//  SelectCityViewController.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "SelectCityViewController.h"
#import "HeaderView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
static NSString *itemIdentifier = @"item";
static NSString *headerIdentifier = @"header";

@interface SelectCityViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) HeaderView *headerView;

@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"切换城市";
    
    [self showBackButton:@"cancel"];
    self.navigationController.navigationBar.barTintColor = MainColor;
    [self.view addSubview:self.collectionView];
    
    //网络请求
    [self loadData];
}

- (void)backButtonAction:(UIButton *)button{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -------Custommethod

- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:kCity parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dic = responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        NSString *status = dic[@"status"];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *Array = successDic[@"list"];
            for (NSDictionary *dict in Array) {
                [self.cityArray addObject:dict[@"cat_name"]];
            }
            [self.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WXQLog(@"%@", error);
    }];
}

#pragma mark ------- Lazyloading

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //创建一个layout布局类
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
       flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 1;
        //设置每个item的大小
        flowLayout.itemSize = CGSizeMake((kScreenWidth - 12)/ 3, kScreenWidth / 6 - 10);

        //设置布局方向（默认垂直方向）
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 100);
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
        //设置代理
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        //注册item类型
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
        [self.collectionView registerNib:[UINib nibWithNibName:@"HeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)cityArray{
    if (_cityArray == nil) {
        self.cityArray = [NSMutableArray new];
    }
    return _cityArray;
}

#pragma mark --------- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = self.cityArray[indexPath.row];
    [cell addSubview:titleLabel];
    return cell;
}
#pragma mark --------- UICollectionViewDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
   UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
       self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        self.headerView.name = self.cityName;
        reusableView = self.headerView;
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.headerView.name = self.cityArray[indexPath.row];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(changCity:)]) {
        [self.delegate changCity:self.cityArray[indexPath.row]];
    }
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

@end
