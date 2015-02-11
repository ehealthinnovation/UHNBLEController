//
//  PeripheralDetailsViewController.m
//  UHNBLEController
//
//  Created by Nathaniel Hamming on 2015-02-10.
//  Copyright (c) 2015 Nathaniel Hamming. All rights reserved.
//

#import "PeripheralDetailsViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralDetailsViewController () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSString *peripheralName;
@property(nonatomic,strong) NSArray *peripheralServices;
@end

@implementation PeripheralDetailsViewController

- (instancetype)initWithPeripheralDetails: (NSDictionary*)peripheralDetails
{
    if (self = [super init]) {
        self.peripheralName = peripheralDetails[kPeripheralDeviceName];
        self.peripheralServices = peripheralDetails[kPeripheralServices];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.peripheralName;
    self.tableView = [[UITableView alloc] initWithFrame: self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.peripheralServices count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *characteristics = self.peripheralServices[section][kPeripheralServiceCharacteristics];
    return [characteristics count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:NSLocalizedString(@"Service: %@", @"Table section header indicating the service for which the characteristics are available"),[CBUUID UUIDWithString:self.peripheralServices[section][kPeripheralServicesUUID]]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PeripheralDetailsCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CBUUID *characteristic = [CBUUID UUIDWithString: self.peripheralServices[indexPath.section][kPeripheralServiceCharacteristics][indexPath.row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", characteristic];
    return cell;
}

@end
