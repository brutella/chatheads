//
//  CHBounceCurveHelper.m
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/21/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//

#import "CHBounceAnimationCurve.h"

@implementation CHBounceAnimationCurve

+ (CHBounceAnimationCurve *)bounceAnimationCurveFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue numberOfBounces:(NSUInteger)numberOfBounces
{
    return [[CHBounceAnimationCurve alloc] initWithFromValue:fromValue toValue:toValue numberOfBounces:numberOfBounces];
}

- (id)initWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue numberOfBounces:(NSUInteger)numberOfBounces
{
    self = [super init];
    if (self) {
        _fromValue = fromValue;
        _toValue = toValue;
        _numberOfBounces = numberOfBounces;
    }
    
    return self;
}

- (NSArray *)interpolatedValuesForDuration:(CGFloat)duration
{
    NSMutableArray *values = [NSMutableArray array];
    
    // Formula
    // v_t = e^(alpha * t) * cos(omega * t) * difference + toValue
    CGFloat steps = duration * 60; // 60 fps
    CGFloat difference = _fromValue - _toValue;
    
    CGFloat omega = (_numberOfBounces/2 + 0.5f) * 2*M_PI/steps;
    
    CGFloat alpha = log2f(0.1f/fabsf(difference))/steps;
    if (_fromValue == _toValue) {
        alpha = log2f(0.1f)/steps;
    }
    
    alpha *= alpha > 0 ? -1 : 1;
    
    for (int t = 0; t < steps; t++) {
        CGFloat value = difference * powf(M_E, alpha*t) * cos(omega*t) + _toValue;
        [values addObject:@(value)];
    }
    
    return values;
}

@end
