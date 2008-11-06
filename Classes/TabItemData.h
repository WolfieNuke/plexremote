//
//  TabItemData.h
//  xbmcremote
//
//  Created by David Fumberger on 4/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkData.h";

@interface TabItemData : NSObject {
	NSString *className;
	BookmarkData *bookmarkData;
}
@property (nonatomic, retain) NSString *className;
@property (nonatomic, retain) BookmarkData *bookmarkData;
- (id)initWithClassName:(NSString*)_className;
- (id)initWithClassName:(NSString*)_className bookmark:(BookmarkData*)_bookmarkData;
@end
