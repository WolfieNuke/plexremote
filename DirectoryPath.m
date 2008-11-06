//
//  DirectoryPath.m
//  xbmcremote
//
//  Created by David Fumberger on 4/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "DirectoryPath.h"
#import "PathItem.h";

@implementation DirectoryPath
@synthesize mask;
- (NSString*)GetPath {
	PathItem *pathItem = [items lastObject];
	return (pathItem == nil) ? (@"") : (pathItem.value);
}	
- (void) encodeWithCoder: (NSCoder *)coder {
	[super encodeWithCoder:coder];
	[coder encodeInteger:  mask		    forKey:@"mask"];
}
- (id)initWithCoder:(NSCoder *)coder {
	[super initWithCoder:coder];
	self.mask		   = [coder decodeIntegerForKey:@"mask"];
	return self;
}
@end
