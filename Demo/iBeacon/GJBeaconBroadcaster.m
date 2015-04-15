//
//  GJBeaconBroadcaster.m
//  Demo
//
//  Created by 高 军 on 15/3/28.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJBeaconBroadcaster.h"

@interface GJBeaconBroadcaster ()<CBPeripheralManagerDelegate>
@property (nonatomic) CLBeaconRegion *beaconRegion;
@property (nonatomic) CBPeripheralManager *peripheralManager;
@end

@implementation GJBeaconBroadcaster

- (id)initWithiBeaconUUIDString:(NSString*)uuidString
{
    self = [super init];
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:uuidString];
    
    // Create the beacon region.
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:identifier];
    
    return self;
}

+ (BOOL)isAvailable
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    BOOL available = [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]];
    
    if (status==kCLAuthorizationStatusAuthorized || status==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        return available;
    }else{
        return NO;
    }
}

- (void)startAdvertiseBeacon
{
    if (![GJBeaconBroadcaster isAvailable])
    {
        NSLog(@"startBeacon iBeacon is not available");
        return;
    }
    
    // Create the peripheral manager.
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
}

#pragma mark CBPeripheralManager Delegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"peripheralManagerDidUpdateState %ld", peripheral.state);
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        // Create a dictionary of advertisement data.
        NSDictionary *beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
        
        // Start advertising your beacon's data.
        [self.peripheralManager startAdvertising:beaconPeripheralData];
    }else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        [self.peripheralManager stopAdvertising];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    NSLog(@"peripheralManagerDidStartAdvertising %@", error);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"didSubscribeToCharacteristic %@", characteristic);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request
{
    NSLog(@"didReceiveReadRequest %@", request);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    NSLog(@"didReceiveWriteRequests %@", requests);
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    NSLog(@"peripheralManagerIsReadyToUpdateSubscribers");
}

@end
