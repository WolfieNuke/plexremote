//
//  DirectoryViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 20/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "DirectoryViewController.h"
#import "Key.h";
#import "NavTestAppDelegate.h";
#import "BaseCell.h";
#import "FileSystemData.h";
@implementation DirectoryViewController
- (void)setupView {
	[super setupView];
	cellIdentifier = @"DirectoryCellView";
	actionCellText = @"Queue All Items";
	hasImage = YES;
	rowHeight = 51;
}

- (void)doneLoad {
	[super doneLoad];
}
- (void)loadData {
	if (self.directoryPath.mask == DIRECTORY_MASK_MUSIC) {
		displayData = [[XBMCInterface GetMediaLocationForMusic:[self.directoryPath GetPath] ] retain];
	} else if (self.directoryPath.mask == DIRECTORY_MASK_VIDEO) {
		displayData = [[XBMCInterface GetMediaLocationForVideo:[self.directoryPath GetPath] ] retain];				
	} else {
		displayData = [[XBMCInterface GetMediaLocation:[self.directoryPath GetPath] mask: nil] retain];		
	}
	NSLog(@"Number of directories %d", [displayData count]);	
}


- (void)selectedDataCell:(FileSystemData*)data {
	DirectoryViewController *targetController = [[DirectoryViewController alloc] init];
	NSString* playList;
	NSString *maskStr;	
	if (self.directoryPath.mask == DIRECTORY_MASK_MUSIC) {
		playList = [NSString stringWithFormat: @"%d", PLAYLIST_MUSIC];
		maskStr = @"[music]";
	} else if (self.directoryPath.mask == DIRECTORY_MASK_VIDEO) {
		playList = [NSString stringWithFormat: @"%d", PLAYLIST_VIDEO];
		maskStr = @"[video]";
	}
	
	if (data == nil || data.file != nil || data.isRar) {
		[XBMCInterface stopPlaying];
		[XBMCInterface clearPlayList: playList ];
		[XBMCInterface setCurrentPlayList: playList ];
		
		if (data == nil) {
			NSArray *paths = [XBMCInterface SplitMultipart:[self.directoryPath GetPath]];
			int c = [paths count];
			for (int i = 0; i < c; i++) {
				[XBMCInterface addToPlayList: [paths objectAtIndex:i] playList: playList mask:maskStr recursive:@"1"];
			}
			[XBMCInterface SetPlaylistSong:0];
		// Work around due to bug in XBMC dealing with RAR's. http://xbmc.org/trac/ticket/4880
		} else if (data.isRar) {
			[XBMCInterface addToPlayList: data.path playList: playList mask:maskStr recursive:@"1"];
			[XBMCInterface SetPlaylistSong:0];
		} else if (data.file != nil) {
			[XBMCInterface addToPlayList: data.file playList: playList mask:maskStr recursive:@"1"];			
			[XBMCInterface playFile:data.file];
		}
		
		// Show now playing
		NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate showNowPlaying];

	} else {
		DirectoryPath *path = [[DirectoryPath alloc] init];
		path.mask = self.directoryPath.mask;
		PathItem *pathItem  = [[PathItem alloc] init];
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

- (UITableViewCell*)getDataCell:(UITableView *)_tableView data:(ViewData*)data{
	
	BaseCell *cell = (BaseCell*)[_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[BaseCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
		cell.imageWidth = rowHeight - 1;
		cell.imageHeight = rowHeight - 1;
		cell.maxImageSize = 320;
	}
	[cell setData:data showImage: hasImage subTitle: nil];
	return cell;	
}

 
- (void)dealloc {
	[super dealloc];
}
@end
