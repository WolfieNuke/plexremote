//
//  RemoveViewContoller.m
//  xbmcremote
//
//  Created by David Fumberger on 17/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "RemoteViewContoller.h"
#import "InterfaceManager.h";
#import "Key.h";
#import "SettingsViewController.h";
#import "RemoteTouchView.h";
#import "Sleep.h";
#import "RemoteButtonData.h";

#define GUI_MODE_NAV    0
#define GUI_MODE_VIDEO  1
#define GUI_MODE_AUDIO  2
#define GESTURE_VIEW 0
#define BUTTON_VIEW 1
@implementation RemoteViewContoller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

- (void)viewDidLoad {
	XBMCInterface = [InterfaceManager getSharedInterface];
	xbmcSettings =  [XBMCSettings sharedInstance];
	
	remoteButtonController = [RemoteButtonViewController alloc];
	remoteButtonController.view = remoteButtonView;
	remoteButtonController.delegate = self;
	[remoteButtonController init];
	
	//remoteButtonView = remoteButtonController.view;
	//remoteButtonController.view = remoteButtonView;
	
	pointer.center = self.view.center;
	pointer.hidden = true;
	
	NSInteger selectedView = xbmcSettings.remoteType;
	if (selectedView == BUTTON_VIEW) {
		[remoteContainerView addSubview:remoteButtonController.view];
	} else if (selectedView == GESTURE_VIEW) {
		[remoteContainerView addSubview:remoteGestureView];
	}
	
}
- (IBAction)actionEditMode:(id)sender {
	[remoteButtonController toggleEditMode];
}
- (IBAction)actionSwitchView:(id)sender {
	[UIView beginAnimations: @"switchview" context: nil];
	[UIView setAnimationDuration:1];

	if ([remoteButtonController.view superview]) {
		[remoteButtonController.view removeFromSuperview];
		[remoteContainerView addSubview:remoteGestureView];
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView: remoteContainerView cache:YES];
		xbmcSettings.remoteType = GESTURE_VIEW;	
	} else {
		[remoteGestureView removeFromSuperview];
		[remoteContainerView addSubview:remoteButtonController.view];
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView: remoteContainerView cache:YES];		
		xbmcSettings.remoteType = BUTTON_VIEW;
	}
	[xbmcSettings saveSettings];
	[UIView commitAnimations];

}
- (void)viewDidAppear:(BOOL)animated {
	NSLog(@"Remote View Did Appear");
	NSDate *date = [NSDate date];
	timer = [[NSTimer alloc] initWithFireDate:date interval:1 target:self selector:@selector(refreshAll) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
- (void)viewDidDisappear:(BOOL)animated {
	NSLog(@"Removew View Did Disappear");	
	[self dismissModalViewControllerAnimated:YES];
	[timer invalidate];
	[timer release];
	timer = nil;
}

- (void)refreshVolume {
	NSInteger volume = [XBMCInterface GetVolume ];
	if (!isFingerDown) {
		[volumeSlider setValue: volume animated: YES] ;
	}
}
- (void)refreshAll {
	if (refreshing) {
		return;
	}
	refreshing = YES;
	[NSThread detachNewThreadSelector:@selector(_refreshAllThread) toTarget:self withObject:nil];	
}
- (void)_refreshAllThread {	
	NSAutoreleasePool   *autoreleasepool = [[NSAutoreleasePool alloc] init];	
	[self refreshVolume];
	[self refreshGUIStatus];
	refreshing = NO;
	[autoreleasepool release];		
}

- (void)refreshGUIStatus {
	if (guiStatus) {
		[guiStatus release];
		guiStatus = nil;
	}
	guiStatus = [[XBMCInterface GetGUIStatus] retain];
	guiMode = GUI_MODE_NAV;
	if ([guiStatus.activeWindowName isEqualToString:@"Fullscreen video"]) {
		guiMode = GUI_MODE_VIDEO;
	}
	if ([guiStatus.activeWindowName isEqualToString:@"Audio visualisation"]) {
		guiMode = GUI_MODE_AUDIO;
	}
	
}
- (IBAction)fingerDown:(id)sender {
	isFingerDown = YES;
}
- (IBAction)fingerUp:(id)sender {
	isFingerDown = NO;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
		return YES;
} 


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)controlMovedUp {
	if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface SendKey:ACTION_MOVE_UP];
	} else if (guiMode == GUI_MODE_VIDEO) {
		[XBMCInterface SendKey:ACTION_STEP_FORWARD];		
	} else if (guiMode == GUI_MODE_AUDIO) {
		[XBMCInterface SendKey:ACTION_VIS_PRESET_NEXT];
	}
}
- (void)controlMovedDown {
	if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface SendKey:ACTION_MOVE_DOWN];
	} else if (guiMode == GUI_MODE_VIDEO) {
		[XBMCInterface SendKey:ACTION_STEP_BACK];		
	} else if (guiMode == GUI_MODE_AUDIO) {
		[XBMCInterface SendKey:ACTION_VIS_PRESET_PREV];	
	}
}
- (void)controlMovedLeft {
	if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface SendKey:ACTION_MOVE_LEFT];
	} else if (guiMode == GUI_MODE_VIDEO || guiMode == GUI_MODE_AUDIO) {
		[XBMCInterface SendKey:ACTION_PLAYER_REWIND];		
	}	
}
- (void)controlMovedRight {
	if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface SendKey:ACTION_MOVE_RIGHT];
	} else if (guiMode == GUI_MODE_VIDEO || guiMode == GUI_MODE_AUDIO) {
		[XBMCInterface SendKey:ACTION_PLAYER_FORWARD];		
	}		
}
- (void)controlEnter {
	if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface SendKey:ACTION_SELECT_ITEM];
	} else if (guiMode == GUI_MODE_VIDEO || guiMode == GUI_MODE_AUDIO) {
		[XBMCInterface SendKey:ACTION_PAUSE];
	}	
}
- (void)controlBack {
	if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface SendKey:ACTION_PREVIOUS_MENU];		
	} else if (guiMode == GUI_MODE_VIDEO || guiMode == GUI_MODE_AUDIO) {
		[XBMCInterface SendKey:ACTION_STOP];
	}
}


