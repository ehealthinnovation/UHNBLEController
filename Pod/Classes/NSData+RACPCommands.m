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
    return [self allStoredRecordsWithOpCode: kRACPOpCodeStoredRecordsReport];
}

+ (NSData*)reportStoredRecordsLessThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self storedRecordsLessThanEqualTo: timeOffset opCode: kRACPOpCodeStoredRecordsReport filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)reportStoredRecordsGreaterThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self storedRecordsGreaterThanEqualTo: timeOffset opCode: kRACPOpCodeStoredRecordsReport filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)reportStoredRecordsBetween:(uint16_t)minTimeOffset and:(uint16_t)maxTimeOffset;
{
    return [self storedRecordsBetween: minTimeOffset and: maxTimeOffset opCode: kRACPOpCodeStoredRecordsReport filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)reportFirstStoredRecord;
{
    return [self firstStoredRecordWithOpCode: kRACPOpCodeStoredRecordsReport];
}

+ (NSData*)reportLastStoredRecord;
{
    return [self lastStoredRecordWithOpCode: kRACPOpCodeStoredRecordsReport];
}

#pragma mark - Delete record methods

+ (NSData*)deleteAllStoredRecords;
{
    return [self allStoredRecordsWithOpCode: kRACPOpCodeStoredRecordsDelete];
}

+ (NSData*)deleteStoredRecordsLessThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self storedRecordsLessThanEqualTo: timeOffset opCode: kRACPOpCodeStoredRecordsDelete filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)deleteStoredRecordsGreaterThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self storedRecordsGreaterThanEqualTo: timeOffset opCode: kRACPOpCodeStoredRecordsDelete filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)deleteStoredRecordsBetween:(uint16_t)minTimeOffset and:(uint16_t)maxTimeOffset;
{
    return [self storedRecordsBetween: minTimeOffset and: maxTimeOffset opCode: kRACPOpCodeStoredRecordsDelete filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)deleteFirstStoredRecord;
{
    return [self firstStoredRecordWithOpCode: kRACPOpCodeStoredRecordsDelete];
}

+ (NSData*)deleteLastStoredRecord;
{
    return [self lastStoredRecordWithOpCode: kRACPOpCodeStoredRecordsDelete];
}

#pragma mark - Report number of records methods

+ (NSData*)reportNumberOfAllStoredRecords;
{
    return [self allStoredRecordsWithOpCode: kRACPOpCodeStoredRecordsReportNumber];
}

+ (NSData*)reportNumberOfStoredRecordsLessThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self storedRecordsLessThanEqualTo: timeOffset opCode: kRACPOpCodeStoredRecordsReportNumber filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)reportNumberOfStoredRecordsGreaterThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self storedRecordsGreaterThanEqualTo: timeOffset opCode: kRACPOpCodeStoredRecordsReportNumber filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)reportNumberOfStoredRecordsBetween:(uint16_t)minTimeOffset and:(uint16_t)maxTimeOffset;
{
    return [self storedRecordsBetween: minTimeOffset and: maxTimeOffset opCode: kRACPOpCodeStoredRecordsReportNumber filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)reportNumberOfFirstStoredRecord;
{
    return [self firstStoredRecordWithOpCode: kRACPOpCodeStoredRecordsReportNumber];
}

+ (NSData*)reportNumberOfLastStoredRecord;
{
    return [self lastStoredRecordWithOpCode: kRACPOpCodeStoredRecordsReportNumber];
}

#pragma mark - Abort method

+ (NSData*)abortOperation;
{
    return [NSData dataWithBytes:(char[]){kRACPOpCodeAbortOperation, kRACPOperatorNull} length: 2];
}

#pragma mark - Private methods

+ (NSData*)allStoredRecordsWithOpCode:(RACPOpCode)opCode;
{
    return [NSData dataWithBytes: (char[]){opCode, kRACPOperatorRecordsAll} length: 2];
}

+ (NSData*)storedRecordsLessThanEqualTo:(uint16_t)operand opCode:(RACPOpCode)opCode filter:(RACPFilterType)filter;
{
    return [NSData dataWithBytes: (char[]){opCode, kRACPOperatorLessThanEqualTo, filter, operand, (operand >> 8)} length: 5];
}

+ (NSData*)storedRecordsGreaterThanEqualTo:(uint16_t)operand opCode:(RACPOpCode)opCode filter:(RACPFilterType)filter;
{
    return [NSData dataWithBytes: (char[]){opCode, kRACPOperatorGreaterThanEqualTo, filter, operand, (operand >> 8)} length: 5];
}

+ (NSData*)storedRecordsBetween:(uint16_t)minOperand and:(uint16_t)maxOperand opCode:(RACPOpCode)opCode filter:(RACPFilterType)filter
{
    return [NSData dataWithBytes: (char[]){opCode, kRACPOperatorWithinRange, filter, minOperand, (minOperand >> 8), maxOperand, (maxOperand >> 8)} length: 7];
}

+ (NSData*)firstStoredRecordWithOpCode:(RACPOpCode)opCode;
{
    return [NSData dataWithBytes: (char[]){opCode, kRACPOperatorRecordFirst} length: 2];
}

+ (NSData*)lastStoredRecordWithOpCode:(RACPOpCode)opCode;
{
    return [NSData dataWithBytes: (char[]){opCode, kRACPOperatorRecordLast} length: 2];
}

@end
