//
//  NSData+ConversionExtensions.m
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 2013-05-03.
//  Copyright (c) 2015 University Health Network.
//

#import "NSData+ConversionExtensions.h"

@implementation NSData (ConversionExtensions)

- (float)shortFloatToFloat;
{
    NSInteger number = *(uint16_t*)[self bytes];

    // remove the mantissa portion of the number using bit shifting
    NSInteger exponent = number >> 12;

    if (exponent >= 8) {
        // exponent is signed and should be negative 8 = -8, 9 = -7, ... 15 = -1. Range is 7 to -8
        exponent = -((0x000F + 1) - exponent);
    }
    
    // remove exponent portion of the number using bit mask
    NSInteger mantissa = number & 4095;
    if (mantissa >= 2048) {
        //mantissa is signed and should be negative 2048 = -2048, 2049 = -2047, ... 4095 = -1. Range is 2047 to -2048
        mantissa = -((0x0FFF + 1) - mantissa);
    }
    
    return (float)mantissa * pow(10., (exponent/1.));
}

- (float)shortFloatAtRange:(NSRange)range;
{
    return [[self subdataWithRange: range] shortFloatToFloat];
}

- (NSUInteger)unsignedIntegerAtRange:(NSRange)range
{
    if (range.length == 1) {
        return *(uint8_t*)[[self subdataWithRange: range] bytes];
    } else if (range.length == 2) {
        return *(uint16_t*)[[self subdataWithRange: range] bytes];
    } else if (range.length == 3) {
        return *(uint32_t*)[[self subdataWithRange: range] bytes];
    } else if (range.length == 4) {
        return *(uint32_t*)[[self subdataWithRange: range] bytes];
    }
    NSAssert(false, @"length needs to be 1, 2, or 4 bytes for this to work.");
    return 0;
}

- (NSInteger)integerAtRange:(NSRange)range
{
    if (range.length == 1) {
        return *(int8_t*)[[self subdataWithRange: range] bytes];
    } else if (range.length == 2) {
        return *(int16_t*)[[self subdataWithRange: range] bytes];
    } else if (range.length == 4) {
        return *(int32_t*)[[self subdataWithRange: range] bytes];
    }
    NSAssert(false, @"length needs to be 1, 2, or 4 bytes for this to work.");
    return 0;
}

- (NSString*)stringAtRange:(NSRange)range;
{
    uint8_t stringBuf[range.length+1];
    [self getBytes:stringBuf range:range];
    stringBuf[range.length] = 0x00;//NULL terminate
    NSString *string = [NSString stringWithCString:(char *)stringBuf encoding:NSASCIIStringEncoding];
    return string;
}

- (NSDate*)parseDateFromStringWithFormat:(NSString*)dateFormat andRange:(NSRange)range;
{
    NSString *string = [self stringAtRange:range];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    return [dateFormatter dateFromString:string];
}

- (NSDate*)parseDateWithSecondsSinceReferenceDateWithRange:(NSRange)range;
{
    return [NSDate dateWithTimeIntervalSince1970: [self unsignedIntegerAtRange:range]];
}


@end
