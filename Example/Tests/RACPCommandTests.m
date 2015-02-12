//
//  RACPCommandTests.m
//  UHNBLEController
//
//  Created by Nathaniel Hamming on 2015-02-12.
//  Copyright (c) 2015 University Health Network.
//

#import <UHNBLEController/RecordAccessControlPoint.h>

SpecBegin(RACPCommandSpecs)

describe(@"RACP report stored records command formatting", ^{
    
    it(@"should construct a report all stored records command", ^{
        NSData *reportAllRecordsCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsReport, kRACPOperatorRecordsAll} length:2];
        NSData *testCommand = [NSData reportAllStoredRecords];
        expect(testCommand).to.equal(reportAllRecordsCommand);
    });

    it(@"should construct a report first stored record command", ^{
        NSData *reportFirstRecordCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsReport, kRACPOperatorRecordFirst} length:2];
        NSData *testCommand = [NSData reportFirstStoredRecord];
        expect(testCommand).to.equal(reportFirstRecordCommand);
    });

    it(@"should construct a report last stored record command", ^{
        NSData *reportLastRecordCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsReport, kRACPOperatorRecordLast} length:2];
        NSData *testCommand = [NSData reportLastStoredRecord];
        expect(testCommand).to.equal(reportLastRecordCommand);
    });

    it(@"should construct a report stored records less than or equal to command", ^{
        uint16_t maxTimeOffset = 15;
        NSData *reportRecordsLessThanCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsReport, kRACPOperatorLessThanEqualTo, kRACPFilterTypeTimeOffset, maxTimeOffset, maxTimeOffset >> 8} length:5];
        NSData *testCommand = [NSData reportStoredRecordsLessThanOrEqualToTimeOffset: 15];
        expect(testCommand).to.equal(reportRecordsLessThanCommand);
    });
    
    it(@"should construct a report stored records greater than or equal to command", ^{
        uint16_t minTimeOffset = 30;
        NSData *reportRecordsGreaterThanCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsReport, kRACPOperatorGreaterThanEqualTo, kRACPFilterTypeTimeOffset, minTimeOffset, minTimeOffset >> 8} length:5];
        NSData *testCommand = [NSData reportStoredRecordsGreaterThanOrEqualToTimeOffset: 30];
        expect(testCommand).to.equal(reportRecordsGreaterThanCommand);
    });
    
    it(@"should construct a report stored records between command", ^{
        uint16_t minTimeOffset = 30;
        uint16_t maxTimeOffset = 15;
        NSData *reportRecordsBetweenCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsReport, kRACPOperatorWithinRange, kRACPFilterTypeTimeOffset, minTimeOffset, minTimeOffset >> 8, maxTimeOffset, maxTimeOffset >> 8} length:7];
        NSData *testCommand = [NSData reportStoredRecordsBetween:minTimeOffset and:maxTimeOffset];
        expect(testCommand).to.equal(reportRecordsBetweenCommand);
    });
    
});

describe(@"RACP delete stored records command formatting", ^{
    
    it(@"should construct a delete all stored records command", ^{
        NSData *deleteAllRecordsCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsDelete, kRACPOperatorRecordsAll} length:2];
        NSData *testCommand = [NSData deleteAllStoredRecords];
        expect(testCommand).to.equal(deleteAllRecordsCommand);
    });
    
    it(@"should construct a delete first stored record command", ^{
        NSData *deleteFirstRecordCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsDelete, kRACPOperatorRecordFirst} length:2];
        NSData *testCommand = [NSData deleteFirstStoredRecord];
        expect(testCommand).to.equal(deleteFirstRecordCommand);
    });
    
    it(@"should construct a delete last stored record command", ^{
        NSData *deleteLastRecordCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsDelete, kRACPOperatorRecordLast} length:2];
        NSData *testCommand = [NSData deleteLastStoredRecord];
        expect(testCommand).to.equal(deleteLastRecordCommand);
    });
    
    it(@"should construct a delete stored records less than or equal to command", ^{
        uint16_t maxTimeOffset = 15;
        NSData *deleteRecordsLessThanCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsDelete, kRACPOperatorLessThanEqualTo, kRACPFilterTypeTimeOffset, maxTimeOffset, maxTimeOffset >> 8} length:5];
        NSData *testCommand = [NSData deleteStoredRecordsLessThanOrEqualToTimeOffset: 15];
        expect(testCommand).to.equal(deleteRecordsLessThanCommand);
    });
    
    it(@"should construct a delete stored records greater than or equal to command", ^{
        uint16_t minTimeOffset = 30;
        NSData *deleteRecordsGreaterThanCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsDelete, kRACPOperatorGreaterThanEqualTo, kRACPFilterTypeTimeOffset, minTimeOffset, minTimeOffset >> 8} length:5];
        NSData *testCommand = [NSData deleteStoredRecordsGreaterThanOrEqualToTimeOffset: 30];
        expect(testCommand).to.equal(deleteRecordsGreaterThanCommand);
    });
    
    it(@"should construct a delete stored records between command", ^{
        uint16_t minTimeOffset = 30;
        uint16_t maxTimeOffset = 15;
        NSData *deleteRecordsBetweenCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsDelete, kRACPOperatorWithinRange, kRACPFilterTypeTimeOffset, minTimeOffset, minTimeOffset >> 8, maxTimeOffset, maxTimeOffset >> 8} length:7];
        NSData *testCommand = [NSData deleteStoredRecordsBetween:minTimeOffset and:maxTimeOffset];
        expect(testCommand).to.equal(deleteRecordsBetweenCommand);
    });
    
});

