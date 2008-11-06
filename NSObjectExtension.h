//
//  NSObjectExtension.h
//  xbmcremote
//
//  Created by David Fumberger on 4/11/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>

// This category enhances NSObject by providing
// methods to get the className on the iPhone.
@interface NSObject (Extension) 
#if (TARGET_OS_IPHONE)
- (NSString *)className;
+ (NSString *)className;
#endif
@end
