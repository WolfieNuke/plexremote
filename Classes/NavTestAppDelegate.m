//
//  NavTestAppDelegate.m
//  NavTest
//
//  Created by David Fumberger on 30/07/08.
//  Copyright collect3 2008. All rights reserved.
//

#import "NavTestAppDelegate.h"
#import "BaseViewController.h";
#import "NowPlayingViewController.h";
#import "XBMCHTTP.h";
#import "BoxeeHTTP.h";
#import "NowPlayingData.h";
#import "SettingsViewController.h";
#import "XBMCSettings.h";
#import "XBMCHostData.h";
#import "Crc32.h";
#import "Cache.h";
#import "Utility.h";
#import "InterfaceManager.h";
#import "TabItemData.h";
#import "ViewsNavigationController.h";

@interface NavTestAppDelegate (private)
- (ViewsNavigationController*)createOrGetTabBarItem:(TabItemData*)itemData;
- (ViewsNavigationController*)createTabBarItem:(TabItemData*)itemData;
- (void)setupInterface;
@end

@implementation NavTestAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize npViewController;

- (id)init {
	if (self = [super init]) {
		
	}
	return self;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	[self setupInterface];
	tabBarController.moreNavigationController.delegate = self;
	navigationController.navigationBarHidden = true;
	[self setupTabs];
	[window addSubview:[mainViewController view]];
	[window addSubview:[mainNavigationController view]];
	[window makeKeyAndVisible];
	tabBarController.delegate = self;		

	// Setup the cache for storing thumbnails
	Cache *cache = [Cache defaultCache];
	[cache setupDirectories];
}

// Sets the default interface for interacting with the server.
- (void)setupInterface {
	XBMCHTTP *defaultInterface = [[XBMCHTTP alloc] init];
	InterfaceManager *im = [InterfaceManager sharedInstance];
	im.interface = defaultInterface;
	[defaultInterface release];	
}


// Tab bar methods
// Classes to show in the tab bar will come from the settings. This stores the class as well as any path information to reinstantiate it.
- (void)setupTabs {
	NSLog(@"Setting up tabs");
	XBMCSettings *settings = [XBMCSettings sharedInstance];

	int count = [settings.tabList count];	
	NSMutableArray *controllers = [NSMutableArray array];
	for (int i = 0; i < count; i++) {
		TabItemData *tabItemData = [settings.tabList objectAtIndex:i];
		ViewsNavigationController *navController = [self createOrGetTabBarItem:tabItemData];
		[controllers addObject:navController];			
	}
	NSLog(@"Tab count %i", [controllers count]);
	tabBarController.viewControllers = controllers;
}
- (ViewsNavigationController*)createOrGetTabBarItem:(TabItemData*)itemData {
	int count = [tabBarController.viewControllers count];
	while(count--) {
		ViewsNavigationController *obj = [tabBarController.viewControllers objectAtIndex:count];
		if (obj.tabItemData == itemData) {
			NSLog(@"TabBar: Getting");
			return obj;
		}
	}
	NSLog(@"TabBar: Creating");	
	return [self createTabBarItem: itemData];
}
- (void)addTabBarItem:(TabItemData*)itemData{
	ViewsNavigationController *navController = [self createTabBarItem:itemData];	
	tabBarController.viewControllers = [tabBarController.viewControllers arrayByAddingObject: navController];
}

