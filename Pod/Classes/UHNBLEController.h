//
//  UHNBLEController.h
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
#import "UHNBLEConstants.h"

@protocol UHNBLEControllerDelegate;


/**
  The UHNBLEController provides a simplified interface to Core Bluetooth (CB) by handling fault checking and removing ann CB specific details. Through the inteface and delegate protocol, one should be able to easily make requests of a BLE peripheral device.
 */
@interface UHNBLEController : NSObject

///-----------------
/// @name Properties
///-----------------

/**
 Indicates if the OS should notify the user when a peripheral is connected
 */
@property(nonatomic,assign) BOOL notifyOnConnection;

/**
 Indicates if the OS should notify the user when a peripheral is disconnected
 */
@property(nonatomic,assign) BOOL notifyOnDisconnection;

/**
 Indicates if the OS should notify the user when the peripheral has issued a notification or indication
 */
@property(nonatomic,assign) BOOL notifyOnNotification;

/**
 Indicates if the last connected device should be stored for a future reconnection
 */
@property(nonatomic,assign) BOOL storeLastConnectedDeviceID;

///--------------------------------------
/// @name Initializing a UHNBLEController
///--------------------------------------

/** 
 UHNBLEController is initialized with a delegate and optional required services. 
 
 @param delegate The delegate object that will received discovery, connectivity, and read/write events. This parameter is mandatory.
 @param services The required services used to filter eligibility of discovered peripherals. Only peripherals that advertist all the required services will be deemed eligible and reported to the delegate. If `services` is `nil`, all peripherals discovered will be reported to the delegate.
 
 @return Instance of a UHNBLEController
 */
- (instancetype)initWithDelegate: (id<UHNBLEControllerDelegate>)delegate
                requiredServices: (NSArray*)services;

///-------------------------
/// @name Connection Methods
///-------------------------

/**
 Starts the connection process. If a peripheral was previously connected, it will try to reconnect to that peripheral. Otherwise, it starts a scan.
 
 @discussion automatically called when bluetooth is powered on
 
 */
- (void)startConnection;

/**
 Try to connect to a peripheral that was already discovered.
 
 @param deviceName The name of device which has been previously discovered and with which the delegate would like to connect
 
 @discussion When a peripheral is discovered, the delegate received a discovered peripheral event. `connectToDiscoveredDevice` should not be used to unless the delegate has already received a discovered peripheral event. 
 
 @discussion If this method makes a successful connection, the delegate could receive the `[UHNBLEControllerDelegate bleController:didConnectWithPeripheral:withUUID:]` event and the discovery of the provided required services during initiation is initiated. Once the required services have been discovered, the delegate could recieve the `[UHNBLEControllerDelegate bleController:didConnectWithPeripheral:withServices:andUUID:]` event and the discovery of all characteristics available for each of the required services is initiated. Once all the characeristics for all the required services have been discovered, the delegate could receive the `[UHNBLEControllerDelegate bleController:didDiscoverCharacteristics:forService:]` event. If required services are provided with instantiation of the UHNBLEController, it is suggested to start making requests with the connected peripheral after the `[UHNBLEControllerDelegate bleController:didDiscoverCharacteristics:forService:]` event is received.
 
 @discussion If no required services were provided, it is up to the delegate to discover the services, using `discoverServices:` and characteristics, using either `discoverAllCharacteristicsForService:` or `discoverCharacteristics:forService:` before making requests of the peripheral.
 
 */
- (void)connectToDiscoveredPeripheral:(NSString*)deviceName;

/**
 Try to reconnect with a peripheral that was previously connected
 
 @param uuid The NSUUID of the peripheral that was perviously connected
 
 */
- (void)reconnectToPeripheralWithUUID:(NSUUID *)uuid;

/** 
 Cancel the existing connecttion.
 */
- (void)cancelConnection;

/** 
 Determine if a peripheral is connected
 
 @return `YES` if a peripheral is connected, otherwise `NO`
 
 */
- (BOOL)isPeripheralConnected;

///-----------------------
/// @name Discover Methods
///-----------------------

/**
 Discover services of interest with the connected peripheral.
 
 @param serviceUUIDs An array of `NSString` representing the UUIDs of the interested services.
 
 @discussion If this method is successful, the delegate could get the optional `[UHNBLEControllerDelegate bleController:didDiscoverServices:]` event including all the discovered service UUIDs
 
 @warning If no requried services were provided during initiation, the delegate must use `discoverServices:` before making requests of the peripheral. Also, if the delegate would like to make use of an other availabe service, it must first be discovered.
 
 */
