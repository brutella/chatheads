//
//  AvatarView.h
//
//  Created by Matthias Hochgatterer on 21.11.12.
//  Copyright (c) 2012 Matthias Hochgatterer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHAvatarView : UIView

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIColor *fillColor;   // used if image is nil
@property (assign, nonatomic) BOOL useEvenOddFill;

@end
