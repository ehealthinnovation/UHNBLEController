//
//  PeripheralDetailsViewController.h
//  UHNBLEController
//
//  Created by Nathaniel Hamming on 2015-02-10.
//  Copyright (c) 2015 Nathaniel Hamming. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPeripheralDeviceName @"PeripheralDeviceName"
#define kPeripheralAdvertisedServices @"PeripheralAdvertisedServices"
#define kPeripheralServices @"PeripheralServices"
#define kPeripheralServicesUUID @"PeripheralServicesUUID"
#define kPeripheralServiceCharacteristics @"PeripheralServiceCharacteristics"

@interface PeripheralDetailsViewController : UIViewController

- (instancetype)initWithPeripheralDetails: (NSDictionary*)peripheralDetails;

@end
