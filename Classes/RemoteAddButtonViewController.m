//
//  RemoteAddButtonViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 8/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "RemoteAddButtonViewController.h"
#import "RemoteButtonData.h";

@implementation RemoteAddButtonViewController
@synthesize tableData;
@synthesize delegate;
NSString* toS(NSInteger type) {
	return [NSString stringWithFormat:@"%i", type];
}
- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		[self init];
	}
	return self;
}
- (NSDictionary*)tRowData:(NSInteger)type title:(NSString*)title  {
	return [NSDictionary dictionaryWithObjectsAndKeys:title, @"title",
			toS(type), @"type", nil];
}
- (void) init {
	self.tableData = [NSArray arrayWithObjects:
					  [self tRowData:REMOTE_BUTTON_UP			title:@"Up" ],					  					  					  
					  [self tRowData:REMOTE_BUTTON_DOWN			title:@"Down" ],					  					  					  					  
					  [self tRowData:REMOTE_BUTTON_LEFT			title:@"Left" ],					  					  					  
					  [self tRowData:REMOTE_BUTTON_RIGHT		title:@"Right" ],					  					  					  					  
					  [self tRowData:REMOTE_BUTTON_OK			title:@"OK" ],					  					  					  					  
					  [self tRowData:REMOTE_BUTTON_BACK			title:@"Back" ],					  					  					  					  					  
					  [self tRowData:REMOTE_BUTTON_UP_DIR		title:@"Up Dir" ],					  
					  [self tRowData:REMOTE_BUTTON_PLAY			  title:@"Play" ],
					  [self tRowData:REMOTE_BUTTON_PAUSE		  title:@"Pause" ],					  
					  [self tRowData:REMOTE_BUTTON_STOP  		  title:@"Stop" ],					  
					  [self tRowData:REMOTE_BUTTON_NEXT			  title:@"Next" ],					  					  
					  [self tRowData:REMOTE_BUTTON_PREV			  title:@"Previous" ],
					  [self tRowData:REMOTE_BUTTON_FF			  title:@"Fast Forward" ],					  
					  [self tRowData:REMOTE_BUTTON_RR			  title:@"Rewind" ],	
					  [self tRowData:REMOTE_BUTTON_PLAY_SPEED_ONE      title:@"Normal Play Speed" ],						  					  					  					  					  					  					  
					  [self tRowData:REMOTE_BUTTON_ASPECT_RATIO	  title:@"Aspect Ratio" ],					  
					  [self tRowData:REMOTE_BUTTON_STEP_FORWARD	  title:@"Step Forward" ],					  
					  [self tRowData:REMOTE_BUTTON_STEP_BACK	  title:@"Step Back" ],					  					  
					  [self tRowData:REMOTE_BUTTON_GUI			  title:@"GUI/Visualisation" ],					  
					  [self tRowData:REMOTE_BUTTON_SHOW_OSD		  title:@"OSD" ],					  					  
					  [self tRowData:REMOTE_BUTTON_SHOW_SUBTITLES title:@"Show Subtitles" ],					  					  					  
					  [self tRowData:REMOTE_BUTTON_NEXT_SUBTITLE  title:@"Next Subtitle" ],		
					  [self tRowData:REMOTE_BUTTON_NEXT_PICTURE   title:@"Next Picture" ],
					  [self tRowData:REMOTE_BUTTON_PREV_PICTURE   title:@"Previous Picture" ],							  
					  [self tRowData:REMOTE_BUTTON_ZOOM_IN        title:@"Zoom In" ],
					  [self tRowData:REMOTE_BUTTON_ZOOM_OUT       title:@"Zoom Out" ],							  					  
					  [self tRowData:REMOTE_BUTTON_ZOOM_NORMAL    title:@"Zoom Reset" ],
					  [self tRowData:REMOTE_BUTTON_QUEUE_ITEM     title:@"Queue Item" ],
					  [self tRowData:REMOTE_BUTTON_SHOW_PLAYLIST  title:@"Show Playlist" ],	
					  [self tRowData:REMOTE_BUTTON_ROTATE_PICTURE  title:@"Rotate Picture" ],		
					  [self tRowData:REMOTE_BUTTON_SHUTDOWN		   title:@"Shutdown" ],							  
					  [self tRowData:REMOTE_BUTTON_RESTART		   title:@"Restart" ],	
					  [self tRowData:REMOTE_BUTTON_CONTEXT_MENU    title:@"Context Menu" ],			
					  [self tRowData:REMOTE_BUTTON_SHOW_INFO       title:@"Information" ],
					  [self tRowData:REMOTE_BUTTON_SHOW_CODEC       title:@"Codec" ],					  
					  [self tRowData:REMOTE_BUTTON_NEXT_VIS        title:@"Next Visualisation" ],						  					  
					  [self tRowData:REMOTE_BUTTON_PREV_VIS        title:@"Previous Visualisation" ],						  					  					  
					  [self tRowData:REMOTE_BUTTON_MUTE            title:@"Mute" ],						  					  					  					  
					  [self tRowData:REMOTE_BUTTON_VOLUME_UP				 title:@"Volume Up" ],
					  [self tRowData:REMOTE_BUTTON_VOLUME_DOWN				 title:@"Volume Down" ],					  
					  [self tRowData:REMOTE_BUTTON_SCREENSHOT				 title:@"Take Screenshot" ],
					  [self tRowData:REMOTE_BUTTON_CHANGE_RESOLUTION         title:@"Change Resolution" ],		
					  [self tRowData:REMOTE_BUTTON_UPDATE_MUSIC_LIBRARY      title:@"Update Music Library" ],							  
					  [self tRowData:REMOTE_BUTTON_UPDATE_VIDEO_LIBRARY      title:@"Update Video Library" ],	
					  [self tRowData:REMOTE_BUTTON_CHANGE_THEME				 title:@"Change Theme" ],						  
					  [self tRowData:REMOTE_BUTTON_EJECT					 title:@"Eject" ],						  					  
					  [self tRowData:REMOTE_BUTTON_PLAY_DVD					 title:@"Play DVD" ],						  					  					  
					  [self tRowData:REMOTE_BUTTON_PARTY_MODE_VIDEO			 title:@"Party Mode Video" ],						  					  					  					  
					  [self tRowData:REMOTE_BUTTON_PARTY_MODE_MUSIC			 title:@"Party Mode Music" ],						  					  					  					  					  

					  nil];				  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	NSDictionary *data = [self.tableData objectAtIndex:indexPath.row];
	cell.text = [data objectForKey:@"title"];
	// Configure the cell
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *data = [self.tableData objectAtIndex:indexPath.row];
	NSInteger type = [[data objectForKey:@"type"] integerValue];
	[self.delegate actionAddedButton: type];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[self.tableData release];
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end

