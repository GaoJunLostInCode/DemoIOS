//
//  GJCacheImage.h
//  Push
//
//  Created by 高 军 on 15/2/28.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class GJCacheImage;

@interface GJCacheImage : NSObject

- (id)initWithUrl:(NSString*)imageUrl localFilePath:(NSString*)filePath;
- (void)getImageWithCompletedHandler:(void(^)(GJCacheImage *cache, UIImage *image))handler;

@end
