//
//  NSManageObjectContext_GJFactory.m
//  Demo
//
//  Created by 高 军 on 15/4/15.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "NSManagedObjectContext_GJFactory.h"

@implementation NSManagedObjectContext (NSManagedObjectContext_GJFactory)

+ (NSManagedObjectContext*)defaultSQLiteContext
{
    static NSManagedObjectContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[NSManagedObjectContext alloc] init];
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL *url = [NSURL fileURLWithPath:[filePath stringByAppendingPathComponent:@"model.sqlite"]];
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
        [context setPersistentStoreCoordinator:coordinator];
    });

    
    return context;
}

@end
