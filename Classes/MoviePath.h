//
//  MoviePath.h
//  xbmcremote
//
//  Created by David Fumberger on 17/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathItem.h";
#import "Path.h";
@interface MoviePath : Path {

}
+ (MoviePath*)pathFromPath:(MoviePath*)path;
- (void)addItem:(PathItem*)item;
- (NSString*)WhereClauseForMovie;
@end
