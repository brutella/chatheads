//
//  CHDraggableView+Avatar.h
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//

#import "CHDraggableView.h"

@interface CHDraggableView (Avatar)

+ (id)draggableViewWithImage:(UIImage *)image;
+ (id)draggableViewWithImage:(UIImage *)image size:(CGSize)size;

+ (id)draggableViewWithFillColor:(UIColor *)color;
+ (id)draggableViewWithFillColor:(UIColor *)color size:(CGSize)size;

@end
