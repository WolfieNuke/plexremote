//
//  NSObjectExtension.m
//  xbmcremote
//
//  Created by David Fumberger on 4/11/08.
//  Copyright 2008 collect3. All rights reserved.
//
	
#import "NSObjectExtension.h"



@implementation NSObject (Extension)

#if (TARGET_OS_IPHONE)
- (NSString *)className
{
	return [NSString stringWithUTF8String:class_getName([self class])];
}
+ (NSString *)className
{
	return [NSString stringWithUTF8String:class_getName(self)];
}
#endif

@end
