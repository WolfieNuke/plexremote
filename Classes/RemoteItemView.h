//
//  RemoteButtonView.h
//  xbmcremote
//
//  Created by David Fumberger on 5/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteButtonData.h";
#import "ResizerView.h";

@interface RemoteItemView : UIView <ResizerViewDelegate> {
	UIView *resizerView;
	
	UIView *button;
	UITouch *firstTouch;
	CGRect startResizeFrame;
	CGPoint lastScale;
	BOOL pinching;
	CGPoint startTouchDistance; 
	float startingTouchDistance;
	RemoteButtonData *buttonData;
	id delegate;
	BOOL editing;
}
@property (nonatomic, retain) UIView *button;
@property (nonatomic, retain) UIView *resizerView;
@property (nonatomic, retain) RemoteButtonData *buttonData;
@property (nonatomic, retain) id delegate;
- (void)startEditing;
@end
