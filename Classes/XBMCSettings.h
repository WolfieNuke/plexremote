//
//  XBMCSettings.h
//  NavTest
//
//  Created by David Fumberger on 5/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBMCHostData.h";
#import "BookmarkData.h";
#import "TabItemData.h";

@interface XBMCSettings : NSObject {
	NSInteger bookmarkIDSeq;
	NSUserDefaults *defaults;
	BOOL showImages;
	NSInteger remoteType;
	BOOL sync;
	NSArray *tabList;
	NSArray *bookmarkList;
}
@property (nonatomic, assign) BOOL showImages;
@property (nonatomic, assign) BOOL sync;
@property (nonatomic, assign) NSInteger remoteType;
@property (nonatomic, assign) NSInteger bookmarkIDSeq;
@property (nonatomic, retain) NSArray   *tabList;
@property (nonatomic, retain) NSArray   *bookmarkList;
+ (XBMCSettings*)sharedInstance;
- (void)saveSettings;
- (void)addHost:(XBMCHostData*)hostData;
- (void)updateHost:(XBMCHostData*)hostData;
- (void)removeHost:(XBMCHostData*)hostData;
- (NSArray*)getHosts;
- (void)setActive:(XBMCHostData*)hostData ;
- (XBMCHostData*)getActiveHost;
- (NSInteger)getActiveId;
- (void)resetAllSettings;
- (BOOL)hasActiveHost;
- (void)addBookmark:(BookmarkData*)bookmarkData;
- (void)addTabItem:(TabItemData*)tabItemData;
- (void)removeBookmark:(BookmarkData*)bookmarkData;
- (void)removeTabItem:(TabItemData*)tabItemData;
@end
