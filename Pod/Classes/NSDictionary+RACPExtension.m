//
//  NSDictionary+RACPExtension.m
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 2015-02-09.
//  Copyright (c) 2015 University Health Network.
//

#import "NSDictionary+RACPExtension.h"

@implementation NSDictionary (RACPExtension)

- (BOOL)isNumberOfRecordResponse;
{
    RACPOpCode opCode = [self responseOpCode];
    if (opCode == kRACPOpCodeResponseStoredRecordsReportNumber) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isGeneralResponse;
{
    RACPOpCode opCode = [self responseOpCode];
    if (opCode == kRACPOpCodeResponse) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isSuccessfulResponseReportRecords;
{
    return [self isSuccessfulResponseOfType: kRACPOpCodeStoredRecordsReport];
}

- (BOOL)isSuccessfulResponseDeleteRecords;
{
    return [self isSuccessfulResponseOfType: kRACPOpCodeStoredRecordsDelete];
}

- (BOOL)isSuccessfulResponseAbort;
{
    return [self isSuccessfulResponseOfType: kRACPOpCodeAbortOperation];
}

- (BOOL)isSuccessfulResponseOfType: (RACPOpCode)opCode
{
    if ([self isGeneralResponse]) {
        RACPOpCode requestOpCode = [self requestOpCode];
        RACPResponseCode responseCode = [self responseCodeValue];
        if (requestOpCode == opCode && responseCode == kRACPSuccess) {
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
    return [[[self objectForKey:kRACPKeyResponseCodeDetails] objectForKey:kRACPKeyRequestOpCode] unsignedIntegerValue];
}

- (RACPResponseCode)responseCodeValue;
{
    return [[[self objectForKey:kRACPKeyResponseCodeDetails] objectForKey:kRACPKeyResponseCode] unsignedIntegerValue];
}


@end
