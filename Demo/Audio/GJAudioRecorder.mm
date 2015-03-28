//
//  GJAudioQueue.m
//  CRM
//
//  Created by 高 军 on 15/3/23.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "GJAudioRecorder.h"
#import "AudioPlayer.h"
#import "ZAAdpcmEncoder.h"


typedef struct AQRecorderState
{
    AudioStreamBasicDescription  mDataFormat;                   // 2
    AudioQueueRef                mQueue;                        // 3
    AudioQueueBufferRef          mBuffers[kNumberBuffers];      // 4
    AudioFileID                  mAudioFile;                    // 5
    UInt32                       bufferByteSize;                // 6
    SInt64                       mCurrentPacket;                // 7
    bool                         mIsRunning;                    // 8
}AQRecorderState;



@implementation GJAudioRecorder
AQRecorderState aqData;                                       // 1
NSString *mFilePath;


static void HandleInputBuffer (
                               void                                 *aqData,
                               AudioQueueRef                        inAQ,
                               AudioQueueBufferRef                  inBuffer,
                               const AudioTimeStamp                 *inStartTime,
                               UInt32                               inNumPackets,
                               const AudioStreamPacketDescription   *inPacketDesc
                               )
{
    AQRecorderState *pAqData = (AQRecorderState *) aqData;               // 1
    
    if (inNumPackets == 0 &&                                             // 2
        pAqData->mDataFormat.mBytesPerPacket != 0)
        inNumPackets =
        inBuffer->mAudioDataByteSize / pAqData->mDataFormat.mBytesPerPacket;
    
    
//    const char* raw = (const char*)inBuffer->mAudioData;
//    adpcm_encode(raw, );
    
    //1. ADPCM encode
    NSData *data = [ZAAdpcmEncoder encode:inBuffer->mAudioData];
    
    //2. write to tail of file
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:mFilePath])
    {
        [data writeToFile:mFilePath atomically:YES];
    }else{
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:mFilePath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
        [fileHandle closeFile];
    }

    
    
//    OSStatus writeRet = AudioFileWritePackets (                                          // 3
//                                               pAqData->mAudioFile,
//                                               false,
//                                               inBuffer->mAudioDataByteSize,
//                                               inPacketDesc,
//                                               pAqData->mCurrentPacket,
//                                               &inNumPackets,
//                                               inBuffer->mAudioData
//                                               );
//    if (writeRet == noErr) {
//        pAqData->mCurrentPacket += inNumPackets;                     // 4
//    }
//    if (pAqData->mIsRunning == 0)                                         // 5
//        return;
    
    AudioQueueEnqueueBuffer(pAqData->mQueue, inBuffer, 0, NULL);
}


OSStatus SetMagicCookieForFile (AudioQueueRef inQueue, AudioFileID inFile)
{
    OSStatus result = noErr;                                    // 3
    UInt32 cookieSize;                                          // 4
    
    if (
        AudioQueueGetPropertySize (                         // 5
                                   inQueue,
                                   kAudioQueueProperty_MagicCookie,
                                   &cookieSize
                                   ) == noErr
        )
        {
            char* magicCookie =
            (char *) malloc (cookieSize);                       // 6
            if (
                AudioQueueGetProperty (                         // 7
                                       inQueue,
                                       kAudioQueueProperty_MagicCookie,
                                       magicCookie,
                                       &cookieSize
                                       ) == noErr
                )
                result =    AudioFileSetProperty (                  // 8
                                                  inFile,
                                                  kAudioFilePropertyMagicCookieData,
                                                  cookieSize,
                                                  magicCookie
                                                  );
            free (magicCookie);                                     // 9
        }
    return result;                                              // 10
}

void DeriveBufferSize (
                       AudioQueueRef                audioQueue,                  // 1
                       AudioStreamBasicDescription  &ASBDescription,             // 2
                       Float64                      seconds,                     // 3
                       UInt32                       *outBufferSize               // 4
) {
    static const int maxBufferSize = 0x50000;                 // 5
    
    int maxPacketSize = ASBDescription.mBytesPerPacket;       // 6
    if (maxPacketSize == 0) {                                 // 7
        UInt32 maxVBRPacketSize = sizeof(maxPacketSize);
        AudioQueueGetProperty (
                               audioQueue,
                               kAudioQueueProperty_MaximumOutputPacketSize,
                               // in Mac OS X v10.5, instead use
                               //   kAudioConverterPropertyMaximumOutputPacketSize
                               &maxPacketSize,
                               &maxVBRPacketSize
                               );
    }
    
    Float64 numBytesForTime =
    ASBDescription.mSampleRate * maxPacketSize * seconds; // 8
    *outBufferSize =
    UInt32 (numBytesForTime < maxBufferSize ?
            numBytesForTime : maxBufferSize);                     // 9
}


