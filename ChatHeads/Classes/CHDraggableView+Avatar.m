//
//  CHDraggableView+Avatar.m
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//

#import "CHDraggableView+Avatar.h"
#import "CHAvatarView.h"


@implementation CHDraggableView (Avatar)

+ (id)draggableViewWithImage:(UIImage *)image
{
    return [self _draggableViewWithImage:image fillColor:nil size:CGSizeMake(66, 66)];
}

+ (id)draggableViewWithImage:(UIImage *)image size:(CGSize)size {
    return [self _draggableViewWithImage:image fillColor:nil size:size];
}

+ (id)draggableViewWithFillColor:(UIColor *)color {
    return [self _draggableViewWithImage:nil fillColor:color size:CGSizeMake(66, 66)];
}

+ (id)draggableViewWithFillColor:(UIColor *)color size:(CGSize)size {
    return [self _draggableViewWithImage:nil fillColor:color size:size];
}

+ (id)draggableViewWithView:(UIView *)customView fillColor:(UIColor *)inColor {
    return [self draggableViewWithView:customView fillColor:inColor size:CGSizeMake(66, 66)];
}

+ (id)_draggableViewWithImage:(UIImage *)inImage fillColor:(UIColor *)inColor size:(CGSize)inSize {
    CHDraggableView *view = [[CHDraggableView alloc] initWithFrame:CGRectMake(0, 0, inSize.width, inSize.height)];
    
    CHAvatarView *avatarView = [[CHAvatarView alloc] initWithFrame:CGRectInset(view.bounds, 4, 4)];
    avatarView.backgroundColor = [UIColor clearColor];
    [avatarView setImage:inImage];
    [avatarView setFillColor:inColor];
    if (inColor) {
        avatarView.useEvenOddFill = NO;
    }
    
    avatarView.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    [view addSubview:avatarView];
    
    return view;
}

+ (id)draggableViewWithView:(UIView *)customView fillColor:(UIColor *)inColor size:(CGSize)inSize
{
    CHDraggableView *view = [[CHDraggableView alloc] initWithFrame:CGRectMake(0, 0, inSize.width, inSize.height)];
    
    customView.frame = view.bounds;
    customView.backgroundColor = [UIColor clearColor];
    
    CHAvatarView *avatarView = [[CHAvatarView alloc] initWithFrame:view.bounds];
    avatarView.backgroundColor = [UIColor clearColor];
    [avatarView setFillColor:inColor];
    
    if (inColor)
    {
        avatarView.useEvenOddFill = NO;
    }
    
    avatarView.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    
    [avatarView addSubview:customView];
    [view addSubview:avatarView];
    
    return view;
}

@end