//
//  WHdefine.h
//  WeekEndHigh
//以后把所有的接口都统一放到WHdefine.h中宏定义
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#ifndef WHdefine_h
#define WHdefine_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ClassifyType){
    ClassifyTypeShowRepertorie = 1, //演出剧目
    ClassifyTypeTouristPlace,       //景点场馆
    ClassifyTypeStudyPUZ,           //学习益智
    ClassifyTypeFamilyTravel        //亲子旅游
};

#define MainColor [UIColor colorWithRed:110.0/255.0 green:210.0/255.0 blue:206.0/255.0 alpha:1.0]


//新浪微博分享
#define  kAppKey             @"938033428"
#define  kRedirectURI        @"https://api.weibo.com/oauth2/default.html"
#define  kAppSecret          @"21b0e9e51743acd9e4792fcfe757a96c"

//微信分享
#define kWXAppKey            @"wx50887583d75eb2cb"
#define kWXAppSecret          @"45da40dd122d8bf5a1a85d887f4c84b3"

//首页数据接口
#define kMainDataList @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1"

//活动详情接口
#define kActicityDetail @"http://e.kumi.cn/app/articleinfo.php?_s_=6055add057b829033bb586a3e00c5e9a&_t_=1452071715&channelid=appstore&cityid=1&id=%@&lat=34.61356779156581&lng=112.4141403843618"


//活动专题接口
#define kActivityTheme @"http://e.kumi.cn/app/positioninfo.php?_s_=1b2f0563dade7abdfdb4b7caa5b36110&_t_=1452218405&channelid=appstore&cityid=1&id=%@&lat=34.61349052974207&limit=30&lng=112.4139739846577&page=1"

//精选活动接口
#define kGoodActivity @"http://e.kumi.cn/app/articlelist.php?_s_=a9d09aa8b7692ebee5c8a123deacf775&_t_=1452236979&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942&page=%ld&type=1"

//热门专题
#define kHotTheme @"http://e.kumi.cn/app/positionlist.php?_s_=e2b71c66789428d5385b06c178a88db2&_t_=1452237051&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942&page=%ld"

//分类列表
#define kClassifyList @"http://e.kumi.cn/app/v1.3/catelist.php?_s_=dad924a9b9cd534b53fc2c521e9f8e84&_t_=1452495193&channelid=appstore&cityid=1&lat=34.61356398594803&limit=30&lng=112.4140434532402&page=%ld&typeid=%@"

//发现
#define kDiscover @"http://e.kumi.cn/app/found.php?_s_=a82c7d49216aedb18c04a20fd9b0d5b2&_t_=1451310230&channelid=appstore&cityid=1&lat=34.62172291944134&lng=112.4149512442411"

#endif /* WHdefine_h */