- (void)controlSecondaryUp {
	if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface SendKey:ACTION_PAGE_UP];
	} else if (guiMode == GUI_MODE_VIDEO || guiMode == GUI_MODE_AUDIO) {
		[XBMCInterface SendKey:ACTION_BIG_STEP_FORWARD];		
	}
}
- (void)controlSecondaryDown {
	if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface SendKey:ACTION_PAGE_DOWN];
	} else if (guiMode == GUI_MODE_VIDEO || guiMode == GUI_MODE_AUDIO) {
		[XBMCInterface SendKey:ACTION_BIG_STEP_BACK];		
	}
}
- (void)controlSecondaryLeft {
	if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface SendKey:ACTION_PREVIOUS_MENU];		
	} else if (guiMode == GUI_MODE_VIDEO || guiMode == GUI_MODE_AUDIO) {
		[XBMCInterface playPrev];		
	}	
}
- (void)controlSecondaryRight {
	if (guiMode == GUI_MODE_NAV) {

	} else if (guiMode == GUI_MODE_VIDEO || guiMode == GUI_MODE_AUDIO) {
		[XBMCInterface playNext];		

	}		
}
- (void)controlSecondaryEnter {
	[XBMCInterface SendKey:ACTION_SHOW_GUI];
}

- (void)controlThirdEnter {
	[self presentModalViewController:moreViewController animated:YES];
}

- (void)controlSecondaryBack {
	[XBMCInterface SendKey:ACTION_PARENT_DIR];
}

