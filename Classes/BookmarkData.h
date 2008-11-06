//
//  BookmarkData.h
//  xbmcremote
//
//  Created by David Fumberger on 3/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicPath.h";
#import "VideoPath.h";
#import "DirectoryPath.h";

@interface BookmarkData : NSObject {
	NSInteger identifier;
	NSString *iconName;
	NSString *className;
	NSString *title;
	MusicPath *musicPath;
	VideoPath *videoPath;
	DirectoryPath *directoryPath;	
}
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic, retain) MusicPath *musicPath;
@property (nonatomic, retain) VideoPath *videoPath;
@property (nonatomic, retain) DirectoryPath *directoryPath;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *className;
@end
