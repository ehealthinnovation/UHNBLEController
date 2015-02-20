//
//  UHNBLEController.m
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 12-02-06.
//  Copyright (c) 2015 University Health Network.
//

#import "UHNBLEController.h"
#import "CBUUID+Extension.h"
#import "UHNDebug.h"
#import "CBCentralManager+StateString.h"
#import "NSString+GUIDExtension.h"

@interface UHNBLEController() <CBCentralManagerDelegate, CBPeripheralDelegate>
@property(nonatomic,strong) NSUUID *deviceIdentifier;
@property(nonatomic,strong) CBCentralManager *manager;
@property(nonatomic,strong) NSMutableArray *discoveredPeripheralList;
@property(nonatomic,strong) CBPeripheral *peripheral;
@property(nonatomic,strong) NSArray *requiredServices;
@property(nonatomic,assign) BOOL hasAlert;
@property(nonatomic,weak) id <UHNBLEControllerDelegate> delegate;
@end

#define kLastConnectedDeviceDefaultsIdentifierKey @"LastConnectedDefaultDeviceNSUUID"

@implementation UHNBLEController

@synthesize deviceIdentifier = _deviceIdentifier; // note: should not be required, but xcode complains if it is missing

#pragma mark - Initializing & property methods

- (instancetype)init
{
    [NSException raise:NSInvalidArgumentException
                format:@"%s: Use %@ instead", __PRETTY_FUNCTION__, NSStringFromSelector(@selector(initWithDelegate:requiredServices:))];
    return nil;
}

- (instancetype)initWithDelegate:(id<UHNBLEControllerDelegate>)delegate
      requiredServices:(NSArray*)services;
{
    if ((self = [super init])) 
    {
        if (!delegate) {
            [NSException raise:NSInvalidArgumentException
                        format:@"%s: a delegate is required", __PRETTY_FUNCTION__];
            return nil;
        }
        self.delegate = delegate;
        NSString *restoreIdentifierKey = [NSString stringWithFormat:@"%@_%@_%@",[[NSBundle mainBundle] bundleIdentifier], [self.delegate class], [NSString generateGUID]]; // provides a unique restore identifier with app and delegate details
        NSDictionary *managerOptions = @{CBCentralManagerOptionShowPowerAlertKey: @(YES), // notify if bluebooth is off
                                         CBCentralManagerOptionRestoreIdentifierKey: restoreIdentifierKey}; // used to restore central manager state
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:managerOptions]; // note: triggers hardware power up
        self.requiredServices = services;
    }
    return self;
}

- (NSUUID*)deviceIdentifier;
{
    if (_deviceIdentifier) {
        return _deviceIdentifier;
    }
    
    if (!self.storeLastConnectedDeviceID) {
        return nil;
    }

    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey: kLastConnectedDeviceDefaultsIdentifierKey];
    if (uuid) {
        _deviceIdentifier = [[NSUUID alloc] initWithUUIDString:uuid];
    }
    return _deviceIdentifier;
}

- (void)setDeviceIdentifier:(NSUUID*)identifier;
{
    if (self.storeLastConnectedDeviceID) {
        DLog(@"%s: %@", __PRETTY_FUNCTION__, identifier);
        
        if ([_deviceIdentifier isEqual:identifier] == NO) {
            _deviceIdentifier = identifier;
            [[NSUserDefaults standardUserDefaults] setObject:[identifier UUIDString] forKey: kLastConnectedDeviceDefaultsIdentifierKey];
        }
    }
}

#pragma mark - Connection Methods

- (void)startConnection;
{
    if (self.deviceIdentifier) {
        [self reconnectToPeripheralWithUUID:self.deviceIdentifier];
    }
    
    // note: the last connected device may take up to 60 seconds before we are notified that it is unavailable, so we also start scanning
    [self startScan];
}

- (void)connectToDiscoveredPeripheral:(NSString*)deviceName;
{
    for (CBPeripheral *peripheral in self.discoveredPeripheralList) {
        if ([peripheral.name isEqualToString: deviceName]) {
            [self connectPeripheral: peripheral];
            break;
        }
    }
}

