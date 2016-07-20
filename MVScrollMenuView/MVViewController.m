//
//  MVViewController.m
//  MVRightSlideView
//
//  Created by wangcw on 16/6/21.
//  Copyright © 2016年 guosen. All rights reserved.
//

#import "MVViewController.h"
#import "MVScrollMenuView.h"

@interface MVViewController ()

@property (nonatomic, strong) MVScrollMenuView *scrollMenuView;

@end

@implementation MVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:23.f / 255.f green:28.f/255.f blue:40.f/255.f alpha:1.f];
    
    UIButton *bbt = [[UIButton alloc] initWithFrame:CGRectZero];
    bbt.center = self.view.center;
    bbt.bounds = CGRectMake(0.f, 0.f, 200.f, 200.f);
    [bbt setTitle:@"ffkk" forState:UIControlStateNormal];
    [bbt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [bbt addTarget:self action:@selector(ffkkAction) forControlEvents:UIControlEventTouchUpInside];
    bbt.backgroundColor = [UIColor redColor];
    [self.view addSubview:bbt];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_scrollMenuView == nil)
    {
        _scrollMenuView = [[MVScrollMenuView alloc] initWithSuperview:self.view.superview frame:CGRectMake(100, 100, 200, 200)];
        [_scrollMenuView.verticalMenu setMenuTitleArray:@[@"VOL", @"MACD", @"KDJ", @"RSI"]];
        _scrollMenuView.verticalMenu.centerOffset = CGSizeMake(40.f, 40.f);
        [_scrollMenuView.verticalMenu setSelectedItemIndex:3];
        //    _scrollMenuView.verticalMenu.backgroundColor = [UIColor grayColor];
        
        [_scrollMenuView.horizontalMenu setMenuTitleArray:@[@"5分", @"15分", @"20分", @"日K", @"周K", @"月K"]];
        //    _scrollMenuView.horizontalMenu.backgroundColor = [UIColor grayColor];
    }
}

- (void)ffkkAction
{
    [_scrollMenuView.horizontalMenu setMenuTitleArray:@[@"ffkk", @"aabb", @"kkkk"]];
    [_scrollMenuView.horizontalMenu setSelectedItemIndex:1];
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
