//
//  GJSectionInfo.h
//  Demo
//
//  Created by 高 军 on 15/2/17.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GJCellInfo;

@interface GJSectionInfo : NSObject

@property (nonatomic, getter=isOpen)BOOL open;
@property (nonatomic) NSString* sectionName;
@property (nonatomic) NSMutableArray* arrCellInfo;     //Array<GJCellInfo>
@property (nonatomic) NSInteger section;

- (NSInteger)cellCount;
- (GJCellInfo*)cellInfoAtIndex:(NSInteger)index;
- (void)removeCellInfoAtIndex:(NSInteger)index;

@end
