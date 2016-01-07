//
//  ActivityDetailView.h
//  WeekEndHigh
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailView : UIView
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *makeCallButton;

@property (nonatomic, strong) NSDictionary *dataDic;

@end
