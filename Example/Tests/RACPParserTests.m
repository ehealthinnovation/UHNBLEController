//
//  RACPParserTests.m
//  UHNBLEController
//
//  Created by Nathaniel Hamming on 2015-02-12.
//  Copyright (c) 2015 University Health Network.
//

#import <UHNBLEController/RecordAccessControlPoint.h>

SpecBegin(RACPParserSpecs)

describe(@"RACP response parsing", ^{
    
    it(@"should be able to parse a successful report records response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){kRACPOpCodeResponse, kRACPOperatorNull, kRACPOpCodeStoredRecordsReport, kRACPSuccess} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beTruthy;
        expect([racpResponseDetails responseOpCode]).to.equal(kRACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(kRACPOpCodeStoredRecordsReport);
        expect([racpResponseDetails responseCodeValue]).to.equal(kRACPSuccess);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse a not supported op code response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){kRACPOpCodeResponse, kRACPOperatorNull, kRACPOpCodeStoredRecordsDelete, kRACPNotSupportedOpCode} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(kRACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(kRACPOpCodeStoredRecordsDelete);
        expect([racpResponseDetails responseCodeValue]).to.equal(kRACPNotSupportedOpCode);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse a not supported operator response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){kRACPOpCodeResponse, kRACPOperatorNull, kRACPOpCodeStoredRecordsDelete, kRACPNotSupportedOperator} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(kRACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(kRACPOpCodeStoredRecordsDelete);
        expect([racpResponseDetails responseCodeValue]).to.equal(kRACPNotSupportedOperator);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse a not supported operand response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){kRACPOpCodeResponse, kRACPOperatorNull, kRACPOpCodeStoredRecordsDelete, kRACPNotSupportedOperand} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(kRACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(kRACPOpCodeStoredRecordsDelete);
        expect([racpResponseDetails responseCodeValue]).to.equal(kRACPNotSupportedOperand);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse a invalid operator response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){kRACPOpCodeResponse, kRACPOperatorNull, kRACPOpCodeStoredRecordsDelete, kRACPInvalidOperator} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(kRACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(kRACPOpCodeStoredRecordsDelete);
        expect([racpResponseDetails responseCodeValue]).to.equal(kRACPInvalidOperator);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse a invalid operand response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){kRACPOpCodeResponse, kRACPOperatorNull, kRACPOpCodeStoredRecordsDelete, kRACPInvalidOperand} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(kRACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(kRACPOpCodeStoredRecordsDelete);
        expect([racpResponseDetails responseCodeValue]).to.equal(kRACPInvalidOperand);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse a no records found response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){kRACPOpCodeResponse, kRACPOperatorNull, kRACPOpCodeStoredRecordsReportNumber, kRACPNoRecordsFound} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(kRACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(kRACPOpCodeStoredRecordsReportNumber);
        expect([racpResponseDetails responseCodeValue]).to.equal(kRACPNoRecordsFound);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse an abort unsuccessful response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){kRACPOpCodeResponse, kRACPOperatorNull, kRACPOpCodeAbortOperation, kRACPAbortUnsuccessful} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(kRACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(kRACPOpCodeAbortOperation);
        expect([racpResponseDetails responseCodeValue]).to.equal(kRACPAbortUnsuccessful);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse an abort unsuccessful response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){kRACPOpCodeResponse, kRACPOperatorNull, kRACPOpCodeStoredRecordsReportNumber, kRACPProcedureNotCompleted} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(kRACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(kRACPOpCodeStoredRecordsReportNumber);
        expect([racpResponseDetails responseCodeValue]).to.equal(kRACPProcedureNotCompleted);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse an number of stored records response", ^{
        uint16_t numOfRecords = 10;
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){kRACPOpCodeResponseStoredRecordsReportNumber, kRACPOperatorNull, numOfRecords, numOfRecords >> 8} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beFalsy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beTruthy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(kRACPOpCodeResponseStoredRecordsReportNumber);
        expect([racpResponseDetails requestOpCode]).to.equal(255); // no request op code found
        expect([racpResponseDetails responseCodeValue]).to.equal(255); // no response code value found
        expect([racpResponseDetails numberOfRecords]).to.equal(10);
    });
    
});

SpecEnd
