//
//  UIViewEventHandlingState.h
//  Symphony_ipad
//
//  Created by Phil Lee on 6/18/15.
//
//

#ifndef Symphony_ipad_UIViewEventHandlingState_h
#define Symphony_ipad_UIViewEventHandlingState_h

//Event handling state to be encapsulated by a custom UIView that performs simple user interaction such as dragging, touch inside, touch+hold
typedef struct EventHandlingState{
    
    CGRect touchedDownFrame; //Frame of the encapsulating view on touchesBegan(); reset to CGRectZero;
    CGPoint touchedDownPoint; //-touchesBegan: Location in encapsulating view or its superview at which user touched down; if the view can be dragged, must assign using superview coordinates; reset to CGPointZero;
    BOOL touchesMoved; //Usually if current touch location is > 3 points in screen distance from <touchedDownPoint> (use DIST_BETWEEN_CGPOINTS); reset to NO;
    
    
}EventHandlingState;

//To be invoked during initialization of encapsulating view, and at end of every touchesEnded() or touchesCancelled() call
#define EventHandlingStateReset(s) \
    s.touchedDownFrame = CGRectZero; \
    s.touchedDownPoint = CGPointZero; \
    s.touchesMoved = NO;

#define EventHandlingStateTouchEventOccurring(e) (!CGPointEqualToPoint(e.touchedDownPoint,CGPointZero))

#endif
