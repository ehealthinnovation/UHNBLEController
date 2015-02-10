//
//  CBUUID+Extension.m
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 12-02-06.
//  Copyright (c) 2015 University Health Network.
//

#import "CBUUID+Extension.h"

@implementation CBUUID (Extension)

- (BOOL)isEqualToCBUUID:(CBUUID*)uuid;
{
    if (self == uuid) {
        return YES;
    }
    
    if ([uuid isKindOfClass:[CBUUID class]] == NO) {
        return NO;
    }
    
    return [[self data] isEqualToData:[(CBUUID*)uuid data]];
}

- (const char*)toCharString
{
    return [[self.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}

- (NSString*)toString
{
    return [self.data description];
}

@end
