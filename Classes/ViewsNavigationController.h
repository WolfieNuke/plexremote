//
//  ViewsNavigationController.h
//  xbmcremote
//
//  Created by David Fumberger on 17/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabItemData.h";

@interface ViewsNavigationController : UINavigationController {
	IBOutlet UIBarButtonItem *settingsButton;
	TabItemData *tabItemData;
}
@property (nonatomic, retain) TabItemData *tabItemData;
@end