- (void)discoverServices:(NSArray*)serviceUUIDs;

/**
 Discover all characteristics for the provided service
 
 @param serviceUUID A `NSString` representing the UUID of the service of interest
 
 @discussion The service must have been discovered before the characteristics of the service can be discovered.
 
 @discussion If this method is successful, the delegate could get the optional `[UHNBLEControllerDelegate bleController:didDiscoverCharacteristics:forService:]` event including all the discovered characteristic UUIDs
 
 @warning If no requried services were provided during initiation, the delegate must use either `discoverAllCharacteristicsForService:` or `discoverCharacteristics:forService:` before making requests of the peripheral.
 
 */
- (void)discoverAllCharacteristicsForService:(NSString*)serviceUUID;

/**
 Discover speicific characteristics for the provided service
 
 @param characteristicUUIDs An array of `NSString` representing the characteristics of interest.
 @param serviceUUID A `NSString` representing the service for which the characteristics should be available
 
 @discussion The service must have been discovered before the characteristics of the service can be discovered.
 
 @discussion If this method is successful, the delegate could get the optional `[UHNBLEControllerDelegate bleController:didDiscoverCharacteristics:forService:]` event including all the discovered characteristic UUIDs.
 
 @discussion If the service is not available, the delegate could get the optional `[UHNBLEControllerDelegate bleController:serviceNotAvailable:]` event.
 
 @warning If no requried services were provided during initiation, the delegate must use either `discoverAllCharacteristicsForService:` or `discoverCharacteristics:forService:` before making requests of the peripheral.
 
 */
- (void)discoverCharacteristics:(NSArray*)characteristicUUIDs forService:(NSString*)serviceUUID;

/**
 Determine is a service is available in the connected peripheral
 
 @param serviceUUID A `NSString` representing the UUID of the service of interest
 
 @return `YES` if the service is available in the connected peripheral, otherwise `NO`
 
 */
- (BOOL)isServiceAvailable:(NSString *)serviceUUID;

///---------------------------
/// @name Read & Write Methods
///---------------------------

/**
 Try to write data to a characteristic
 
 @param data The value to write to the characteristic
 @param characteristicUUID A `NSString` representing the UUID of the characteristic
 @param serviceUUID A `NSString` representing the UUID of the service
 
 @discussion If this method is successful, the delegate will receive a `[UHNBLEControllerDelegate bleController:didWriteValue:toCharacteristic:]` event. If the method is unsuccessful, the delegate could receive the `[UHNBLEControllerDelegate bleController:failedWriteToCharacteristic:]`.
 
 @discussion If the service is not available, the delegate could get the optional `[UHNBLEControllerDelegate bleController:serviceNotAvailable:]` event.
 
 @discussion If the character is not available, the delegate could get the optional `[UHNBLEControllerDelegate bleController:characteristicNotAvailable:]` event.
 
 */
- (void)writeValue:(NSData *)data toCharacteristicUUID:(NSString*)characteristicUUID withServiceUUID:(NSString*)serviceUUID;

/**
 Try to read the value of a characteristic
 
 @param characteristicUUID A `NSString` representing the UUID of the characteristic
 @param serviceUUID A `NSString` representing the UUID of the service
 
 @discussion Writes to a characteristic are indicated, meaning that a response is provided from the peripheral once the write was successful. If this method is successful, the delegate will receive a `[UHNBLEControllerDelegate bleController:didUpdateValue:forCharacteristic:]` event. If the method is unsuccessful, the delegate could receive the `[UHNBLEControllerDelegate bleController:failedReadOfCharacteristic:]`.
 
 @discussion If the service is not available, the delegate could get the optional `[UHNBLEControllerDelegate bleController:serviceNotAvailable:]` event.
 
 @discussion If the character is not available, the delegate could get the optional a `[UHNBLEControllerDelegate bleController:characteristicNotAvailable:]` event.

 */
- (void)readValueFromCharacteristicUUID:(NSString*)characteristicUUID withServiceUUID:(NSString*)serviceUUID;

