//
//  RemoteButtonViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 5/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "RemoteButtonViewController.h"
#import "XBMCSettings.h";
#import "RemoteButtonData.h";
#import "RemoteItemView.h";
#import "RoundedButton.h";

@interface RemoteButtonViewController  (private) 
- (CGRect)defaultFrameForButtonType:(NSInteger)type;
- (NSString*)imageForButtonType:(NSInteger)type;
- (void)addButton:(RemoteButtonData*)buttonData;
@end


@implementation RemoteButtonViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

- (id)init {
	NSLog(@"Init remote button view controller");
	XBMCSettings *settings = [XBMCSettings sharedInstance];
	self.view.multipleTouchEnabled = YES;
	self.view.userInteractionEnabled = YES;
	editMode = NO;
	for (RemoteButtonData *button in settings.remoteButtonList) {
		[self addButton:button];
	}
	return self;
}
- (void)toggleEditMode {
	[self setEditMode:!editMode];
}
- (void)setEditMode:(BOOL)_editMode {
	if (editMode == _editMode) { return; }
	editMode = _editMode;
	if (editMode) {
		[self startEditing];
	} else {
		[self endEditing];
	}
}

- (void)startEditing {
	for (RemoteItemView *view in [self.view subviews]) {
		if ([[view className] isEqualToString:@"RemoteItemView"]) {
			[view startEditing];
		}
	}
}
- (void)endEditing {
	NSMutableArray *buttonList = [NSMutableArray array];
	for (RemoteItemView *view in [self.view subviews]) {
		if ([[view className] isEqualToString:@"RemoteItemView"]) {
			[buttonList addObject: view.buttonData];
			[view endEditing];
		}
	}
	XBMCSettings *settings = [XBMCSettings sharedInstance];
	settings.remoteButtonList = buttonList; 
	[settings saveSettings];
}
- (void)actionButtonPress:(id)sender {
	RoundedButton *button = sender;
	RemoteItemView *remoteButton = [button superview];
	[self.delegate actionButtonPress: remoteButton.buttonData];
}
- (void)addButton:(RemoteButtonData*)buttonData {
	if (buttonData.frame.size.width == 0 && buttonData.frame.size.height == 0) {
		buttonData.frame = [self defaultFrameForButtonType: buttonData.type];
	} 
	
	NSDictionary *data = [self dataForButtonType:buttonData.type];
	RemoteItemView *remoteButton = [[RemoteItemView alloc] initWithFrame:buttonData.frame];
	remoteButton.userInteractionEnabled = YES;
	remoteButton.multipleTouchEnabled = YES;
	[remoteButton setButtonData: buttonData];
	
	RoundedButton *button = [[RoundedButton alloc] init];
	button.lineColor    = [UIColor colorWithRed: 31.0f / 255.0f green:31.0f / 255.0f blue:31.0f / 255.0f alpha:1];
	button.fillColor    = [UIColor colorWithRed: 63.0f / 255.0f green:63.0f / 255.0f blue:63.0f / 255.0f alpha:1];	
	button.rounding     = 10;
	button.lineWidth    = 5;
	[button addTarget:self action:@selector(actionButtonPress:) forControlEvents: UIControlEventTouchUpInside];
	if ([data objectForKey:@"icon"]) {
		UIImage *icon       = [UIImage imageNamed:[data objectForKey:@"icon"]];
		[button setImage:icon forState:UIControlStateNormal];
	}
		//UIImage *background = [UIImage imageNamed:[data objectForKey:@"background"]]; 
	NSString *text      = [data objectForKey:@"text"];
	//[button setBackgroundImage:background forState:UIControlStateNormal];

	[button setTitle:text forState:UIControlStateNormal];
	
	[remoteButton setButton: button];
	[self.view addSubview: remoteButton];
	[button release];
	[remoteButton release];
}
- (CGRect)defaultFrameForButtonType:(NSInteger)type {
	switch (type) {
		case REMOTE_BUTTON_UP:			
			return CGRectMake(77, 34, 160, 105);			
		case REMOTE_BUTTON_DOWN:			
			return CGRectMake(80, 257, 160, 105);			
		case REMOTE_BUTTON_LEFT:			
			return CGRectMake(-2.5, 122, 103, 153);			
		case REMOTE_BUTTON_RIGHT:			
			return CGRectMake(220, 122, 103, 153);			
		case REMOTE_BUTTON_BACK:
			return CGRectMake(-2.0f, 263, 94, 100);			
		case REMOTE_BUTTON_UP_DIR:
			return CGRectMake(-2.5, 361, 94, 57);			
		case REMOTE_BUTTON_PLAY:
			return CGRectMake(144, 364, 65, 65);
		case REMOTE_BUTTON_PAUSE:
			return CGRectMake(87, 364, 65, 65);
		case REMOTE_BUTTON_OK:
			return CGRectMake(90, 128, 141, 140);
		case REMOTE_BUTTON_NEXT:
			return CGRectMake(258, 364, 65, 65);
		case REMOTE_BUTTON_PREV:
			return CGRectMake(201, 364, 65, 65);

	}
	return CGRectMake(50,50,50,50);
}
- (NSString*)dataForButtonType:(NSInteger)type {
	switch (type) {
		case REMOTE_BUTTON_PLAY:
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-play.png", @"icon", nil];
		case REMOTE_BUTTON_PAUSE:
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-pause.png", @"icon",nil];
		case REMOTE_BUTTON_UP:
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-up.png", @"icon", nil];			
		case REMOTE_BUTTON_DOWN: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-down.png", @"icon", nil];	
		case REMOTE_BUTTON_LEFT:
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-left.png", @"icon", nil];	
		case REMOTE_BUTTON_RIGHT: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-right.png", @"icon", nil];	
		case REMOTE_BUTTON_OK: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-ok.png", @"icon", nil];	
		case REMOTE_BUTTON_BACK:
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Back", @"text", nil];	
		case REMOTE_BUTTON_UP_DIR:
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"...", @"text", nil];		
		case REMOTE_BUTTON_NEXT: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-next.png", @"icon", nil];			
		case REMOTE_BUTTON_PREV: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-prev.png", @"icon", nil];	
			
	}
	
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"remote-eye.png", @"icon",
			@"button-blue.png", @"background",
			@"Back", @"text", nil];	
}
- (void)awakeFromNib {
	[self init];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}


@end
