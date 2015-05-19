//
//  GJSessionHttpClient.m
//  Demo
//
//  Created by 高 军 on 15/4/26.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJSessionHttpClient.h"

@implementation GJSessionHttpClient

- (void)upload
{
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/httpTest/json/uploadFile"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask* uploadTask = [urlSession uploadTaskWithRequest:request fromFile:fileUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (nil==error) {
            NSLog(@"success %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }else{
            NSLog(@"upload failed .... %@", error);
        }
    }];
    [uploadTask resume];
}

@end
