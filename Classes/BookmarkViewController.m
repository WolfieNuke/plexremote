//
//  BookmarkViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 4/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "BookmarkViewController.h"
#import "BaseViewController.h";
#import "ArtistViewController.h";
#import "AlbumsViewController.h";
#import "MusicSharesViewController.h";
#import "VideoSharesViewController.h";
#import "PodcastViewController.h";
#import "GenresViewController.h";
#import "TVShowsViewController.h";
#import "MoviesViewController.h";
#import "BookmarkData.h";
#import "TabItemData.h";
#import "NavTestAppDelegate.h";
@interface BookmarkViewController(private)
- (void)setupTableData;
@end

@implementation BookmarkViewController
@synthesize tableData;
@synthesize baseIcon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}
- (UIBarButtonItem*)createDoneButton {
	UIBarButtonItem *returnButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
	return returnButton;
}

- (void)viewDidLoad {
	UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style: UITableViewStyleGrouped];
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview:tableView];
	self.navigationController.delegate = self;
	[self setupTableData];
}
 
- (void)setupTableData {
	NSArray *data = [NSArray arrayWithObjects:
						[NSDictionary dictionaryWithObjectsAndKeys:@"ArtistViewController",		 @"class", nil],
						[NSDictionary dictionaryWithObjectsAndKeys:@"AlbumsViewController",      @"class", nil],
						[NSDictionary dictionaryWithObjectsAndKeys:@"TVShowsViewController",     @"class", nil],						 
						[NSDictionary dictionaryWithObjectsAndKeys:@"MoviesViewController",      @"class", nil],						 		
						[NSDictionary dictionaryWithObjectsAndKeys:@"GenresViewController",      @"class", nil],						 					 
						[NSDictionary dictionaryWithObjectsAndKeys:@"MusicSharesViewController", @"class", nil],						 
						[NSDictionary dictionaryWithObjectsAndKeys:@"VideoSharesViewController", @"class", nil],	
						nil
					 ];
	self.tableData = data;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tableData count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"BookmarkCell";	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	NSDictionary *data = [self.tableData objectAtIndex:indexPath.row];
	cell.text = [BaseViewController titleForClass:[data objectForKey:@"class"]];
	cell.image = [UIImage imageNamed:[BaseViewController imageForClass:[data objectForKey:@"class"]]];
	cell.hidesAccessoryWhenEditing = NO;
	return cell;	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *data = [self.tableData objectAtIndex:indexPath.row];
	NSString *className = [data objectForKey:@"class"];
	BaseViewController *obj = [BaseViewController classForName:className];
	if (obj) {
		baseIcon  = [BaseViewController imageForClass:[data objectForKey:@"class"]];		
		obj.title = [BaseViewController titleForClass:[data objectForKey:@"class"]];
		obj.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;		
		[self.navigationController pushViewController:obj animated:YES];
	}
}
- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (![[viewController className] isEqualToString: @"BookmarkViewController"]) {
		viewController.navigationItem.rightBarButtonItem = [self createDoneButton];
	}
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)actionDone:(id)sender  {
	NSArray *viewControllers	   = [self.navigationController viewControllers];
	BaseViewController *controller = [viewControllers lastObject];
	XBMCSettings *settings	       = [XBMCSettings sharedInstance];
	
	BookmarkData *bookmarkData = [[BookmarkData alloc] init];
	bookmarkData.iconName	   = baseIcon;
	bookmarkData.title         = controller.title;
	bookmarkData.className     = [controller className];
	bookmarkData.musicPath     = controller.musicPath;
	bookmarkData.videoPath     = controller.videoPath;	
	bookmarkData.directoryPath = controller.directoryPath;		
	[settings addBookmark: bookmarkData];
	[bookmarkData release];
	
	TabItemData *tabItemData = [[TabItemData alloc] initWithClassName: [controller className] bookmark: bookmarkData];
	[settings addTabItem:tabItemData];
	[tabItemData release];
	
	[settings saveSettings];
	
	NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate setupTabs];
	
	[[self navigationController] popToRootViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}


@end
