//
//  PathItem.m
//  xbmcremote
//
//  Created by David Fumberger on 13/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "PathItem.h"


@implementation PathItem
@synthesize type;
@synthesize value;
- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeInteger: type		    forKey:@"type"];
	[coder encodeObject:  value		    forKey:@"value"];	
}
- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super init]) {
		self.type		   = [coder decodeIntegerForKey:@"type"];
		self.value		   = [coder decodeObjectForKey:@"value"];		
	}
	return self;
}
-(void)dealloc {
	[value release];
	[super dealloc];
}
@end
