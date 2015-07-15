
/* ContainerViewWithDraggableContentLayout.m
 
 The MIT License (MIT)
 Copyright (c) 2015 Symphony Pro / Xenon Labs
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */


#import "ContainerViewWithDraggableContentLayout.h"

//lbl: View Debugging Class

@implementation ContainerViewWithDraggableContentLayout

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return self;
}

//Overrideable
-(NSArray*)interactibleSubviews{
    NSMutableArray* a = [NSMutableArray arrayWithCapacity:self.subviews.count];
    for(UIView* v in self.subviews){
        if(v.userInteractionEnabled){
            [a addObject:v];
        }
    }
    return a;
}

-(UIView*)_viewForPt:(CGPoint)p withEvent:(UIEvent*)e{
    for(UIView* v in [self interactibleSubviews]){
        if([v pointInside:[v convertPoint:p fromView:self] withEvent:e]){
            return v;
        }
    }
    return nil;
}

//Overrideable
-(NSString*)tooltipStringForViewBeingDragged:(UIView*)v{
    return [NSString stringWithFormat:@"%@ Δx:%.2f Δy:%.2f",[[v class]description],
            (v.frame.origin.x-_eventHandlingStateForViewTouchedDown.touchedDownFrame.origin.x),
              (v.frame.origin.y-_eventHandlingStateForViewTouchedDown.touchedDownFrame.origin.y)];
}

-(void)_showMenuController{
    
    if(_viewTouchedDown && EventHandlingStateTouchEventOccurring(_eventHandlingStateForViewTouchedDown)){
        [[UIMenuController sharedMenuController]setMenuItems:@[[[UIMenuItem alloc]initWithTitle:[self tooltipStringForViewBeingDragged:_viewTouchedDown] action:nil]]];
        [[UIMenuController sharedMenuController]setTargetRect:_viewTouchedDown.frame inView:self];
        
        if(![UIMenuController sharedMenuController].isMenuVisible)
            [[UIMenuController sharedMenuController]setMenuVisible:YES];
        
        [[UIMenuController sharedMenuController]update];
        [self becomeFirstResponder];

    }
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(action == nil){
        return YES;
    }
    return NO;
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _viewTouchedDown = [self _viewForPt:[[touches anyObject]locationInView:self] withEvent:event];
    if(_viewTouchedDown){
        _eventHandlingStateForViewTouchedDown.touchedDownPoint = [[touches anyObject]locationInView:self];
        _eventHandlingStateForViewTouchedDown.touchedDownFrame = _viewTouchedDown.frame;
        [self _showMenuController];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint p = [[touches anyObject]locationInView:self];
    if(_viewTouchedDown != nil){
        if(_highlightOverlay == nil){
            _highlightOverlay = [[UIView alloc]initWithFrame:_viewTouchedDown.frame];
            _highlightOverlay.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:0.2];
        }
        
        _viewTouchedDown.frame = CGRectMake(
                                            _eventHandlingStateForViewTouchedDown.touchedDownFrame.origin.x + (p.x - _eventHandlingStateForViewTouchedDown.touchedDownPoint.x),
                                            _eventHandlingStateForViewTouchedDown.touchedDownFrame.origin.y + (p.y - _eventHandlingStateForViewTouchedDown.touchedDownPoint.y),
                                            _eventHandlingStateForViewTouchedDown.touchedDownFrame.size.width,
                                            _eventHandlingStateForViewTouchedDown.touchedDownFrame.size.height);
        _highlightOverlay.frame = _viewTouchedDown.frame;
        [self insertSubview:_highlightOverlay aboveSubview:_viewTouchedDown];
        [self _showMenuController];
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(_viewTouchedDown)
        printf("New Frame for view: %f %f %f %f | Center = %f %f\n",_viewTouchedDown.frame.origin.x,_viewTouchedDown.frame.origin.y,_viewTouchedDown.frame.size.width,_viewTouchedDown.frame.size.height,_viewTouchedDown.center.x,_viewTouchedDown.center.y);
    
    EventHandlingStateReset(_eventHandlingStateForViewTouchedDown);
    _viewTouchedDown = nil;
    [_highlightOverlay removeFromSuperview];
    
    [[UIMenuController sharedMenuController]setMenuVisible:NO animated:YES];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesEnded:touches withEvent:event];
}

@end
