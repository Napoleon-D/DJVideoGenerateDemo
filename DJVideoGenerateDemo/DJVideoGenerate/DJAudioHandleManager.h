//
//  DJAudioHandleManager.h
//  DJVideoGenerateDemo
//
//  Created by Tommy on 2019/3/12.
//  Copyright © 2019年 Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJAudioPathManager.h"

@protocol AudioHandleManagerDelegate <NSObject>

/**
 合并多段音频，并增加时长，完成合并时候的回调
 @param resultPath 最终合并完的音频，所在的沙盒路劲
 @param error 合并过程中是否出错
 */
-(void)didFinishMixAudio:(NSString *)resultPath withError:(NSError *)error;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DJAudioHandleManager : NSObject

@property(nonatomic,assign)id<AudioHandleManagerDelegate>delegate;

///【勿传值】暴露出来是用于外部设置dataSource，实现自定义存储路径
@property(nonatomic,strong)DJAudioPathManager *pathManager;

/**
 音频截取
 
 @param anAudioPath 源录音文件
 @param time 截取的总共时间【单位：秒】
 @param finishBlock 完成时候的回调
 */
-(void)interceptAnAudio:(NSString *)anAudioPath withTime:(float)time finish:(void(^)(NSError *error,NSString *resultPath))finishBlock;

/**
 合并多段音频
 增加音频时长
 对应的合并完成的回调方法为：didFinishMixAudio:withError:
 
 @param originalAudioArray 存放音频路径的数组
 */
-(void)mixAudio:(NSArray <NSString *>*)originalAudioArray;

/**
 根据音量，重新生成单段的音频，格式为.m4a
 
 @param originalAudioPath 录音源文件在沙盒中的路径
 @param volume 音量
 @param finishBlock 完成时候的回调
 */
-(void)regenerateOneAudio:(NSString *)originalAudioPath withVolume:(float)volume finish:(void(^)(NSError *error,NSString *resultPath))finishBlock;

/**
 音频合成，两段音频合并成一段音频，音频时长不会增加
 
 @param anAudioPath 第一段录音
 @param otherAudioPath 另一段录音
 @param finishBlock 完成时候的回调
 */
- (void)audioMixWithAudioPath:(NSString *)anAudioPath anotherAudioPath:(NSString *)otherAudioPath finish:(void(^)(NSError *error,NSString *resultPath))finishBlock;

/**
 将音频流pcm文件转成wav文件
 
 @param pcmPath 音频流pcm源文件
 @param wavPath 目标wav文件在沙盒中的路径
 @param sampleRate 采样率
 @param channels 通道数
 @param byteRate 位数
 @param finishBlock 完成时候的回调
 */
-(void)translateAudioFromPCMFile:(NSString *)pcmPath toWAVFile:(NSString *)wavPath sampleRate:(int)sampleRate channels:(int)channels byteRate:(int)byteRate finish:(void (^)(void))finishBlock;

@end

NS_ASSUME_NONNULL_END
