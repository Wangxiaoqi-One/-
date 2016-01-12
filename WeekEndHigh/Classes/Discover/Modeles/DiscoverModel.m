//
//  DiscoverModel.m
//  WeekEndHigh
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.activityId = dic[@"id"];
        self.image = dic[@"image"];
        self.title = dic[@"title"];
        self.type = dic[@"type"];
    }
    return self;
}

@end
