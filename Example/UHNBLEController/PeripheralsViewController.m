//
//  PeripheralsViewController.m
//  UHNBLEDemo
//
//  Created by Nathaniel Hamming on 02/09/2015.
//  Copyright (c) 2015 University Health Network.

#import "PeripheralsViewController.h"
#import <UHNBLEController/UHNBLEController.h>
#import "PeripheralDetailsViewController.h"

@interface PeripheralsViewController () <UITabBarControllerDelegate, UITableViewDataSource, UHNBLEControllerDelegate>
@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) UHNBLEController *bleController;
@property(nonatomic,strong) NSMutableArray *peripheralList;
@property(nonatomic,strong) NSMutableDictionary *selectedPeripheralDetails;
@end

@implementation PeripheralsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Select Peripheral";
    self.bleController = [[UHNBLEController alloc] initWithDelegate: self requiredServices: nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.bleController isPerpherialConnected]) {
        [self.bleController cancelConnection];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.peripheralList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Peripherals Discovered";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PeripheralCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *peripheralDetails = [self.peripheralList objectAtIndex: indexPath.row];
    cell.textLabel.text = peripheralDetails[kPeripheralDeviceName];
    NSArray *advertisedServices = peripheralDetails[kPeripheralAdvertisedServices];
    if (advertisedServices && [advertisedServices count]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld services advertised", [advertisedServices count]];
    } else {
        cell.detailTextLabel.text = @"No services advertised";
    }
    return cell;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedPeripheralDetails = [self.peripheralList objectAtIndex: indexPath.row];
    [self.bleController connectToDiscoveredPeripheral: self.selectedPeripheralDetails[kPeripheralDeviceName]];
    
    
}

#pragma mark - BLE Controller Delegate Methods

- (void)bleController:(UHNBLEController*)controller didDiscoverPeripheral:(NSString*)deviceName services:(NSArray*)serviceUUIDs RSSI:(NSNumber*)RSSI;
{
    if (!self.peripheralList) {
        self.peripheralList = [NSMutableArray array];
    }
    
    if (!deviceName) {
        deviceName = @"No device name available";
    }

    NSMutableDictionary *peripheralDetails = [NSMutableDictionary dictionaryWithObject: deviceName forKey: kPeripheralDeviceName];
    if (serviceUUIDs) {
        [peripheralDetails setObject: serviceUUIDs forKey: kPeripheralAdvertisedServices];
    }
    [self.peripheralList addObject: peripheralDetails];
    [self.tableView reloadSections: [NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)bleController:(UHNBLEController*)controller didDisconnectFromPeripheral:(NSString*)deviceName;
{
    //NOP
}

- (void)bleController:(UHNBLEController*)controller failedToConnectWithPeripheral:(NSString*)deviceName;
{
    //NOP
}

- (void)bleController:(UHNBLEController*)controller didConnectWithPeripheral:(NSString*)deviceName withUUID:(NSUUID*)uuid;
{
    [self.bleController discoverServices: nil];
}

- (void)bleController:(UHNBLEController*)controller didDiscoverServices:(NSArray*)serviceUUIDs;
{
    NSMutableArray *serviceDetails = [NSMutableArray array];
    for (NSString *serviceUUID in serviceUUIDs) {
        [serviceDetails addObject: @{kPeripheralServicesUUID: serviceUUID, kPeripheralServiceCharacteristics: [NSMutableArray array]}];
    }
    [self.selectedPeripheralDetails setObject: serviceDetails forKey: kPeripheralServices];
    [self.bleController discoverAllCharacteristicsForService: [serviceUUIDs firstObject]];
}

- (void)bleController:(UHNBLEController*)controller didDiscoverCharacteristics:(NSArray*)characteristicUUIDs forService:(NSString*)serviceUUID;
{
    NSArray *peripheralServices = self.selectedPeripheralDetails[kPeripheralServices];
    for (int i = 0; i < [peripheralServices count]; i++) {
        NSMutableDictionary *serviceDetails = [peripheralServices[i] mutableCopy];
        if ([serviceUUID isEqualToString: serviceDetails[kPeripheralServicesUUID]]) {
            [serviceDetails setObject: characteristicUUIDs forKey: kPeripheralServiceCharacteristics];
            self.selectedPeripheralDetails[kPeripheralServices][i] = serviceDetails;
            if (i < [peripheralServices count] - 1) {
                NSDictionary *nextService = peripheralServices[i+1];
                [self.bleController discoverAllCharacteristicsForService: nextService[kPeripheralServicesUUID]];
                break;
            } else {
                PeripheralDetailsViewController *viewController = [[PeripheralDetailsViewController alloc] initWithPeripheralDetails: self.selectedPeripheralDetails];
                [self.navigationController pushViewController: viewController animated: YES];
            }
        }
    }
    
}

@end
