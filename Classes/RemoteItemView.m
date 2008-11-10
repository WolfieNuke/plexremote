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
- (void)frameResize:(CGRect)frame;
- (void)refreshResize;
- (void)setInactive;
- (void)setActive;
- (CGPoint)snapToGrid:(CGPoint)location;
- (CGSize)snapToGridSize:(CGSize)size;
@end

@implementation RemoteItemView
@synthesize resizerView;
@synthesize button;
@synthesize buttonData;
@synthesize delegate;
@synthesize removeButton;

- (void)setButtonData:(RemoteButtonData*)_buttonData {
	buttonData = [_buttonData retain];
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
	
	
	UIButton *rb = [[UIButton alloc] initWithFrame:CGRectMake(-10,-10,35,35)];
	[self addSubview:rb];
	[rb setBackgroundImage:[UIImage imageNamed:@"remove.png"] forState:UIControlStateNormal];
	self.removeButton = rb;
	[rb addTarget:self action:@selector(actionRemove) forControlEvents:UIControlEventTouchUpInside];
	[rb release];
	
	[self frameResize: self.frame];
}
- (void)actionRemove {
	[self setInactive];
	[self removeFromSuperview];
}
- (void)setInactive {
	[self.removeButton removeFromSuperview];
	[self.resizerView  removeFromSuperview];
	self.resizerView  = nil;
	self.removeButton = nil;
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
		
		CGPoint origin = [self snapToGrid:self.frame.origin];
		self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
	}
}
- (CGPoint)snapToGrid:(CGPoint)location {
	int y = location.y;
	int x = location.x;
	while(remainder(y, 5) != 0) { y++; }
	while(remainder(x, 5) != 0) { x++; }	
	return CGPointMake(x,y);;
}
- (CGSize)snapToGridSize:(CGSize)size {
	int width = size.width;
	int height = size.height;
	while(remainder(width, 10) != 0) { width++; }
	while(remainder(height, 10) != 0) { height++; }	
	return CGSizeMake(width,height);;
}
- (void)frameResizeByX:(NSInteger)X Y:(NSInteger)Y {
	[self resize: CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width + X, self.frame.size.height + Y)];
}
- (void)frameResize:(CGRect)frame {
	CGSize size = [self snapToGridSize: frame.size];
	
	CGFloat width =   size.width;
	CGFloat height =  size.height;
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

	[UIView beginAnimations:@"alpha" context:nil];
	[UIView setAnimationDuration:0.25];
	button.alpha = 0.75;
	[UIView commitAnimations];

	[self setActive];
}
- (void)endEditing {
	button.userInteractionEnabled = YES;

	[UIView beginAnimations:@"fade" context:nil];
	[UIView setAnimationDuration:0.25];
	button.alpha = 1;
	[UIView commitAnimations];
	
	editing = NO;
	[self setInactive];
}
@end
