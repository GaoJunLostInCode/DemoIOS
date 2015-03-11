//
//  GJParamBase.m
//  Demo
//
//  Created by 高 军 on 15/3/11.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJParamBase.h"
#import <objc/message.h>

@implementation GJParamBase

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        id value = [self valueForKey:propName];
        if ([value isKindOfClass:[GJParamBase class]])
        {
            GJParamBase *child = (GJParamBase*)value;
            value = [child toDictionary];
        }
        [dic setValue:value forKey:propName];
    }
    
    
    return dic;
}


@end
