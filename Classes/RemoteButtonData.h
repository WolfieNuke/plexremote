//
//  RemoteButtonData.h
//  xbmcremote
//
//  Created by David Fumberger on 5/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#define REMOTE_BUTTON_PLAY   0
#define REMOTE_BUTTON_PAUSE  1
#define REMOTE_BUTTON_OK     2
#define REMOTE_BUTTON_NEXT   3
#define REMOTE_BUTTON_PREV   4
#define REMOTE_BUTTON_LEFT   5
#define REMOTE_BUTTON_RIGHT  6
#define REMOTE_BUTTON_UP     7
#define REMOTE_BUTTON_DOWN   8
#define REMOTE_BUTTON_BACK   9
#define REMOTE_BUTTON_UP_DIR 10
#define REMOTE_BUTTON_GUI    11
#define REMOTE_BUTTON_STOP   12
#define REMOTE_BUTTON_FF     13
#define REMOTE_BUTTON_RR	 14
@interface RemoteButtonData : NSObject {
	NSInteger type;
	CGRect    frame;
}
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) CGRect    frame;
- (id)initWithType:(NSInteger)_buttonType;
- (id)initWithType:(NSInteger)_buttonType point:(CGPoint)_point;
@end
