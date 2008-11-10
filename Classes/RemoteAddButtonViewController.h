//
//  RemoteAddButtonViewController.h
//  xbmcremote
//
//  Created by David Fumberger on 8/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RemoteAddButtonViewController : UITableViewController {
	NSArray *tableData;
	id delegate;
}
@property (nonatomic, retain) NSArray *tableData;
@property (nonatomic, assign) id delegate;
@end
