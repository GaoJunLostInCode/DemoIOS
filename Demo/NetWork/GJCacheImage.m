//
//  GJCacheImage.m
//  Push
//
//  Created by 高 军 on 15/2/28.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJCacheImage.h"
#import "GJHttpClient.h"
#import "GJImageUtils.h"


@interface GJCacheImage()
@property (nonatomic) NSString *imageUrl;       //网络地址
@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *localFilePath;  //本地存储的完整路径
@property (nonatomic) GJHttpClient *httpClient;
@end

@implementation GJCacheImage

- (id)initWithUrl:(NSString*)imageUrl localFilePath:(NSString*)filePath
{
    self = [super init];
    
    _imageUrl = imageUrl;
    if (filePath == nil)
    {

    }
    _localFilePath = filePath;
    
    return self;
}

- (void)getImageWithCompletedHandler:(void(^)(GJCacheImage *cache, UIImage *image))handler;
{
    if (_image == nil)
    {
        self.image = [[UIImage alloc] initWithContentsOfFile:_localFilePath];
    }
    
    if (nil == _image)
    {
        _httpClient = [[GJHttpClient alloc] init];
        [_httpClient download:_imageUrl completedHandler:^(NSURLResponse *response, NSData *data, NSError *error)
            {
                self.image = [[UIImage alloc] initWithData:data];
                self.image = [GJImageUtils compressImageDownWithMaxLength:_image maxLength:kGJImageUtilsImageMaxLength];
                
                handler(self, _image);
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *fileName = [_localFilePath lastPathComponent];
                NSRange range = [_localFilePath rangeOfString:fileName];
                if (range.location != NSNotFound && range.location > 0)
                {
                    NSString *dirPath = [_localFilePath substringToIndex:range.location-1];
                    BOOL success = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
                    if (success)
                    {
                        [fileManager createFileAtPath:_localFilePath contents:data attributes:nil];
                    }
                }
            }];
    }else
    {
        handler(self, _image);
    }
}


@end
