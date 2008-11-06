//
//  RoundedButton.h
//  xbmcremote
//
//  Created by David Fumberger on 6/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RoundedButton : UIButton {
	CGFloat rounding;
	CGFloat lineWidth;
	UIColor *lineColor;
	UIColor *fillColor;
}
@property (nonatomic, assign) CGFloat rounding;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, retain) UIColor *fillColor;
@end
