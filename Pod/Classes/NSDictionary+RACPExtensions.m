//
//  NSDictionary+RACPExtensions.m
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 2015-02-09.
//  Copyright (c) 2015 University Health Network.
//

#import "NSDictionary+RACPExtensions.h"

@implementation NSDictionary (RACPExtensions)

- (BOOL)isNumberOfRecordResponse;
{
    RACPOpCode opCode = [self responseOpCode];
    if (opCode == RACPOpCodeResponseStoredRecordsReportNumber) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isGeneralResponse;
{
    RACPOpCode opCode = [self responseOpCode];
    if (opCode == RACPOpCodeResponse) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isSuccessfulResponseReportRecords;
{
    return [self isSuccessfulResponseOfType: RACPOpCodeStoredRecordsReport];
}

- (BOOL)isSuccessfulResponseDeleteRecords;
{
    return [self isSuccessfulResponseOfType: RACPOpCodeStoredRecordsDelete];
}

- (BOOL)isSuccessfulResponseAbort;
{
    return [self isSuccessfulResponseOfType: RACPOpCodeAbortOperation];
}

- (BOOL)isSuccessfulResponseOfType: (RACPOpCode)opCode
{
    if ([self isGeneralResponse]) {
        RACPOpCode requestOpCode = [self requestOpCode];
        RACPResponseCode responseCode = [self responseCodeValue];
        if (requestOpCode == opCode && responseCode == RACPSuccess) {
            return YES;
        }
    }
    return NO;
}

- (NSNumber*)numberOfRecords;
{
    if ([self isNumberOfRecordResponse]) {
        return [self objectForKey: kRACPKeyNumberOfRecords];
    } else {
        return nil;
    }
}

- (RACPOpCode)responseOpCode;
{
    return [[self objectForKey:kRACPKeyResponseOpCode] unsignedIntegerValue];
}
- (RACPOpCode)requestOpCode;
{
    if ([self isGeneralResponse]) {
        return [[[self objectForKey:kRACPKeyResponseCodeDetails] objectForKey:kRACPKeyRequestOpCode] unsignedIntegerValue];
    } else {
        return 255;
    }
}

- (RACPResponseCode)responseCodeValue;
{
    if ([self isGeneralResponse]) {
        return [[[self objectForKey:kRACPKeyResponseCodeDetails] objectForKey:kRACPKeyResponseCode] unsignedIntegerValue];
    } else {
        return 255;
    }
}


@end
