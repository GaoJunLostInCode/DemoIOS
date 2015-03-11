//
//  GJHttpClient.h
//  Demo
//
//  Created by 高 军 on 15/3/11.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GJHttpClientCompletedHandler)(NSURLResponse*, NSData*, NSError*);

@interface GJHttpClient : NSObject

//transfer dicParams to JSON and post it
- (void)post:(NSDictionary*)dicParams toUrl: (NSString*)toUrl completedHandler:(GJHttpClientCompletedHandler)handler;
//download
- (void)download:(NSString*)strUrl completedHandler:(GJHttpClientCompletedHandler)handler;
//upload
- (void)upload:(NSString*)strWholeUrl postParams:(NSDictionary*)postParems data:(NSData*)data fileName:(NSString*)fileName completedHandler:(GJHttpClientCompletedHandler)handler;

@end
