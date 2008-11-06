//
//  RemoteButtonData.m
//  xbmcremote
//
//  Created by David Fumberger on 5/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "RemoteButtonData.h"


@implementation RemoteButtonData
@synthesize frame;
@synthesize type;
- (id)initWithType:(NSInteger)_buttonType point:(CGPoint)_point {
	if (self = [self init]) {
		self.type  = _buttonType;
	}
	return self;
}

- (id)initWithType:(NSInteger)_buttonType  {
	if (self = [self init]) {
		self.type  = _buttonType;
	}
	return self;
}


- (void) encodeWithCoder: (NSCoder *)coder
{		
	[coder encodeFloat:  frame.origin.x		    forKey:@"x"];
	[coder encodeFloat:  frame.origin.y		    forKey:@"y"];	
	[coder encodeFloat:  frame.size.width		forKey:@"width"];
	[coder encodeFloat:  frame.size.height		forKey:@"height"];	
	[coder encodeInteger: self.type	forKey:@"type"];	
	
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super init]) {
		float x        = [coder decodeFloatForKey:@"x"];
		float y        = [coder decodeFloatForKey:@"y"];		
		float width    = [coder decodeFloatForKey:@"width"];
		float height   = [coder decodeFloatForKey:@"height"];		

		self.frame     = CGRectMake(x,y,width,height);
		self.type      = [coder decodeIntegerForKey:@"type"];				
	}
	return self;
}

@end