/** 
 Try to set a notification or indication state of a characteristic
 
 @param notify Indicates whether notifications or indications should be enabled or disabled
 @param characteristicUUID A `NSString` representing the UUID of the characteristic
 @param serviceUUID A `NSString` representing the UUID of the service

 @discussion If this method is successful, the delegate will receive a `[UHNBLEControllerDelegate bleController:didUpdateValue:forCharacteristic:]` event. If the method is unsuccessful, the delegate could receive the `[UHNBLEControllerDelegate bleController:failedNotificationUpdateToCharacteristic:]`.
 
 @discussion If the service is not available, the delegate could get the optional `[UHNBLEControllerDelegate bleController:serviceNotAvailable:]` event.
 
 @discussion If the character is not available, the delegate could get the optional a `[UHNBLEControllerDelegate bleController:characteristicNotAvailable:]` event.
 
 */
- (void)setNotificationState:(BOOL)notify forCharacteristicUUID:(NSString*)characteristicUUID withServiceUUID:(NSString*)serviceUUID;

@end

/**
 The UHNBLEControllerDelegate protocol defines the methods that a delegate of a UHNBLEController object must adopt. The optional methods of the protocol allow the delegate to monitor the discovery and connectivity of peripheral devices. The required methods of the protocol indicates discovery, connectivity, and read/write request with the peripheral device.
 
 */
@protocol UHNBLEControllerDelegate <NSObject>

/**
 Notifies the delegate when a peripheral has been discovered
 
 @param controller The `UHNBLEController` that discovered the peripheral
 @param deviceName The device name of the peripheral
 @param serviceUUIDs An array of `NSString` representing the UUID of the services available for the peripheral. This array includes all the provided required services and potentially additional services.
 @param RSSI The rssi power of the peripheral
 
 @discussion This method is invoked when a peripheral with the required services is discovered. If required services were provided during instantiation, the only peripherals with all of those services will be notified to the delegate. If no required services were provided, all discovered peripherals will be notified to the delegate.
 
 */
- (void)bleController:(UHNBLEController*)controller didDiscoverPeripheral:(NSString*)deviceName services:(NSArray*)serviceUUIDs RSSI:(NSNumber*)RSSI;

/**
 Notifies the delegate when a peripheral was disconnected
 
 @param controller The `UHNBLEController` that was managing the peripheral
 @param deviceName The device name of the peripheral
 
 @discussion This method is invoked when a peripheral is disconnected
 
 */
- (void)bleController:(UHNBLEController*)controller didDisconnectFromPeripheral:(NSString*)deviceName;

@optional

/**
 Notifies the delegate when a peripheral failed to connect
 
 @param controller The `UHNBLEController` that discovered the peripheral
 @param deviceName The device name of the peripheral
 
 @discussion This method is invoked when a peripheral failed to connect
 
 */
- (void)bleController:(UHNBLEController*)controller failedToConnectWithPeripheral:(NSString*)deviceName;

/**
 Notifies the delegate when the peripheral did update a characteristic notification state
 
 @param controller The `UHNBLEController` that is managing the peripheral
 @param notify The current state of the characteristic notification/indication
 @param characteristicUUID A `NSString` representing the UUID of the characteristic
 
 @discussion This method is invoked when the peripheral successfully updated the notification state of a characteristic
 
 */
- (void)bleController:(UHNBLEController*)controller didUpdateNotificationState:(BOOL)notify forCharacteristic:(NSString*)characteristicUUID;

/**
 Notifies the delegate when the peripheral did complete a successful write to a characteristic
 
 @param controller The `UHNBLEController` that is managing the peripheral
 @param value The value that was written to the characteristic
 @param characteristicUUID A `NSString` representing the UUID of the characteristic
 
 @discussion This method is invoked when a value was successfully written to a characteristic
 
 */
- (void)bleController:(UHNBLEController*)controller didWriteValue:(NSData*)value toCharacteristic:(NSString*)characteristicUUID;

/**
 Notifies the delegate when the peripheral did update the value of a characteristic (either read or notified/indicated)
 
 @param controller The `UHNBLEController` that is managing the peripheral
 @param value The value that was written to the characteristic
 @param characteristicUUID A `NSString` representing the UUID of the characteristic
 
 @discussion This method is invoked when a value was successfully updated for a characteristic. Values are updated with either reads or notifications/indications
 
 */
- (void)bleController:(UHNBLEController*)controller didUpdateValue:(NSData*)value forCharacteristic:(NSString*)characteristicUUID;

/**
 Notifies the delegate when a peripheral did connect
 
 @param controller The `UHNBLEController` that is managing the peripheral
 @param deviceName The device name of the peripheral
 @param uuid A `NSUUID` with the uuid of the peripheral
 
 @discussion This method is invoked when the peripheral is connected
 
 */
