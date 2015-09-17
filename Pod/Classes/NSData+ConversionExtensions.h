//
//  NSData+ConversionExtensions.h
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 2013-05-03.
//  Copyright (c) 2015 University Health Network.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

/**
 `NSData+ConversionExtensions` converts `NSDate` bytes to standard types (float, NSUInteger, NSString*, NSDate*)
 */
@interface NSData (ConversionExtensions)

/**
 Converts an `NSData` representing a short float to float 
 
 @returns The float representaiton of the short float value
 
 */
- (float)shortFloatToFloat;

/**
 Converts the short float represented by the bytes in the given range to a float
 
 @param range The range of the bytes to convert
 
 @returns The float value of the short float represented by the bytes
 
 */
- (float)shortFloatAtRange: (NSRange)range;

/**
 Converts the bytes in the given range to an unsigned integer value
 
 @param range The range of the bytes to convert
 
 @return The unsigned integer represented by the bytes
 
 @discussion If the byte range length is only 3 bytes, a 32-bit unsigned integer will be returned
 
 */
- (NSUInteger)unsignedIntegerAtRange: (NSRange)range;

/**
 Converts the bytes in the given range to an integer value
 
 @param range The range of the bytes to convert
 
 @return The integer represented by the bytes
 
 @discussion If the byte range length is only 3 bytes, a 32-bit integer will be returned
 
 */
- (NSInteger)integerAtRange: (NSRange)range;

/** 
 Converts the bytes in the given range to a string
 
 @param range The range of the bytes to convert
 
 @return The string represented by the bytes
 
 */
- (NSString*)stringAtRange: (NSRange)range;

/** 
 Converts the bytes in the given range to a date using the given string format
 
 @param dateFormat The format of the date
 @param range The range of the bytes to convert
 
 @return The date represented by the bytes for the given format
 
 */
- (NSDate*)parseDateFromStringWithFormat: (NSString*)dateFormat andRange: (NSRange)range;

/**
 Converts the bytes in the given range to a date
 
 @param range The range of the bytes to convert
 
 @return The date since the reference data represented by the bytes
 
 @discussion This method assume the bytes in the given range represent an integer with second resolution
 
 */
- (NSDate*)parseDateWithSecondsSinceReferenceDateWithRange: (NSRange)range;

/**
 Extracts the low (first 4 bits) nibble of the byte at the given position and returns it as an unsigned integer
 
 @param position The position of the byte to get the lower nibble from
 
 @return The unsigned integer representation of the low nibble of the byte at the position provided
 
 */
- (NSUInteger) lowNibbleAtPosition:(NSUInteger) position;

/**
 Extracts the high (last 4 bits) nibble of the byte at the given position and returns it as an unsigned integer
 
 @param position The position of the byte to get the high nibble from
 
 @return The unsigned integer representation of the high nibble of the byte at the position provided
 
 */
- (NSUInteger) highNibbleAtPosition:(NSUInteger) position;

/**
 Converts the NSData to an NSDate starting at 'location' and adds 'timeOffsetInMinutesNumber' to the minutes of the date
 
 @param location The location to start parsing the date in the NSData object
 @param timeOffsetInMinutesNumber An integer number of minutes to be added to the minutes component of the date
 
 @return The NSDate object found by parsing the data at the location specified
 
 */
- (NSDate *) parseDateAtLocation:(NSUInteger) location andTimeOffsetInMinutes:(NSNumber *) timeOffsetInMinutesNumber;

@end
