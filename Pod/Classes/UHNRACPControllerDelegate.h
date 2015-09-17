//
//  UHNRACPControllerDelegate.h
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

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "UHNRACPConstants.h"

/**
 The UHNRACPControllerDelegate protocol defines the methods that a delegate of a UHNRACPController object must adopt. The optional methods of the protocol allow the delegate to be notified upon completion of RACP operations.
 
 */
@protocol UHNRACPControllerDelegate <NSObject>

@optional

/**
 Notifies the delegate after a successful RACP operation
 
 @param controller The `UHNRACPController` that initiated the RACP operation, which could be any of a number of different controller types, hence its type is 'id'
 @param enabled The state that the RACP notification was set to
 
 @discussion This method is invoked after successful completion of an RACP operation
 
 */
- (void) racpController:(id) controller didSetNotificationStateRACP:(BOOL) enabled;

/**
 Notifies the delegate after a successful RACP operation
 
 @param controller The `UHNRACPController` that initiated the RACP operation, which could be any of a number of different controller types, hence its type is 'id'
 @param opCode The opCode of the operation
 
 @discussion This method is invoked after successful completion of an RACP operation
 
 */
- (void) racpController:(id) controller RACPOperationSuccessful:(RACPOpCode) opCode;

/**
 Notifies the delegate after a failed RACP operation
 
 @param controller The `UHNRACPController` that initiated the RACP operation, which could be any of a number of different controller types, hence its type is 'id'
 @param opCode The opCode of the operation
 @param responseCode The responseCode of the characteristic after the failed operation
 
 @discussion This method is invoked after failure from of an RACP operation
 
 */
- (void) racpController:(id) controller RACPOperation:(RACPOpCode) opCode failed:(RACPResponseCode) responseCode;


@end