- (ViewsNavigationController*)createTabBarItem:(TabItemData*)itemData {
	NSLog(@"Class name %@", itemData.className);
	BaseViewController *obj = [BaseViewController classForName:itemData.className];
	NSString *title;
	NSString *icon;
	if (itemData.bookmarkData) {
		title = itemData.bookmarkData.title;
		icon  = itemData.bookmarkData.iconName;
		obj.directoryPath = itemData.bookmarkData.directoryPath;
		obj.musicPath = itemData.bookmarkData.musicPath;
		obj.videoPath = itemData.bookmarkData.videoPath;	
	} else {
		icon  = [BaseViewController imageForClass: itemData.className];
		title = [BaseViewController titleForClass: itemData.className];
	}
	ViewsNavigationController *navController = [[ViewsNavigationController alloc] initWithRootViewController: obj];
	navController.delegate = self;
	UITabBarItem *tabItem = [[UITabBarItem alloc] init];
	obj.title = title;
	tabItem.title = title;
	tabItem.image = [UIImage imageNamed:icon];
	navController.tabBarItem = tabItem;	
	navController.tabItemData = itemData;
	return navController;
}


- (IBAction)showNowPlayingAction:(id)sender {
	//[self showRemote];
	[self showNowPlaying];
}
- (void)showRemote {
	
	[mainViewController.view addSubview: remoteController.view];
	remoteController.view.frame = CGRectMake(0, 0, remoteController.view.frame.size.width, remoteController.view.frame.size.height);
	[window bringSubviewToFront:mainViewController.view]; 

	[remoteController viewDidAppear:YES];
	remoteController.view.alpha = 0;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	remoteController.view.alpha = 1;
	[UIView commitAnimations];		
}
- (void)hideRemote {
	if (remoteController.view.alpha == 0) {
		return;
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];	
	[UIView setAnimationDidStopSelector:@selector(remoteIsHidden)];	
	[UIView setAnimationDuration:1];	
	remoteController.view.alpha = 0;
	[UIView commitAnimations];		
	[remoteController viewDidDisappear:YES];	
		
}
- (void)remoteIsHidden {
	[window sendSubviewToBack:mainViewController.view];
	[remoteController.view removeFromSuperview];
}
- (void)hideNowPlaying {
	[navigationController popViewControllerAnimated:YES];
}
- (void)showSettings {
	//settingsNavigationController.navigationController =  navigationController;
	[navigationController presentModalViewController: settingsNavigationController animated:YES];	
}
- (IBAction)showSettingsAction:(id)sender {
	[self showSettings];
}
- (void)resetAllNavigationControllers {
	NSArray *items = tabBarController.viewControllers;
	for (int i = 0; i < [items count]; i++) {
		UINavigationController *titem = [items objectAtIndex:i];
		if (titem == tabBarController.selectedViewController) {
			continue;
		}
		[titem popToRootViewControllerAnimated:NO];
	}
	[tabBarController.moreNavigationController popToRootViewControllerAnimated:NO];	
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	[self resetAllNavigationControllers];
}
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
	XBMCSettings *settings = [XBMCSettings sharedInstance];
	NSMutableArray *tabList = [NSMutableArray array];
	for (ViewsNavigationController *vc in viewControllers) {
		[tabList addObject:vc.tabItemData];
	}
	settings.tabList = tabList;
	[settings saveSettings];
}

- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (!animated) {
		viewController.navigationItem.leftBarButtonItem = settingsButton;
	}
	if (viewController.navigationItem.rightBarButtonItem == nil) {
		viewController.navigationItem.rightBarButtonItem = nowPlayingButton;
	}
	NSLog(@"Will show");
}
- (void)navigationController:(UINavigationController *)navController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

	//navController.rightBarButtonItem = settingsButton;
}

- (void)showNowPlaying {
	if (npViewController == nil) {
		npViewController = [[NowPlayingViewController alloc] initWithNibName:@"NowPlayingView" bundle:nil ];
	}
	[navigationController pushViewController:npViewController animated:YES];
}
- (void)reloadAllViews {
	NSLog(@"Reloading views");
	NSArray *items = [tabBarController viewControllers];
	for (ViewsNavigationController *vc in items) {
		BaseViewController *bc = [[vc viewControllers] objectAtIndex:0];
		bc.reloadData = YES;
	}
}
- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}
- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
}




- (void)dealloc {
	[npViewController release];
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
