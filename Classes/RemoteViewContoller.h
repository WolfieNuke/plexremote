//
//  RemoveViewContoller.h
//  xbmcremote
//
//  Created by David Fumberger on 17/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteMoreViewController.h";
#import "RemoteTouchView.h";
#import "GUIStatus.h";
#import "RemoteInterface.h";
#import "XBMCSettings.h";
#import "RemoteButtonViewController.h";
@interface RemoteViewContoller : UIViewController {
	RemoteButtonViewController *remoteButtonController;
	
	RemoteInterface *XBMCInterface;
	GUIStatus *guiStatus;
	NSInteger guiMode;
	IBOutlet UIViewController *moreViewController;
	IBOutlet UISlider *volumeSlider;
	IBOutlet UIImageView *pointer;
	NSTimer *timer;
	
	IBOutlet UIView *remoteGestureView;
	IBOutlet UIView *remoteButtonView;
	IBOutlet UIView *remoteButtonPagingView;	
	IBOutlet UIView *remoteContainerView;
	
	IBOutlet UIButton *addButton;
	
	BOOL refreshing;
	BOOL isFingerDown;
	
	XBMCSettings *xbmcSettings;
}	

- (IBAction)fingerDown:(id)sender;
- (IBAction)fingerUp:(id)sender;
- (IBAction)actionAddButton:(id)sender;
- (IBAction)actionEditMode:(id)sender;
- (IBAction)actionSwitchView:(id)sender;
- (IBAction)actionGui:(id)sender;
- (IBAction)actionMenu:(id)sender;
- (IBAction)actionChangeVolume:(id)sender;

- (IBAction)closeMenu:(id)sender;
@end
