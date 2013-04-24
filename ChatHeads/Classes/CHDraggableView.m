//
//  CHDraggableView.m
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//

#import "CHDraggableView.h"
#import <QuartzCore/QuartzCore.h>

#import "SKBounceAnimation.h"

@interface CHDraggableView ()

@property (nonatomic, assign) BOOL moved;
@property (nonatomic, assign) BOOL scaledDown;
@property (nonatomic, assign) CGPoint startTouchPoint;

@end

@implementation CHDraggableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)snapViewCenterToPoint:(CGPoint)point edge:(CGRectEdge)edge
{
    [self _snapViewCenterToPoint:point edge:edge];
}

#pragma mark - Override Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _startTouchPoint = [touch locationInView:self];
    
    // Simulate a touch with the scale animation
    [self _beginHoldAnimation];
    _scaledDown = YES;
    
    [_delegate draggableViewHold:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint movedPoint = [touch locationInView:self];
    
    CGFloat deltaX = movedPoint.x - _startTouchPoint.x;
    CGFloat deltaY = movedPoint.y - _startTouchPoint.y;
    [self _moveByDeltaX:deltaX deltaY:deltaY];
    if (_scaledDown) {
        [self _beginReleaseAnimation];
    }
    _scaledDown = NO;
    _moved = YES;
    
    [_delegate draggableView:self didMoveToPoint:movedPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_scaledDown) {
        [self _beginReleaseAnimation];
    }
    if (!_moved) {
        [_delegate draggableViewTouched:self];
    } else {
        [_delegate draggableViewReleased:self];
    }
    
    _moved = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

#pragma mark - Animations
#define CGPointIntegral(point) CGPointMake((int)point.x, (int)point.y)

- (CGFloat)_distanceFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2
{
    return hypotf(point1.x - point2.x, point1.y - point2.y);
}

- (CGFloat)_angleFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2
{
    CGFloat x = point2.x - point1.x;
    CGFloat y = point2.y - point1.y;
    
    return atan2f(x,y);
}

- (void)_moveByDeltaX:(CGFloat)x deltaY:(CGFloat)y
{
    [UIView animateWithDuration:0.3f animations:^{
        CGPoint center = self.center;
        center.x += x;
        center.y += y;
        self.center = CGPointIntegral(center);
    }];
}

- (void)_beginHoldAnimation
{
    SKBounceAnimation *animation = [SKBounceAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95f, 0.95f, 1)];
    animation.duration = 0.2f;
    
    self.layer.transform = [animation.toValue CATransform3DValue];
    [self.layer addAnimation:animation forKey:nil];
}

- (void)_beginReleaseAnimation
{
    SKBounceAnimation *animation = [SKBounceAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCATransform3D:self.layer.transform];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    animation.duration = 0.2f;
    
    self.layer.transform = [animation.toValue CATransform3DValue];
    [self.layer addAnimation:animation forKey:nil];
}

- (void)_snapViewCenterToPoint:(CGPoint)point edge:(CGRectEdge)edge
{
    CGPoint currentCenter = self.center;
    
    SKBounceAnimation *animation = [SKBounceAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCGPoint:currentCenter];
    animation.toValue = [NSValue valueWithCGPoint:point];
    animation.duration = 1.2f;
    self.layer.position = point;
    [self.layer addAnimation:animation forKey:nil];
}

@end
