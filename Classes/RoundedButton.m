//
//  RoundedButton.m
//  xbmcremote
//
//  Created by David Fumberger on 6/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "RoundedButton.h"


@implementation RoundedButton
@synthesize lineColor;
@synthesize fillColor;
@synthesize rounding;
@synthesize lineWidth;
- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
	}
	return self;
}

- (void) addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect ovalWidth:(float)ovalWidth ovalHeight:(float)ovalHeight {
	float fw, fh;
	// If the width or height of the corner oval is zero, then it reduces to a right angle,
	// so instead of a rounded rectangle we have an ordinary one.
	if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
	}
	
	//  Save the context's state so that the translate and scale can be undone with a call
	//  to CGContextRestoreGState.
	CGContextSaveGState(context);
	
	//  Translate the origin of the contex to the lower left corner of the rectangle.
	CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	
	//Normalize the scale of the context so that the width and height of the arcs are 1.0
	CGContextScaleCTM(context, ovalWidth, ovalHeight);
	
	// Calculate the width and height of the rectangle in the new coordinate system.
	fw = CGRectGetWidth(rect) / ovalWidth;
	fh = CGRectGetHeight(rect) / ovalHeight;
	
	// CGContextAddArcToPoint adds an arc of a circle to the context's path (creating the rounded
	// corners).  It also adds a line from the path's last point to the begining of the arc, making
	// the sides of the rectangle.
	CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
	CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
	
	// Close the path
	CGContextClosePath(context);
	
	// Restore the context's state. This removes the translation and scaling
	// but leaves the path, since the path is not part of the graphics state.
	CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect {
	// Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext() ;	
	
	CGContextSetLineWidth(context, lineWidth);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
	CGContextSetStrokeColorWithColor(context,  lineColor.CGColor);	
	CGContextSetFillColorWithColor(context, fillColor.CGColor);
	CGFloat margin = rounding;
	CGRect strokeRect = CGRectMake(rect.origin.x +margin, rect.origin.y + margin, rect.size.width - (margin * 2), rect.size.height - (margin * 2));
	// Signal the start of a path
	CGContextBeginPath(context);
	// Add a rounded rect to the path
	[self addRoundedRectToPath:context  rect:strokeRect ovalWidth: rounding ovalHeight:rounding];
	// Stroke the path
	CGContextStrokePath(context);
	
	CGContextBeginPath(context);
	// Add a rounded rect to the path
	[self addRoundedRectToPath:context  rect:strokeRect ovalWidth: rounding ovalHeight:rounding];
	// Stroke the path	
	CGContextFillPath(context);
}


- (void)dealloc {
	[lineColor release];
	[fillColor release];
	[super dealloc];
}


@end