describe(@"RACP report number of stored records command formatting", ^{
    
    it(@"should construct a report number of all stored records command", ^{
        NSData *reportNumberOfAllRecordsCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsReportNumber, kRACPOperatorRecordsAll} length:2];
        NSData *testCommand = [NSData reportNumberOfAllStoredRecords];
        expect(testCommand).to.equal(reportNumberOfAllRecordsCommand);
    });
    
    it(@"should construct a report number of first stored record command", ^{
        NSData *reportNumberOfFirstRecordCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsReportNumber, kRACPOperatorRecordFirst} length:2];
        NSData *testCommand = [NSData reportNumberOfFirstStoredRecord];
        expect(testCommand).to.equal(reportNumberOfFirstRecordCommand);
    });
    
    it(@"should construct a delete last stored record command", ^{
        NSData *reportNumberOfLastRecordCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsReportNumber, kRACPOperatorRecordLast} length:2];
        NSData *testCommand = [NSData reportNumberOfLastStoredRecord];
        expect(testCommand).to.equal(reportNumberOfLastRecordCommand);
    });
    
    it(@"should construct a delete stored records less than or equal to command", ^{
        uint16_t maxTimeOffset = 15;
        NSData *reportNumberOfRecordsLessThanCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsReportNumber, kRACPOperatorLessThanEqualTo, kRACPFilterTypeTimeOffset, maxTimeOffset, maxTimeOffset >> 8} length:5];
        NSData *testCommand = [NSData reportNumberOfStoredRecordsLessThanOrEqualToTimeOffset: 15];
        expect(testCommand).to.equal(reportNumberOfRecordsLessThanCommand);
    });
    
    it(@"should construct a delete stored records greater than or equal to command", ^{
        uint16_t minTimeOffset = 30;
        NSData *reportNumberOfRecordsGreaterThanCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsReportNumber, kRACPOperatorGreaterThanEqualTo, kRACPFilterTypeTimeOffset, minTimeOffset, minTimeOffset >> 8} length:5];
        NSData *testCommand = [NSData reportNumberOfStoredRecordsGreaterThanOrEqualToTimeOffset: 30];
        expect(testCommand).to.equal(reportNumberOfRecordsGreaterThanCommand);
    });
    
    it(@"should construct a delete stored records between command", ^{
        uint16_t minTimeOffset = 30;
        uint16_t maxTimeOffset = 15;
        NSData *reportNumberOfRecordsBetweenCommand = [NSData dataWithBytes:(char[]){kRACPOpCodeStoredRecordsReportNumber, kRACPOperatorWithinRange, kRACPFilterTypeTimeOffset, minTimeOffset, minTimeOffset >> 8, maxTimeOffset, maxTimeOffset >> 8} length:7];
        NSData *testCommand = [NSData reportNumberOfStoredRecordsBetween:minTimeOffset and:maxTimeOffset];
        expect(testCommand).to.equal(reportNumberOfRecordsBetweenCommand);
    });
    
});

describe(@"RACP abort command formatting", ^{
    
    it(@"should construct an abort command", ^{
        NSData *abortCommnd = [NSData dataWithBytes:(char[]){kRACPOpCodeAbortOperation, kRACPOperatorNull} length:2];
        NSData *testCommand = [NSData abortOperation];
        expect(testCommand).to.equal(abortCommnd);
    });
    
});

SpecEnd
