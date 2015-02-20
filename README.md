# UHNBLEController

## Description

A general central BLE library that provides helpers for common task and the generic record access control point service.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

The ble controller is meant to be an property of a specific ble sensor controller (e.g. Continuous Glucose Monitor or Heart Rate controller) acting as a central manager. As a property, its delegate would subscribe for notification when specific events of interest occurs and respond to them. While these events are available from the CBCentralManagerDelegate and CBPeripheralDelegate, the ble controller brings them together into a single delegate protocol and provider task helpers (e.g. ensuring the service and characteristic exists in the connected peripheral before any interaction occurs).

```
  #import "UHNBLEController.h"
  
  @interface BLESensorController() <UHNBLEControllerDelegate>
  
  @property(nonatomic,strong) UHNBLEController *bleController;
  
  self.bleController =  [[UHNBLEController alloc] initWithDelegate:self 
                                                  requiredServices:requiredServices];
```
```
- (void)bleController:(UHNBLEController*)controller didDiscoverPeripheral:(NSString*)deviceName services:(NSArray*)serviceUUIDs RSSI:(NSNumber*)RSSI;

- (void)bleController:(UHNBLEController*)controller didDisconnectFromPeripheral:(NSString*)deviceName;

- (void)bleController:(UHNBLEController*)controller didConnectWithPeripheral:(NSString*)deviceName withUUID:(NSUUID*)uuid;

- (void)bleController:(UHNBLEController*)controller didDiscoverServices:(NSArray*)serviceUUIDs;

- (void)bleController:(UHNBLEController*)controller didDiscoverCharacteristics:(NSArray*)characteristicUUIDs forService:(NSString*)serviceUUID;

- (void)bleController:(UHNBLEController*)controller didUpdateNotificationState:(BOOL)notify forCharacteristic:(NSString*)characteristicUUID;

- (void)bleController:(UHNBLEController*)controller didWriteValue:(NSData*)value toCharacteristic:(NSString*)characteristicUUID;

- (void)bleController:(UHNBLEController*)controller didUpdateValue:(NSData*)value forCharacteristic:(NSString*)characteristicUUID;
```

## Installation

UHNBLEController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "UHNBLEController"

## Documentation

`appledoc` of the pod can be found at `./docs/html/index.html`

## Author

Nathaniel Hamming, nhamming@ehealthinnovation.org

## License

UHNBLEController is available under the MIT license. See the LICENSE file for more info.

