//
//  RemoteButtonViewController.h
//  xbmcremote
//
//  Created by David Fumberger on 5/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RemoteButtonViewController : UIViewController {
	BOOL editMode;
	id delegate;
}
@property (nonatomic, assign) id delegate;
- (void)toggleEditMode;
- (void)setEditMode:(BOOL)_editMode;
@end