- (void)bleController:(UHNBLEController*)controller didConnectWithPeripheral:(NSString*)deviceName withUUID:(NSUUID*)uuid;

/**
 Notifies the delegate when a peripheral did connect
 
 @param controller The `UHNBLEController` that is managing the peripheral
 @param deviceName The device name of the peripheral
 @param serviceUUIDs An array of `NSString` representing the UUID of the services available for the peripheral. This array includes all the provided required services and potentially additional services.
 @param uuid A `NSUUID` with the uuid of the peripheral
 
 @discussion This method is invoked if required services were provided during instantiation after the discovery of the required services. If this method is invoked, it indicates that a request to discover all charactieristic for the required services has been initiated.
 
 */
- (void)bleController:(UHNBLEController*)controller didConnectWithPeripheral:(NSString*)deviceName withServices:(NSArray*)serviceUUIDs andUUID:(NSUUID*)uuid;

/**
 Notifies the delegate when services were discovered for the peripheral
 
 @param controller The `UHNBLEController` that is managing the peripheral
 @param serviceUUIDs An array of `NSString` representing the UUID of the services available for the peripheral. 
 
 @discussion This method is invoked when services were discovered for the peripheral
 
 */
- (void)bleController:(UHNBLEController*)controller didDiscoverServices:(NSArray*)serviceUUIDs;

/**
 Notifies the delegate when characteristics were discovered for the peripheral
 
 @param controller The `UHNBLEController` that is managing the peripheral
 @param characteristicUUIDs An array of `NSString` representing the characteristic UUIDs
 @param serviceUUID A `NSString` representing the UUID of the service

 @discussion This method is invoked when characteristics were discovered for the peripheral.  If required services are provided with instantiation of the UHNBLEController, it is suggested to start making requests with the connected peripheral after the `[UHNBLEControllerDelegate bleController:didDiscoverCharacteristics:forService:]` event is received.
 
 */
- (void)bleController:(UHNBLEController*)controller didDiscoverCharacteristics:(NSArray*)characteristicUUIDs forService:(NSString*)serviceUUID;

/**
 Notifies the delegate when the requested service is not available for the peripheral
 
 @param controller The `UHNBLEController` that is managing the peripheral
 @param serviceUUID A `NSString` representing the UUID of the service
 
 @discussion This method is invoked when a requested service has not been discovered or is not available in the peripheral
 
 */
- (void)bleController:(UHNBLEController*)controller serviceNotAvailable:(NSString*)serviceUUID;

/**
 Notifies the delegate when the requested characteristic is not available for the peripheral
 
 @param controller The `UHNBLEController` that is managing the peripheral
 @param characteristicUUID A `NSString` representing the UUID of the characteristic
 
 @discussion This method is invoked when a requested characteristic has not been discovered or is not available in the peripheral

 */
- (void)bleController:(UHNBLEController*)controller characteristicNotAvailable:(NSString*)characteristicUUID;

/**
 Notifies the delegate when a write to characteristic request failed
 
 @param controller The `UHNBLEController` that is managing the peripheral
 @param characteristicUUID A `NSString` representing the UUID of the characteristic

 @discussion This method is invoked when the peripheral failed to write to a characteristic
 
 */
- (void)bleController:(UHNBLEController*)controller failedWriteToCharacteristic:(NSString*)characteristicUUID;

/**
 Notifies the delegate when a read from characteristic request failed
 
 @param controller The `UHNBLEController` that is managing the peripheral
 @param characteristicUUID A `NSString` representing the UUID of the characteristic
 
 @discussion This method is invoked when the peripheral failed to read a characteristic
 
 */
- (void)bleController:(UHNBLEController*)controller failedReadOfCharacteristic:(NSString*)characteristicUUID;

/**
 Notifies the delegate when a update notification state request failed
 
 @param controller The `UHNBLEController` that is managing the peripheral
 @param characteristicUUID A `NSString` representing the UUID of the characteristic
 
 @discussion This method is invoked when the peripheral failed to update the notification state of a characteristic
 
 */
- (void)bleController:(UHNBLEController*)controller failedNotificationUpdateToCharacteristic:(NSString*)characteristicUUID;

/**
 Notifies the delegate when pairing failed
 
 @param controller The `UHNBLEController` that is managing the peripheral
 
 @discussion This method is invoked after making a request to the peripheral, but the request failed due to pairing issues.
 
 */
- (void)bleControllerPairingFailed:(UHNBLEController*)controller;
@end