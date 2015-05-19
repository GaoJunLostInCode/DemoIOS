//
//  NSString_Ext.h
//  Radar
//
//  Created by 高 军 on 15/5/11.
//  Copyright (c) 2015年 ZA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface NSString (NSString_Ext)

- (NSString*)md5;

- (NSString*)sha1;

@end
