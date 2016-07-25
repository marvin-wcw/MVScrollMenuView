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

@property (nonatomic, readonly, strong) MVScrollMenu *currentMenu;

@property (nonatomic, assign) CGPoint preLocation;
@property (nonatomic, assign) MVScrollDirection scrollDirection;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *pressGesture;
@property (nonatomic, assign) BOOL shouldReceiveTapGestureRecognizer;
@property (nonatomic, assign) BOOL shouldReceivePanGestureRecognizer;

@end

@implementation MVScrollMenuView

- (instancetype)initWithSuperview:(UIView *)superview frame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [superview insertSubview:self atIndex:0];
        
        [self resetLocation];
        _scrollDirection = MVScrollDirectionNone;
        _pressDuration = 0.3f;
        
        _verticalMenu = [[MVScrollMenu alloc] initWithMenuDirection:MVScrollMenuDirectionVertical];
        _verticalMenu.enabled = YES;
        [self addSubview:_verticalMenu];
        
        _horizontalMenu = [[MVScrollMenu alloc] initWithMenuDirection:MVScrollMenuDirectionHorizontal];
        _horizontalMenu.enabled = YES;
        [self addSubview:_horizontalMenu];
        
        _pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressGesture:)];
        _pressGesture.delegate = self;
        _pressGesture.numberOfTouchesRequired = 1;
        _pressGesture.cancelsTouchesInView = YES;
        _pressGesture.minimumPressDuration = _pressDuration;
        [superview addGestureRecognizer:_pressGesture];
        
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        _panGesture.delegate = self;
        _panGesture.minimumNumberOfTouches = 1;
        _panGesture.maximumNumberOfTouches = 1;
        _panGesture.cancelsTouchesInView = YES;
        [superview addGestureRecognizer:_panGesture];
        
        _shouldReceivePanGestureRecognizer = YES;
        _shouldReceiveTapGestureRecognizer = YES;
        
        self.enabled = YES;
    }
    
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    _pressGesture.enabled = enabled;
    _panGesture.enabled = enabled;
}

- (void)setPressDuration:(CGFloat)pressDuration
{
    _pressDuration = pressDuration;
    _pressGesture.minimumPressDuration = _pressDuration;
}

#pragma mark - Gesture Event

- (void)pressGesture:(UILongPressGestureRecognizer *)pressGesture
{
    CGPoint point = [pressGesture locationInView:self];
    if (pressGesture.state == UIGestureRecognizerStateBegan && !CGRectContainsPoint(self.bounds, point))
    {
        return;
    }

    if (pressGesture.state == UIGestureRecognizerStateBegan || pressGesture.state == UIGestureRecognizerStateChanged)
    {
        _panGesture.enabled = NO;
    }
    else
    {
        _panGesture.enabled = YES;
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [panGesture locationInView:self];
        if (panGesture.state == UIGestureRecognizerStateBegan && !CGRectContainsPoint(self.bounds, point))
        {
            _shouldReceivePanGestureRecognizer = NO;
            return;
        }
        
        if (panGesture.state == UIGestureRecognizerStateBegan)
        {
            _shouldReceivePanGestureRecognizer = [self shouldReceiveGestureRecognizer:panGesture];
        }
        if (!_shouldReceivePanGestureRecognizer)
        {
            return;
        }
        
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
                
                if (_currentMenu.enabled && [_currentMenu itemCount] > 0 && (CGRectIsEmpty(_currentMenu.hotArea) || CGRectContainsPoint(_currentMenu.hotArea, point)))
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
            
            _currentMenu = nil;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == _panGesture && otherGestureRecognizer == _pressGesture)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == _pressGesture || gestureRecognizer == _panGesture)
    {
        CGPoint point = [gestureRecognizer locationInView:self];
        NSLog(@"%ld", gestureRecognizer.state);
        NSLog(@"%lf, %lf", point.x, point.y);
        
        return YES;
    }
    
    return NO;
}

- (void)resetLocation
{
    _preLocation = CGPointMake(CGFLOAT_MIN, CGFLOAT_MIN);
}

- (BOOL)isValidLocation
{
    return _preLocation.x != CGFLOAT_MIN && _preLocation.y != CGFLOAT_MIN;
}

- (BOOL)shouldReceiveGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"shouldReceiveGestureRecognizer");
    
    if (_delegate && [_delegate respondsToSelector:@selector(scrollMenuView:shouldReceiveGestureRecognizer:)] && ![_delegate scrollMenuView:self shouldReceiveGestureRecognizer:gestureRecognizer])
    {
        return NO;
    }
    
    return YES;
}

@end