- (void)reconnectToPeripheralWithUUID:(NSUUID*)uuid;
{
    DLog(@"%s: %@", __PRETTY_FUNCTION__, uuid);
    NSArray *peripherals = [self.manager retrievePeripheralsWithIdentifiers:@[uuid]];
    self.peripheral = [peripherals firstObject];
    [self connectPeripheral:self.peripheral];
}

- (void)cancelConnection
{
    DLog(@"cancelConnection");
    
    if (self.peripheral)
    {
        [self.manager cancelPeripheralConnection: self.peripheral];
        self.peripheral = nil;
    }
    else
    {
        DLog(@"cancel connection but we don't have a current peripheral");
        [self.delegate bleController: self didDisconnectFromPeripheral:nil];
    }
}

- (BOOL)isPeripheralConnected
{
    DLog(@"isPeripheralConnected");
    
    if (self.peripheral && CBPeripheralStateConnected == self.peripheral.state)
    {
        return YES;
    }
    
    return NO;
}

#pragma mark - Discover Methods

- (void)discoverServices:(NSArray*)serviceUUIDs
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    NSMutableArray *services = [NSMutableArray array];
    for (NSString *UUID in serviceUUIDs)
    {
        [services addObject: [CBUUID UUIDWithString: UUID]];
    }
    DLog(@"Trying to discover services: %@", services);
    [self.peripheral discoverServices: services];
}

- (void)discoverAllCharacteristicsForService:(NSString*)serviceUUID
{
    DLog(@"%s: %@", __PRETTY_FUNCTION__, serviceUUID);
    
    NSArray *characteristics = nil;
    [self discoverCharacteristics:characteristics forService: serviceUUID];
}

- (void)discoverCharacteristics:(NSArray*)characteristicUUIDs forService:(NSString*)serviceUUID
{
    DLog(@"%s: %@ %@", __PRETTY_FUNCTION__, characteristicUUIDs, serviceUUID);
    CBService *service = [self findServiceFromUUID: [CBUUID UUIDWithString: serviceUUID]];
    if (service == nil) {
        if ([self.delegate respondsToSelector:@selector(bleController:serviceNotAvailable:)]) {
            [self.delegate bleController:self serviceNotAvailable:serviceUUID];
        }
        return;
    }
    
    NSMutableArray *characteristics = [NSMutableArray array]; // [CBUUID, ...]
    for (NSString *UUID in characteristicUUIDs)
    {
        [characteristics addObject: [CBUUID UUIDWithString: UUID]];
    }
    
    if (characteristicUUIDs == nil)
    {
        DLog(@"Trying to discover all characteristics for service: %@", service.UUID);
    }
    
    [self.peripheral discoverCharacteristics:characteristics forService:service];
}

- (BOOL)isServiceAvailable:(NSString*)serviceUUID;
{
    CBUUID *serviceCBUUID = [CBUUID UUIDWithString: serviceUUID];
    CBService *service = [self findServiceFromUUID: serviceCBUUID];
    return (service != nil);
}

#pragma mark - Read & Write Methods

