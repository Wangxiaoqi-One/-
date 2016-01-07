//
//  HWTools.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "HWTools.h"

@implementation HWTools

+ (NSString *)getDateFromString:(NSString *)timestamp{
    NSTimeInterval times = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *time = [dateFormatter stringFromDate:date];
    return time;
}

#pragma mark ----------根据文字最大显示宽高和文字内容返回文字高度
+ (CGFloat)getTextHeightWithText:(NSString *)text bigestSize:(CGSize)bigSize textFont:(CGFloat)font{
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.height;
}

@end
