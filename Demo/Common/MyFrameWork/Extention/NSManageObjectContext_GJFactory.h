//
//  NSManageObjectContext_GJFactory.h
//  Radar
//
//  Created by 高 军 on 15/4/14.
//  Copyright (c) 2015年 ZA. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (GJFactory)

+ (NSManagedObjectContext*)defaultSQLiteContext;

@end
