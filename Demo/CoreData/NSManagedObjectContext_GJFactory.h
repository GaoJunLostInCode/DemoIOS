//
//  NSManageObjectContext_GJFactory.h
//  Demo
//
//  Created by 高 军 on 15/4/15.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

@import CoreData;

@interface NSManagedObjectContext (NSManagedObjectContext_GJFactory)

+ (NSManagedObjectContext*)defaultSQLiteContext;

@end