- (void)actionButtonPress:(id)sender {
	RemoteButtonData *buttonData = sender;
	switch (buttonData.type) {
		case REMOTE_BUTTON_UP:
			[self controlMovedUp];
			break;
		case REMOTE_BUTTON_DOWN:
			[self controlMovedDown];
			break;
		case REMOTE_BUTTON_LEFT:
			[self controlMovedLeft];
			break;
		case REMOTE_BUTTON_RIGHT:
			[self controlMovedRight];
			break;
		case REMOTE_BUTTON_OK:
			[self controlEnter];
			break;
		case REMOTE_BUTTON_NEXT:
			[XBMCInterface playNext];
			break;
		case REMOTE_BUTTON_PREV:
			[XBMCInterface playPrev];
			break;
		case REMOTE_BUTTON_BACK:
			[self controlBack];
			break;
		case REMOTE_BUTTON_UP_DIR:
			[XBMCInterface SendKey:ACTION_PARENT_DIR];
			break;
		case REMOTE_BUTTON_PAUSE:
			[XBMCInterface pause];
			break;
		case REMOTE_BUTTON_PLAY:
			[XBMCInterface pause];
			break;
	}
}
- (IBAction)actionUp:(id)sender { 
	[self controlMovedUp];
}
- (IBAction)actionDown:(id)sender {
	[self controlMovedDown];
}
- (IBAction)actionLeft:(id)sender {
	[self controlMovedLeft];
}
- (IBAction)actionRight:(id)sender {
	[self controlMovedRight];
}
- (IBAction)actionEnter:(id)sender {
	[self controlEnter];
}
- (IBAction)actionBack:(id)sender {
	[self controlBack];
}
- (IBAction)actionBackSecond:(id)sender {
	[self controlSecondaryBack];
}
- (IBAction)actionPlay:(id)sender {
	//[XBMCInterface Action:ACTION_PLAYLI];	
}
- (IBAction)actionPause:(id)sender {
	[XBMCInterface pause];
	//[XBMCInterface SendKey:ACTION_PAUSE];
}
- (IBAction)actionNext:(id)sender {
	[XBMCInterface playNext];
}
- (IBAction)actionPrev:(id)sender {
	[XBMCInterface playPrev];
}
- (IBAction)actionStop:(id)sender {
	[XBMCInterface SendKey:ACTION_STOP];
}
- (IBAction)actionGui:(id)sender {
	[XBMCInterface SendKey:ACTION_SHOW_GUI];	
}
- (IBAction)actionMenu:(id)sender {
	[self presentModalViewController:moreViewController animated:YES];
	//[NSThread detachNewThreadSelector:@selector(showMenu) toTarget:self withObject:nil];
	//[XBMCInterface SendKey:ACTION_CONTEXT_MENU];	
}
- (IBAction)closeMenu:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}
- (IBAction)actionChangeVolume:(id)sender {	
	[XBMCInterface SetVolume: volumeSlider.value];
}
- (void)showMenu {
	//[XBMCInterface Action:ACTION_CONTEXT_MENU];
}
/*
- (void)controlStarted:(NSInteger)touchType initialSpeed:(NSInteger)initialSpeed location:(CGPoint)location {
	controlActive = YES;
	controlSpeed  = initialSpeed;
	controlType   = touchType; 
	[NSThread detachNewThreadSelector:@selector(controlThread) toTarget:self withObject:nil];
}
- (void)controlBefore:(CGPoint)location  {
	[self showPointer:location];
}
- (void)controlMoved:(CGPoint)location  {
	pointer.center = location;
}
- (void)growPointer:(CGPoint)location scale:(CGFloat)scalenew { 
	NSLog(@"new scale %f",scalenew);
	NSValue *touchPointValue = [NSValue valueWithCGPoint:location];
	[UIView beginAnimations:nil context:touchPointValue];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	CGAffineTransform transform = CGAffineTransformMakeScale(scalenew,scalenew);
	pointer.transform = transform;
	[UIView commitAnimations];	
}
- (void)controlEnded:(CGPoint)location  {
	if (controlSpeed == 0) {
		[XBMCInterface SendKey:ACTION_SELECT_ITEM];
	}
	controlActive = NO;
	controlSpeedChange = YES;
	controlSpeed = 0;
	lastControlSpeed = 0;
	[self hidePointer:location];
}
- (void)controlSpeedChange:(NSInteger)touchType speed:(NSInteger)speed location:(CGPoint)location  {
	controlSpeedChange = YES;
	controlSpeed  = speed;	
	if (controlSpeedChange) {
		NSInteger tmpcs = controlSpeed;
		if (tmpcs < 0) {
			tmpcs = tmpcs * -1;
		}
		CGFloat nscale = (tmpcs + 1) * .5;
		if (tmpcs <= 1) { nscale = 1; }
		[self growPointer:location scale: nscale];
	}	
}

- (void)showPointer:(CGPoint)location {
	pointer.hidden = false;
	pointer.alpha = 0;
	pointer.center = location;
	CGRect frame = CGRectMake(pointer.bounds.origin.x, pointer.bounds.origin.y , 150, 150);
	pointer.bounds = frame;
	NSValue *touchPointValue = [NSValue valueWithCGPoint:location];
	[UIView beginAnimations:nil context:touchPointValue];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	CGAffineTransform transform = CGAffineTransformMakeScale(1,1);
	pointer.transform = transform;
	pointer.alpha = 1;
	//CGRect newframe = CGRectMake(pointer.bounds.origin.x, pointer.bounds.origin.y , 30, 30);	
	//pointer.bounds = newframe;
	[UIView commitAnimations];
}

- (void)hidePointer:(CGPoint)location {
	
	pointer.alpha = 1;
	NSValue *touchPointValue = [NSValue valueWithCGPoint:location];
	[UIView beginAnimations:nil context:touchPointValue];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];
	CGAffineTransform transform = CGAffineTransformMakeScale(.5, .5);
	pointer.transform = transform;
	pointer.alpha = 0;
	[UIView commitAnimations];
}*/

- (void)dealloc {
	[xbmcSettings release];
	[guiStatus release];	
	[super dealloc];
}


@end
