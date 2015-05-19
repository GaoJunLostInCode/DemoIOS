////
////  NSObject_JsonConverter.m
////  Radar
////
////  Created by 高 军 on 15/5/6.
////  Copyright (c) 2015年 ZA. All rights reserved.
////
//
//#import "NSObject_JsonConverter.h"
//#import "ZABaseOption.h"
//
//@implementation  NSObject (NSObject_JsonConverter)
//
//- (NSDictionary*)toDictionary
//{
//    NSMutableDictionary *mutDictionary = [[NSMutableDictionary alloc] init];
//    
//    for (NSString *strPropertyName in [[self class] propertyNames]) {
//        id value = [self valueForKey:strPropertyName];
//        if ([value isKindOfClass:[ZABaseOption class]])
//        {
//            [mutDictionary setValue:[value toDictionary] forKey:strPropertyName];
//        }else if ([value isKindOfClass:[NSArray class]]){
//            NSMutableArray *mutItems = [[NSMutableArray alloc] init];
//            for (id item in value)
//            {
//                if ([item isKindOfClass:[ZABaseOption class]]) {
//                    [mutItems addObject:[item toDictionary]];
//                }else{
//                    [mutItems addObject:item];
//                }
//            }
//            [mutDictionary setValue:mutItems forKey:strPropertyName];
//        }
//        else{
//            [mutDictionary setValue:value forKey:strPropertyName];
//        }
//    }
//    
//    return mutDictionary;
//}
//
//- (NSString*)toJsonString
//{
//    NSError *error;
//    NSData *strData = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:0 error:&error];
//    
//    return [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
//}
//
//- (NSArray*)propertyNames
//{
//    NSAssert(NO, @"must implete the propertyNames method!");
//    return nil;
//}
//
//@end