- (void) writeValue:(NSData*)data toCharacteristicUUID:(NSString*)characteristicUUID withServiceUUID:(NSString*)serviceUUID
{
    DLog(@"%s: %@ %@ %@", __PRETTY_FUNCTION__, data, characteristicUUID, serviceUUID);
    CBService *service = [self retrieveService: serviceUUID];
    CBCharacteristic *characteristic = [self retrieveCharacteristic: characteristicUUID service:service];
    if (service && characteristic) {
        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)readValueFromCharacteristicUUID:(NSString*)characteristicUUID withServiceUUID:(NSString*)serviceUUID
{
    DLog(@"%s: %@ %@", __PRETTY_FUNCTION__, characteristicUUID, serviceUUID);
    CBService *service = [self retrieveService: serviceUUID];
    CBCharacteristic *characteristic = [self retrieveCharacteristic: characteristicUUID service: service];
    if (service && characteristic) {
        [self.peripheral readValueForCharacteristic: characteristic];
    }
}

- (void)setNotificationState:(BOOL)notify forCharacteristicUUID:(NSString*)characteristicUUID withServiceUUID:(NSString*)serviceUUID
{
    DLog(@"%s: %d %@ %@", __PRETTY_FUNCTION__, notify, characteristicUUID, serviceUUID);
    CBService *service = [self retrieveService: serviceUUID];
    CBCharacteristic *characteristic = [self retrieveCharacteristic: characteristicUUID service:service];
    if (service && characteristic) {
        [self.peripheral setNotifyValue: notify forCharacteristic: characteristic];
    }
}

- (CBCharacteristic*)retrieveCharacteristic:(NSString*)characteristicUUIDString service:(CBService*)service
{
    NSAssert(characteristicUUIDString != nil, @"Trying to read to characteristic when characteristic UUID is nil");
    
    CBUUID *characteristicUUID = [CBUUID UUIDWithString: characteristicUUIDString];
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID: characteristicUUID service: service];
    
    if (characteristic == nil) {
        DLog(@"characteristic isn't availble to read from");
        if ([self.delegate respondsToSelector:@selector(bleController:characteristicNotAvailable:)]) {
            [self.delegate bleController:self characteristicNotAvailable:characteristicUUIDString];
        }
        return nil;
    }
    
    return characteristic;
}

- (CBService*)retrieveService:(NSString*)serviceUUIDString {
    NSAssert(serviceUUIDString != nil, @"Trying to read to characteristic when service UUID is nil");
    
    CBUUID *serviceUUID = [CBUUID UUIDWithString: serviceUUIDString];
    CBService *service = [self findServiceFromUUID:serviceUUID];
    
    if (service == nil) {
        DLog(@"service isn't availble to read from");
        if ([self.delegate respondsToSelector:@selector(bleController:serviceNotAvailable:)]) {
            [self.delegate bleController:self serviceNotAvailable:serviceUUIDString];
        }
        return nil;
    }
    
    return service;
}
#pragma mark - Private Methods

- (UInt16) swap:(UInt16)s
{
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

- (void) startScan
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    if (self.manager.state != CBCentralManagerStatePoweredOn) {
        DLog(@"Warn: unable to start scanning for peripherals when bluetooth power is not on");
        return;
    }

    NSMutableArray *services = [NSMutableArray array];
    for (NSString *serviceID in self.requiredServices) {
        [services addObject: [CBUUID UUIDWithString: serviceID]];
    }
    
    DLog(@"services: %@", services);
    [self.manager scanForPeripheralsWithServices:services options: nil];
}

- (void) stopScan
{
    DLog(@"stopScan");
    [self.manager stopScan];
}

- (void) connectPeripheral:(CBPeripheral*)peripheral;
{
    DLog(@"%s: %@", __PRETTY_FUNCTION__, peripheral);
    [self stopScan];
    
    if (self.peripheral && self.peripheral.state != CBPeripheralStateConnected) {
        if ([self.peripheral.identifier isEqual:peripheral.identifier] && self.peripheral.state == CBPeripheralStateConnecting) {
            DLog(@"already connecting to peripheral... skip cancel connection, skip connect");
            return;
        } else {
            DLog(@"cancel pending peripheral connection: %@", self.peripheral);
            [self.manager cancelPeripheralConnection:self.peripheral];
        }
    }
    
    NSDictionary *opts = @{ CBConnectPeripheralOptionNotifyOnConnectionKey: @(self.notifyOnConnection),
                            CBConnectPeripheralOptionNotifyOnNotificationKey: @(self.notifyOnNotification),
                            CBConnectPeripheralOptionNotifyOnDisconnectionKey: @(self.notifyOnDisconnection)};
    [self.manager connectPeripheral: peripheral options: opts];
}

- (CBService*)findServiceFromUUID:(CBUUID*)UUID
{
    CBService *foundService = nil;
    if (self.peripheral && UUID)
    {
        for (CBService *service in self.peripheral.services) {
            if ([service.UUID isEqualToCBUUID:UUID]) {
                foundService = service;
                break;
            }
        }
    }
    else
    {
        DLog(@"Missing peripheral (%@) or UUID (%@)", self.peripheral, UUID);
    }
    
    if (foundService == nil) {
        DLog(@"Warn: No service with CBUUID: %@", UUID);
    }
    return foundService;
}

