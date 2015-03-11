//
//  GJSectionInfo.m
//  Demo
//
//  Created by 高 军 on 15/2/17.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJSectionInfo.h"
#import "GJCellInfo.h"

@implementation GJSectionInfo

- (NSInteger)cellCount
{
    return self.arrCellInfo.count;
}

- (GJCellInfo*)cellInfoAtIndex:(NSInteger)index
{
    if (index > self.arrCellInfo.count) {
        return  nil;
    }
    
    return [self.arrCellInfo objectAtIndex:index];
}

- (void)removeCellInfoAtIndex:(NSInteger)index
{
    if (index > self.arrCellInfo.count) {
        return;
    }
    
    [self.arrCellInfo removeObjectAtIndex:index];
}

@end
