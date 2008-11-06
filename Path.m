//
//  Path.m
//  xbmcremote
//
//  Created by David Fumberger on 4/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "Path.h"


@implementation Path
@synthesize items;
- (void)addItem:(PathItem*)pathItem {
	if ([self.items count] == 0) {
		self.items = [NSMutableArray arrayWithObjects:pathItem, nil];
	} else {
		[self.items addObject:pathItem];
	}
}	

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:  items		    forKey:@"items"];
}
- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super init]) {
		self.items		   = [coder decodeObjectForKey:@"items"];
	}
	return self;
}
-(void)dealloc {
	[items release];
	[super dealloc];
}
@end
