//
//  MVScrollMenuItem.m
//  MVScrollMenuView
//
//  Created by wangcw on 16/6/22.
//  Copyright © 2016年 marvin. All rights reserved.
//

#import "MVScrollMenuItem.h"

@implementation MVScrollMenuItem

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [self init]) {
        self.text = title;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectZero])
    {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:161.f green:161.f blue:161.f alpha:0.7f];
        self.adjustsFontSizeToFitWidth = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor colorWithRed:212.f green:212.f blue:212.f alpha:1.f];
    }
    
    return self;
}

@end
