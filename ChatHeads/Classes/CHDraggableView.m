//
//  CHDraggableView.m
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//

#import "CHDraggableView.h"

#import <QuartzCore/QuartzCore.h>

#import "CHBounceAnimationCurve.h"

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
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.13f;

    CGFloat toValue = 0.95f;
    animation.values = [self _valuesForAnimationFromScaleValue:1 toScaleValue:toValue duration:animation.duration];
    self.layer.transform = CATransform3DMakeScale(toValue, toValue, 1);
    [self.layer addAnimation:animation forKey:nil];
}

- (void)_beginReleaseAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.13f;
    
    CGFloat toValue = 1.05;
    animation.values = [self _valuesForAnimationFromScaleValue:1 toScaleValue:toValue duration:animation.duration];
    self.layer.transform = CATransform3DMakeScale(toValue, toValue, 1);
    [self.layer addAnimation:animation forKey:nil];
}

#define SNAP_ANIMATION_BOUNCE 0.04f
- (void)_snapViewCenterToPoint:(CGPoint)point edge:(CGRectEdge)edge
{
    CGPoint currentCenter = self.center;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 1;
    animation.values = [self _valuesForAnimationFromPoint:currentCenter toPoint:point duration:animation.duration];
    self.layer.position = point;
    [self.layer addAnimation:animation forKey:nil];
}

- (NSArray *)_valuesForAnimationFromScaleValue:(CGFloat)fromValue toScaleValue:(CGFloat)toValue duration:(CGFloat)duration
{
    CHBounceAnimationCurve *curve = [CHBounceAnimationCurve bounceAnimationCurveFromValue:fromValue toValue:toValue numberOfBounces:2];
    NSArray *interpolatedValues = [curve interpolatedValuesForDuration:duration];
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:[interpolatedValues count]];
    for (int i = 0; i < [interpolatedValues count]; i++) {
        CGFloat value = [[interpolatedValues objectAtIndex:i] floatValue];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(value, value, 1)]];
    }
    
    return values;
}

- (NSArray *)_valuesForAnimationFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint duration:(CGFloat)duration
{
    CHBounceAnimationCurve *curveX = [CHBounceAnimationCurve bounceAnimationCurveFromValue:fromPoint.x toValue:toPoint.x numberOfBounces:2];
    CHBounceAnimationCurve *curveY = [CHBounceAnimationCurve bounceAnimationCurveFromValue:fromPoint.y toValue:toPoint.y numberOfBounces:2];
    NSArray *xValues = [curveX interpolatedValuesForDuration:duration];
    NSArray *yValues = [curveY interpolatedValuesForDuration:duration];
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:[xValues count]];
    for (int i = 0; i < [xValues count]; i++) {
        CGFloat x = [[xValues objectAtIndex:i] floatValue];
        CGFloat y = [[yValues objectAtIndex:i] floatValue];
        [values addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }
    
    return values;
}

@end
