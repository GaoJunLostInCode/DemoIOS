//
//  GJBlueToothCopier.m
//  Demo
//
//  Created by 高 军 on 15/4/2.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJBlueToothCopier.h"

const static NSString *peripheralFileName = @"peripheral.xml";

@implementation GJBlueToothCopier

+ (BOOL)writeToLocalFile:(CBPeripheral*)peripheral services:(NSArray*)services
{
    NSString *filePath = [GJBlueToothCopier peripheralServicesFilePath];

    NSMutableArray *arrServices = [[NSMutableArray alloc] init];
    for (CBService *service in services)
    {
        NSMutableArray *arrCharacteristics = [[NSMutableArray alloc] init];
        for (CBCharacteristic *characteristic in service.characteristics)
        {
            NSDictionary *dicCharacteristic =
            @{
              @"UUID":characteristic.UUID.UUIDString,
              @"value":characteristic.value==nil?[@"" dataUsingEncoding:NSUTF8StringEncoding]:characteristic.value
              };
            [arrCharacteristics addObject:dicCharacteristic];
        }
        
        NSDictionary *dicService = @{@"UUID":service.UUID.UUIDString, @"primary":service.isPrimary?@"YES":@"NO", @"characteristics":arrCharacteristics};
        [arrServices addObject:dicService];
    }
    
    NSDictionary *dicPeripheral = @{@"services":arrServices};
    NSLog(@"write peripheral %@", dicPeripheral);
    return [dicPeripheral writeToFile:filePath atomically:YES];
}

+ (NSString*)peripheralServicesFilePath
{
    NSString *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [dirPath stringByAppendingPathComponent:peripheralFileName];
    
    return filePath;
}

+ (NSString*)characteristicFilePath:(CBUUID*)characteristicUUID
{
    return [[self peripheralServicesFilePath] stringByAppendingPathComponent:characteristicUUID.UUIDString];
}

+ (NSArray*)readServicesFromLocalFile
{
    NSString *filePath = [GJBlueToothCopier peripheralServicesFilePath];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSMutableArray *services = [[NSMutableArray alloc] init];
    for (NSDictionary *service in dic[@"services"])
    {
        BOOL isPrimary = [service[@"primary"] isEqualToString:@"YES"] ? YES : NO;
        CBUUID *uuidService = [CBUUID UUIDWithString:service[@"UUID"]];
        NSLog(@"read uuid %@", uuidService);
        CBMutableService *mutService = [[CBMutableService alloc] initWithType:uuidService primary:isPrimary];
        [services addObject:mutService];
        NSMutableArray *mutArr = [[NSMutableArray alloc] init];
        for (NSDictionary *characteristic in service[@"characteristics"])
        {
            CBUUID *uuidCharacteristic = [CBUUID UUIDWithString:characteristic[@"UUID"]];
            CBMutableCharacteristic *mutCharacteristic = [[CBMutableCharacteristic alloc] initWithType:uuidCharacteristic properties:CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsReadable];
            [mutArr addObject:mutCharacteristic];
        }

        mutService.characteristics = mutArr;
    }
    
    return services;
}

+ (BOOL)writeToLocalFile:(CBCharacteristic *)characteristic value:(NSData*)value
{
    NSMutableArray *arrDescriptors = [[NSMutableArray alloc] init];

    for (CBDescriptor *descriptor in characteristic.descriptors)
    {
        
        NSMutableDictionary *dicDescriptor = [[NSMutableDictionary alloc] init];
        [arrDescriptors addObject:dicDescriptor];
        [dicDescriptor setObject:descriptor.value==nil?@"":descriptor.value forKey:@"value"];
        [dicDescriptor setObject:descriptor.UUID.UUIDString forKey:@"UUID"];
    }
    NSDictionary *dic = @{
                          @"UUID":characteristic.UUID.UUIDString,
                          @"value":value==nil?[@"" dataUsingEncoding:NSUTF8StringEncoding]:value,
                          @"descriptors":arrDescriptors
                          };
    NSString *filePath = [self characteristicFilePath:characteristic.UUID];
    return [dic writeToFile:filePath atomically:YES];
}

+ (CBMutableCharacteristic*)readFromLocalFile:(CBUUID*)characteristicUUID
{
    NSString *filePath = [self characteristicFilePath:characteristicUUID];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    CBMutableCharacteristic *characteristic = [[CBMutableCharacteristic alloc] initWithType:dic[@"UUID"] properties:CBCharacteristicPropertyWrite value:nil permissions:CBAttributePermissionsWriteable];
    characteristic.value = dic[@"value"];
    NSMutableArray *arrDescriptors = [[NSMutableArray alloc] init];
    for (NSDictionary *dicDescriptor in dic[@"descriptors"])
    {
        CBUUID *uuid = [CBUUID UUIDWithString:dicDescriptor[@"UUID"]];
        CBMutableDescriptor *descriptor = [[CBMutableDescriptor alloc] initWithType:uuid value:dicDescriptor[@"value"]];
        [arrDescriptors addObject:descriptor];
    }
    
    characteristic.descriptors = arrDescriptors;

    
    
    return characteristic;
}

@end
