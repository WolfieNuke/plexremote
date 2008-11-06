//
//  Path.h
//  xbmcremote
//
//  Created by David Fumberger on 4/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathItem.h";

@interface Path : NSObject {
	NSMutableArray *items;
}
@property (nonatomic, retain) NSMutableArray *items;
- (void)addItem:(PathItem*)item;
@end
