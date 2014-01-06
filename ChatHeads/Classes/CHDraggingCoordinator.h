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
    CHAlignTopLeft,
    CHAlignTopRight,
    CHAlignBottomLeft,
    CHAlignBottomRight
} CHAlignment;

@protocol CHDraggingCoordinatorDelegate;
@interface CHDraggingCoordinator : NSObject <CHDraggableViewDelegate>

@property (nonatomic) CHSnappingEdge snappingEdge;
@property (nonatomic) CHAlignment alignment;
@property (nonatomic, weak) id<CHDraggingCoordinatorDelegate> delegate;

- (id)initWithWindow:(UIWindow *)window draggableViewBounds:(CGRect)bounds;
- (void) dismissPresentedViewController;

@end

@protocol CHDraggingCoordinatorDelegate <NSObject>

- (UIViewController *)draggingCoordinator:(CHDraggingCoordinator *)coordinator viewControllerForDraggableView:(CHDraggableView *)draggableView;

@end
