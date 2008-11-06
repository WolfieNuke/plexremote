//
//  VideoSharesViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 20/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "PicturesViewController.h"
#import "DirectoryViewController.h";

@implementation PicturesViewController

- (void)setupView {
	[super setupView];
	cellIdentifier = @"PictureCellView";
	directoryMask = DIRECTORY_MASK_PICTURE;
	actionSections = 0;
	hasImage = YES;
}

- (void)loadData {
	displayData = [[XBMCInterface GetSharesForType:@"pictures"] retain];
	NSLog(@"Number of picture shares %d", [displayData count]);	
}

@end
