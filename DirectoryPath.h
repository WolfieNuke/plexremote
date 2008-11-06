//
//  DirectoryPath.h
//  xbmcremote
//
//  Created by David Fumberger on 4/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Path.h";
#define DIRECTORY_MASK_MUSIC 0
#define DIRECTORY_MASK_VIDEO 1
#define DIRECTORY_MASK_PICTURE 2
@interface DirectoryPath : Path {
	NSInteger mask;
}
@property (nonatomic, assign) NSInteger mask;
- (NSString*)GetPath; 
@end
