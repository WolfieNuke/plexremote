//
//  XBMCSettings.m
//  NavTest
//
//  Created by David Fumberger on 5/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "XBMCSettings.h"
#import "TabItemData.h";

#define KEY_HOST_LIST   0
#define KEY_HOST_ACTIVE 1
#define KEY_ID_SEQ      2
#define KEY_SHOW_IMAGES 3
#define KEY_SYNC        4

// This is a singleton class, see below
static XBMCSettings *sharedSettingsDelegate = nil;

@implementation XBMCSettings

@synthesize showImages;
@synthesize sync;
@synthesize remoteType;
@synthesize tabList;
@synthesize bookmarkList;
@synthesize bookmarkIDSeq;

-(void)init {
	defaults = [NSUserDefaults standardUserDefaults];
	[self loadSettings];
	[super init];
}
- (void)setupDefaults {
	NSArray *hostList = [NSArray array];
	[defaults setObject: hostList forKey:@"XBMCHostList"];
	[defaults setBool:  YES		  forKey:@"XBMCShowImages"];
	[defaults setBool:  NO		  forKey:@"XBMCSync"];		
	[defaults setInteger:0		  forKey:@"XBMCRemoteType"];		
	[self setupTabListDefault];
}
- (void)setupTabListDefault {
	self.tabList = [NSArray arrayWithObjects:
			   [[TabItemData alloc] initWithClassName:@"ArtistViewController"],
			   [[TabItemData alloc] initWithClassName:@"TVShowsViewController"],			   
			   [[TabItemData alloc] initWithClassName:@"MoviesViewController"],			   			   
			   [[TabItemData alloc] initWithClassName:@"AlbumsViewController"],			   			   
			   [[TabItemData alloc] initWithClassName:@"GenresViewController"],			   			   
			   [[TabItemData alloc] initWithClassName:@"SongsViewController"],			   			   
			   [[TabItemData alloc] initWithClassName:@"PodcastViewController"],			   			   
			   [[TabItemData alloc] initWithClassName:@"VideoSharesViewController"],			   			   
			   [[TabItemData alloc] initWithClassName:@"MusicSharesViewController"],	
			   [[TabItemData alloc] initWithClassName:@"PlaylistViewController"],
			   [[TabItemData alloc] initWithClassName:@"PicturesViewController"],					
			   nil
			   ];
	//[defaults setObject:tabList forKey:@"XBMCTabList"];	
}
- (void)loadSettings {
	//[self resetAllSettings];
	[defaults removeObjectForKey:@"XBMCBookmarkList"];
	[defaults removeObjectForKey:@"XBMCTabList"];	
	NSMutableArray *hostList = [defaults objectForKey:@"XBMCHostList"];
	if (hostList == nil) {
		[self setupDefaults];
	}  
	
	NSData *tablistData = [defaults objectForKey:@"XBMCTabList"];
	if (tablistData) {
		self.tabList = [NSKeyedUnarchiver unarchiveObjectWithData:tablistData];
	} else {
		[self setupTabListDefault];
	}	
	
	NSData *bookmarkData = [defaults objectForKey:@"XBMCBookmarkList"];
	if (bookmarkData) {
		self.bookmarkList = [NSKeyedUnarchiver unarchiveObjectWithData:bookmarkData];
	} else {
		self.bookmarkList = [NSArray array];
	}
	
	self.bookmarkIDSeq = [defaults integerForKey:@"XBMCBookmarkIDSeq"];
	self.showImages = [defaults boolForKey: @"XBMCShowImages"];
	self.sync       = [defaults boolForKey: @"XBMCSync"];	
	self.remoteType = [defaults integerForKey:@"XBMCRemoteType"];	
	
	//NSLog(@"Tab list count %@", [[tabList objectAtIndex:1] objectForKey:@"id"]);
}
- (void)saveSettings {
	NSLog(@"Boomark count %i Tab list Count %i", [self.bookmarkList count], [self.tabList count]);
	NSData *bookmarkData = [NSKeyedArchiver archivedDataWithRootObject: self.bookmarkList];
	[defaults setObject:bookmarkData forKey:@"XBMCBookmarkList"];

	
	NSData *tablistData = [NSKeyedArchiver archivedDataWithRootObject: self.tabList];
	[defaults setObject:tablistData forKey:@"XBMCTabList"];
	
	[defaults setInteger:self.bookmarkIDSeq forKey:@"XBMCBookmarkIDSeq"];
	[defaults setBool: showImages forKey: @"XBMCShowImages"];
	[defaults setBool: sync forKey: @"XBMCSync"];	
	[defaults setInteger: remoteType forKey: @"XBMCRemoteType"];		
}
- (void)resetAllSettings {
	[defaults removeObjectForKey:@"XBMCTabList"];
	[defaults removeObjectForKey:@"XBMCHostList"];
	[defaults removeObjectForKey:@"XBMCHostActive"];
	[defaults removeObjectForKey:@"XBMCIDSeq"];
	[defaults removeObjectForKey:@"XBMCBookmarkIDSeq"];	
	[defaults removeObjectForKey:@"XBMCBookmarkList"];
}
- (void)removeBookmark:(BookmarkData*)bookmarkData {
	NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.bookmarkList];
	[tempArray removeObject:bookmarkData];
	self.bookmarkList = tempArray;
}
- (void)removeTabItem:(TabItemData*)tabItemData {
	NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.tabList];
	[tempArray removeObject:tabItemData];
	self.tabList = tempArray;
}
- (void)addBookmark:(BookmarkData*)bookmarkData {
	self.bookmarkIDSeq = self.bookmarkIDSeq + 1;
	bookmarkData.identifier = self.bookmarkIDSeq;
	self.bookmarkList = [self.bookmarkList arrayByAddingObject:bookmarkData];
}
- (void)addTabItem:(TabItemData*)tabItemData {
	NSArray *newTabList = [self.tabList arrayByAddingObject:tabItemData];
	self.tabList = newTabList;
}
- (void)addHost:(XBMCHostData*)hostData {
	NSMutableArray *hostList = [NSMutableArray arrayWithArray: [defaults objectForKey:@"XBMCHostList"]];
	NSInteger idseq          = [defaults integerForKey:@"XBMCIDSeq"];
	idseq++;
	[hostData setIdentifier: idseq];
	[hostList addObject: [hostData toArray]];	
	[defaults setInteger: idseq forKey:@"XBMCHostActive"];
	[defaults setInteger: idseq forKey:@"XBMCIDSeq"];
	[defaults setObject: hostList forKey:@"XBMCHostList"];	
}
- (void)setActive:(XBMCHostData*)hostData {
	[defaults setInteger: hostData.identifier forKey:@"XBMCHostActive"];
}
- (NSInteger)getActiveId  {
	NSInteger activeIdentifier = [defaults integerForKey:@"XBMCHostActive"];
	return activeIdentifier;
}
- (void)removeHost:(XBMCHostData*)hostData {
	NSArray *hostList = [defaults objectForKey:@"XBMCHostList"];
	NSMutableArray *newHostList = [NSMutableArray array]; 
	NSEnumerator *enumerator = [hostList objectEnumerator];
	
	NSArray *host;
	NSInteger activeIdentifier = [defaults integerForKey:@"XBMCHostActive"];
	NSInteger newActiveIdentifier;
	BOOL setNewActiveIdentifier = NO;
	while (host = [enumerator nextObject]) {
		XBMCHostData *currHostData = [[XBMCHostData alloc] initWithArray:host];	
		if ( currHostData.identifier != hostData.identifier) {
			newActiveIdentifier = currHostData.identifier;
			[newHostList addObject:[currHostData toArray]];
		} else {
			if (currHostData.identifier == activeIdentifier) {
				setNewActiveIdentifier = YES;
			}
		}
		[currHostData release];
	}

	if (setNewActiveIdentifier) {
		if (newActiveIdentifier) {
			[defaults setInteger:newActiveIdentifier forKey:@"XBMCHostActive"];
		} else {
			[defaults removeObjectForKey:@"XBMCHostActive"];
		}
	}
		
	[defaults setObject: newHostList forKey:@"XBMCHostList"];	
}
- (void)updateHost:(XBMCHostData*)hostData {
	NSArray *hostList = [defaults objectForKey:@"XBMCHostList"];
	NSMutableArray *newHostList = [NSMutableArray array]; 
	NSEnumerator *enumerator = [hostList objectEnumerator];
	
	NSArray *host;
	while (host = [enumerator nextObject]) {
		XBMCHostData *currHostData = [[XBMCHostData alloc] initWithArray:host];	
		if ( currHostData.identifier == hostData.identifier) {
			[newHostList addObject:[hostData toArray]];
		} else {
			[newHostList addObject:host];
		}
		[currHostData release];
	}
	
	[defaults setObject: newHostList forKey:@"XBMCHostList"];
}
- (NSArray*)getHosts {
	NSArray *hostList = [defaults objectForKey:@"XBMCHostList"];	
	NSInteger activeIdentifier = [defaults integerForKey:@"XBMCHostActive"];
	NSMutableArray *hostArray = [NSMutableArray array ];
	NSArray *host;
	int count = [hostList count];
	for (int i = 0; i < count; i++) {
		host = [hostList objectAtIndex:i];
		XBMCHostData *hostdata = [[XBMCHostData alloc] initWithArray: host];
		if ( hostdata.identifier == activeIdentifier){
			hostdata.active = YES;
		}
		[hostArray addObject: hostdata];
		[hostdata release];
	}
	return hostArray;
}
- (BOOL)hasActiveHost {
	NSInteger activeIdentifier = [defaults integerForKey:@"XBMCHostActive"];
	if (activeIdentifier) {	
		return YES;
	}	
	return NO;
}
- (XBMCHostData*)getActiveHost {
	NSInteger activeIdentifier = [defaults integerForKey:@"XBMCHostActive"];
	if (!activeIdentifier) {	
		return nil;
	}
	NSArray *hosts = [self getHosts];
	XBMCHostData *host;
	int count = [hosts count];
	while (count--) {
		host = [hosts objectAtIndex:count];
		if ( host.identifier == activeIdentifier ) {
			return host;
		}
	}
	
	return nil;	
}



#pragma mark ---- singleton object methods ----

+ (XBMCSettings*)sharedInstance {
    @synchronized(self) {
        if (sharedSettingsDelegate == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedSettingsDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedSettingsDelegate == nil) {
            sharedSettingsDelegate = [super allocWithZone:zone];
            return sharedSettingsDelegate;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end