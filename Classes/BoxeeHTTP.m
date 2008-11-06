//
//  BoxeeHTTP.m
//  xbmcremote
//
//  Created by David Fumberger on 1/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "BoxeeHTTP.h"


@implementation BoxeeHTTP
- (void)GetAlbumsQuery:(NSString*)whereClause {
	return [NSString stringWithFormat:@"select albums.idAlbum, albums.strTitle, albums.idArtist, artists.strName, albums.strPath from albums join artists on albums.idArtist = artists.idArtist where %@ order by albums.strTitle asc", whereClause];
}
@end
