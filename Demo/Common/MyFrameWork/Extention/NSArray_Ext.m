//
//  NSArray_Ext.m
//  Radar
//
//  Created by 高 军 on 15/5/9.
//  Copyright (c) 2015年 ZA. All rights reserved.
//

#import "NSArray_Ext.h"

@implementation NSArray (NSArray_Ext)

+ (id)arrayWithSet:(NSSet*)set
{
    NSMutableArray *array = [NSMutableArray array];
    for (id value in set)
    {
        [array addObject:value];
    }
    
    return array;
}

@end
