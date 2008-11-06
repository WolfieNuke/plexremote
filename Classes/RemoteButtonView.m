//
//  RemoteButtonView.m
//  xbmcremote
//
//  Created by David Fumberger on 5/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "RemoteButtonView.h"


@implementation RemoteButtonView


- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
	}
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"Touches began");
}

- (void)drawRect:(CGRect)rect {
	// Drawing code
}


- (void)dealloc {
	[super dealloc];
}


@end
