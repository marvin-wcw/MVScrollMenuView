//
//  MVScrollMenu.m
//  MVScrollMenuView
//
//  Created by wangcw on 16/6/22.
//  Copyright © 2016年 marvin. All rights reserved.
//

#import "MVScrollMenu.h"

@interface MVScrollMenu ()

@property (nonatomic, strong) NSMutableArray *menuItemArray;

@property (nonatomic, readonly, strong) MVScrollMenuItem *activeItem;
@property (nonatomic, readonly, strong) MVScrollMenuItem *selectedItem;

@end

@implementation MVScrollMenu

- (instancetype)initWithMenuDirection:(MVScrollMenuDirection)menuDirection
{
    if (self = [super init]) {
        
        _menuDirection = menuDirection;
        
        [self setDefaults];
    }
    
    return self;
}

- (void)setDefaults
{
    _selectedItemIndex = -1;
    _menuItemArray = [[NSMutableArray alloc] init];
    self.hidden = YES;

    _itemFont = [UIFont systemFontOfSize:16.f];
    _itemHighlightFont = [UIFont systemFontOfSize:17.f];
    _itemTextColor = [UIColor colorWithRed:212.f / 255.f green:212.f / 255.f blue:212.f / 255.f alpha:1.f];
    _itemHighlightTextColor = [UIColor whiteColor];
    _itemBackgroundColor = [UIColor clearColor];
    _itemHighlightBackgroundColor = [UIColor colorWithRed:45.f / 255.f green:166.f / 255.f blue:223.f / 255.f alpha:1.f];
    _itemCornerRadius = 0.f;
    _itemSpacing = 0.f;
    _edgeInsets = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    _centerOffset = CGSizeMake(0.f, 0.f);
    
    if (_menuDirection == MVScrollMenuDirectionVertical)
    {
        _itemSize = CGSizeMake(225.f, 45.f);
    }
    else if (_menuDirection == MVScrollMenuDirectionHorizontal)
    {
        _itemSize = CGSizeMake(51.f, 75.f);
    }
    
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
    self.alpha = 0.93f;
    self.backgroundColor = [UIColor colorWithRed:23.f/255.f green:36.f/255.f blue:51.f/255.f alpha:1.f];  //[[UIColor blackColor] colorWithAlphaComponent:0.16f];
}

- (void)setMenuTitleArray:(NSArray *)menuTitleArray
{
    if (menuTitleArray && [menuTitleArray count] > 0)
    {
        [_menuItemArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_menuItemArray removeAllObjects];
        
        NSInteger count = [menuTitleArray count];
        for (NSInteger i = 0; i < count; ++i)
        {
            NSString *title = [menuTitleArray objectAtIndex:i];
            MVScrollMenuItem *menuItem = [[MVScrollMenuItem alloc] initWithTitle:title];
            [self addSubview:menuItem];
            
            [_menuItemArray addObject:menuItem];
        }
        
        //Active item
        _activeItem = [[MVScrollMenuItem alloc] initWithTitle:@""];
        _activeItem.hidden = YES;
        _activeItem.font = _itemHighlightFont;
        _activeItem.frame = CGRectMake(self.superview.center.x + _centerOffset.width - _itemSize.width / 2.f, self.superview.center.y + _centerOffset.height - _itemSize.height / 2.0, _itemSize.width, _itemSize.height);
        [self addSubview:_activeItem];

        [self updateSubviews];
    }
}

- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex
{
    if (selectedItemIndex >= 0 && selectedItemIndex < [_menuItemArray count])
    {
        [self setSelectedItem:[_menuItemArray objectAtIndex:selectedItemIndex] updateFrame:YES];
    }
}

- (void)scrollBegin
{
    self.hidden = NO;
    _activeItem.hidden = NO;
}

- (void)scrollEnd
{
    self.hidden = YES;
    _activeItem.hidden = YES;
}

