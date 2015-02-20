//
//  RACPCommandTests.m
//  UHNBLEController
//
//  Created by Nathaniel Hamming on 2015-02-12.
//  Copyright (c) 2015 University Health Network.
//

#import <UHNBLEController/UHNRecordAccessControlPoint.h>

SpecBegin(RACPCommandSpecs)

describe(@"RACP report stored records command formatting", ^{
    
    it(@"should construct a report all stored records command", ^{
        NSData *reportAllRecordsCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsReport, RACPOperatorRecordsAll} length:2];
        NSData *testCommand = [NSData reportAllStoredRecords];
        expect(testCommand).to.equal(reportAllRecordsCommand);
    });

    it(@"should construct a report first stored record command", ^{
        NSData *reportFirstRecordCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsReport, RACPOperatorRecordFirst} length:2];
        NSData *testCommand = [NSData reportFirstStoredRecord];
        expect(testCommand).to.equal(reportFirstRecordCommand);
    });

    it(@"should construct a report last stored record command", ^{
        NSData *reportLastRecordCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsReport, RACPOperatorRecordLast} length:2];
        NSData *testCommand = [NSData reportLastStoredRecord];
        expect(testCommand).to.equal(reportLastRecordCommand);
    });

    it(@"should construct a report stored records less than or equal to command", ^{
        uint16_t maxTimeOffset = 15;
        NSData *reportRecordsLessThanCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsReport, RACPOperatorLessThanEqualTo, RACPFilterTypeTimeOffset, maxTimeOffset, maxTimeOffset >> 8} length:5];
        NSData *testCommand = [NSData reportStoredRecordsLessThanOrEqualToTimeOffset: 15];
        expect(testCommand).to.equal(reportRecordsLessThanCommand);
    });
    
    it(@"should construct a report stored records greater than or equal to command", ^{
        uint16_t minTimeOffset = 30;
        NSData *reportRecordsGreaterThanCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsReport, RACPOperatorGreaterThanEqualTo, RACPFilterTypeTimeOffset, minTimeOffset, minTimeOffset >> 8} length:5];
        NSData *testCommand = [NSData reportStoredRecordsGreaterThanOrEqualToTimeOffset: 30];
        expect(testCommand).to.equal(reportRecordsGreaterThanCommand);
    });
    
    it(@"should construct a report stored records between command", ^{
        uint16_t minTimeOffset = 30;
        uint16_t maxTimeOffset = 15;
        NSData *reportRecordsBetweenCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsReport, RACPOperatorWithinRange, RACPFilterTypeTimeOffset, minTimeOffset, minTimeOffset >> 8, maxTimeOffset, maxTimeOffset >> 8} length:7];
        NSData *testCommand = [NSData reportStoredRecordsBetween:minTimeOffset and:maxTimeOffset];
        expect(testCommand).to.equal(reportRecordsBetweenCommand);
    });
    
});

describe(@"RACP delete stored records command formatting", ^{
    
    it(@"should construct a delete all stored records command", ^{
        NSData *deleteAllRecordsCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsDelete, RACPOperatorRecordsAll} length:2];
        NSData *testCommand = [NSData deleteAllStoredRecords];
        expect(testCommand).to.equal(deleteAllRecordsCommand);
    });
    
    it(@"should construct a delete first stored record command", ^{
        NSData *deleteFirstRecordCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsDelete, RACPOperatorRecordFirst} length:2];
        NSData *testCommand = [NSData deleteFirstStoredRecord];
        expect(testCommand).to.equal(deleteFirstRecordCommand);
    });
    
    it(@"should construct a delete last stored record command", ^{
        NSData *deleteLastRecordCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsDelete, RACPOperatorRecordLast} length:2];
        NSData *testCommand = [NSData deleteLastStoredRecord];
        expect(testCommand).to.equal(deleteLastRecordCommand);
    });
    
    it(@"should construct a delete stored records less than or equal to command", ^{
        uint16_t maxTimeOffset = 15;
        NSData *deleteRecordsLessThanCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsDelete, RACPOperatorLessThanEqualTo, RACPFilterTypeTimeOffset, maxTimeOffset, maxTimeOffset >> 8} length:5];
        NSData *testCommand = [NSData deleteStoredRecordsLessThanOrEqualToTimeOffset: 15];
        expect(testCommand).to.equal(deleteRecordsLessThanCommand);
    });
    
    it(@"should construct a delete stored records greater than or equal to command", ^{
        uint16_t minTimeOffset = 30;
        NSData *deleteRecordsGreaterThanCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsDelete, RACPOperatorGreaterThanEqualTo, RACPFilterTypeTimeOffset, minTimeOffset, minTimeOffset >> 8} length:5];
        NSData *testCommand = [NSData deleteStoredRecordsGreaterThanOrEqualToTimeOffset: 30];
        expect(testCommand).to.equal(deleteRecordsGreaterThanCommand);
    });
    
    it(@"should construct a delete stored records between command", ^{
        uint16_t minTimeOffset = 30;
        uint16_t maxTimeOffset = 15;
        NSData *deleteRecordsBetweenCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsDelete, RACPOperatorWithinRange, RACPFilterTypeTimeOffset, minTimeOffset, minTimeOffset >> 8, maxTimeOffset, maxTimeOffset >> 8} length:7];
        NSData *testCommand = [NSData deleteStoredRecordsBetween:minTimeOffset and:maxTimeOffset];
        expect(testCommand).to.equal(deleteRecordsBetweenCommand);
    });
    
});

