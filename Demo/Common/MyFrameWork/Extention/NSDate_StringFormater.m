//
//  NSDate_StringFormater.m
//  Radar
//
//  Created by 高 军 on 15/5/8.
//  Copyright (c) 2015年 ZA. All rights reserved.
//

#import "NSDate_StringFormater.h"

@implementation NSDate (NSDate_StringFormater)


- (NSString*)toTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm:ss";
    return [formatter stringFromDate:self];
}

- (NSString*)toDateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:self];
}

@end
