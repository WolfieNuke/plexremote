//
//  BookmarkData.m
//  xbmcremote
//
//  Created by David Fumberger on 3/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "BookmarkData.h"


@implementation BookmarkData
@synthesize musicPath;
@synthesize videoPath;
@synthesize directoryPath;
@synthesize title;
@synthesize className;
@synthesize identifier;
@synthesize iconName;
- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject:  title		    forKey:@"title"];
	[coder encodeObject:  iconName		    forKey:@"iconName"];	
	[coder encodeObject:  musicPath	    forKey:@"musicPath"];	
	[coder encodeObject:  videoPath		forKey:@"videoPath"];	
	[coder encodeObject:  directoryPath		forKey:@"directoryPath"];		
	[coder encodeObject:  className     forKey:@"className"];
	[coder encodeInteger: identifier    forKey:@"identifier"];
	
}

- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super init]) {
		self.title		   = [coder decodeObjectForKey:@"title"];
		self.iconName     = [coder decodeObjectForKey:@"iconName"];				
		self.className     = [coder decodeObjectForKey:@"className"];		
		self.identifier    = [coder decodeIntegerForKey:@"identifier"];	
		self.musicPath    = [coder decodeObjectForKey:@"musicPath"];			
		self.videoPath    = [coder decodeObjectForKey:@"videoPath"];	
		self.directoryPath    = [coder decodeObjectForKey:@"directoryPath"];			

		//self.musicPath = [[coder decodeObjectForKey:@"WhereAmI_1"] retain];
	}
	return self;
}
@end