- (void)scrollWithOffset:(CGFloat)offset
{
    self.hidden = NO;
    _activeItem.hidden = NO;
    
    UIView *superview = self.superview;
    
    if (_menuDirection == MVScrollMenuDirectionVertical)
    {
        CGRect menuFrame = self.frame;
        CGFloat newY = menuFrame.origin.y + offset;
        CGFloat minY = superview.center.y + _centerOffset.height - CGRectGetHeight(self.frame) + _itemSize.height / 2.f + _edgeInsets.bottom;
        CGFloat maxY = superview.center.y + _centerOffset.height - _itemSize.height / 2.f - _edgeInsets.top;
        if (newY < minY)
        {
            newY = minY;
        }
        else if(newY > maxY)
        {
            newY = maxY;
        }
        
        self.frame = CGRectMake(superview.center.x + _centerOffset.width - CGRectGetWidth(self.frame) / 2.f, newY, menuFrame.size.width, menuFrame.size.height);
        
        NSInteger count = [self itemCount];
        for (NSInteger i = 0; i < count; i++)
        {
            MVScrollMenuItem *item = [self itemAtIndex:i];
            CGPoint centerPointInMenuView = [superview convertPoint:CGPointMake(superview.center.x + _centerOffset.width, superview.center.y + _centerOffset.height) toView:item];
            if ([item pointInside:centerPointInMenuView withEvent:nil])
            {
                [self setSelectedItem:item updateFrame:NO];
                break;
            }
        }

    }
    else if (_menuDirection == MVScrollMenuDirectionHorizontal)
    {
        CGRect menuFrame = self.frame;
        CGFloat newX = menuFrame.origin.x + offset;
        CGFloat minX = superview.center.x + _centerOffset.width - CGRectGetWidth(self.frame) + _itemSize.width / 2.f + _edgeInsets.right;
        CGFloat maxX = superview.center.x + _centerOffset.width - _itemSize.width / 2.f - _edgeInsets.left;
        if (newX < minX)
        {
            newX = minX;
        }
        else if (newX > maxX)
        {
            newX = maxX;
        }
        
        self.frame = CGRectMake(newX, superview.center.y + _centerOffset.height - CGRectGetHeight(self.frame) / 2.f, menuFrame.size.width, menuFrame.size.height);
        
        NSInteger count = [self itemCount];
        for (NSInteger i = 0; i < count; i++)
        {
            MVScrollMenuItem *item = [self itemAtIndex:i];
            CGPoint centerPointInMenuView = [superview convertPoint:CGPointMake(superview.center.x + _centerOffset.width, superview.center.y + _centerOffset.height) toView:item];
            if ([item pointInside:centerPointInMenuView withEvent:nil])
            {
                [self setSelectedItem:item updateFrame:NO];
                break;
            }
        }
    }
    
    _activeItem.frame = [self.superview convertRect:CGRectMake(self.superview.center.x + _centerOffset.width - _itemSize.width / 2.f, self.superview.center.y + _centerOffset.height - _itemSize.height / 2.0, _itemSize.width, _itemSize.height) toView:self];
}

- (NSInteger)itemCount
{
    return [_menuItemArray count];
}

- (MVScrollMenuItem *)itemAtIndex:(NSInteger)index
{
    if (index < [_menuItemArray count])
    {
        return [_menuItemArray objectAtIndex:index];
    }
    
    return nil;
}

