//
//  NSDictionary+RACPExtensions.h
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 2015-02-09.
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

#import <Foundation/Foundation.h>
#import "UHNRACPConstants.h"

/**
 `NSDictionary+RACPExtensions` provides helper methods for interpreting the dictionary returned by the `[NSData+RACPParser]`
 */
@interface NSDictionary (RACPExtensions)

/**
 Checks if the RACP response details dictionary is a number of records response
 
 @return `YES` if the response was to a report number of records operation, otherwise `NO`
 
 */
- (BOOL)isNumberOfRecordResponse;

/**
 Checks if the RACP response details dictionary is a general response
 
 @return `YES` if the response was a general response, otherwise `NO`
 
 */
- (BOOL)isGeneralResponse;

/**
 Checks if the RACP response was a successful report records operation
 
 @return `YES` if the response was to a successful report records operation, otherwise `NO`
 
 */
- (BOOL)isSuccessfulResponseReportRecords;

/**
 Checks if the RACP response was a successful delete records operation
 
 @return `YES` if the response was to a successful delete records operation, otherwise `NO`
 
 */
- (BOOL)isSuccessfulResponseDeleteRecords;

/**
 Checks if the RACP response was a successful abort operation
 
 @return `YES` if the response was to a successful abort operation, otherwise `NO`
 
 */
- (BOOL)isSuccessfulResponseAbort;

/**
 Get the number of records from the RACP response details
 
 @return Returns the number of stored records for the request, otherwise nil (RACP response is not a response to report number of records).
 
 */
- (NSNumber*)numberOfRecords;

/**
 Get the RACP response op code
 
 @return Only two possible op codes, report number of records response or general response. The values are defined in `RACPConstants.h`
 
 */
- (RACPOpCode)responseOpCode;

/**
 Get the RACP request op code
 
 @return The request op code is the operation just completed by the RACP and for which these response details are related to. The values are defined in `RACPConstants.h`
 
 @discussion If a value of 255 is returned no request op code was found
 
 */
- (RACPOpCode)requestOpCode;

/**
 Get the RACP response code value
 
 @return Returns the value of the response code. The values are defined in `RACPConstants.h`
 
 @discussion If a value of 255 is returned no response code valuex was found
 
 */
- (RACPResponseCode)responseCodeValue;

@end
