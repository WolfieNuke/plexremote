//
//  BookmarkViewController.h
//  xbmcremote
//
//  Created by David Fumberger on 4/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookmarkViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate> {
	NSArray  *tableData;
	NSString *baseIcon;
}
@property (nonatomic, retain) NSArray  *tableData;
@property (nonatomic, retain) NSString *baseIcon;
- (void)actionDone:(id)sender;
@end
