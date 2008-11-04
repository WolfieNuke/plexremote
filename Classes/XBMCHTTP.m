//
//  XBMCHTTP.m
//  NavTest
//
//  Created by David Fumberger on 30/07/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "XBMCHTTP.h"

@implementation XBMCHTTP
- (void)GetAlbumsQuery:(NSString*)whereClause {
	return [NSString stringWithFormat:@"select idAlbum, strAlbum, idArtist, strArtist, strThumb from albumview where %@ order by strAlbum asc", whereClause];
}
@end

