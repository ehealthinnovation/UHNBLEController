//
//  RACPParserTests.m
//  UHNBLEController
//
//  Created by Nathaniel Hamming on 2015-02-12.
//  Copyright (c) 2015 University Health Network.
//

#import <UHNBLEController/UHNRecordAccessControlPoint.h>

SpecBegin(RACPParserSpecs)

describe(@"RACP response parsing", ^{
    
    it(@"should be able to parse a successful report records response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){RACPOpCodeResponse, RACPOperatorNull, RACPOpCodeStoredRecordsReport, RACPSuccess} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beTruthy;
        expect([racpResponseDetails responseOpCode]).to.equal(RACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(RACPOpCodeStoredRecordsReport);
        expect([racpResponseDetails responseCodeValue]).to.equal(RACPSuccess);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse a not supported op code response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){RACPOpCodeResponse, RACPOperatorNull, RACPOpCodeStoredRecordsDelete, RACPNotSupportedOpCode} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(RACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(RACPOpCodeStoredRecordsDelete);
        expect([racpResponseDetails responseCodeValue]).to.equal(RACPNotSupportedOpCode);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse a not supported operator response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){RACPOpCodeResponse, RACPOperatorNull, RACPOpCodeStoredRecordsDelete, RACPNotSupportedOperator} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(RACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(RACPOpCodeStoredRecordsDelete);
        expect([racpResponseDetails responseCodeValue]).to.equal(RACPNotSupportedOperator);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse a not supported operand response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){RACPOpCodeResponse, RACPOperatorNull, RACPOpCodeStoredRecordsDelete, RACPNotSupportedOperand} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(RACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(RACPOpCodeStoredRecordsDelete);
        expect([racpResponseDetails responseCodeValue]).to.equal(RACPNotSupportedOperand);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse a invalid operator response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){RACPOpCodeResponse, RACPOperatorNull, RACPOpCodeStoredRecordsDelete, RACPInvalidOperator} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(RACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(RACPOpCodeStoredRecordsDelete);
        expect([racpResponseDetails responseCodeValue]).to.equal(RACPInvalidOperator);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse a invalid operand response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){RACPOpCodeResponse, RACPOperatorNull, RACPOpCodeStoredRecordsDelete, RACPInvalidOperand} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(RACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(RACPOpCodeStoredRecordsDelete);
        expect([racpResponseDetails responseCodeValue]).to.equal(RACPInvalidOperand);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse a no records found response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){RACPOpCodeResponse, RACPOperatorNull, RACPOpCodeStoredRecordsReportNumber, RACPNoRecordsFound} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(RACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(RACPOpCodeStoredRecordsReportNumber);
        expect([racpResponseDetails responseCodeValue]).to.equal(RACPNoRecordsFound);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse an abort unsuccessful response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){RACPOpCodeResponse, RACPOperatorNull, RACPOpCodeAbortOperation, RACPAbortUnsuccessful} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(RACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(RACPOpCodeAbortOperation);
        expect([racpResponseDetails responseCodeValue]).to.equal(RACPAbortUnsuccessful);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse an abort unsuccessful response", ^{
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){RACPOpCodeResponse, RACPOperatorNull, RACPOpCodeStoredRecordsReportNumber, RACPProcedureNotCompleted} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beTruthy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beFalsy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(RACPOpCodeResponse);
        expect([racpResponseDetails requestOpCode]).to.equal(RACPOpCodeStoredRecordsReportNumber);
        expect([racpResponseDetails responseCodeValue]).to.equal(RACPProcedureNotCompleted);
        expect([racpResponseDetails numberOfRecords]).to.beNil;
    });
    
    it(@"should be able to parse an number of stored records response", ^{
        uint16_t numOfRecords = 10;
        NSData *successfulReportRecordReponse = [NSData dataWithBytes:(char[]){RACPOpCodeResponseStoredRecordsReportNumber, RACPOperatorNull, numOfRecords, numOfRecords >> 8} length:4];
        NSDictionary *racpResponseDetails = [successfulReportRecordReponse parseRACPResponse];
        expect([racpResponseDetails isGeneralResponse]).to.beFalsy;
        expect([racpResponseDetails isNumberOfRecordResponse]).to.beTruthy;
        expect([racpResponseDetails isSuccessfulResponseReportRecords]).to.beFalsy;
        expect([racpResponseDetails responseOpCode]).to.equal(RACPOpCodeResponseStoredRecordsReportNumber);
        expect([racpResponseDetails requestOpCode]).to.equal(255); // no request op code found
        expect([racpResponseDetails responseCodeValue]).to.equal(255); // no response code value found
        expect([racpResponseDetails numberOfRecords]).to.equal(10);
    });
    
});

SpecEnd
