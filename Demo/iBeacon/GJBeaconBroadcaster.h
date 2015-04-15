//
//  GJBeaconBroadcaster.h
//  Demo
//
//  Created by 高 军 on 15/3/28.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface GJBeaconBroadcaster : NSObject

- (id)initWithiBeaconUUIDString:(NSString*)uuidString;
+ (BOOL)isAvailable;
- (void)startAdvertiseBeacon;

@end
