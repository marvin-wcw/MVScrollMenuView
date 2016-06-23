//
//  MVScrollMenuView.m
//  MVScrollMenuView
//
//  Created by wangcw on 16/6/21.
//  Copyright © 2016年 marvin. All rights reserved.
//

#import "MVScrollMenuView.h"


typedef enum
{
    MVScrollDirectionNone,
    MVScrollDirectionVertical,
    MVScrollDirectionHorizontal,
    
} MVScrollDirection;

@interface MVScrollMenuView () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGPoint preLocation;
@property (nonatomic, assign) MVScrollDirection scrollDirection;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *pressGesture;

@end

@implementation MVScrollMenuView

- (instancetype)initWithSuperview:(UIView *)superview frame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [superview addSubview:self];
        [superview sendSubviewToBack:self];
        
        [self resetLocation];
        _scrollDirection = MVScrollDirectionNone;
        
        _verticalMenu = [[MVScrollMenu alloc] initWithMenuDirection:MVScrollMenuDirectionVertical];
        _verticalMenu.enabled = YES;
        [self addSubview:_verticalMenu];
        
        _horizontalMenu = [[MVScrollMenu alloc] initWithMenuDirection:MVScrollMenuDirectionHorizontal];
        _horizontalMenu.enabled = YES;
        [self addSubview:_horizontalMenu];
        
        _pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressGesture:)];
        _panGesture.delegate = self;
        _pressGesture.numberOfTouchesRequired = 1;
        _pressGesture.cancelsTouchesInView = YES;
        _pressGesture.minimumPressDuration = 0.2f;
        [self addGestureRecognizer:_pressGesture];
        
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        _panGesture.delegate = self;
        _panGesture.minimumNumberOfTouches = 1;
        _panGesture.maximumNumberOfTouches = 1;
        _panGesture.cancelsTouchesInView = YES;
        [self addGestureRecognizer:_panGesture];
        
    }
    
    return self;
}

#pragma mark - Gesture Event

- (void)pressGesture:(UILongPressGestureRecognizer *)pressGesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollMenuView:shouldReceiveGestureRecognizer:)] && ![_delegate scrollMenuView:self shouldReceiveGestureRecognizer:pressGesture])
    {
        return;
    }
    
    NSLog(@"Press Ignore");
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(scrollMenuView:shouldReceiveGestureRecognizer:)] && ![_delegate scrollMenuView:self shouldReceiveGestureRecognizer:panGesture])
    {
        return;
    }
    
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [panGesture locationInView:self];
        if ([self isValidLocation])
        {
            if (_scrollDirection == MVScrollDirectionNone)
            {
                CGFloat xOffset = point.x - _preLocation.x;
                CGFloat yOffset = point.y - _preLocation.y;
                
                if ((fabs(yOffset) - fabs(xOffset)) >= 0)
                {
                    _currentMenu = _verticalMenu;
                    _scrollDirection = MVScrollDirectionVertical;
                }
                else
                {
                    _currentMenu = _horizontalMenu;
                    _scrollDirection = MVScrollDirectionHorizontal;
                }
                
                if (_currentMenu.enabled && [_currentMenu itemCount] > 0 && CGRectContainsPoint(_currentMenu.hotArea, point))
                {
                    [_currentMenu scrollBegin];
                }
            }
            
            if (_scrollDirection == MVScrollDirectionVertical)
            {
                [self.superview bringSubviewToFront:self];
                [_currentMenu scrollWithOffset:point.y - _preLocation.y];
            }
            else if (_scrollDirection == MVScrollDirectionHorizontal)
            {
                [self.superview bringSubviewToFront:self];
                [_currentMenu scrollWithOffset:point.x - _preLocation.x];
            }
        }
        
        _preLocation = point;
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled)
    {
        if (_currentMenu.enabled && [_currentMenu itemCount] > 0)
        {
            [_currentMenu scrollEnd];
            
            [self resetLocation];
            [self.superview sendSubviewToBack:self];
            
            _scrollDirection = MVScrollDirectionNone;
            
            if (_delegate && [_delegate respondsToSelector:@selector(scrollMenuView:didSelectItemIndex:)])
            {
                [_delegate scrollMenuView:self didSelectItemIndex:_currentMenu.selectedItemIndex];
            }
        }
    }
}

- (void)resetLocation
{
    _preLocation = CGPointMake(-1.f, -1.f);
}

- (BOOL)isValidLocation
{
    return _preLocation.x >= 0.f && _preLocation.y >= 0.f;
}

@end
