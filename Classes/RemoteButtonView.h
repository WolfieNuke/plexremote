//
//  RemoteButtonView.h
//  xbmcremote
//
//  Created by David Fumberger on 5/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RemoteButtonView : UIScrollView {
	IBOutlet UIPageControl *pageControl;
	NSInteger pages;
}
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@end
