//
//  GJBlueToothDetailViewController.m
//  Demo
//
//  Created by 高 军 on 15/3/31.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJBlueClientViewController.h"
#import "GJBlueToothCopier.h"


static NSString *cellIdentifier = @"cell";
static NSString *headerIdentifier = @"header";

@interface GJBlueClientViewController ()<CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *mLabelName;
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic) NSMutableArray *mArrServices;
@property (strong, nonatomic) IBOutlet UIImageView *mImgV;
@property (nonatomic) NSMutableData *mDataReceived;
@end

@implementation GJBlueClientViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mDataReceived = [NSMutableData data];
    self.mArrServices = [[NSMutableArray alloc] init];
    
    self.mPeripheral.delegate = self;
    [self.mPeripheral discoverServices:nil];
    
    [self setTitle:self.mPeripheral.name];
    [self.mLabelName setText:self.mPeripheral.identifier.UUIDString];
    
    [self.mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.mTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerIdentifier];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"read" style:UIBarButtonItemStyleDone target:self action:@selector(readFromServer)];
}

- (void)readFromServer
{

}

- (void)writeMinor
{
    CBCharacteristic *characteriticWrite = nil;
    for (CBService *service in self.mArrServices) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            for (CBDescriptor *descriptor in characteristic.descriptors) {
                if ([descriptor.UUID.UUIDString isEqualToString:CBUUIDCharacteristicUserDescriptionString] && [descriptor.value isEqualToString:@"iBeacon Minor"])
                {
                    characteriticWrite = characteristic;
                    break;
                }
            }
        }
    }
    if (nil != characteriticWrite)
    {
        [self.mPeripheral writeValue:[@"3" dataUsingEncoding:NSASCIIStringEncoding] forCharacteristic:characteriticWrite type:CBCharacteristicWriteWithResponse];
    }

}

- (void)doCopy
{
    BOOL success = [GJBlueToothCopier writeToLocalFile:nil services:self.mArrServices];
    NSString *strMessage = [NSString stringWithFormat:@"%@", success?@"copy success!":@"copy failed!"];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mArrServices.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CBService *service = self.mArrServices[section];
    NSInteger count = service.characteristics.count;
    
    return count;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CBService *service = self.mArrServices[section];
    
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    NSString *strUUID = [NSString stringWithFormat:@"%@", service.UUID];
    [header.textLabel setText:strUUID];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBService *service = self.mArrServices[indexPath.section];
    CBCharacteristic *characteristic = service.characteristics[indexPath.row];

    NSString *strDescriptorValue = @"";
    if (characteristic.descriptors.count > 0)
    {
        CBDescriptor *descriptor = characteristic.descriptors[0];
        if ([descriptor.UUID.UUIDString isEqualToString:CBUUIDCharacteristicUserDescriptionString])
        {
            NSLog(@"CBUUIDCharacteristicUserDescriptionString");
            strDescriptorValue = descriptor.value;
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    NSString *strValue = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    NSString *str = [NSString stringWithFormat:@"%@:%@:%@",strDescriptorValue, characteristic.UUID, strValue];
    [cell.textLabel setText:str];
    
    return cell;
}

#pragma mark CBPeripheral Delegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services)
    {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:(NSString*)UUID_SERVICE]])
        {
            NSLog(@"Discovered service %@", service);
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    [self.mArrServices addObject:service];
    [self.mTableView reloadData];
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:(NSString*)UUID_CHARACTER]])
        {
            NSLog(@"Discovered characteristic %@", characteristic);
            NSData *data = characteristic.value;
            [self.mLabelName setText:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
            
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    [peripheral readValueForCharacteristic:characteristic];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:(NSString*)UUID_CHARACTER]])
    {
        NSLog(@"didUpdateValueForCharacteristic");
        
        NSData *data = characteristic.value;

        NSString *strValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.mLabelName setText:strValue];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didDiscoverDescriptorsForCharacteristic==%@:%@", error, characteristic.descriptors);
//    [GJBlueToothCopier writeToLocalFile:characteristic value:characteristic.value];
    for (CBDescriptor *descriptor in characteristic.descriptors)
    {
        [peripheral readValueForDescriptor:descriptor];
    }

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"descriptor==%@:%@", error, descriptor);
}


- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
//    [peripheral writeValue:dataToWrite forCharacteristic:interestingCharacteristic
//                      type:CBCharacteristicWriteWithResponse];
    if (error)
    {
        NSLog(@"Error writing characteristic value: %@", [error localizedDescription]);
    }else{
        NSLog(@"didWriteValueForCharacteristic success");
    }
}



@end
