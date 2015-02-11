//
//  CBCentralManager+StateString.m
//  UHNBLEDemo
//
//  Created by Jay Moore on 2014-05-29.
//  Copyright (c) 2015 University Health Network.
//

#import "CBCentralManager+StateString.h"

@implementation CBCentralManager (StateString)

- (NSString*) stringForState:(CBCentralManagerState)state;
{
    NSString *stringState;
    switch (state) {
        case CBCentralManagerStateResetting:
            stringState = @"CBCentralManagerStateResetting";
            break;
        case CBCentralManagerStateUnsupported:
            stringState = @"CBCentralManagerStateUnsupported";
            break;
        case CBCentralManagerStateUnauthorized:
            stringState = @"CBCentralManagerStateUnauthorized";
            break;
        case CBCentralManagerStatePoweredOff:
            stringState = @"CBCentralManagerStatePoweredOff";
            break;
        case CBCentralManagerStatePoweredOn:
            stringState = @"CBCentralManagerStatePoweredOn";
            break;
        case CBCentralManagerStateUnknown:
        default:
            stringState = @"CBCentralManagerStateUnknown";
            break;
    }
    return stringState;
}

@end