describe(@"RACP report number of stored records command formatting", ^{
    
    it(@"should construct a report number of all stored records command", ^{
        NSData *reportNumberOfAllRecordsCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsReportNumber, RACPOperatorRecordsAll} length:2];
        NSData *testCommand = [NSData reportNumberOfAllStoredRecords];
        expect(testCommand).to.equal(reportNumberOfAllRecordsCommand);
    });
    
    it(@"should construct a report number of first stored record command", ^{
        NSData *reportNumberOfFirstRecordCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsReportNumber, RACPOperatorRecordFirst} length:2];
        NSData *testCommand = [NSData reportNumberOfFirstStoredRecord];
        expect(testCommand).to.equal(reportNumberOfFirstRecordCommand);
    });
    
    it(@"should construct a delete last stored record command", ^{
        NSData *reportNumberOfLastRecordCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsReportNumber, RACPOperatorRecordLast} length:2];
        NSData *testCommand = [NSData reportNumberOfLastStoredRecord];
        expect(testCommand).to.equal(reportNumberOfLastRecordCommand);
    });
    
    it(@"should construct a delete stored records less than or equal to command", ^{
        uint16_t maxTimeOffset = 15;
        NSData *reportNumberOfRecordsLessThanCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsReportNumber, RACPOperatorLessThanEqualTo, RACPFilterTypeTimeOffset, maxTimeOffset, maxTimeOffset >> 8} length:5];
        NSData *testCommand = [NSData reportNumberOfStoredRecordsLessThanOrEqualToTimeOffset: 15];
        expect(testCommand).to.equal(reportNumberOfRecordsLessThanCommand);
    });
    
    it(@"should construct a delete stored records greater than or equal to command", ^{
        uint16_t minTimeOffset = 30;
        NSData *reportNumberOfRecordsGreaterThanCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsReportNumber, RACPOperatorGreaterThanEqualTo, RACPFilterTypeTimeOffset, minTimeOffset, minTimeOffset >> 8} length:5];
        NSData *testCommand = [NSData reportNumberOfStoredRecordsGreaterThanOrEqualToTimeOffset: 30];
        expect(testCommand).to.equal(reportNumberOfRecordsGreaterThanCommand);
    });
    
    it(@"should construct a delete stored records between command", ^{
        uint16_t minTimeOffset = 30;
        uint16_t maxTimeOffset = 15;
        NSData *reportNumberOfRecordsBetweenCommand = [NSData dataWithBytes:(char[]){RACPOpCodeStoredRecordsReportNumber, RACPOperatorWithinRange, RACPFilterTypeTimeOffset, minTimeOffset, minTimeOffset >> 8, maxTimeOffset, maxTimeOffset >> 8} length:7];
        NSData *testCommand = [NSData reportNumberOfStoredRecordsBetween:minTimeOffset and:maxTimeOffset];
        expect(testCommand).to.equal(reportNumberOfRecordsBetweenCommand);
    });
    
});

describe(@"RACP abort command formatting", ^{
    
    it(@"should construct an abort command", ^{
        NSData *abortCommnd = [NSData dataWithBytes:(char[]){RACPOpCodeAbortOperation, RACPOperatorNull} length:2];
        NSData *testCommand = [NSData abortOperation];
        expect(testCommand).to.equal(abortCommnd);
    });
    
});

SpecEnd
