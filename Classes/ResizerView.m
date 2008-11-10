//
//  ResizerView.m
//  xbmcremote
//
//  Created by David Fumberger on 6/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "ResizerView.h"


@implementation ResizerView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
	}
	self.backgroundColor = [UIColor clearColor];
	self.userInteractionEnabled = YES;
	return self;
}


- (void)drawRect:(CGRect)rect {
	[[UIImage imageNamed:@"remote-resize.png"] drawInRect:rect];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *totalTouches = [touches setByAddingObjectsFromSet:[event touchesForView:self]];
	if ([totalTouches count] == 1) {
		[self.delegate resizeBegan];
		NSArray *allTouches = [touches allObjects];
		startPoint = [[allTouches objectAtIndex:0] locationInView: [self getSuperView]];
	}
}
- (UIView*)getSuperView {
	return [self superview];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([[event touchesForView:self] count] == 1) { 
		UITouch *currentTouch = [[touches allObjects] objectAtIndex:0];
		CGPoint currentPoint = [currentTouch locationInView:[self getSuperView]];
		
		CGPoint newTouchDistance = CGPointMake(currentPoint.x - startPoint.x , 
											   currentPoint.y - startPoint.y);
		[self.delegate resizeMovedX:  newTouchDistance.x Y: newTouchDistance.y];
	}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.delegate resizeEnded];
}


- (void)dealloc {
	[super dealloc];
}


@end
