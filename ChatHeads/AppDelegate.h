//
//  AppDelegate.h
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CHDraggingCoordinator.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CHDraggingCoordinatorDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) CHDraggingCoordinator *draggingCoordinator;

@end
