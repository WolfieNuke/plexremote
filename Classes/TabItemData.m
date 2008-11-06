//
//  TabItemData.m
//  xbmcremote
//
//  Created by David Fumberger on 4/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "TabItemData.h"


@implementation TabItemData
@synthesize className;
@synthesize bookmarkData;
- (id)initWithClassName:(NSString*)_className bookmark:(BookmarkData*)_bookmarkData {
	if (self = [self init]) {
		self.className  = _className;
		self.bookmarkData = _bookmarkData;
	}
	return self;
}
- (id)initWithClassName:(NSString*)_className {
	if (self = [self init]) {
		self.className  = _className;
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:  className		    forKey:@"className"];
	[coder encodeObject:  bookmarkData      forKey:@"bookmarkData"];
	
}
- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super init]) {
		self.className       = [coder decodeObjectForKey:@"className"];		
		self.bookmarkData    = [coder decodeObjectForKey:@"bookmarkData"];	
	}
	return self;
}
@end