- (id)init
{
    self = [super init];
    
    aqData.mDataFormat.mFormatID         = kAudioFormatLinearPCM;     //kAudioFormatLinearPCM; // 2
    aqData.mDataFormat.mSampleRate       = 44100.0;               // 3
    aqData.mDataFormat.mChannelsPerFrame = 2;                     // 4
    aqData.mDataFormat.mBitsPerChannel   = 16;                    // 5
    aqData.mDataFormat.mBytesPerPacket   =                        // 6
    aqData.mDataFormat.mBytesPerFrame =
    aqData.mDataFormat.mChannelsPerFrame * sizeof (SInt16);
    aqData.mDataFormat.mFramesPerPacket  = 1;                     // 7
    
    AudioFileTypeID fileType             = kAudioFileCAFType;    // 8
    aqData.mDataFormat.mFormatFlags =                             // 9
    kLinearPCMFormatFlagIsBigEndian
    | kLinearPCMFormatFlagIsSignedInteger
    | kLinearPCMFormatFlagIsPacked;
    
    AudioQueueNewInput (                              // 1
                        &aqData.mDataFormat,                          // 2
                        HandleInputBuffer,                            // 3
                        &aqData,                                      // 4
                        NULL,                                         // 5
                        kCFRunLoopCommonModes,                        // 6
                        0,                                            // 7
                        &aqData.mQueue                                // 8
                        );
    
    
    
    UInt32 dataFormatSize = sizeof (aqData.mDataFormat);       // 1
    AudioQueueGetProperty (                                    // 2
                           aqData.mQueue,                                         // 3
                           kAudioQueueProperty_StreamDescription,                 // 4
                           // in Mac OS X, instead use
                           //    kAudioConverterCurrentInputStreamDescription
                           &aqData.mDataFormat,                                   // 5
                           &dataFormatSize                                        // 6
                           );
    
    
    
//    const char *filePath = [strFilePath cStringUsingEncoding:NSUTF8StringEncoding];
//    CFURLRef audioFileURL =
//    CFURLCreateFromFileSystemRepresentation (            // 1
//                                             NULL,                                            // 2
//                                             (const UInt8 *) filePath,                        // 3
//                                             strlen (filePath),                               // 4
//                                             false                                            // 5
//                                             );
//    
//    AudioFileCreateWithURL (                                 // 6
//                            audioFileURL,                                        // 7
//                            fileType,                                            // 8
//                            &aqData.mDataFormat,                                 // 9
//                            kAudioFileFlags_EraseFile,                           // 10
//                            &aqData.mAudioFile                                   // 11
//                            );
    
    
    DeriveBufferSize (                               // 1
                      aqData.mQueue,                               // 2
                      aqData.mDataFormat,                          // 3
                      0.5,                                         // 4
                      &aqData.bufferByteSize                       // 5
                      );
    
    
    
    for (int i = 0; i < kNumberBuffers; i++) {           // 1
        AudioQueueAllocateBuffer (                       // 2
                                  aqData.mQueue,                               // 3
                                  aqData.bufferByteSize,                       // 4
                                  &aqData.mBuffers[i]                          // 5
                                  );
        
        AudioQueueEnqueueBuffer (                        // 6
                                 aqData.mQueue,                               // 7
                                 aqData.mBuffers[i],                          // 8
                                 0,                                           // 9
                                 NULL                                         // 10
                                 );
    }
    
    return self;
}

- (void)record:(NSString*)strFilePath
{
    mFilePath = strFilePath;
    
    aqData.mCurrentPacket = 0;                           // 1
    aqData.mIsRunning = true;                            // 2
    AudioQueueStart (                                    // 3
                     aqData.mQueue,                                   // 4
                     NULL                                             // 5
                     );
}

- (BOOL)isRecording
{
    return aqData.mIsRunning;
}

- (void)pause
{
    // Wait, on user interface thread, until user stops the recording
    AudioQueueStop (                                     // 6
                    aqData.mQueue,                                   // 7
                    true                                             // 8
                    );
    
    aqData.mIsRunning = false;                           // 9
}

- (void)stop
{
    if (aqData.mIsRunning)
    {
        AudioQueueStop (                                     // 6
                        aqData.mQueue,                                   // 7
                        true                                             // 8
                        );
        
        aqData.mIsRunning = false;
        
        AudioQueueDispose (                                 // 1
                           aqData.mQueue,                                  // 2
                           true                                            // 3
                           );
        
        AudioFileClose (aqData.mAudioFile);                 // 4
    }
}

@end
