//
//  SettingsUtil.h
//  Push
//
//  Created by 高 军 on 15/2/7.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingsUtil : NSObject
{
    
}

+ (NSDictionary*)getDictionaryForName:(NSString*)dicName;
+ (NSDictionary*)getDictionaryForName:(NSString *)dicName plistName:(NSString*)plistName;
+ (NSString*)getHomeUrl;
+ (NSArray*)getMessageArray;

+ (NSString*)getStringForName:(NSString*)name;
+ (NSArray *)getArrayForName:(NSString*)name;

@end
