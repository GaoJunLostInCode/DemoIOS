//
//  SettingsUtil.m
//  Push
//
//  Created by 高 军 on 15/2/7.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "SettingsUtil.h"

@implementation SettingsUtil

+ (NSDictionary*)getDictionaryForName:(NSString *)dicName plistName:(NSString*)plistName
{
    NSDictionary *dicRoot = [self dictionaryFromPlist:plistName];
    
    return [dicRoot objectForKey:dicName];
}

+ (NSDictionary*)dictionaryFromPlist:(NSString*)plistName
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    return dic;
}

+ (NSDictionary*)getDictionaryForName:(NSString*)dicName
{
    NSDictionary *dic = [SettingsUtil dictionaryFromPlist:@"settings"];
    
    NSDictionary *dicRet = [dic valueForKey:dicName];
    
    return dicRet;
}

+ (NSString*)getStringForName:(NSString*)name
{
    NSDictionary *dic = [SettingsUtil dictionaryFromPlist:@"settings"];
    NSString *value = [dic valueForKey:name];
    
    return value;
}

+ (NSArray *)getArrayForName:(NSString*)name
{
    NSDictionary *dic = [SettingsUtil dictionaryFromPlist:@"settings"];
    NSArray *arr = [dic valueForKey:name];
    
    return arr;
}

+ (NSString*)getHomeUrl
{
    return [SettingsUtil getStringForName:@"str_url_home"];
}

+ (NSArray*)getMessageArray
{
    return [SettingsUtil getArrayForName:@"arr_message"];
}

@end
