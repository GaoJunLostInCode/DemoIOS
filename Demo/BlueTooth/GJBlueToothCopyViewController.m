//
//  GJBlueToothCopyViewController.m
//  Demo
//
//  Created by 高 军 on 15/4/1.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJBlueToothCopyViewController.h"

@interface GJBlueToothCopyViewController ()<CBPeripheralDelegate, CBPeripheralManagerDelegate>
@property (nonatomic) CBPeripheralManager *mPeripheralManager;
@property (nonatomic) NSMutableArray *mArrServices;
@property (nonatomic, assign) int mServiceCount, count;

@end

@implementation GJBlueToothCopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mArrServices = [[NSMutableArray alloc] init];
    
    self.mPeripheral.delegate = self;
    [self.mPeripheral discoverServices:nil];
}

- (void)didReceiveMemoryWarning {
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

#pragma mark CBPeripheral Delegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    self.mServiceCount = peripheral.services.count;
    NSLog(@"services count :%ld", peripheral.services.count);
    for (CBService *service in peripheral.services)
    {
        NSLog(@"Discovered service %@", service);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    CBMutableService *mutService = [[CBMutableService alloc] initWithType:service.UUID primary:service.isPrimary];
    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithCapacity:service.characteristics.count];
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        CBMutableCharacteristic *mutCharacteristic = [[CBMutableCharacteristic alloc] initWithType:characteristic.UUID properties:CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsReadable];
        [mutArr addObject:mutCharacteristic];
    }
    mutService.characteristics = mutArr;
    
    [self.mArrServices addObject:mutService];
    [self.mPeripheralManager addService:mutService];
    
    self.count++;
    if (self.count == self.mServiceCount)
    {
        self.mPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)];
        self.mPeripheralManager.delegate = self;
    }
    
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
//        NSLog(@"Discovered characteristic %@", characteristic);
        [peripheral readValueForCharacteristic:characteristic];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    NSData *data = characteristic.value;
//    NSLog(@"didUpdateValueForCharacteristic %@:%@", characteristic, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //    [peripheral writeValue:dataToWrite forCharacteristic:interestingCharacteristic
    //                      type:CBCharacteristicWriteWithResponse];
    if (error)
    {
        NSLog(@"Error writing characteristic value: %@", [error localizedDescription]);
    }
}



#pragma mark CBPeripheralManager Delegate
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    NSString *str = @"copy success";
    if (error)
    {
        str = [NSString stringWithFormat:@"%@", error];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        NSMutableArray *arrUUIDs = [[NSMutableArray alloc] initWithCapacity:self.mArrServices.count];
        for (CBMutableService *service in self.mArrServices)
        {
            [self.mPeripheralManager addService:service];
            [arrUUIDs addObject:service.UUID];
        }
        [self.mPeripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey : arrUUIDs}];
    }
}



@end