- (CBCharacteristic*)findCharacteristicFromUUID:(CBUUID*)UUID service:(CBService*)service
{
    CBCharacteristic *foundCharacteristic = nil;
    if (self.peripheral && service && UUID)
    {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqualToCBUUID:UUID]) {
                foundCharacteristic = characteristic;
                break;
            }
        }
    }
    else
    {
        DLog(@"Missing peripheral (%@), service (%@), and/or UUID (%@)", self.peripheral, service, UUID);
    }
    
    if (foundCharacteristic == nil) {
        DLog(@"Warn: No characteristic with UUID: %@", UUID);
    }
    return foundCharacteristic;
}

#pragma mark - CBCentralManagerDelegate

- (void) centralManagerDidUpdateState:(CBCentralManager*)central 
{
    CBCentralManagerState state = [central state];
    DLog(@"%s: %@", __PRETTY_FUNCTION__, [central stringForState:state]);
    
    if (state == CBCentralManagerStatePoweredOn) {
        [self startConnection];
    } else if (state == CBCentralManagerStatePoweredOff) {
        if (self.peripheral) {
            [self cancelConnection];
        }
    }
    
}

- (void) centralManager:(CBCentralManager*)central didDiscoverPeripheral:(CBPeripheral*)peripheral advertisementData:(NSDictionary*)advertisementData RSSI:(NSNumber*)RSSI
{    
    DLog(@"%s: %@ %@ advertisementData: %@ RSSI: %@", __PRETTY_FUNCTION__, central, peripheral, advertisementData, RSSI);

    NSArray *advertisedServices = advertisementData[CBAdvertisementDataServiceUUIDsKey];
    NSMutableArray *adServicesUUIDs = [NSMutableArray array];
    for (CBUUID *service in advertisedServices) {
        NSString *serviceUUID = [service UUIDString];
        [adServicesUUIDs addObject: serviceUUID];
    }
    
    // confirm the device has all required services
    BOOL hasRequiredServices = YES;
    for (NSString *requireService in self.requiredServices) {
        for (NSInteger i = 0; i < [adServicesUUIDs count]; i++) {
            NSString *adServiceUUID = [adServicesUUIDs objectAtIndex:i];
            if ([adServiceUUID isEqualToString: requireService]) {
                break;
            }
            if (i == [adServicesUUIDs count] - 1) {
                // did not find a required service
                hasRequiredServices = NO;
            }
        }
        if (!hasRequiredServices) {
            // no need to keep checking services
            break;
        }
    }
    
    if (hasRequiredServices) {
        if (!self.discoveredPeripheralList) {
            self.discoveredPeripheralList = [NSMutableArray array];
        }
        if ([self.discoveredPeripheralList indexOfObject: peripheral] == NSNotFound) {
            // only store and report newly discovered devices
            [self.discoveredPeripheralList addObject: peripheral];
            if ([self.delegate respondsToSelector: @selector(bleController:didDiscoverPeripheral:services:RSSI:)]) {
                // note: a device name is available in both: peripheral.name and advertisementData[CBAdvertisementDataLocalNameKey], but they may be different
                [self.delegate bleController: self didDiscoverPeripheral: peripheral.name services: adServicesUUIDs RSSI: RSSI];
            }
        }
    }
}

- (void) centralManager:(CBCentralManager*)central didConnectPeripheral:(CBPeripheral*)peripheral
{    
    DLog(@"%s: %@", __PRETTY_FUNCTION__, peripheral);
    
    if (peripheral.state == CBPeripheralStateDisconnected) {
        DLog(@"peripheral disconnected? Starting to scan...");
        [self startScan];
    }
    
    [peripheral setDelegate:self];
    self.peripheral = peripheral;
    self.deviceIdentifier = peripheral.identifier;
    
    if (self.requiredServices)
    {
        [self discoverServices: self.requiredServices];
    }
    
    if ([self.delegate respondsToSelector: @selector(bleController:didConnectWithPeripheral:withUUID:)])
    {
        [self.delegate bleController: self didConnectWithPeripheral:self.peripheral.name withUUID:peripheral.identifier];
    }
}

