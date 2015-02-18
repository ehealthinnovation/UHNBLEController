//
//  NSData+RACPParser.m
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 2015-01-16.
//  Copyright (c) 2015 University Health Network.
//

#import "NSData+RACPParser.h"
#import "NSData+ConversionExtensions.h"
#import "UHNDebug.h"

@implementation NSData (RACPParser)

- (NSDictionary*)parseRACPResponse;
{
    RACPOpCode opCode = [self parseRACPResponseOpCode];
    NSMutableDictionary *responseDict = [NSMutableDictionary dictionaryWithObject: [NSNumber numberWithUnsignedInteger: opCode] forKey: kRACPKeyResponseOpCode];
    switch (opCode) {
        case RACPOpCodeResponseStoredRecordsReportNumber:
        {
            NSUInteger numOfRecords = [self parseRACPResponseNumberOfRecords];
            responseDict[kRACPKeyNumberOfRecords] = [NSNumber numberWithUnsignedInteger: numOfRecords];
            break;
        }
        case RACPOpCodeResponse:
        {
            NSDictionary *responseDetails = [self parseRACPResponseCodeDetails];
            responseDict[kRACPKeyResponseCodeDetails] = responseDetails;
            break;
        }
        default:
            DLog(@"Do not know about RACP operation with code %d", opCode);
            break;
    }
    return responseDict;
}

- (RACPOpCode)parseRACPResponseOpCode;
{
    RACPOpCode responseOpCode = [self unsignedIntegerAtRange: (NSRange)kRACPResponseFieldRangeOpCode];
    return responseOpCode;
}

- (RACPOperator)parseRACPResponseOperator;
{
    RACPOperator responseOperator = [self unsignedIntegerAtRange: (NSRange)kRACPResponseFieldRangeOperator];
    return responseOperator;
}

- (NSUInteger)parseRACPResponseNumberOfRecords;
{
    NSUInteger numberOfRecords = [self unsignedIntegerAtRange: (NSRange)kRACPResponseFieldRangeNumberOfRecords];
    return numberOfRecords;
}

- (NSDictionary*)parseRACPResponseCodeDetails;
{
    RACPOpCode requestOpCode = [self parseRACPRequestOpCode];
    NSUInteger responseValue = [self parseRACPResponseCode];
    return @{kRACPKeyRequestOpCode: [NSNumber numberWithUnsignedInteger: requestOpCode], kRACPKeyResponseCode: [NSNumber numberWithUnsignedInteger: responseValue]};
}

- (RACPOpCode)parseRACPRequestOpCode;
{
    RACPOpCode requestOpCode = [self unsignedIntegerAtRange: (NSRange)kRACPResponseFieldRangeRequestOpCode];
    return requestOpCode;
}

- (NSUInteger)parseRACPResponseCode;
{
    NSUInteger responseValue = [self unsignedIntegerAtRange: (NSRange)kRACPResponseFieldRangeResponseValue];
    return responseValue;
}


@end
