////
////  GJAudioPlayer.m
////  Push
////
////  Created by 高 军 on 15/3/26.
////  Copyright (c) 2015年 gaojun. All rights reserved.
////
//
//#import "GJAudioPlayer.h"
//#import "ConstAudio.h"
//
//
//UInt32 maxPacketSize;
//UInt32 propertySize = sizeof (maxPacketSize);
//
//struct AQPlayerState {
//    AudioStreamBasicDescription   mDataFormat;                    // 2
//    AudioQueueRef                 mQueue;                         // 3
//    AudioQueueBufferRef           mBuffers[kNumberBuffers];       // 4
//    AudioFileID                   mAudioFile;                     // 5
//    UInt32                        bufferByteSize;                 // 6
//    SInt64                        mCurrentPacket;                 // 7
//    UInt32                        mNumPacketsToRead;              // 8
//    AudioStreamPacketDescription  *mPacketDescs;                  // 9
//    bool                          mIsRunning;                     // 10
//};
//
//static void HandleOutputBuffer (
//                                void                *aqData,
//                                AudioQueueRef       inAQ,
//                                AudioQueueBufferRef inBuffer
//                                ) {
//    AQPlayerState *pAqData = (AQPlayerState *) aqData;        // 1
//    if (pAqData->mIsRunning == 0) return;                     // 2
//    UInt32 numBytesReadFromFile;                              // 3
//    UInt32 numPackets = pAqData->mNumPacketsToRead;           // 4
//    AudioFileReadPackets (
//                          pAqData->mAudioFile,
//                          false,
//                          &numBytesReadFromFile,
//                          pAqData->mPacketDescs,
//                          pAqData->mCurrentPacket,
//                          &numPackets,
//                          inBuffer->mAudioData
//                          );
//    if (numPackets > 0) {                                     // 5
//        inBuffer->mAudioDataByteSize = numBytesReadFromFile;  // 6
//        AudioQueueEnqueueBuffer (
//                                 pAqData->mQueue,
//                                 inBuffer,
//                                 (pAqData->mPacketDescs ? numPackets : 0),
//                                 pAqData->mPacketDescs
//                                 );
//        pAqData->mCurrentPacket += numPackets;                // 7 
//    } else {
//        AudioQueueStop (
//                        pAqData->mQueue,
//                        false
//                        );
//        pAqData->mIsRunning = false; 
//    }
//    
//    
//    if (numPackets == 0) {                          // 1
//        AudioQueueStop (                            // 2
//                        pAqData->mQueue,                        // 3
//                        false                                   // 4
//                        );
//        pAqData->mIsRunning = false;                // 5
//    }
//}
//
//void DeriveBufferSize (
//                       AudioStreamBasicDescription &ASBDesc,                            // 1
//                       UInt32                      maxPacketSize,                       // 2
//                       Float64                     seconds,                             // 3
//                       UInt32                      *outBufferSize,                      // 4
//                       UInt32                      *outNumPacketsToRead                 // 5
//) {
//    static const int maxBufferSize = 0x50000;                        // 6
//    static const int minBufferSize = 0x4000;                         // 7
//    
//    if (ASBDesc.mFramesPerPacket != 0) {                             // 8
//        Float64 numPacketsForTime =
//        ASBDesc.mSampleRate / ASBDesc.mFramesPerPacket * seconds;
//        *outBufferSize = numPacketsForTime * maxPacketSize;
//    } else {                                                         // 9
//        *outBufferSize =
//        maxBufferSize > maxPacketSize ?
//        maxBufferSize : maxPacketSize;
//    }
//    
//    if (                                                             // 10
//        *outBufferSize > maxBufferSize &&
//        *outBufferSize > maxPacketSize
//        )
//        *outBufferSize = maxBufferSize;
//    else {                                                           // 11
//        if (*outBufferSize < minBufferSize)
//            *outBufferSize = minBufferSize;
//    }
//    
//    *outNumPacketsToRead = *outBufferSize / maxPacketSize;           // 12
//}
//
//
//
//@implementation GJAudioPlayer
//AQPlayerState aqData;
//
//- (void)play:(NSString*)filePath
//{
//    AudioQueueNewOutput (                                // 1
//                         &aqData.mDataFormat,                             // 2
//                         HandleOutputBuffer,                              // 3
//                         &aqData,                                         // 4
//                         CFRunLoopGetCurrent (),                          // 5
//                         kCFRunLoopCommonModes,                           // 6
//                         0,                                               // 7
//                         &aqData.mQueue                                   // 8
//                         );
//    
//    
//    DeriveBufferSize (                                   // 6
//                      aqData.mDataFormat,                              // 7
//                      maxPacketSize,                                   // 8
//                      0.5,                                             // 9
//                      &aqData.bufferByteSize,                          // 10
//                      &aqData.mNumPacketsToRead                        // 11
//                      );
//    
//    bool isFormatVBR = (                                       // 1
//                        aqData.mDataFormat.mBytesPerPacket == 0 ||
//                        aqData.mDataFormat.mFramesPerPacket == 0
//                        );
//    
//    if (isFormatVBR) {                                         // 2
//        aqData.mPacketDescs =
//        (AudioStreamPacketDescription*) malloc (
//                                                aqData.mNumPacketsToRead * sizeof (AudioStreamPacketDescription)
//                                                );
//    } else {                                                   // 3
//        aqData.mPacketDescs = NULL;
//    }
//    
//    
//    
//    
//    aqData.mCurrentPacket = 0;                                // 1
//    
//    for (int i = 0; i < kNumberBuffers; ++i) {                // 2
//        AudioQueueAllocateBuffer (                            // 3
//                                  aqData.mQueue,                                    // 4
//                                  aqData.bufferByteSize,                            // 5
//                                  &aqData.mBuffers[i]                               // 6
//                                  );
//        
//        HandleOutputBuffer (                                  // 7
//                            &aqData,                                          // 8
//                            aqData.mQueue,                                    // 9
//                            aqData.mBuffers[i]                                // 10
//                            );
//    }
//    
//    
//    
//    
//    aqData.mIsRunning = true;                          // 1
//    
//    AudioQueueStart (                                  // 2
//                     aqData.mQueue,                                 // 3
//                     NULL                                           // 4
//                     );
//    
//    do {                                               // 5
//        CFRunLoopRunInMode (                           // 6
//                            kCFRunLoopDefaultMode,                     // 7
//                            0.25,                                      // 8
//                            false                                      // 9
//                            );
//    } while (aqData.mIsRunning);
//    
//    CFRunLoopRunInMode (                               // 10
//                        kCFRunLoopDefaultMode,
//                        1,
//                        false
//                        );
//    
//    
//    
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
//        NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:filePath];
//        
//        NSData *data = [file readDataOfLength:AUDIO_PACKAGE_LENGTH];
//        while (data.length > 0)
//        {
//            NSLog(@"lenght read ====== %ld", data.length);
//
//            data = [file readDataOfLength:AUDIO_PACKAGE_LENGTH];
//        }
//    });
//}
//
//- (void)stop
//{
//    
//}
//
//@end
