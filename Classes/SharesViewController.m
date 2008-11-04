//
//  SharesViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 21/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "SharesViewController.h"
#import "DirectoryViewController.h";
#import "DirectoryPath.h";

@implementation SharesViewController

-(void)doneLoad {
	[super doneLoad];
	actionSections = 0;
	rowHeight = 51;	
}

- (void)selectedDataCell:(ViewData*)data {
	DirectoryViewController *targetController = [[DirectoryViewController alloc] init];
	if (data == nil) {
		// Queue all
	} else {
		DirectoryPath *path = [[DirectoryPath alloc] init];
		path.mask = directoryMask;
		PathItem *pathItem = [[PathItem alloc] init];
		pathItem.value = data.path;
		[path addItem:pathItem];
		
		targetController.directoryPath = path;
		targetController.title = data.title;
		[[self navigationController] pushViewController: targetController animated: YES];
		[targetController release];
		
		[path release];
		[pathItem release];
	}
}

@end
