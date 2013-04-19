//
//  CHDraggableView.m
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//

#import "CHDraggableView.h"

#import <QuartzCore/QuartzCore.h>

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

#define SNAP_ANIMATION_BOUNCE 0.04f
- (void)_snapViewCenterToPoint:(CGPoint)point edge:(CGRectEdge)edge
{
    CGPoint currentCenter = self.center;
    
    // How much should be bounced based on the moving distance?
    CGFloat movingDistance = [self _distanceFromPoint:currentCenter toPoint:point];
    CGFloat angle = [self _angleFromPoint:currentCenter toPoint:point];
    
    CGFloat bounceDistance = movingDistance * SNAP_ANIMATION_BOUNCE;
    CGFloat deltaX = sinf(angle) * bounceDistance;
    CGFloat deltaY = cosf(angle) * bounceDistance;
    
    CGPoint step1 = point;
    step1.x += deltaX;
    step1.y += deltaY;
    
    CGPoint step2 = point;
    
    [UIView animateWithDuration:0.28f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointIntegral(step1);
    } completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.center = CGPointIntegral(step2);
            } completion:^(BOOL finished){}];
        }
    }];
}

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
    CGAffineTransform transform_step1 = CGAffineTransformMakeScale(0.9f, 0.9f);
    CGAffineTransform transform_step2 = CGAffineTransformMakeScale(0.95f, 0.95f);
    [self _beginScaleAnimationWithTransformStep1:transform_step1 durationStep1:0.1f transformStep2:transform_step2 durationStep2:0.1f];
}

- (void)_beginReleaseAnimation
{
    CGAffineTransform transform_step1 = CGAffineTransformMakeScale(1.05f, 1.05f);
    CGAffineTransform transform_step2 = CGAffineTransformMakeScale(1, 1);
    [self _beginScaleAnimationWithTransformStep1:transform_step1 durationStep1:0.15f transformStep2:transform_step2 durationStep2:0.1f];
}

- (void)_beginScaleAnimationWithTransformStep1:(CGAffineTransform)transformStep1 durationStep1:(CGFloat)durationStep1 transformStep2:(CGAffineTransform)transformStep2 durationStep2:(CGFloat)durationStep2
{
    [UIView animateWithDuration:durationStep1 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.layer.affineTransform = transformStep1;
    }completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:durationStep2 animations:^{
                self.layer.affineTransform = transformStep2;
            }];
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
