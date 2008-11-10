//
//  RemoteButtonView.m
//  xbmcremote
//
//  Created by David Fumberger on 5/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "RemoteButtonView.h"


@implementation RemoteButtonView
@synthesize pageControl;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Initialization code
	}
	return self;
}
- (void)setPageControl:(UIPageControl*)_pageControl {
	if (pageControl) { [pageControl release]; }
	pageControl = [_pageControl retain];
	pageControl.numberOfPages = 4;
	[pageControl addTarget:self action:@selector(actionPageControlChanged:) forControlEvents: UIControlEventValueChanged];
}
- (id)init {
	NSLog(@"Init RemoteButton View");
	pages = 4;
	int width = 320 * pages;
	self.contentSize = CGSizeMake(width, 0);
	self.showsVerticalScrollIndicator = NO;
	self.showsHorizontalScrollIndicator = NO;
	self.pagingEnabled = YES;
	self.delegate = self;
	return self;;
}
- (void)actionPageControlChanged:(UIPageControl*)sender {
	int newx = sender.currentPage * 320;
	[self setContentOffset: CGPointMake(newx, 0) animated: YES];
}
- (void)awakeFromNib {
	[self init];
}
/*- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	if ([touch tapCount] == 2) {
		
	}
}*/

- (void)drawRect:(CGRect)rect {
	// Drawing code
}

#pragma mark delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat x = scrollView.contentOffset.x;
	if ( remainder(x, 320) == 0) {
		self.pageControl.currentPage = x / 320;
	}
}


- (void)dealloc {
	[super dealloc];
}


@end
