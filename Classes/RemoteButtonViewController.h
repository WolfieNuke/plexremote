//
//  RemoteButtonViewController.h
//  xbmcremote
//
//  Created by David Fumberger on 5/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteButtonView.h";
#import "RemoteButtonData.h";

@interface RemoteButtonViewController : UIViewController {
	BOOL editMode;
	id delegate;
	RemoteButtonView *view;
	NSTimer *repeatTimer;
	BOOL buttonPressing;
}
@property (nonatomic, assign) id delegate;
- (void)toggleEditMode;
- (void)setEditMode:(BOOL)_editMode;
- (void)addButton:(RemoteButtonData*)buttonData;
- (CGRect)defaultFrameForButtonType:(NSInteger)type;
@property (nonatomic, assign) BOOL editMode;
@property (nonatomic, retain) RemoteButtonView *view;
@end