- (void)centralManager:(CBCentralManager*)central didDisconnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error
{
    DLog(@"*** %s: %@ %@", __PRETTY_FUNCTION__, peripheral, error);
    
    self.peripheral.delegate = nil;
    self.peripheral = nil;
    
    NSString *tempName = [peripheral.name copy];
    
    // note: the delegate can trigger scanning if needed
    [self.delegate bleController: self didDisconnectFromPeripheral:tempName];
}

- (void)centralManager:(CBCentralManager*)central didFailToConnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error
{
    DLog(@"Fail to connect to peripheral: %@ with error = %@", peripheral, [error localizedDescription]);
    [self.delegate bleController: self failedToConnectWithPeripheral: self.peripheral.name];

    if (self.peripheral)
    {
        DLog(@"%s: wiping peripheral", __PRETTY_FUNCTION__);
        self.peripheral.delegate = nil;
        self.peripheral = nil;
    }    
}

#pragma mark - CBPeripheralDelegate

- (void) peripheral:(CBPeripheral*)aPeripheral didDiscoverServices:(NSError*)error 
{
    if (error) 
    {
        DLog(@"Discovered services for %@ with error: %@", aPeripheral.name, [error localizedDescription]);
        return;
    }
    else 
    {
        DLog(@"did Discover services: %@ for peripheral: %@", aPeripheral.services, aPeripheral.name);
        NSMutableArray *serviceUUIDs = [NSMutableArray array];
        for (CBService *service in aPeripheral.services) 
        {
            [serviceUUIDs addObject: [service.UUID UUIDString]];
        }
        
        if (self.requiredServices)
        {
            for (NSString *UUID in self.requiredServices)
            {
                [self discoverAllCharacteristicsForService: UUID];
            }
            
            if ([self.delegate respondsToSelector: @selector(bleController:didConnectWithPeripheral:withServices:andUUID:)])
            {
                [self.delegate bleController: self didConnectWithPeripheral: aPeripheral.name withServices: serviceUUIDs andUUID: aPeripheral.identifier];
            }
        } 
        
        if ([self.delegate respondsToSelector: @selector(bleController:didDiscoverServices:)])
        {
            [self.delegate bleController: self didDiscoverServices: serviceUUIDs];
        }
    }
}

- (void) peripheral:(CBPeripheral*)aPeripheral didDiscoverCharacteristicsForService:(CBService*)service error:(NSError*)error 
{    
    if (error) 
    {
        DLog(@"%s: %@ %@ %@", __PRETTY_FUNCTION__, aPeripheral, service.UUID, error);
        return;
    }
    
    DLog(@"service.UUID: %@", service.UUID);
    NSMutableArray *characteristicUUIDs = [NSMutableArray array];
    //display All characteristics
    for (CBCharacteristic *aChar in service.characteristics) 
    {
        DLog(@"Found a Characteristic: %@ (UUID) %@ (value) %d (properties) %d (notify?)", aChar.UUID, aChar.value, (int)aChar.properties, aChar.isNotifying);
        [characteristicUUIDs addObject: [aChar.UUID UUIDString]];
    }
    
    if ([self.delegate respondsToSelector: @selector(bleController:didDiscoverCharacteristics:forService:)])
    {
        [self.delegate bleController: self didDiscoverCharacteristics: characteristicUUIDs forService: [service.UUID UUIDString]];
    }
}

- (void)peripheral:(CBPeripheral*)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error 
{
    if (error) 
    {
        DLog(@"Discovered descriptors for %@ with error: %@", characteristic.UUID, [error localizedDescription]);
    }
    else 
    {
        DLog(@"didDiscoverDescriptorsForCharacteristic");
    }
}

- (void)peripheral:(CBPeripheral*)peripheral didDiscoverIncludedServicesForService:(CBService*)service error:(NSError*)error
{
    if (error) {
        DLog(@"Error discovering included service %@ for service error: %@", service.UUID, [error localizedDescription]);
    }
    else 
    {
        DLog(@"didDiscoverIncludedServicesForService");
    }
}

