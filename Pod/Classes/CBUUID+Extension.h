//
//  CBUUID+Extension.h
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 12-02-06.
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

#import <CoreBluetooth/CoreBluetooth.h>

/**
 `CBUUID+Extension` provides convenience methods for comparing and converting to strings
 */
@interface CBUUID (Extension)

/**  
 Checks if the receiver is equal to the given `CBUUID`
 
 @param uuid The CBUUID with which to compare the receiver.
 
 @return `YES` if uuid is equivalent to the receiver, otherwise `NO`
 */
- (BOOL)isEqualToCBUUID:(CBUUID*)uuid;

/**
 Converts the receiver to a `char *` string
 
 @return The receiver as a `char *` string
 */
- (const char*)toCharString;

/**
 Converts the receiver to an `NSString`
 
 @return The receiver as a `NSString`
 */
- (NSString*)toString;

@end
