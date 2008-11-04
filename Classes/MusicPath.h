//
//  MusicPath.h
//  xbmcremote
//
//  Created by David Fumberger on 13/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathItem.h";
#import "Path.h";
@interface MusicPath : Path {

}
+ (MusicPath*)pathFromPath:(MusicPath*)path;
- (NSString*)WhereClauseForArtist;
- (NSString*)WhereClauseForAlbum;
- (NSString*)WhereClauseForSong;
- (NSString*)GetPath; 
@end
