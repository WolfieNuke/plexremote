//
//  RemoteButtonView.m
//  xbmcremote
//
//  Created by David Fumberger on 5/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "RemoteItemView.h"
#import "ResizerView.h";

#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
@interface RemoteItemView (private)
- (void)resize:(CGRect)frame;
@end

@implementation RemoteItemView
@synthesize resizerView;
@synthesize button;
@synthesize buttonData;
@synthesize delegate;
- (void)setButtonData:(RemoteButtonData*)_buttonData {
	buttonData = _buttonData;
	[self frameResize: self.frame];
	//self.transform = CGAffineTransformMakeScale(_buttonData.scale.x, _buttonData.scale.y);
}
- (void)setActive {
	ResizerView *rv = [[ResizerView alloc] initWithFrame:CGRectMake(0,0,20,20)];
	[self.superview addSubview:rv];
	[self.superview bringSubviewToFront:self];
	self.resizerView = rv;
	rv.delegate = self;
	[rv release];
	
	[self frameResize: self.frame];
}
- (void)setInactive {
	[resizerView removeFromSuperview];
	self.resizerView = nil;
}
- (void)setButton:(UIView*)_button {
	pinching = NO;
	button = [_button retain];
	button.contentMode = UIViewContentModeScaleToFill;
	//button.bounds = self.bounds;
	[self frameResize: self.frame];
	[self addSubview:button];
}

- (void)resizeBegan {
	startResizeFrame = self.frame;
}
- (void)resizeMovedX:(float)X Y:(float)Y {
	CGRect newFrame = CGRectMake(startResizeFrame.origin.x, 
								 startResizeFrame.origin.y, 
								 startResizeFrame.size.width  + X, 
								 startResizeFrame.size.height + Y);
	[self frameResize: newFrame];
}
- (void)resizeEnded {
	NSLog(@"Frame X %f Y %f Width %f Height %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
	[button setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!editing) { return; }
	[[self superview] bringSubviewToFront:self.resizerView];
	[[self superview] bringSubviewToFront:self];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!editing) { return; }
	UITouch *touch       = [touches anyObject];
	CGPoint location     = [touch locationInView:[self superview]];
	if ([[event touchesForView:self] count] == 1) { 
		self.center = location;
		self.buttonData.frame = self.frame;		
		[self refreshResize];
	}
}
- (void)frameResizeByX:(NSInteger)X Y:(NSInteger)Y {
	[self resize: CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width + X, self.frame.size.height + Y)];
}
- (void)frameResize:(CGRect)frame {
	CGFloat width =   frame.size.width;
	CGFloat height =  frame.size.height;
	CGFloat x      =  frame.origin.x;
	CGFloat y      =  frame.origin.y;
	self.button.frame = CGRectMake(0,0,width, height);
	self.frame = CGRectMake(x, y, width,height);
	self.buttonData.frame = frame;
	[self refreshResize];
}
- (void)refreshResize {
	if (!self.resizerView) { return; }
	CGFloat resizeOffset = 5;	
	self.resizerView.center = CGPointMake(self.frame.origin.x + self.frame.size.width + resizeOffset, self.frame.origin.y + self.frame.size.height + resizeOffset);	
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableSet *remainingTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [remainingTouches minusSet:touches];
	if ([remainingTouches count] < 2) {
		NSLog(@"Touches finished");
	}
		
}
- (void)startEditing {
	editing = YES;
	button.userInteractionEnabled = NO;
	//button.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(1));	
	//[UIView beginAnimations:@"edit" context:nil];
	//[UIView setAnimationDuration:0.2];
	//[UIView setAnimationRepeatCount:10000];
	//[UIView setAnimationRepeatAutoreverses:YES];
	//button.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-1));
	//[UIView commitAnimations];
	[self setActive];
}
- (void)endEditing {
	NSLog(@"End editing");
	button.userInteractionEnabled = YES;
	[button.layer removeAllAnimations];
	button.transform = CGAffineTransformMakeRotation(0);	
	editing = NO;
	[self setInactive];
}
@end
