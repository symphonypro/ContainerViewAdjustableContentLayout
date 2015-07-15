
/* ContainerViewWithDraggableContentLayout.h
 
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

#import <UIKit/UIKit.h>
#import "UIViewEventHandlingState.h"

//lbl: View Debugging Class

/* If your UIView layout is done programmatically, this class will overcome difficulties in view debugging and layout inefficiencies.
 * Subclass your container views for layout debugging and flexible adjustability of subview layout during runtime.
 * • Subclassing will disable normal interaction with subviews, so is for on-the-fly debugging only.
 * • If subclassing doesn't work, use this view as a wrapper around the content instead (composition pattern).
 * • See also -interactibleSubviews, -tooltipStringForViewBeingDragged:
 */

@interface ContainerViewWithDraggableContentLayout : UIView{
    EventHandlingState _eventHandlingStateForViewTouchedDown;
    UIView* _viewTouchedDown;
    UIView* _highlightOverlay;
}

-(NSArray*)interactibleSubviews; //Override to modify which subviews will be scanned; default returns <self.subviews> (i.e. all views that are a direct subview of this container). Each element need not be a direct subview of this container, but must be at least indirect.
-(NSString*)tooltipStringForViewBeingDragged:(UIView*)v; //Override to modify the tooltip that appears above <v> while it's being dragged. Default returns class name with displacement

@end
