//
//  UHNRACPConstants.h
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 2015-01-15.
//  Copyright (c) 2015 University Health Network.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

///--------------------------------
/// @name RACP Reponse Field Ranges
///--------------------------------
/**
 Record access control point response field ranges. Note that they are type casted to make easy use in code
 */
#define kRACPResponseFieldRangeOpCode           (NSRange){0,1}
#define kRACPResponseFieldRangeOperator         (NSRange){1,1}
#define kRACPResponseFieldRangeNumberOfRecords  (NSRange){2,2}
#define kRACPResponseFieldRangeRequestOpCode    (NSRange){2,1}
#define kRACPResponseFieldRangeResponseValue    (NSRange){3,1}

///----------------
/// @name RACP Keys
///----------------
#define kRACPKeyResponseOpCode @"RACPResponseOpCode"
#define kRACPKeyRequestOpCode @"RACPResponseRequestOpCode"
#define kRACPKeyResponseCode @"RACPResponseCode"
#define kRACPKeyResponseCodeDetails @"RACPResponseCodeDetails"
#define kRACPKeyNumberOfRecords @"RACPNumberOfRecords"

///---------------------------
/// @name RACP Operation Codes
///---------------------------
/**
 All possible record access control point operation codes with their assigned value
 */
typedef NS_ENUM(uint8_t, RACPOpCode) {
    /** Op Code for requesting a report of the stored records */
    RACPOpCodeStoredRecordsReport = 1,
    /** Op Code for requesting a delete of the stored records */
    RACPOpCodeStoredRecordsDelete,
    /** Op Code for requesting an abort of the previous operation */
    RACPOpCodeAbortOperation,
    /** Op Code for requesting the number of stored records */
    RACPOpCodeStoredRecordsReportNumber,
    /** Op Code for the response for the number of stored records */
    RACPOpCodeResponseStoredRecordsReportNumber,
    /** Op Code for a general response */
    RACPOpCodeResponse
};

///---------------------
/// @name RACP Operators
///---------------------
/**
 All possible record access control point operators with their assigned value
 */
typedef NS_ENUM(uint8_t, RACPOperator) {
    /** The NULL operator. Used when an operator isn't required */
    RACPOperatorNull = 0,
    /** Operator for indicating all records */
    RACPOperatorRecordsAll,
    /** Operator for indicating less than or equal to */
    RACPOperatorLessThanEqualTo,
    /** Operator for indicating greater thatn or equal to */
    RACPOperatorGreaterThanEqualTo,
    /** Operator for indicating within a given range */
    RACPOperatorWithinRange,
    /** Operator for indicating the first record */
    RACPOperatorRecordFirst,
    /** Operator for indicating the last record */
    RACPOperatorRecordLast
};

///------------------------
/// @name RACP Filter Types
///------------------------
/**
 All possible record access control point filter types with their assigned value
 */
typedef NS_ENUM(uint8_t, RACPFilterType) {
    /** Filter type of sequence number */
    RACPFilterTypeSquenceNumber = 1,
    /** Filter type of time offset */
    RACPFilterTypeTimeOffset = 1,
    /** Filter type of user facing time */
    RACPFilterTypeUserFacingTime = 2,
};

///--------------------------
/// @name RACP Response Codes
///--------------------------
/**
 All possible record access control point response codes with their assigned value
 */
typedef NS_ENUM(uint8_t, RACPResponseCode) {
    /** Response code for success */
    RACPSuccess = 1,
    /** Response code for op code not supported */
    RACPNotSupportedOpCode,
    /** Response code for invalid operator */
    RACPInvalidOperator,
    /** Response code for not supported operator */
    RACPNotSupportedOperator,
    /** Response code for invalid operand */
    RACPInvalidOperand,
    /** Response code for no records found */
    RACPNoRecordsFound,
    /** Response code for abort unsuccessful */
    RACPAbortUnsuccessful,
    /** Response code for procedure not completed */
    RACPProcedureNotCompleted,
    /** Response code for not supported operand */
    RACPNotSupportedOperand,
};
