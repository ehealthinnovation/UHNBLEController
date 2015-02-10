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
    return [self allRecordsWithOpCode: kRACPOpCodeStoredRecordsReport];
}

+ (NSData*)reportStoreRecordsLessThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self recordsLessThanEqualTo: timeOffset opCode: kRACPOpCodeStoredRecordsReport filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)reportStoreRecordsGreaterThanOrEqualToimeOffset:(uint16_t)timeOffset;
{
    return [self recordsGreaterThanEqualTo: timeOffset opCode: kRACPOpCodeStoredRecordsReport filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)reportRecordsBetween:(uint16_t)minTimeOffset and:(uint16_t)maxTimeOffset;
{
    return [self recordsBetween: minTimeOffset and: maxTimeOffset opCode: kRACPOpCodeStoredRecordsReport filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)reportFirstRecord;
{
    return [self firstRecordWithOpCode: kRACPOpCodeStoredRecordsReport];
}

+ (NSData*)reportLastRecord;
{
    return [self lastRecordWithOpCode: kRACPOpCodeStoredRecordsReport];
}

#pragma mark - Delete record methods

+ (NSData*)deleteAllStoredRecords;
{
    return [self allRecordsWithOpCode: kRACPOpCodeStoredRecordsDelete];
}

+ (NSData*)deleteStoreRecordsLessThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self recordsLessThanEqualTo: timeOffset opCode: kRACPOpCodeStoredRecordsDelete filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)deleteStoreRecordsGreaterThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self recordsGreaterThanEqualTo: timeOffset opCode: kRACPOpCodeStoredRecordsDelete filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)deleteRecordsBetween:(uint16_t)minTimeOffset and:(uint16_t)maxTimeOffset;
{
    return [self recordsBetween: minTimeOffset and: maxTimeOffset opCode: kRACPOpCodeStoredRecordsDelete filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)deleteFirstRecord;
{
    return [self firstRecordWithOpCode: kRACPOpCodeStoredRecordsDelete];
}

+ (NSData*)deleteLastRecord;
{
    return [self lastRecordWithOpCode: kRACPOpCodeStoredRecordsDelete];
}

#pragma mark - Report number of records methods

+ (NSData*)reportNumberOfAllStoredRecords;
{
    return [self allRecordsWithOpCode: kRACPOpCodeStoredRecordsReportNumber];
}

+ (NSData*)reportNumberOfStoreRecordsLessThanOrEqualToTimeOffset:(uint16_t)timeOffset;
{
    return [self recordsLessThanEqualTo: timeOffset opCode: kRACPOpCodeStoredRecordsReportNumber filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)reportNumberOfStoreRecordsGreaterThanOrEqualToimeOffset:(uint16_t)timeOffset;
{
    return [self recordsGreaterThanEqualTo: timeOffset opCode: kRACPOpCodeStoredRecordsReportNumber filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)reportNumberOfRecordsBetween:(uint16_t)minTimeOffset and:(uint16_t)maxTimeOffset;
{
    return [self recordsBetween: minTimeOffset and: maxTimeOffset opCode: kRACPOpCodeStoredRecordsReportNumber filter: kRACPFilterTypeTimeOffset];
}

+ (NSData*)reportNumberOfFirstRecord;
{
    return [self firstRecordWithOpCode: kRACPOpCodeStoredRecordsReportNumber];
}

+ (NSData*)reportNumberOfLastRecord;
{
    return [self lastRecordWithOpCode: kRACPOpCodeStoredRecordsReportNumber];
}

#pragma mark - Abort method

+ (NSData*)abortOperation;
{
    return [NSData dataWithBytes:(char[]){kRACPOpCodeAbortOperation, kRACPOperatorNull} length: 2];
}

#pragma mark - Private methods

+ (NSData*)allRecordsWithOpCode:(RACPOpCode)opCode;
{
    return [NSData dataWithBytes: (char[]){opCode, kRACPOperatorRecordsAll} length: 2];
}

+ (NSData*)recordsLessThanEqualTo:(uint16_t)operand opCode:(RACPOpCode)opCode filter:(RACPFilterType)filter;
{
    return [NSData dataWithBytes: (char[]){opCode, kRACPOperatorLessThanEqualTo, filter, operand, (operand >> 8)} length: 5];
}

+ (NSData*)recordsGreaterThanEqualTo:(uint16_t)operand opCode:(RACPOpCode)opCode filter:(RACPFilterType)filter;
{
    return [NSData dataWithBytes: (char[]){opCode, kRACPOperatorGreaterThanEqualTo, filter, operand, (operand >> 8)} length: 5];
}

+ (NSData*)recordsBetween:(uint16_t)minOperand and:(uint16_t)maxOperand opCode:(RACPOpCode)opCode filter:(RACPFilterType)filter
{
    return [NSData dataWithBytes: (char[]){opCode, kRACPOperatorWithinRange, filter, minOperand, (minOperand >> 8), maxOperand, (maxOperand >> 8)} length: 7];
}

+ (NSData*)firstRecordWithOpCode:(RACPOpCode)opCode;
{
    return [NSData dataWithBytes: (char[]){opCode, kRACPOperatorRecordFirst} length: 2];
}

+ (NSData*)lastRecordWithOpCode:(RACPOpCode)opCode;
{
    return [NSData dataWithBytes: (char[]){opCode, kRACPOperatorRecordLast} length: 2];
}

@end