- (void)updateSubviews
{
    CGFloat xStart = _edgeInsets.left;
    CGFloat yStart = _edgeInsets.top;
    
    NSInteger count = [_menuItemArray count];
    for (NSInteger i = 0; i < count; ++i)
    {
        MVScrollMenuItem *menuItem = [_menuItemArray objectAtIndex:i];
        menuItem.font = _itemFont;
        menuItem.textColor = _itemTextColor;
        menuItem.backgroundColor = _itemBackgroundColor;
        menuItem.layer.cornerRadius = _itemCornerRadius;
        menuItem.layer.masksToBounds = YES;
        menuItem.frame = CGRectMake(xStart, yStart, _itemSize.width, _itemSize.height);
        
        if (_menuDirection == MVScrollMenuDirectionVertical)
        {
            yStart += _itemSize.height;
            if (i > 0 && i < count - 1)
            {
                yStart += _itemSpacing;
            }
        }
        else if (_menuDirection == MVScrollMenuDirectionHorizontal)
        {
            xStart += _itemSize.width;
            if (i > 0 && i < count - 1)
            {
                xStart += _itemSpacing;
            }
        }
    }
    
    CGSize menuSize = CGSizeZero;
    if (_menuDirection == MVScrollMenuDirectionVertical)
    {
        menuSize = CGSizeMake(_edgeInsets.left + _itemSize.width + _edgeInsets.right, yStart + _edgeInsets.bottom);
    }
    else if (_menuDirection == MVScrollMenuDirectionHorizontal)
    {
        menuSize = CGSizeMake(xStart + _edgeInsets.right, _edgeInsets.top + _itemSize.height + _edgeInsets.bottom);
    }
    self.bounds = CGRectMake(0.f, 0.f, menuSize.width, menuSize.height);
    
    _activeItem.backgroundColor = _itemHighlightBackgroundColor;
    _activeItem.textColor = _itemHighlightTextColor;
    _activeItem.font = _itemFont;
    _activeItem.frame = [self.superview convertRect:CGRectMake(self.superview.center.x + _centerOffset.width - _itemSize.width / 2.f, self.superview.center.y + _centerOffset.height - _itemSize.height / 2.0, _itemSize.width, _itemSize.height) toView:self];
    
    if (_selectedItemIndex < 0 || _selectedItemIndex > [_menuItemArray count] - 1)
    {
        _selectedItemIndex = 0;
    }
    [self setSelectedItemIndex:_selectedItemIndex];
}

- (void)setSelectedItem:(MVScrollMenuItem *)selectedItem updateFrame:(BOOL)updateFrame
{
    NSInteger index = [_menuItemArray indexOfObject:selectedItem];
    if (selectedItem && selectedItem != _selectedItem && index != NSNotFound)
    {
        if (updateFrame)
        {
            UIView *superview = self.superview;
            
            if (_menuDirection == MVScrollMenuDirectionVertical)
            {
                CGFloat newY = superview.center.y + _centerOffset.height - (_edgeInsets.top + _itemSize.height * (index + .5f));
                self.frame = CGRectMake(superview.center.x + _centerOffset.width - CGRectGetWidth(self.frame) / 2.f, newY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            }
            else if (_menuDirection == MVScrollMenuDirectionHorizontal)
            {
                CGFloat newX = superview.center.x + _centerOffset.width - (_edgeInsets.left + _itemSize.width * (index + .5f));
                self.frame = CGRectMake(newX, superview.center.y + _centerOffset.height - CGRectGetHeight(self.frame) / 2.f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            }
            
            _activeItem.frame = [self.superview convertRect:CGRectMake(self.superview.center.x + _centerOffset.width - _itemSize.width / 2.f, self.superview.center.y + _centerOffset.height - _itemSize.height / 2.0, _itemSize.width, _itemSize.height) toView:self];
        }
        
        if (_selectedItem)
        {
            _selectedItem.hidden = NO;
        }
        
        _selectedItem = selectedItem;
        _selectedItem.hidden = YES;
        _activeItem.text = _selectedItem.text;
        
        _selectedItemIndex = index;
    }
}

- (void)setItemFont:(UIFont *)itemFont
{
    _itemFont = itemFont;
    [self updateSubviews];
}

- (void)setItemTextColor:(UIColor *)itemTextColor
{
    _itemTextColor = itemTextColor;
    [self updateSubviews];
}

- (void)setItemHighlightTextColor:(UIColor *)itemHighlightTextColor
{
    _itemHighlightTextColor = itemHighlightTextColor;
    [self updateSubviews];
}

- (void)setItemBackgroundColor:(UIColor *)itemBackgroundColor
{
    _itemBackgroundColor = itemBackgroundColor;
    [self updateSubviews];
}

- (void)setItemHighlightBackgroundColor:(UIColor *)itemHighlightBackgroundColor
{
    _itemHighlightBackgroundColor = itemHighlightBackgroundColor;
    [self updateSubviews];
}

@end
