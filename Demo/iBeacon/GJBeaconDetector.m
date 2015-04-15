//
//  GJBeaconDetector.m
//  Demo
//
//  Created by 高 军 on 15/3/28.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJBeaconDetector.h"

@interface GJBeaconDetector()
@property (nonatomic) CLLocationManager *locationManager;
@end

@implementation GJBeaconDetector

- (id)init
{
    self = [super init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined)
    {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestAlwaysAuthorization];
        }else
        {
            [self.locationManager startUpdatingLocation];
        }
    }
    
    return self;
}

- (void)detectiBeacon:(NSString*)iBeaconUUIDString locationManagerDelegate:(id<CLLocationManagerDelegate>)delegate
{
    if (![GJBeaconDetector isAvailable])
    {
        NSLog(@"detectBeacon iBeacon is not available");
        return;
    }
    
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:iBeaconUUIDString];
    CLBeaconRegion* beaconReginTarget = [[CLBeaconRegion alloc] initWithProximityUUID: proximityUUID identifier:identifier];
    
    self.locationManager.delegate = delegate;

    [self.locationManager startMonitoringForRegion:beaconReginTarget];
    [self.locationManager startRangingBeaconsInRegion:beaconReginTarget];

    [self.locationManager startUpdatingLocation];
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


@end
