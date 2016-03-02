//
//  SelectCityViewController.h
//  WeekEndHigh
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changCityName <NSObject>

- (void)changCity:(NSString *)name;

@end

@interface SelectCityViewController : UIViewController

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, assign) id<changCityName>delegate;

@end
