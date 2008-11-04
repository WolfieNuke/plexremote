//
//  SettingsViewController.m
//
//  Created by David Fumberger on 10/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsEditViewController.h";
#import "XBMCHostData.h";
#import "NavTestAppDelegate.h";
#import "DisplayCell.h";
#import "BookmarkData.h";
#import "BookmarkViewController.h";

#define HOSTS_SECTION           0
#define PERFORMANCE_SECTION     1
#define BOOKMARKS_SECTION       2
@implementation SettingsViewController

- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.delegate = self;	
}
- (void)viewDidAppear:(BOOL)animated {
    [self setupDisplayList];
	[[self tableView] reloadData];
}

- (NSString*)getActiveHash {
	XBMCHostData *active = [xbmcSettings getActiveHost];
	NSString *data = nil;
	if (active != nil) {	
		data = [active dataHash];
	} else {
		data = @"";
	}
	NSLog(@"Hash %@", data);
	return data;	
}

- (void)actionDone {	
	NSString *currentHash = [self getActiveHash];
	if (activeHash == nil || currentHash == nil || ![currentHash isEqualToString:activeHash]) {
		NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate reloadAllViews];	
		activeHash = [currentHash retain];
	}
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}
- (UIBarButtonItem*)createDoneButton {
	UIBarButtonItem *returnButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone)] autorelease];
	return returnButton;
}
- (UIBarButtonItem*)createEditButton {
	UIBarButtonItem *returnButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEdit)] autorelease];
	return returnButton;
}

- (UISwitch*)create_UISwitch
{
	CGRect frame = CGRectMake(0.0, 0.0, 94.0, 27.0);
	UISwitch* switchCtl = [[[UISwitch alloc] initWithFrame:frame] autorelease];
	// in case the parent view draws with a custom color or gradient, use a transparent color
	switchCtl.backgroundColor = [UIColor clearColor];
	return switchCtl;
}

- (void)actionShowImagesSwitch:(id)sender {
	UISwitch *s = (UISwitch*)sender;
	[xbmcSettings setShowImages:s.on];
	[xbmcSettings saveSettings];
}
- (void)actionSyncSwitch:(id)sender {
	UISwitch *s = (UISwitch*)sender;
	[xbmcSettings setSync: s.on];
	[xbmcSettings saveSettings];
}

- (void)viewDidLoad {
	xbmcSettings = [XBMCSettings sharedInstance];
	activeHash = [[self getActiveHash] retain];
	doneButton = [[self createDoneButton] retain]; 
	[self setupDisplayList];
	[self tableView].allowsSelectionDuringEditing = YES; 
	UINavigationItem *navigationItem = [self navigationItem];
	navigationItem.hidesBackButton = false;
	navigationItem.rightBarButtonItem = self.editButtonItem;;		
	navigationItem.leftBarButtonItem = doneButton; 
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	if (editing) {
		[self navigationItem].leftBarButtonItem = nil;
	} else {
		[self navigationItem].leftBarButtonItem = doneButton;	
	}
	[super setEditing:editing animated:animated];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == HOSTS_SECTION) {
		return [tableData count]  + 1;
	} else if (section == PERFORMANCE_SECTION) {
		return 1;
	} else if (section == BOOKMARKS_SECTION) {
		return [bookmarkList count] + 1;
	}
	return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == HOSTS_SECTION) {
		return @"XBMC Hosts";
	} else if (section == PERFORMANCE_SECTION) {
		return @"Performance";
	} else if (section == BOOKMARKS_SECTION) {
		return @"Bookmarks";
	}
	return @"";
}

