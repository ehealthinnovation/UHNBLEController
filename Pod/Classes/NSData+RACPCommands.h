//
//  NSData+RACPCommands.h
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 2015-01-15.
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
#import "UHNRACPConstants.h"

/**
 `NSData+RACPCommands` constructs record access control point commands and returns a cooresponding `NSData` object
 */
@interface NSData (RACPCommands)

///-------------------------------------
/// @name Report Stored Records Commands
///-------------------------------------

/**
 Command for reporting all stored records
 
 @return The command as a `NSData` object
 */
+ (NSData*)reportAllStoredRecords;

/**
 Command for reporting stored records less than of equal to provided timeOffset
 
 @param timeOffset The time offset to report records less than or equal to.
 
 @return The command as a `NSData` object
 */
+ (NSData*)reportStoredRecordsLessThanOrEqualToTimeOffset: (uint16_t)timeOffset;

/**
 Command for reporting stored records greater than of equal to provided timeOffset
 
 @param timeOffset The time offset to report records greater than or equal to.
 
 @return The command as a `NSData` object
 */
+ (NSData*)reportStoredRecordsGreaterThanOrEqualToTimeOffset: (uint16_t)timeOffset;

/**
 Command for reporting stored records between a max and min time offset
 
 @param maxTimeOffset The max time offset to report records less than or equal to.
 @param minTimeOffset The min time offset to report records greater than or equal to.
 
 @return The command as a `NSData` object
 */
+ (NSData*)reportStoredRecordsBetween: (uint16_t)maxTimeOffset and: (uint16_t)minTimeOffset;

/**
 Command for reporting the first stored record
 
 @return The command as a `NSData` object
 */
+ (NSData*)reportFirstStoredRecord;

/**
 Command for reporting the last stored record
 
 @return The command as a `NSData` object
 */
+ (NSData*)reportLastStoredRecord;

///-------------------------------------
/// @name Delete Stored Records Commands
///-------------------------------------


/**
 Command for deleting all stored records
 
 @return The command as a `NSData` object
 */
+ (NSData*)deleteAllStoredRecords;

/**
 Command for deleting stored records less than of equal to provided timeOffset
 
 @param timeOffset The time offset to report records less than or equal to.
 
 @return The command as a `NSData` object
 */
+ (NSData*)deleteStoredRecordsLessThanOrEqualToTimeOffset: (uint16_t)timeOffset;

/**
 Command for deleting stored records greater than of equal to provided timeOffset
 
 @param timeOffset The time offset to report records greater than or equal to.
 
 @return The command as a `NSData` object
 */
+ (NSData*)deleteStoredRecordsGreaterThanOrEqualToTimeOffset: (uint16_t)timeOffset;

/**
 Command for deleting stored records between a max and min time offset
 
 @param maxTimeOffset The max time offset to report records less than or equal to.
 @param minTimeOffset The min time offset to report records greater than or equal to.
 
 @return The command as a `NSData` object
 */
+ (NSData*)deleteStoredRecordsBetween: (uint16_t)minTimeOffset and: (uint16_t)maxTimeOffset;

/**
 Command for deleting the first stored record
 
 @return The command as a `NSData` object
 */
+ (NSData*)deleteFirstStoredRecord;

/**
 Command for deleting the last stored record
 
 @return The command as a `NSData` object
 */
+ (NSData*)deleteLastStoredRecord;

///-----------------------------------------------
/// @name Report Number of Stored Records Commands
///-----------------------------------------------

/**
 Command for reporting the number of all stored records
 
 @return The command as a `NSData` object
 */
+ (NSData*)reportNumberOfAllStoredRecords;

/**
 Command for reporting the number of stored records less than of equal to provided timeOffset
 
 @param timeOffset The time offset to report records less than or equal to.
 
 @return The command as a `NSData` object
 */
+ (NSData*)reportNumberOfStoredRecordsLessThanOrEqualToTimeOffset: (uint16_t)timeOffset;

/**
 Command for reporting the number of stored records greater than of equal to provided timeOffset
 
 @param timeOffset The time offset to report records greater than or equal to.
 
 @return The command as a `NSData` object
 */
+ (NSData*)reportNumberOfStoredRecordsGreaterThanOrEqualToTimeOffset: (uint16_t)timeOffset;

/**
 Command for reporting the number of stored records between a max and min time offset
 
 @param maxTimeOffset The max time offset to report records less than or equal to.
 @param minTimeOffset The min time offset to report records greater than or equal to.
 
 @return The command as a `NSData` object
 */
+ (NSData*)reportNumberOfStoredRecordsBetween: (uint16_t)minTimeOffset and: (uint16_t)maxTimeOffset;

/**
 Command for reporting the number of first stored records
 
 @return The command as a `NSData` object
 */
+ (NSData*)reportNumberOfFirstStoredRecord;

/**
 Command for reporting the number of last stored records
 
 @return The command as a `NSData` object
 */
+ (NSData*)reportNumberOfLastStoredRecord;

///-------------------------------------
/// @name Abort Command
///-------------------------------------

/**
 Command to abort the current operation
 
 @return The command as a `NSData` object
 
 */
+ (NSData*)abortOperation;

@end
