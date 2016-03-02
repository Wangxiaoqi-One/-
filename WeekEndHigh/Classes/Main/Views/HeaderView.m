//
//  HeaderView.m
//  WeekEndHigh
//
//  Created by scjy on 16/3/1.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()
- (IBAction)locationAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *cityNameLabel;

@end

@implementation HeaderView


- (void)setName:(NSString *)name{
    self.cityNameLabel.text = [NSString stringWithFormat:@"  %@", name];
}

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)locationAction:(UIButton *)sender {
    
}
@end
