//
//  NSString+GUIDExtension.m
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 10-10-15.
//  Copyright (c) 2015 University Health Network.
//

#import "NSString+GUIDExtension.h"

@implementation NSString (GUIDExtension)

+ (NSString*)generateGUID
{
    NSString *guid = nil;
    
	CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid)
    {
        guid = CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
        CFRelease(uuid);
    }
    
	return guid;
}

@end
