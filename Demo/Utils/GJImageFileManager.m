//
//  GJFileUtils.m
//  Demo
//
//  Created by 高 军 on 15/5/12.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJImageFileManager.h"

@implementation GJImageFileManager

+ (NSString*)saveDataAsLocalFile:(NSData*)data
{
    NSMutableString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [GJImageFileManager fileNameByDateNow];
    NSString *filePath = [documentDirPath stringByAppendingPathComponent:fileName];
    if (![fileManager fileExistsAtPath:filePath])
    {
        [fileManager createFileAtPath:filePath contents:data attributes:nil];
    }
    
    
    return filePath;
}

+ (NSString*)fileNameByDateNow
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy_MM_dd_hh_mm_ss";
    return [formatter stringFromDate:date];
    
}

@end
