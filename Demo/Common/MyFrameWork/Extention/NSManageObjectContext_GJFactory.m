//
//  NSManageObjectContext_GJFactory.m
//  Radar
//
//  Created by 高 军 on 15/4/14.
//  Copyright (c) 2015年 ZA. All rights reserved.
//

#import "NSManageObjectContext_GJFactory.h"

@implementation NSManagedObjectContext (GJFactory)

+ (NSManagedObjectContext*)defaultSQLiteContext
{
    static NSManagedObjectContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void)
          {
              context = [[NSManagedObjectContext alloc] init];
              NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
              NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
              NSURL *url = [NSURL fileURLWithPath:[doc stringByAppendingPathComponent:@"CoreData.sqlite"]];
              NSError *error = nil;
              [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
              if (nil != error) {
                  NSLog(@"NSManageObjectContext_GJFactory defaultSQLiteContext error:%@", error);
              }
              
              context.persistentStoreCoordinator = coordinator;
          });
    
    return context;
}

@end
