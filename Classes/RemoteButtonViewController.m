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
- (NSDictionary*)dataForButtonType:(NSInteger)type;
- (void)startEditing;
- (void)endEditing;
@end


@implementation RemoteButtonViewController
@synthesize delegate;
@synthesize editMode;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}
- (void)awakeFromNib {
	[self init];
}
- (id)init {
	XBMCSettings *settings = [XBMCSettings sharedInstance];
	self.view.multipleTouchEnabled = YES;
	self.view.userInteractionEnabled = YES;
	editMode = NO;
	buttonPressing = NO;
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
	self.view.pagingEnabled = NO;
	self.view.scrollEnabled = NO;	
	for (RemoteItemView *rview in [self.view subviews]) {
		if ([[rview className] isEqualToString:@"RemoteItemView"]) {
			[rview startEditing];
		}
	}
}
- (void)endEditing {
	self.view.pagingEnabled = YES;
	self.view.scrollEnabled = YES;		
	NSMutableArray *buttonList = [NSMutableArray array];
	for (RemoteItemView *rview in [self.view subviews]) {
		if ([[rview className] isEqualToString:@"RemoteItemView"]) {
			[buttonList addObject: rview.buttonData];
			[rview endEditing];
		}
	}
	XBMCSettings *settings = [XBMCSettings sharedInstance];
	settings.remoteButtonList = buttonList; 
	[settings saveSettings];
}
- (void)buttonPress:(NSTimer*)timer  {
	[self.delegate actionButtonPress: (RemoteButtonData*)timer.userInfo];	
}
- (void)actionButtonDown:(id)sender {
	if (buttonPressing) { return; }
	buttonPressing = YES;
	RoundedButton *button = sender;
	RemoteItemView *remoteButton = [button superview];
	[self.delegate actionButtonPress: remoteButton.buttonData];	
	repeatTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target: self selector: @selector(buttonPress:) userInfo:remoteButton.buttonData repeats:YES];		
}
- (void)actionButtonUp:(id)sender {
	buttonPressing = NO;
	[repeatTimer invalidate];
}
- (void)addButton:(RemoteButtonData*)buttonData {
	if (buttonData.frame.size.width == 0 && buttonData.frame.size.height == 0) {
		buttonData.frame = [self defaultFrameForButtonType: buttonData.type];
	} 
	//NSLog(@"case %i:", buttonData.type);			
	//NSLog(@"	return CGRectMake(%f, %f, %f, %f);", buttonData.frame.origin.x, buttonData.frame.origin.y, buttonData.frame.size.width, buttonData.frame.size.height);

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
	button.showsTouchWhenHighlighted = YES;
	[button addTarget:self action:@selector(actionButtonDown:) forControlEvents: UIControlEventTouchDown];
	[button addTarget:self action:@selector(actionButtonUp:) forControlEvents: UIControlEventTouchUpInside];
	if ([data objectForKey:@"icon"]) {
		UIImage *icon       = [UIImage imageNamed:[data objectForKey:@"icon"]];
		[button setImage:icon forState:UIControlStateNormal];
	}
	NSString *text      = [data objectForKey:@"text"];
	[button setTitle:text forState:UIControlStateNormal];	
	[remoteButton setButton: button];
	[self.view addSubview: remoteButton];
	[button release];
	[remoteButton release];
	
	if (self.editMode) {
		[remoteButton startEditing];
	}
}
- (CGRect)defaultFrameForButtonType:(NSInteger)type {
	switch (type) {
			 case 16:
			 	return CGRectMake(325.000000, 55.000000, 70.000000, 70.000000);
			 case 27:
			 	return CGRectMake(505.000000, 55.000000, 70.000000, 70.000000);
			 case 25:
			 	return CGRectMake(445.000000, 55.000000, 70.000000, 70.000000);
			 case 26:
			 	return CGRectMake(385.000000, 55.000000, 70.000000, 70.000000);
			 case 30:
			 	return CGRectMake(565.000000, 55.000000, 70.000000, 70.000000);
			 case 47:
			 	return CGRectMake(325.000000, 125.000000, 160.000000, 60.000000);
			 case 46:
			 	return CGRectMake(475.000000, 125.000000, 160.000000, 60.000000);
			 case 20:
			 	return CGRectMake(325.000000, 175.000000, 160.000000, 60.000000);
			 case 29:
			 	return CGRectMake(475.000000, 175.000000, 160.000000, 60.000000);
			 case 18:
			 	return CGRectMake(320.000000, 380.000000, 160.000000, 50.000000);
			 case 50:
			 	return CGRectMake(318.000000, 337.953613, 320.000000, 50.000000);
			 case 17:
			 	return CGRectMake(470.000000, 380.000000, 170.000000, 50.000000);
			 case 13:
			 	return CGRectMake(470.000000, 275.000000, 170.000000, 70.000000);
			 case 28:
			 	return CGRectMake(220.000000, 250.000000, 90.000000, 80.000000);
			 case 6:
			 	return CGRectMake(220.000000, 120.000000, 90.000000, 140.000000);
			 case 11:
			 	return CGRectMake(220.000000, 50.000000, 90.000000, 80.000000);
			 case 7:
			 	return CGRectMake(90.000000, 50.000000, 140.000000, 80.000000);
			 case 2:
			 	return CGRectMake(90.000000, 120.000000, 140.000000, 140.000000);
			 case 8:
			 	return CGRectMake(90.000000, 250.000000, 140.000000, 80.000000);
			 case 9:
			 	return CGRectMake(10.000000, 250.000000, 90.000000, 80.000000);
			 case 5:
			 	return CGRectMake(10.000000, 120.000000, 90.000000, 140.000000);
			 case 19:
			 	return CGRectMake(10.000000, 50.000000, 90.000000, 80.000000);
			 case 10:
			 	return CGRectMake(10.000000, 320.000000, 90.000000, 60.000000);
			 case 33:
			 	return CGRectMake(10.000000, 370.000000, 60.000000, 60.000000);
			 case 1:
			 	return CGRectMake(90.000000, 320.000000, 50.000000, 60.000000);
			 case 4:
			 	return CGRectMake(130.000000, 320.000000, 70.000000, 60.000000);
			 case 3:
			 	return CGRectMake(190.000000, 320.000000, 70.000000, 60.000000);
			 case 12:
			 	return CGRectMake(250.000000, 320.000000, 60.000000, 60.000000);
			 case 14:
			 	return CGRectMake(319.000000, 274.953613, 160.000000, 70.000000);			
		
	}
	return CGRectMake(50,50,65,65);
}
- (NSDictionary*)dataForButtonType:(NSInteger)type {
	switch (type) {
		case REMOTE_BUTTON_PLAY:
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-play.png", @"icon", nil];
		case REMOTE_BUTTON_PAUSE:
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-pause.png", @"icon",nil];
		case REMOTE_BUTTON_STOP:
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-stop.png", @"icon",nil];
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
		case REMOTE_BUTTON_FF: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-ff.png", @"icon", nil];				
		case REMOTE_BUTTON_RR: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-rw.png", @"icon", nil];				
		case REMOTE_BUTTON_SHOW_INFO: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Info", @"text", nil];				
		case REMOTE_BUTTON_ASPECT_RATIO: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-aspect.png", @"icon", nil];				
		case REMOTE_BUTTON_BIG_STEP_FORWARD: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Big Step Forward", @"text", nil];				
		case REMOTE_BUTTON_BIG_STEP_BACK: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Big Step Back", @"text", nil];				
		case REMOTE_BUTTON_STEP_FORWARD: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Step Forward", @"text", nil];				
		case REMOTE_BUTTON_STEP_BACK: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Step Back", @"text", nil];							
		case REMOTE_BUTTON_SHOW_OSD: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"OSD", @"text", nil];				
		case REMOTE_BUTTON_SHOW_SUBTITLES: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Subtitles", @"text", nil];				
		case REMOTE_BUTTON_NEXT_SUBTITLE: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Next Subtitle", @"text", nil];				
		case REMOTE_BUTTON_SHOW_CODEC: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Show Codec", @"text", nil];				
		case REMOTE_BUTTON_NEXT_PICTURE: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Next Picture", @"text", nil];				
		case REMOTE_BUTTON_PREV_PICTURE: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Previous Picture", @"text", nil];				
		case REMOTE_BUTTON_ZOOM_OUT: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-zoom-out.png", @"icon", nil];				
		case REMOTE_BUTTON_ZOOM_IN: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-zoom-in.png", @"icon", nil];				
		case REMOTE_BUTTON_ZOOM_NORMAL: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-zoom-normal.png", @"icon", nil];				
		case REMOTE_BUTTON_QUEUE_ITEM: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-add.png", @"icon", nil];				
		case REMOTE_BUTTON_SHOW_PLAYLIST: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Playlist", @"text", nil];				
		case REMOTE_BUTTON_ROTATE_PICTURE: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-rotate.png", @"icon", nil];				
		case REMOTE_BUTTON_GUI: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-eye.png", @"icon", nil];				
		case REMOTE_BUTTON_SHUTDOWN: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"remote-b-shutdown.png", @"icon", nil];				
		case REMOTE_BUTTON_RESTART: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Restart", @"text", nil];				
		case REMOTE_BUTTON_CONTEXT_MENU: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Context Menu", @"text", nil];				
		case REMOTE_BUTTON_NEXT_VIS: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Next Vis", @"text", nil];				
		case REMOTE_BUTTON_PREV_VIS: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Previous Vis", @"text", nil];				
		case REMOTE_BUTTON_MUTE: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Mute", @"text", nil];				
		case REMOTE_BUTTON_VOLUME_UP: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Vol Up", @"text", nil];				
		case REMOTE_BUTTON_VOLUME_DOWN: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Vol Down", @"text", nil];				
		case REMOTE_BUTTON_SCREENSHOT: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Screenshot", @"text", nil];				
		case REMOTE_BUTTON_CHANGE_RESOLUTION: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Change Resolution", @"text", nil];				
		case REMOTE_BUTTON_UPDATE_MUSIC_LIBRARY: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Update Music Library", @"text", nil];				
		case REMOTE_BUTTON_UPDATE_VIDEO_LIBRARY: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Update Video Library",  @"text", nil];				
		case REMOTE_BUTTON_CHANGE_THEME: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Change Theme", @"text", nil];				
		case REMOTE_BUTTON_EJECT: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Eject", @"text", nil];				
		case REMOTE_BUTTON_PLAY_DVD: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Play DVD", @"text", nil];				
		case REMOTE_BUTTON_PARTY_MODE_VIDEO: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Party Mode Video", @"text", nil];				
		case REMOTE_BUTTON_PARTY_MODE_MUSIC: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Party Mode Music", @"text", nil];				
		case REMOTE_BUTTON_PLAY_SPEED_ONE: 
			return [NSDictionary dictionaryWithObjectsAndKeys:
					@"Normal Play Speed", @"text", nil];				
			
	}
	
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"remote-eye.png", @"icon",
			@"button-blue.png", @"background",
			@"Back", @"text", nil];	
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
