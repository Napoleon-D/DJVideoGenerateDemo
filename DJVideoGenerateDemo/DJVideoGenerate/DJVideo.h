//
//  DJVideo.h
//  DJVideoGenerateDemo
//
//  Created by Tommy on 2019/3/12.
//  Copyright © 2019年 Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DJCompleteVideoPathManager;

NS_ASSUME_NONNULL_BEGIN

@interface DJVideo : NSObject

///【勿传值】暴露出来是用于外部设置dataSource，实现自定义存储路径
@property(nonatomic,strong)DJCompleteVideoPathManager *pathManager;

/**
 本地静态图合成视频

 @param imageNameArray 存放图片名的数组如 xxx.png,xxx.jpg
 @param audioPath 音频所在路径或网络链接
 @param audioType 音频类型，如@".mp3",@".m4a"，audioPath网络链接时生效
 @param isLocalAudio 本地路径/网络链接
 @param videoTime 视频时长【单位：秒】
 @param videoSize 视频尺寸【pt】
 @param imageCountForSecond 每秒展示的图片的个数
 @param audioVolume 要设置的音频音量【0~1】
 @param progressBlock 进度回调【0~1】
 @param finishBlock 完成回调
 */
-(void)generateCompleteVideoWithImageNameArray:(NSArray <NSString *>*)imageNameArray audioPath:(NSString *)audioPath audioType:(NSString *)audioType isLocalAudio:(BOOL)isLocalAudio videoTime:(NSInteger)videoTime videoSize:(CGSize)videoSize imageCountForSecond:(NSInteger)imageCountForSecond audioVolume:(CGFloat)audioVolume progress:(void(^)(CGFloat progress))progressBlock finishBlock:(void(^)(NSError *error,NSString *path))finishBlock;

/**
 本地动态图合成音视频

 @param gifNameArray 存放gif图名字，如xx.gif
 @param audioPath 音频所在路径或网络链接
 @param audioType 音频类型，如@".mp3",@".m4a"，audioPath网络链接时生效
 @param isLocalAudio 本地路径/网络链接
 @param videoTime 目的视频时长
 @param videoSize 目的视频尺寸
 @param imageCountForSecond 每秒展示图片的个数
 @param audioVolume 音频的音量调整
 @param progressBlock 合成的进度回调
 @param finishBlock 完成的回调
 */
-(void)generateCompleteVideoWithGifNameArray:(NSArray <NSString *>*)gifNameArray audioPath:(NSString *)audioPath audioType:(NSString *)audioType isLocalAudio:(BOOL)isLocalAudio videoTime:(NSInteger)videoTime videoSize:(CGSize)videoSize imageCountForSecond:(NSInteger)imageCountForSecond audioVolume:(CGFloat)audioVolume progress:(void(^)(CGFloat progress))progressBlock finishBlock:(void(^)(NSError *error,NSString *path))finishBlock;

/**
 非gif网络图合成音视频

 @param imageUrlStringArray 存放图片链接的数组，如http://xxxx/xxx/xxx.png
 @param audioPath 音频所在路径或网络链接
 @param audioType 音频类型，如@".mp3",@".m4a"，audioPath网络链接时生效
 @param isLocalAudio 本地路径/网络链接
 @param videoTime 目的视频的时长
 @param videoSize 目的视频的尺寸
 @param imageCountForSecond 每秒播放的图片数
 @param audioVolume 音频的音量大小
 @param progressBlock 进度回调
 @param finishBlock 完成的回调
 */
-(void)generateCompleteVideoWithImageUrlStringArray:(NSArray <NSString *>*)imageUrlStringArray audioPath:(NSString *)audioPath audioType:(NSString *)audioType isLocalAudio:(BOOL)isLocalAudio videoTime:(NSInteger)videoTime videoSize:(CGSize)videoSize imageCountForSecond:(NSInteger)imageCountForSecond audioVolume:(CGFloat)audioVolume progress:(void(^)(CGFloat progress))progressBlock finishBlock:(void(^)(NSError *error,NSString *path))finishBlock;

/**
 gif网络图合成音视频
 
 @param gifUrlStringArray 存放图片链接的数组，如http://xxxx/xxx/xxx.gif
 @param audioPath 音频所在路径或网络链接
 @param audioType 音频类型，如@".mp3",@".m4a"，audioPath网络链接时生效
 @param isLocalAudio 本地路径/网络链接
 @param videoTime 目的视频的时长
 @param videoSize 目的视频的尺寸
 @param imageCountForSecond 每秒播放的图片数
 @param audioVolume 音频的音量大小
 @param progressBlock 进度回调
 @param finishBlock 完成的回调
 */
-(void)generateCompleteVideoWithGifUrlStringArray:(NSArray <NSString *>*)gifUrlStringArray audioPath:(NSString *)audioPath audioType:(NSString *)audioType isLocalAudio:(BOOL)isLocalAudio videoTime:(NSInteger)videoTime videoSize:(CGSize)videoSize imageCountForSecond:(NSInteger)imageCountForSecond audioVolume:(CGFloat)audioVolume progress:(void(^)(CGFloat progress))progressBlock finishBlock:(void(^)(NSError *error,NSString *path))finishBlock;

@end

NS_ASSUME_NONNULL_END
