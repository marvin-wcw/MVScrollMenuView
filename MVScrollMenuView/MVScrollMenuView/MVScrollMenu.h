//
//  MVScrollMenu.h
//  MVScrollMenuView
//
//  Created by wangcw on 16/6/22.
//  Copyright © 2016年 marvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVScrollMenuItem.h"

typedef enum
{
    MVScrollMenuDirectionVertical = 0,
    MVScrollMenuDirectionHorizontal
    
} MVScrollMenuDirection;

@interface MVScrollMenu : UIView

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, readonly, assign) MVScrollMenuDirection menuDirection;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGRect hotArea;

@property (nonatomic, assign) NSInteger selectedItemIndex;

@property (nonatomic, strong) UIFont *itemFont;
@property (nonatomic, strong) UIFont *itemHighlightFont;
@property (nonatomic, strong) UIColor *itemTextColor;
@property (nonatomic, strong) UIColor *itemHighlightTextColor;
@property (nonatomic, strong) UIColor *itemBackgroundColor;
@property (nonatomic, strong) UIColor *itemHighlightBackgroundColor;
@property (nonatomic, assign) CGFloat itemCornerRadius;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGSize centerOffset;

- (instancetype)initWithMenuDirection:(MVScrollMenuDirection)menuDirection;

- (void)setMenuTitleArray:(NSArray *)menuTitleArray;

- (void)scrollBegin;
- (void)scrollWithOffset:(CGFloat)offset;
- (void)scrollEnd;

- (NSInteger)itemCount;
- (MVScrollMenuItem *)itemAtIndex:(NSInteger)index;

@end
