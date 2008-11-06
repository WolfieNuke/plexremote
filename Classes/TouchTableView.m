//
//  TouchResponder.m
//  xbmcremote
//
//  Created by David Fumberger on 20/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "TouchTableView.h"
#import "BaseViewController.h";

@implementation TouchTableView
//@synthesize controller;

- (float)distanceBetweenTouches:(NSSet *)touches {
	NSArray *allTouches = [touches allObjects];
	CGPoint point1 = [[allTouches objectAtIndex:0] locationInView:[self superview]];
	CGPoint point2 = [[allTouches objectAtIndex:1] locationInView:[self superview]];
	return (sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y)));
}

- (CGPoint)distanceBetweenTouchesXY:(NSSet *)touches {	
	NSArray *allTouches = [touches allObjects];
	CGPoint point1 = [[allTouches objectAtIndex:0] locationInView:[self superview]];
	CGPoint point2 = [[allTouches objectAtIndex:1] locationInView:[self superview]];
	return CGPointMake(	(sqrt((point1.x - point2.x) * (point1.x - point2.x))),
					   (sqrt((point1.y - point2.y) * (point1.y - point2.y))) );
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *totalTouches = [touches setByAddingObjectsFromSet:[event touchesForView:self]];
	if ([totalTouches count] > 1) {
		startTouchDistance = [self distanceBetweenTouches:totalTouches];
	} else {
		[super touchesBegan:touches withEvent:event];
	}
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	//if (!editing) { return; }
	UITouch *touch       = [touches anyObject];
	CGPoint location     = [touch locationInView:[self superview]];
	
	if ([[event touchesForView:self] count] == 1) { 
		[super touchesMoved:touches withEvent:event];
	} else {
		pinching = YES;		
		float newTouchDistance = [self distanceBetweenTouches:[event touchesForView:self]];
		float scale = (newTouchDistance / startTouchDistance) ;
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableSet *remainingTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [remainingTouches minusSet:touches];
	if ([remainingTouches count] < 2) {
		if (pinching) { }
	}
	
}

- (void)dealloc {
	NSLog(@"TouchTableView - dealloc");
	[super dealloc];
}
@end
