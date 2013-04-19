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
    CHDraggableView *view = [[CHDraggableView alloc] initWithFrame:CGRectMake(0, 0, 66, 66)];
    
    CHAvatarView *avatarView = [[CHAvatarView alloc] initWithFrame:CGRectInset(view.bounds, 4, 4)];
    avatarView.backgroundColor = [UIColor clearColor];
    [avatarView setImage:image];
    avatarView.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
    [view addSubview:avatarView];
    
    return view;
}

@end
