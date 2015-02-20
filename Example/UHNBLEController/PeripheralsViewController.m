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
@property(nonatomic,strong) IBOutlet UIView *messageView;
@property(nonatomic,strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,strong) IBOutlet UILabel *messageLabel;
@property(nonatomic,strong) UHNBLEController *bleController;
@property(nonatomic,strong) NSMutableArray *peripheralList;
@property(nonatomic,strong) NSMutableDictionary *selectedPeripheralDetails;
@end

@implementation PeripheralsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Select Peripheral", @"table header asking user to select a peripheral from the given list");
    self.bleController = [[UHNBLEController alloc] initWithDelegate: self requiredServices: nil];
    self.messageView.center = self.tableView.center;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.messageView removeFromSuperview];
    if ([self.bleController isPeripheralConnected]) {
        [self.bleController cancelConnection];
    }
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
    return NSLocalizedString(@"Peripherals Discovered", @"table view header");
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
        cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%ld services advertised", @"count of services advertised by the peripheral"), [advertisedServices count]];
    } else {
        cell.detailTextLabel.text = NSLocalizedString(@"No services advertised", @"indicating that the perihperal does not advertise any services");
    }
    return cell;
}

#pragma mark - Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedPeripheralDetails = [self.peripheralList objectAtIndex: indexPath.row];
    [self.bleController connectToDiscoveredPeripheral: self.selectedPeripheralDetails[kPeripheralDeviceName]];
    self.activityIndicator.hidden = NO;
    self.messageLabel.text = NSLocalizedString(@"Interrogating", @"UI message indicating the app is blocked while getting all services and characteristics of the peripheral");
    [self.view addSubview: self.messageView];
    self.view.userInteractionEnabled = NO;
}

#pragma mark - BLE Controller Delegate Methods

- (void)bleController:(UHNBLEController*)controller didDiscoverPeripheral:(NSString*)deviceName services:(NSArray*)serviceUUIDs RSSI:(NSNumber*)RSSI;
{
    if (!self.peripheralList) {
        self.peripheralList = [NSMutableArray array];
    }
    
    if (!deviceName) {
        deviceName = NSLocalizedString(@"No device name available", @"Notice that the peripheral does not have a device name");
    }

    NSMutableDictionary *peripheralDetails = [NSMutableDictionary dictionaryWithObject: deviceName forKey: kPeripheralDeviceName];
    if (serviceUUIDs) {
        peripheralDetails[kPeripheralAdvertisedServices] = serviceUUIDs;
    }
    [self.peripheralList addObject: peripheralDetails];
    [self.tableView reloadSections: [NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)bleController:(UHNBLEController*)controller didDisconnectFromPeripheral:(NSString*)deviceName;
{
    self.view.userInteractionEnabled = YES;
    self.activityIndicator.hidden = YES;
    self.messageLabel.text = NSLocalizedString(@"Peripheral Disconnected", @"UI Message indicating the peripheral disconnected unexpectantly");
    [self.messageView performSelector: @selector(removeFromSuperview) withObject:nil afterDelay: 1.];
}

- (void)bleController:(UHNBLEController*)controller failedToConnectWithPeripheral:(NSString*)deviceName;
{
    self.view.userInteractionEnabled = YES;
    self.activityIndicator.hidden = YES;
    self.messageLabel.text = NSLocalizedString(@"Connection Failed", @"UI message indicating the connection to the peripheral failed");
    [self.messageView performSelector: @selector(removeFromSuperview) withObject:nil afterDelay: 1.];
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
    self.selectedPeripheralDetails[kPeripheralServices] = serviceDetails;
    [self.bleController discoverAllCharacteristicsForService: [serviceUUIDs firstObject]];
}

- (void)bleController:(UHNBLEController*)controller didDiscoverCharacteristics:(NSArray*)characteristicUUIDs forService:(NSString*)serviceUUID;
{
    NSArray *peripheralServices = self.selectedPeripheralDetails[kPeripheralServices];
    for (int i = 0; i < [peripheralServices count]; i++) {
        NSMutableDictionary *serviceDetails = [peripheralServices[i] mutableCopy];
        if ([serviceUUID isEqualToString: serviceDetails[kPeripheralServicesUUID]]) {
            serviceDetails[kPeripheralServiceCharacteristics] = characteristicUUIDs;
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
