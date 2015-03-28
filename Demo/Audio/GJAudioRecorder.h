//
//  GJAudioQueue.h
//  CRM
//
//  Created by 高 军 on 15/3/23.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>



@interface GJAudioRecorder : NSObject

- (id)init;

- (void)record:(NSString*)filePath;
- (void)stop;
- (BOOL)isRecording;
- (void)pause;


@end
