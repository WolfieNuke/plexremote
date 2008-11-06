//
//  ResizerView.h
//  xbmcremote
//
//  Created by David Fumberger on 6/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResizerViewDelegate;

@interface ResizerView : UIView {
	id delegate;
	CGPoint startPoint;
}
@property (nonatomic, retain) id delegate;
@end

// Protocol to be adopted by an object wishing to be resized
@protocol ResizerViewDelegate <NSObject>

@optional

- (void)resizeMovedX:(float)X Y:(float)Y;
- (void)resizeBegan;
- (void)resizeEnded;

@end