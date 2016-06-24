//
//  MVScrollMenuView.h
//  MVScrollMenuView
//
//  Created by wangcw on 16/6/21.
//  Copyright © 2016年 marvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVScrollMenuItem.h"
#import "MVScrollMenu.h"


@protocol  MVScrollMenuViewDelegate;


@interface MVScrollMenuView : UIView

@property (nonatomic, readonly, strong) MVScrollMenu *verticalMenu;
@property (nonatomic, readonly, strong) MVScrollMenu *horizontalMenu;

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) CGFloat pressDuration;

@property (nonatomic,weak) id<MVScrollMenuViewDelegate> delegate;

- (instancetype)initWithSuperview:(UIView *)superview frame:(CGRect)frame;

@end


@protocol MVScrollMenuViewDelegate <NSObject>

@optional
- (BOOL)scrollMenuView:(MVScrollMenuView *)scrollMenuView shouldReceiveGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
- (void)scrollMenuView:(MVScrollMenuView *)scrollMenuView didSelectItemIndex:(NSInteger)index;

@end
