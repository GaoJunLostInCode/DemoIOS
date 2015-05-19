//
//  GJimageUtils.m
//  Demo
//
//  Created by 高 军 on 15/3/9.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJImageUtils.h"


@implementation GJImageUtils

+(UIImage*)compressImageDownWithMaxLength:(UIImage*)theImage maxLength:(NSInteger)maxLength
{
    UIImage * bigImage = theImage;
    
    float actualHeight = bigImage.size.height;
    float actualWidth = bigImage.size.width;
    
    float imgRatio = actualWidth / actualHeight;
    if (imgRatio >= 1) {
        if (actualWidth > maxLength) {
            actualWidth = maxLength;
            actualHeight = maxLength/imgRatio;
        }
    }else{
        if (actualHeight > maxLength) {
            actualHeight = maxLength;
            actualWidth = maxLength * imgRatio;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    
    UIGraphicsBeginImageContext(rect.size);
    [bigImage drawInRect:rect]; // scales image to rect
    theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return theImage;
    
}

@end
