//
//  RemoveViewContoller.m
//  xbmcremote
//
//  Created by David Fumberger on 17/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "RemoteViewContoller.h"
#import "RemoteAddButtonViewController.h";
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
	remoteButtonController.view = remoteButtonPagingView;
	remoteButtonController.delegate = self;
	[remoteButtonController init];
	
	//remoteButtonView = remoteButtonController.view;
	//remoteButtonController.view = remoteButtonView;
	
	pointer.center = self.view.center;
	pointer.hidden = true;
	
	NSInteger selectedView = xbmcSettings.remoteType;
	if (selectedView == BUTTON_VIEW) {
		[remoteContainerView addSubview:remoteButtonView];
	} else if (selectedView == GESTURE_VIEW) {
		[remoteContainerView addSubview:remoteGestureView];
	}
	
}
- (IBAction)actionAddButton:(id)sender {
	RemoteAddButtonViewController *controller = [[RemoteAddButtonViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[self presentModalViewController:controller animated:YES];
	controller.delegate = self;
	[controller release];
}
- (IBAction)actionEditMode:(id)sender {
	[remoteButtonController toggleEditMode];
	if (remoteButtonController.editMode) {
		[self showAddButton];
	} else {
		[self hideAddButton];
	}
}
- (void)actionAddedButton:(NSInteger)type {
	RemoteButtonData *buttonData = [[RemoteButtonData alloc] init];
	buttonData.type = type;
	CGRect frame = [remoteButtonController defaultFrameForButtonType: type];
	CGFloat xOffset = [remoteButtonController.view contentOffset].x;
	buttonData.frame = CGRectMake(xOffset + (remoteButtonController.view.frame.size.width / 2 - frame.size.width / 2),
								  remoteButtonController.view.frame.size.height / 2 - frame.size.height / 2 ,
								  frame.size.width,
								  frame.size.height);
 	[remoteButtonController addButton: buttonData];
	[buttonData release];
}
- (void)showAddButton {
	addButton.userInteractionEnabled = YES;
	addButton.hidden = NO;
	addButton.alpha = 0;
	[UIView beginAnimations: @"fade" context: nil];
	[UIView setAnimationDuration:0.5];
	addButton.alpha = 1;
	[UIView commitAnimations];
}

- (void)hideAddButton {
	addButton.userInteractionEnabled = NO;	
	addButton.alpha = 1;
	[UIView beginAnimations: @"fade" context: nil];
	[UIView setAnimationDuration:0.5];
	addButton.alpha = 0;
	[UIView commitAnimations];	
}

- (IBAction)actionSwitchView:(id)sender {
	[UIView beginAnimations: @"switchview" context: nil];
	[UIView setAnimationDuration:1];

	if ([remoteButtonView superview]) {
		[remoteButtonView removeFromSuperview];
		[remoteContainerView addSubview:remoteGestureView];
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView: remoteContainerView cache:YES];
		xbmcSettings.remoteType = GESTURE_VIEW;	
	} else {
		[remoteGestureView removeFromSuperview];
		[remoteContainerView addSubview:remoteButtonView];
		[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView: remoteContainerView cache:YES];		
		xbmcSettings.remoteType = BUTTON_VIEW;
	}
	[xbmcSettings saveSettings];
	[UIView commitAnimations];

}
- (void)viewDidAppear:(BOOL)animated {
	NSDate *date = [NSDate date];
	timer = [[NSTimer alloc] initWithFireDate:date interval:1 target:self selector:@selector(refreshAll) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
- (void)viewDidDisappear:(BOOL)animated {
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
	//if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface up];
	//} else if (guiMode == GUI_MODE_VIDEO) {
	//	[XBMCInterface Action:ACTION_STEP_FORWARD];		
	//} else if (guiMode == GUI_MODE_AUDIO) {
	//	[XBMCInterface Action:ACTION_VIS_PRESET_NEXT];
	//}
}
- (void)controlMovedDown {
	//if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface down];
	//} else if (guiMode == GUI_MODE_VIDEO) {
	//	[XBMCInterface Action:ACTION_STEP_BACK];		
	//} else if (guiMode == GUI_MODE_AUDIO) {
	//	[XBMCInterface Action:ACTION_VIS_PRESET_PREV];	
	//}
}
- (void)controlMovedLeft {
	//if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface left];
	//} else if (guiMode == GUI_MODE_VIDEO || guiMode == GUI_MODE_AUDIO) {
	//	[XBMCInterface Action:ACTION_PLAYER_REWIND];		
	//}	
}
- (void)controlMovedRight {
	//if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface right];
	//} else if (guiMode == GUI_MODE_VIDEO || guiMode == GUI_MODE_AUDIO) {
	//	[XBMCInterface Action:ACTION_PLAYER_FORWARD];		
	//}		
}
- (void)controlEnter {
	//if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface enter];
	//} else if (guiMode == GUI_MODE_VIDEO || guiMode == GUI_MODE_AUDIO) {
	//	[XBMCInterface Action:ACTION_PAUSE];
	//}	
}
- (void)controlBack {
	//if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface back];		
	//} else if (guiMode == GUI_MODE_VIDEO || guiMode == GUI_MODE_AUDIO) {
	//	[XBMCInterface Action:ACTION_STOP];
	//}
}


- (void)controlSecondaryUp {
	if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface Action:ACTION_PAGE_UP];
	} else if (guiMode == GUI_MODE_VIDEO || guiMode == GUI_MODE_AUDIO) {
		[XBMCInterface Action:ACTION_BIG_STEP_FORWARD];		
	}
}
- (void)controlSecondaryDown {
	if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface Action:ACTION_PAGE_DOWN];
	} else if (guiMode == GUI_MODE_VIDEO || guiMode == GUI_MODE_AUDIO) {
		[XBMCInterface Action:ACTION_BIG_STEP_BACK];		
	}
}
- (void)controlSecondaryLeft {
	if (guiMode == GUI_MODE_NAV) {
		[XBMCInterface Action:ACTION_PREVIOUS_MENU];		
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
	[XBMCInterface Action:ACTION_SHOW_GUI];
}

- (void)controlThirdEnter {
	[self presentModalViewController:moreViewController animated:YES];
}

- (void)controlSecondaryBack {
	[XBMCInterface Action:ACTION_PARENT_DIR];
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
			[XBMCInterface Action:ACTION_PARENT_DIR];
			break;
		case REMOTE_BUTTON_PAUSE:
			[XBMCInterface pause];
			break;
		case REMOTE_BUTTON_PLAY:
			[XBMCInterface pause];
			break;
		case REMOTE_BUTTON_STOP:
			[XBMCInterface Action:ACTION_STOP];
			break;
		case REMOTE_BUTTON_GUI:
			[XBMCInterface Action:ACTION_SHOW_GUI];
			break;
		case REMOTE_BUTTON_SHOW_INFO:
			[XBMCInterface Action:ACTION_SHOW_INFO];
			break;
		case REMOTE_BUTTON_ASPECT_RATIO:
			[XBMCInterface Action:ACTION_ASPECT_RATIO];
			break;
		case REMOTE_BUTTON_STEP_FORWARD:
			[XBMCInterface Action:ACTION_STEP_FORWARD];
			break;
		case REMOTE_BUTTON_STEP_BACK:
			[XBMCInterface Action:ACTION_STEP_BACK];
			break;
		case REMOTE_BUTTON_SHOW_OSD:
			[XBMCInterface osd];
			break;
		case REMOTE_BUTTON_SHOW_SUBTITLES:
			[XBMCInterface Action:ACTION_SHOW_SUBTITLES];
			break;
		case REMOTE_BUTTON_NEXT_SUBTITLE:
			[XBMCInterface Action:ACTION_NEXT_SUBTITLE];
			break;
		case REMOTE_BUTTON_SHOW_CODEC:
			[XBMCInterface Action:ACTION_SHOW_CODEC];
			break;
		case REMOTE_BUTTON_NEXT_PICTURE:
			[XBMCInterface Action:ACTION_NEXT_PICTURE];
			break;
		case REMOTE_BUTTON_PREV_PICTURE:
			[XBMCInterface Action:ACTION_PREV_PICTURE];
			break;
		case REMOTE_BUTTON_ZOOM_OUT:
			[XBMCInterface Action:ACTION_ZOOM_OUT];
			break;
		case REMOTE_BUTTON_ZOOM_IN:
			[XBMCInterface Action:ACTION_ZOOM_IN];
			break;
		case REMOTE_BUTTON_ZOOM_NORMAL:
			[XBMCInterface Action:ACTION_ZOOM_LEVEL_NORMAL];
			break;
		case REMOTE_BUTTON_QUEUE_ITEM:
			[XBMCInterface Action:ACTION_QUEUE_ITEM];
			break;
		case REMOTE_BUTTON_SHOW_PLAYLIST:
			[XBMCInterface Action:ACTION_SHOW_PLAYLIST];
			break;
		case REMOTE_BUTTON_ROTATE_PICTURE:
			[XBMCInterface Action:ACTION_ROTATE_PICTURE];
			break;
		case REMOTE_BUTTON_BIG_STEP_BACK:
			[XBMCInterface Action:ACTION_BIG_STEP_BACK];
			break;
		case REMOTE_BUTTON_BIG_STEP_FORWARD:
			[XBMCInterface Action:ACTION_BIG_STEP_FORWARD];
			break;
		case REMOTE_BUTTON_SHUTDOWN:
			[XBMCInterface Shutdown];
			break;
		case REMOTE_BUTTON_RESTART:
			[XBMCInterface Restart];
			break;
		case REMOTE_BUTTON_CONTEXT_MENU:
			[XBMCInterface Action:ACTION_CONTEXT_MENU];
			break;
		case REMOTE_BUTTON_NEXT_VIS:
			[XBMCInterface Action:ACTION_VIS_PRESET_NEXT];
			break;
		case REMOTE_BUTTON_PREV_VIS:
			[XBMCInterface Action:ACTION_VIS_PRESET_PREV];
			break;
		case REMOTE_BUTTON_MUTE:
			[XBMCInterface Action:ACTION_MUTE];
			break;
		case REMOTE_BUTTON_VOLUME_UP:
			[XBMCInterface Action:ACTION_VOLUME_UP];
			break;
		case REMOTE_BUTTON_VOLUME_DOWN:
			[XBMCInterface Action:ACTION_VOLUME_DOWN];
			break;			
		case REMOTE_BUTTON_SCREENSHOT:
			[XBMCInterface Action:ACTION_TAKE_SCREENSHOT];
			break;
		case REMOTE_BUTTON_CHANGE_RESOLUTION:
			[XBMCInterface Action:ACTION_CHANGE_RESOLUTION];
			break;
	}
}
- (IBAction)actionMenu:(id)sender {
	[self presentModalViewController:moreViewController animated:YES];
	//[NSThread detachNewThreadSelector:@selector(showMenu) toTarget:self withObject:nil];
	//[XBMCInterface Action:ACTION_CONTEXT_MENU];	
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
		[XBMCInterface Action:ACTION_SELECT_ITEM];
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
