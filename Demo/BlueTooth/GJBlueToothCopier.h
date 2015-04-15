//
//  GJBlueToothCopier.h
//  Demo
//
//  Created by 高 军 on 15/4/2.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreBluetooth;

@interface GJBlueToothCopier : NSObject

+ (BOOL)writeToLocalFile:(CBPeripheral*)peripheral services:(NSArray*)services;
+ (NSArray*)readServicesFromLocalFile;
+ (BOOL)writeToLocalFile:(CBCharacteristic *)characteristic value:(NSData*)value;
+ (CBMutableCharacteristic*)readFromLocalFile:(CBUUID*)characteristicUUID;

@end