- (void)peripheral:(CBPeripheral*)aPeripheral didWriteValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error 
{
    if (error) 
    {
        DLog(@"Error writing value for characteristic %@ error: %@", characteristic.UUID, error);
        //TODO check for security error codes... or should the controller be smart enough to just disconnect, forget the peripheral and try reconnection... or both (notification to user if desired
        if ([self.delegate respondsToSelector:@selector(bleController:failedWriteToCharacteristic:)]) {
            [self.delegate bleController:self failedWriteToCharacteristic: [characteristic.UUID UUIDString]];
        }
    }
    else 
    {
        DLog(@"%s: %@", __PRETTY_FUNCTION__, characteristic);
        [self.delegate bleController: self didWriteValue: characteristic.value toCharacteristic: [characteristic.UUID UUIDString]];
    }
}

- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForDescriptor:(CBDescriptor*)descriptor error:(NSError*)error
{
    //TODO current there is no support to write/read froma descriptor.
    
    if (error)
    {
        DLog(@"Error writing value for descriptor %@ error: %@", descriptor.UUID, [error localizedDescription]);
    }
    else 
    {
        DLog(@"%s: %@ %@", __PRETTY_FUNCTION__, peripheral, descriptor);
    }
}

- (void) peripheral:(CBPeripheral*)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error 
{
    if (error) 
    {
        DLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        //TODO check for security error codes... or should the controller be smart enough to just disconnect, forget the peripheral and try reconnection... or both (notification to user if desired
        if ([self.delegate respondsToSelector:@selector(bleController:failedReadOfCharacteristic:)]) {
            [self.delegate bleController:self failedReadOfCharacteristic: [characteristic.UUID UUIDString]];
        }
    }
    else
    {
        DLog(@"%s: %@", __PRETTY_FUNCTION__, characteristic);
        [self.delegate bleController: self didUpdateValue: characteristic.value forCharacteristic: [characteristic.UUID UUIDString]];
    }
}

- (void)peripheral:(CBPeripheral*)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error 
{
    if (error) 
    {
        DLog(@"Error updating notification state for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        //TODO check for security error codes... or should the controller be smart enough to just disconnect, forget the peripheral and try reconnection... or both (notification to user if desired
        if ([self.delegate respondsToSelector:@selector(bleController:failedNotificationUpdateToCharacteristic:)]) {
            [self.delegate bleController:self failedNotificationUpdateToCharacteristic: [characteristic.UUID UUIDString]];
        }
    }
    else
    {
        DLog(@"Updated notification state for characteristic %@ (newState:%@)", characteristic.UUID, [characteristic isNotifying] ? @"Notifying" : @"Not Notifying");
        [self.delegate bleController: self didUpdateNotificationState: characteristic.isNotifying forCharacteristic: [characteristic.UUID UUIDString]];
    }
}

- (void)peripheral:(CBPeripheral*)peripheral didUpdateValueForDescriptor:(CBDescriptor*)descriptor error:(NSError*)error
{
    if (error) 
    {
        DLog(@"Error updating value for descriptor %@ error: %@", descriptor.UUID, [error localizedDescription]);
    }
    else 
    {
        DLog(@"Updated value %@ for descriptor %@", descriptor.UUID, [descriptor value]);
    }
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral*)aPeripheral error:(NSError*)error
{
    if (error) 
    {
        DLog(@"Error updating RSSI for peripheral %@ error: %@", aPeripheral.name, [error localizedDescription]);
    }
    else 
    {
        DLog(@"peripheralDidUpdateRSSI");
    }
}

#pragma mark - Restoration delegate method

- (void)centralManager:(CBCentralManager*)central
      willRestoreState:(NSDictionary*)state;
{
    NSArray *peripherals = state[CBCentralManagerRestoredStatePeripheralsKey];
    self.peripheral = [peripherals firstObject]; // since this app only connects to 1 peripheral, just take the first from the array
}

@end
