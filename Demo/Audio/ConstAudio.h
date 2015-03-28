//
//  ConstAudio.h
//  Push
//
//  Created by 高 军 on 15/3/26.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#ifndef Push_ConstAudio_h
#define Push_ConstAudio_h

#define AUDIO_BUFFER_SIZE                               640
#define D_AUDIO_RECORD_BUFFERS_NUMBER					10
#define D_AUDIO_PLAY_BUFFERS_NUMBER						10

#define D_AUDIO_BUFFER_SZIE                             640
#define D_AUDIO_TIME_LIMIT                              100

static int AUDIO_PACKAGE_LENGTH = 187; //每包音频总长度
static int AUDIO_PACKAGE_ADPCM_LENGTH = 160; //每包音频adpcm数据长度
static const int kNumberBuffers = 3;                              // 1


static int index_adjust[8] = {-1,-1,-1,-1,2,4,6,8};

static int step_table[89] = {
    7,8,9,10,11,12,13,14,16,17,19,21,23,25,28,31,34,37,41,45,
    50,55,60,66,73,80,88,97,107,118,130,143,157,173,190,209,230,253,279,307,337,371,
    408,449,494,544,598,658,724,796,876,963,1060,1166,1282,1411,1552,1707,1878,2066,
    2272,2499,2749,3024,3327,3660,4026,4428,4871,5358,5894,6484,7132,7845,8630,9493,
    10442,11487,12635,13899,15289,16818,18500,20350,22385,24623,27086,29794,32767
};


#endif