// decide what kind of accesory view (to the far right) we will use
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case HOSTS_SECTION: {
				if (self.editing || indexPath.row == [tableData count]) {
					return UITableViewCellAccessoryDisclosureIndicator;
				}
				if (tableData != nil && indexPath.row < [tableData count]) {
					XBMCHostData *hd = [tableData objectAtIndex: indexPath.row];
					if (hd.active) {
						return UITableViewCellAccessoryCheckmark;				
					}
				}
				break;
		}
		case BOOKMARKS_SECTION: {
				if (indexPath.row == [bookmarkList count]) {
					return UITableViewCellAccessoryDisclosureIndicator;
				}
				break;
		}

	}
	return UITableViewCellAccessoryNone;

}
- (void)setupDisplayList {
	tableData     = [[NSMutableArray arrayWithArray:[ xbmcSettings getHosts]] retain];
	bookmarkList  = [[NSArray arrayWithArray: xbmcSettings.bookmarkList] retain];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == HOSTS_SECTION || indexPath.section == BOOKMARKS_SECTION) {
		if (indexPath.section == HOSTS_SECTION) {
			[xbmcSettings removeHost: [tableData objectAtIndex: indexPath.row]];
		} else {
			BookmarkData *bookmarkData = [bookmarkList objectAtIndex: indexPath.row];
			int c = [xbmcSettings.tabList count];
			while(c--) {
				TabItemData *tabItemData = [xbmcSettings.tabList objectAtIndex:c];
				if (tabItemData.bookmarkData.identifier == bookmarkData.identifier) {
					[xbmcSettings removeTabItem:tabItemData];
				}
			}
			[xbmcSettings removeBookmark: bookmarkData];
			[xbmcSettings saveSettings];
			NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];
			[appDelegate setupTabs];
		}
		[self setupDisplayList];
		[[self tableView] reloadData];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section)
	{
		case HOSTS_SECTION:
		{
			static NSString *MyIdentifier = @"SettingCell";	
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
			}

			if (indexPath.row == [tableData count]) {
				cell.text = @"Add Host";
			} else {
				XBMCHostData *hostData = [tableData objectAtIndex:indexPath.row];				
				cell.text = hostData.title;
			}
			cell.hidesAccessoryWhenEditing = NO;
			return cell;	
			break;
		}
			
		case PERFORMANCE_SECTION:
		{
			UISwitch *switchCtl = [self create_UISwitch];
			static NSString *cellId = @"DisplayCell";	
			DisplayCell *cell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellId] autorelease];
			cell.nameLabel.text = @"Cover Images";
			cell.view = switchCtl;
			
			[switchCtl setOn:[xbmcSettings showImages]];
			[switchCtl addTarget:self action:@selector(actionShowImagesSwitch:) forControlEvents:UIControlEventValueChanged];
			[switchCtl release];

			return cell;
			break;
		}
			
		case BOOKMARKS_SECTION:
		{
			static NSString *MyIdentifier = @"SettingCell";	
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
			}

			if (indexPath.row == [bookmarkList count]) {
				cell.text = @"Add Bookmark";
			} else {
				BookmarkData *bookmarkData = [bookmarkList objectAtIndex:indexPath.row];
				cell.text = bookmarkData.title;
				cell.hidesAccessoryWhenEditing = NO;
			}
			return cell;	
			break;
		}		
	}

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == HOSTS_SECTION) {
		return (indexPath.row == [tableData count]) ? (NO) : (YES);
	} else if (indexPath.section == BOOKMARKS_SECTION) {
		return (indexPath.row == [bookmarkList count]) ? (NO) : (YES);
	} else {
		return NO;
	}
}


// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	if (indexPath.section == HOSTS_SECTION) {	
		if (self.editing || indexPath.row == [tableData count]) {

			SettingsEditViewController *targetController = [ [SettingsEditViewController alloc] initWithNibName:@"SettingsView" bundle:nil];

			targetController.xbmcSettings = xbmcSettings;
			if (indexPath.row == [tableData count]) {
				targetController.title = @"Add Host";
				targetController.hostData = [[[XBMCHostData alloc] init] autorelease];
			} else {
				XBMCHostData *hostData = [tableData objectAtIndex:indexPath.row];	
				targetController.title =  hostData.title;			
				targetController.hostData = hostData;
			}
			[[self navigationController] pushViewController:targetController animated:YES ];
			[targetController release ];				
		} else {
			if (indexPath.row < [tableData count]) {
				XBMCHostData *hostData = [tableData objectAtIndex:indexPath.row];					
				// Reset current hash as we always want to refresh when any items are clicked on
				activeHash = nil;
				[xbmcSettings  setActive:hostData];
				[self actionDone];	
			}
		}
	} else if (indexPath.section == BOOKMARKS_SECTION) {
		if (indexPath.row == [bookmarkList count]) {
			BookmarkViewController *targetController = [[BookmarkViewController alloc] init];
			targetController.title = @"Add Bookmark";
			[[self navigationController] pushViewController:targetController animated:YES ];
			[targetController release ];				
		}
	}
}


- (void)dealloc {
	[tableData release];
	[hostList release];
	[xbmcSettings release];
	[activeHash release];
	[doneButton release];	
	[super dealloc];
}
@end
	