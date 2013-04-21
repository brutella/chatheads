//
//  CHBounceCurveHelper.h
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/21/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHBounceAnimationCurve : NSObject

@property (nonatomic, assign, readonly) CGFloat resolution; // fps

@property (nonatomic, assign, readonly) CGFloat fromValue;
@property (nonatomic, assign, readonly) CGFloat toValue;
@property (nonatomic, assign, readonly) NSUInteger numberOfBounces;

+ (CHBounceAnimationCurve *)bounceAnimationCurveFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue numberOfBounces:(NSUInteger)numberOfBounces;
- (id)initWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue numberOfBounces:(NSUInteger)numberOfBounces;
- (NSArray *)interpolatedValuesForDuration:(CGFloat)duration;

@end
