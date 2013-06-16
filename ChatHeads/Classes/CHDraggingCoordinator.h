//
//  CHDraggingCoordinator.h
//  ChatHeads
//
//  Created by Matthias Hochgatterer on 4/19/13.
//  Copyright (c) 2013 Matthias Hochgatterer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CHDraggableView.h"

typedef enum {
    CHSnappingEdgeBoth,
    CHSnappingEdgeRight,
    CHSnappingEdgeLeft
} CHSnappingEdge;

typedef enum {
    CHHidePresentedViewController,
    CHSnapBack
} CHDragReleaseAction;

@protocol CHDraggingCoordinatorDelegate;
@interface CHDraggingCoordinator : NSObject <CHDraggableViewDelegate>

@property (nonatomic) CHSnappingEdge snappingEdge;
@property (nonatomic, weak) id<CHDraggingCoordinatorDelegate> delegate;
@property (nonatomic, assign) CHDragReleaseAction releaseAction;

- (id)initWithWindow:(UIWindow *)window draggableViewBounds:(CGRect)bounds;

@end

@protocol CHDraggingCoordinatorDelegate <NSObject>

- (UIViewController *)draggingCoordinator:(CHDraggingCoordinator *)coordinator viewControllerForDraggableView:(CHDraggableView *)draggableView;

@end
