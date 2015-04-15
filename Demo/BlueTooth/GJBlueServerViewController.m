//
//  GJBlueToothAdvertiserViewController.m
//  Demo
//
//  Created by 高 军 on 15/4/1.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJBlueServerViewController.h"
#import "GJBlueToothCopyViewController.h"
#import "GJBlueToothCopier.h"

@interface GJBlueServerViewController ()<CBPeripheralManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *labelStatus;
@property (nonatomic) CBPeripheralManager * mPeripheralManager;
@property (nonatomic) CBMutableCharacteristic *mCharacteristic;
@property (nonatomic) CBMutableService *mService;
@property (nonatomic) NSMutableArray *mArrServices;
@end

@implementation GJBlueServerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mArrServices = [[NSMutableArray alloc] init];
    self.mPeripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)];
}

- (void)setUpService
{
    [self.mArrServices removeAllObjects];
    CBUUID *heartRateServiceUUID = [CBUUID UUIDWithString: @"180D"];
    CBUUID *myCustomServiceUUID = [CBUUID UUIDWithString:@"71DA3FD1-7E10-41C1-B16F-4430B506CDE7"];
    NSString *strValue = @"abc123";
    self.mCharacteristic = [[CBMutableCharacteristic alloc] initWithType:heartRateServiceUUID properties:CBCharacteristicPropertyRead value:[strValue dataUsingEncoding:NSUTF8StringEncoding] permissions:CBAttributePermissionsReadable];
    self.mService = [[CBMutableService alloc] initWithType:myCustomServiceUUID primary:YES];
    [self.mArrServices addObject:self.mService];
    self.mService.characteristics = @[self.mCharacteristic];
//    [self.mPeripheralManager addService:self.mService];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

#pragma mark CBPeripheralManager Delegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
//        [self setUpService];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    NSString *strInfo = @"add service success";
    if (error == nil)
    {
//        [self.mPeripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[service.UUID] }];
    }else
    {
        strInfo = [NSString stringWithFormat:@"add service failed : %@", error];
    }
    
    NSLog(@"%@:%@", strInfo, service.UUID);
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
    }else
    {
        [self.labelStatus setText:@"success"];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    NSLog(@"didReceiveReadRequest ....%@", request);
    CBATTError resultStatus = CBATTErrorAttributeNotFound;
//    if ([request.characteristic.UUID isEqual:self.mCharacteristic.UUID])
//    {
//        if (request.offset > self.mCharacteristic.value.length)
//        {
//            resultStatus = CBATTErrorInvalidOffset;
//        }else
//        {
//            resultStatus = CBATTErrorSuccess;
//            request.value = [self.mCharacteristic.value subdataWithRange:NSMakeRange(request.offset, self.mCharacteristic.value.length - request.offset)];
//        }
//    }
    
    CBCharacteristic *characteristic = [GJBlueToothCopier readFromLocalFile:request.characteristic.UUID];
    if (request.offset > characteristic.value.length)
    {
        resultStatus = CBATTErrorInvalidOffset;
    }else
    {
        resultStatus = CBATTErrorSuccess;
        request.value = [characteristic.value subdataWithRange:NSMakeRange(request.offset, characteristic.value.length - request.offset)];
    }
    
    NSLog(@"didReceiveReadRequest ....%@", request);
    
    [self.mPeripheralManager respondToRequest:request withResult:resultStatus];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    for (CBATTRequest *request in requests)
    {
        NSLog(@"request : %@", request);
    }
    
    self.mCharacteristic.value = ((CBATTRequest*)requests[0]).value;
    [self.mPeripheralManager respondToRequest:[requests objectAtIndex:0] withResult:CBATTErrorSuccess];
}
- (IBAction)onAdvertiseButtonClicked:(id)sender
{
    if (self.mPeripheralManager.state == CBPeripheralManagerStatePoweredOn)
    {
        [self setUpService];
        [self startAdvertise];
    }
}

- (IBAction)onAdvertiseCopiedButtonClicked:(id)sender
{
    [self.mArrServices removeAllObjects];
    
    if (self.mPeripheralManager.state == CBPeripheralManagerStatePoweredOn)
    {
        [self.mArrServices addObjectsFromArray:[GJBlueToothCopier readServicesFromLocalFile]];
        [self startAdvertise];
    }
}

- (void)startAdvertise
{
    NSMutableArray *arrUUIDs = [[NSMutableArray alloc] init];
    for (CBMutableService *service in self.mArrServices)
    {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180F"]]) {
            continue;
        }
        [arrUUIDs addObject:service.UUID];
        NSLog(@"uuid : %@", service.UUID);

        [self.mPeripheralManager addService:service];
    }
    
    if([self.mPeripheralManager isAdvertising])
    {
        [self.mPeripheralManager stopAdvertising];
    }
    [self.mPeripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : arrUUIDs }];
}

@end
