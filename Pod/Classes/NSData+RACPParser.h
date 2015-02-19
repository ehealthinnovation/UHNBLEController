//
//  NSData+RACPParser.h
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 2015-01-16.
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
 `NSData+RACPParser` provides record access control point (RACP) response parsing
 */
@interface NSData (RACPParser)

/**
 Parses an RACP response and provided the details in a dictionary using keys from the `RACPConstants.h`
 
 @return Dictionar of the RACP response details
 
 @discussion The RACP reponse has two formats; 1) an RACP number of records response or 2) RACP general response. Helper methods are available in `[NSDictionary+RACPExtension]` to interprete the dictionary.
 
 @discussion The number of records repsonse includes the number of records for the request in the `RACPNumberOfRecords` field and the report number of records reponse op code in the `RACPResponseOpCode`

    Example:
    {
        "RACPResponseOpCode": 5,
        "RACPNumberOfRecords": 10
    }
 
 @discussion For the general response, the op code for the RACP response is in the `RACPResponseOpCode` field with the response details in the `RACPResponseCodeDetails` field. The response details includes the requested op code in the `RACPResponseRequestOpCode` field and the response code value in the `RACPResponseCode` field.
 
    Example:
    {
        "RACPResponseOpCode": 6,
        "RACPResponseCodeDetails":    {
            RACPResponseRequestOpCode: 1,
            RACPResponseCode: 1
        }
    }
 
 */
- (NSDictionary*)parseRACPResponse;

@end
