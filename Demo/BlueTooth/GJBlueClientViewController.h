//
//  GJBlueToothDetailViewController.h
//  Demo
//
//  Created by 高 军 on 15/3/31.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstBlueTooth.h"
@import CoreBluetooth;


@interface GJBlueClientViewController : UIViewController

@property (nonatomic) CBPeripheral *mPeripheral;

@end
