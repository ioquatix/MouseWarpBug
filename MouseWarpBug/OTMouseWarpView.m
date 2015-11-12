//
//  OTMouseWarpView.m
//  MouseWarpBug
//
//  Created by Samuel Williams on 25/05/12.
//  Copyright (c) 2012 Orion Transfer Ltd. All rights reserved.
//

#import "OTMouseWarpView.h"

@implementation OTMouseWarpView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)viewDidMoveToWindow {
	[self.window setAcceptsMouseMovedEvents:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (void) warpCursorToCenter {
	// Warp the mouse cursor to the center of the view.
	NSRect bounds = self.bounds;
	NSPoint view_center = NSMakePoint(bounds.origin.x + bounds.size.width / 2.0, bounds.origin.y + bounds.size.height / 2.0);
	NSPoint window_center = [self convertPoint:view_center toView:nil];
	
	NSRect window_center_rect = {window_center, {0, 0}};
	NSRect screen_offset_rect = [self.window convertRectToScreen:window_center_rect];
	NSPoint screen_offset = screen_offset_rect.origin;
	//NSLog(@"Screen offset: %@", NSStringFromPoint(screen_offset));
	
	NSScreen * screen = self.window.screen;
	//NSLog(@"Screen frame: %@", NSStringFromRect(screen.frame));
	
	CGFloat top = screen.frame.origin.y + screen.frame.size.height;
	CGPoint new_cursor_position = CGPointMake(screen_offset.x, top - screen_offset.y);
	NSLog(@"Cursor position: %@", NSStringFromPoint((NSPoint){new_cursor_position.x, new_cursor_position.y}));
	
	// Even thought at this point the mouse and mouse cursor position has been disassociated, this function can cause an large deltaX and deltaY:
	CGWarpMouseCursorPosition(new_cursor_position);
}

- (void) mouseMoved:(NSEvent *)theEvent {
	NSPoint delta = {theEvent.deltaX, theEvent.deltaY};
	
	NSLog(@"Position: %@, Moved: %@", NSStringFromPoint(theEvent.locationInWindow), NSStringFromPoint(delta));
}

- (void)mouseDown:(NSEvent *)theEvent {
	//CGDisplayHideCursor(kCGNullDirectDisplay);
	
	// This will cause a large delta in the mouseMoved function, and yet the mouse cursor has not been moved that much, except by this function (programatically).
	CGAssociateMouseAndMouseCursorPosition(false);
	
	// Warp mouse to center of view
	[self warpCursorToCenter];
}

- (void)keyDown:(NSEvent *)theEvent {
	if (theEvent.keyCode == 13) {
		//CGDisplayShowCursor(kCGNullDirectDisplay);
		CGAssociateMouseAndMouseCursorPosition(true);
	}
}

@end
