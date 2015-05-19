//
//  GJHttpClient.m
//  Demo
//
//  Created by 高 军 on 15/3/11.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJHttpClient.h"

static const NSInteger kGJDownloaderTimeOut = 5;

@implementation GJHttpClient

- (void)getWithWholeUrl:(NSString*)wholeUrl completedOnMainThread:(GJHttpClientCompletedHandler)handler
{
    NSURL *url = [NSURL URLWithString:wholeUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:handler];
}

- (void)post:(NSDictionary*)dicParams toUrl: (NSString*)toUrl completedHandler:(GJHttpClientCompletedHandler)handler
{
//    toUrl = @"http://localhost:8080/httpTest/json/testJson";
    NSDate *tmpStartData = [NSDate date];
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dicParams, @"dicParams", nil];
    [dicData setValue:toUrl forKey:@"toUrl"];
    
    BOOL isValidJsonObject = [NSJSONSerialization isValidJSONObject:dicParams];
    if (!isValidJsonObject) {
        return;
    }
    
    NSData *jData = [NSJSONSerialization dataWithJSONObject:dicParams options:0 error:nil];
    NSString *post = [[NSString alloc] initWithData:jData encoding:NSUTF8StringEncoding];
    post = [NSString stringWithFormat:@"data=%@", post];
    NSLog(@"post params========%@", post);
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:toUrl]];
    [request setHTTPMethod:@"POST"];
    //    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:5];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:handler];
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@">>>>>>>>>>cost time = %f", deltaTime);
}

//download
- (void)download:(NSString*)strUrl completedHandler:(GJHttpClientCompletedHandler)handler
{
    NSString *strTestUrl = @"http://192.168.1.12/za-sw-wego/upload/photo/2015-03-03/59737d47-1364-46e9-ab3e-f471069b664b.jpg";
    strUrl = strTestUrl;
    
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kGJDownloaderTimeOut];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:handler];
}

//upload
- (void)upload:(NSString*)strWholeUrl postParams:(NSDictionary*)postParems data:(NSData*)data fileName:(NSString*)fileName completedHandler:(GJHttpClientCompletedHandler)handler;
{
    strWholeUrl = @"http://localhost:8080/httpTest/json/uploadFile";
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strWholeUrl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
    }
    
    if(fileName)
    {
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        
        //声明pic字段，文件名
        [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",fileName];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //    if(picFilePath)
    {
        //将image的data加入
        [myRequestData appendData:data];
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:handler];
    
}

@end
