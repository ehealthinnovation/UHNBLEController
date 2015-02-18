//
//  NSData+RACPCommands.m
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 2015-01-15.
//  Copyright (c) 2015 University Health Network.
//

#import "NSData+RACPCommands.h"

@implementation NSData (RACPCommands)

#pragma mark - Report records methods

+ (NSData*)reportAllStoredRecords;
{
    return [self allStoredRecordsWithOpCode: RACPOpCodeStoredRecordsReport];
}

+ (NSData*)reportStoredRecordsLessThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self storedRecordsLessThanEqualTo: timeOffset opCode: RACPOpCodeStoredRecordsReport filter: RACPFilterTypeTimeOffset];
}

+ (NSData*)reportStoredRecordsGreaterThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self storedRecordsGreaterThanEqualTo: timeOffset opCode: RACPOpCodeStoredRecordsReport filter: RACPFilterTypeTimeOffset];
}

+ (NSData*)reportStoredRecordsBetween:(uint16_t)minTimeOffset and:(uint16_t)maxTimeOffset;
{
    return [self storedRecordsBetween: minTimeOffset and: maxTimeOffset opCode: RACPOpCodeStoredRecordsReport filter: RACPFilterTypeTimeOffset];
}

+ (NSData*)reportFirstStoredRecord;
{
    return [self firstStoredRecordWithOpCode: RACPOpCodeStoredRecordsReport];
}

+ (NSData*)reportLastStoredRecord;
{
    return [self lastStoredRecordWithOpCode: RACPOpCodeStoredRecordsReport];
}

#pragma mark - Delete record methods

+ (NSData*)deleteAllStoredRecords;
{
    return [self allStoredRecordsWithOpCode: RACPOpCodeStoredRecordsDelete];
}

+ (NSData*)deleteStoredRecordsLessThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self storedRecordsLessThanEqualTo: timeOffset opCode: RACPOpCodeStoredRecordsDelete filter: RACPFilterTypeTimeOffset];
}

+ (NSData*)deleteStoredRecordsGreaterThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self storedRecordsGreaterThanEqualTo: timeOffset opCode: RACPOpCodeStoredRecordsDelete filter: RACPFilterTypeTimeOffset];
}

+ (NSData*)deleteStoredRecordsBetween:(uint16_t)minTimeOffset and:(uint16_t)maxTimeOffset;
{
    return [self storedRecordsBetween: minTimeOffset and: maxTimeOffset opCode: RACPOpCodeStoredRecordsDelete filter: RACPFilterTypeTimeOffset];
}

+ (NSData*)deleteFirstStoredRecord;
{
    return [self firstStoredRecordWithOpCode: RACPOpCodeStoredRecordsDelete];
}

+ (NSData*)deleteLastStoredRecord;
{
    return [self lastStoredRecordWithOpCode: RACPOpCodeStoredRecordsDelete];
}

#pragma mark - Report number of records methods

+ (NSData*)reportNumberOfAllStoredRecords;
{
    return [self allStoredRecordsWithOpCode: RACPOpCodeStoredRecordsReportNumber];
}

+ (NSData*)reportNumberOfStoredRecordsLessThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self storedRecordsLessThanEqualTo: timeOffset opCode: RACPOpCodeStoredRecordsReportNumber filter: RACPFilterTypeTimeOffset];
}

+ (NSData*)reportNumberOfStoredRecordsGreaterThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self storedRecordsGreaterThanEqualTo: timeOffset opCode: RACPOpCodeStoredRecordsReportNumber filter: RACPFilterTypeTimeOffset];
}

+ (NSData*)reportNumberOfStoredRecordsBetween:(uint16_t)minTimeOffset and:(uint16_t)maxTimeOffset;
{
    return [self storedRecordsBetween: minTimeOffset and: maxTimeOffset opCode: RACPOpCodeStoredRecordsReportNumber filter: RACPFilterTypeTimeOffset];
}

+ (NSData*)reportNumberOfFirstStoredRecord;
{
    return [self firstStoredRecordWithOpCode: RACPOpCodeStoredRecordsReportNumber];
}

+ (NSData*)reportNumberOfLastStoredRecord;
{
    return [self lastStoredRecordWithOpCode: RACPOpCodeStoredRecordsReportNumber];
}

#pragma mark - Abort method

+ (NSData*)abortOperation;
{
    return [NSData dataWithBytes:(char[]){RACPOpCodeAbortOperation, RACPOperatorNull} length: 2];
}

#pragma mark - Private methods

+ (NSData*)allStoredRecordsWithOpCode:(RACPOpCode)opCode;
{
    return [NSData dataWithBytes: (char[]){opCode, RACPOperatorRecordsAll} length: 2];
}

+ (NSData*)storedRecordsLessThanEqualTo:(uint16_t)operand opCode:(RACPOpCode)opCode filter:(RACPFilterType)filter;
{
    return [NSData dataWithBytes: (char[]){opCode, RACPOperatorLessThanEqualTo, filter, operand, (operand >> 8)} length: 5];
}

+ (NSData*)storedRecordsGreaterThanEqualTo:(uint16_t)operand opCode:(RACPOpCode)opCode filter:(RACPFilterType)filter;
{
    return [NSData dataWithBytes: (char[]){opCode, RACPOperatorGreaterThanEqualTo, filter, operand, (operand >> 8)} length: 5];
}

+ (NSData*)storedRecordsBetween:(uint16_t)minOperand and:(uint16_t)maxOperand opCode:(RACPOpCode)opCode filter:(RACPFilterType)filter
{
    return [NSData dataWithBytes: (char[]){opCode, RACPOperatorWithinRange, filter, minOperand, (minOperand >> 8), maxOperand, (maxOperand >> 8)} length: 7];
}

+ (NSData*)firstStoredRecordWithOpCode:(RACPOpCode)opCode;
{
    return [NSData dataWithBytes: (char[]){opCode, RACPOperatorRecordFirst} length: 2];
}

+ (NSData*)lastStoredRecordWithOpCode:(RACPOpCode)opCode;
{
    return [NSData dataWithBytes: (char[]){opCode, RACPOperatorRecordLast} length: 2];
}

@end
