//
//  GJimageUtils.h
//  Demo
//
//  Created by 高 军 on 15/3/9.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import <Foundation/Foundation.h>

const static NSInteger kGJImageUtilsImageMaxLength = 800;

@interface GJImageUtils : NSObject

+(UIImage*)compressImageDownWithMaxLength:(UIImage*)theImage maxLength:(NSInteger)maxLength;

@end
