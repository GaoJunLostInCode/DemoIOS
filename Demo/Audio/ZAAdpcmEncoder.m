//
//  ZAAdpcmEncoder.m
//  Push
//
//  Created by 高 军 on 15/3/26.
//  Copyright (c) 2015年 gaojun. All rights reserved.
//

#import "ZAAdpcmEncoder.h"
#import "ConstAudio.h"



void adpcmEncode(unsigned char * raw, int len, unsigned char * encoded, int * pre_sample, int * index){
    short * pcm = (short *)raw;
    int cur_sample;
    int i;
    int delta;
    int sb;
    int code;
    len >>= 1;
    
    for (i = 0;i < len;i ++){
        cur_sample = pcm[i];
        delta = cur_sample - * pre_sample;
        if (delta < 0)
        {
            delta = -delta;
            sb = 8;
        }
        else
        {
            sb = 0;
        }
        code = 4 * delta / step_table[* index];
        if (code>7)
            code=7;
        
        delta = (step_table[* index] * code) / 4 + step_table[* index] / 8;
        if (sb)
            delta = -delta;
        * pre_sample += delta;
        if (* pre_sample > 32767)
            * pre_sample = 32767;
        else if (* pre_sample < -32768)
            * pre_sample = -32768;
        
        * index += index_adjust[code];
        if (* index < 0)
            * index = 0;
        else if (* index > 88)
            * index = 88;
        if (i & 0x01)
            encoded[i >> 1] |= (code | sb) << 4;
        else
            encoded[i >> 1] = code | sb;
    }
}


@implementation ZAAdpcmEncoder
int adpcm_encode_sample1 = 0, adpcm_encode_index1 = 0, talk_seq1 = 0, talk_tick1 = 0;

+ (NSData*)encode:(void*)data
{
    int audioLength = 4+4+4+4+2+1+4+2+2+AUDIO_BUFFER_SIZE/4;
    unsigned char decode[audioLength];
    memset(decode, 0, audioLength);
    int length = AUDIO_BUFFER_SIZE/4 + 4;
    int codec = 1;
    memcpy(decode+0,&codec,4);
    memcpy(decode+4,&talk_seq1,4);
    talk_seq1++;
    if(talk_seq1 >= NSUIntegerMax){
        talk_seq1 = 0;
    }
    talk_tick1 += 40;
    int talk_tick1 = time(NULL);
    memcpy(decode+8,&talk_tick1,4);
    memcpy(decode+12,&talk_tick1,4);
    memcpy(decode+16,&adpcm_encode_sample1,2);
    memcpy(decode+18,&adpcm_encode_index1,1);
    memcpy(decode+19,&length,4);
    memcpy(decode+23,&adpcm_encode_sample1,2);
    memcpy(decode+25,&adpcm_encode_index1,2);
    adpcmEncode(data, AUDIO_BUFFER_SIZE, decode+27, &adpcm_encode_sample1, &adpcm_encode_index1);
    //        [talkBuffer appendBytes:decode length:audioLength];
    
    
    NSData *dataEncoded = [[NSData alloc] initWithBytes:decode length:audioLength];

    return dataEncoded;
}

@end
