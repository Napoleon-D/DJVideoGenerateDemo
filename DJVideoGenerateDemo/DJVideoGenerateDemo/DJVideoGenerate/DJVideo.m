//
//  DJVideo.m
//  DJVideoGenerateDemo
//
//  Created by Tommy on 2019/3/12.
//  Copyright © 2019年 Tommy. All rights reserved.
//

#import "DJVideo.h"
#import "DJVideoGenerateManager.h"
#import "DJAudioDownloadManager.h"
#import "DJAudioHandleManager.h"
#import "DJCompleteVideoPathManager.h"
#import "DJAudioPathManager.h"
#import <AVFoundation/AVFoundation.h>

@interface DJVideo()<DJVideoGenerateManagerDataSource>{
    dispatch_group_t _group;
}
/// 下载器
@property(nonatomic,strong)DJAudioDownloadManager *downloader;
/// 视频生成器
@property(nonatomic,strong)DJVideoGenerateManager *videoManager;
/// 音频生成器
@property(nonatomic,strong)DJAudioHandleManager *audioManager;
/// 音频文件路径管理器
@property(nonatomic,strong)DJAudioPathManager *audioPathManager;
/// 下载的音频的文件夹路径
@property(nonatomic,strong)NSString *downloadedAudioFilePath;
/// 音视频文件夹路径
@property(nonatomic,copy)NSString *completeVideoFilePath;
/// 音视频尺寸
@property(nonatomic,assign)CGSize videoSize;
/// 音视频时长
@property(nonatomic,assign)NSInteger videoTime;
/// 每秒展示的图片数
@property(nonatomic,assign)NSInteger imageCountForSecond;
/// 原始图片的总数
@property(nonatomic,assign)NSInteger originTotalImageCount;

@end

@implementation DJVideo

-(instancetype)init{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

-(void)initData{
    
    _group = dispatch_group_create();
    /// 音频下载器
    _downloader = [[DJAudioDownloadManager alloc] init];
    /// 视频处理器
    _videoManager = [[DJVideoGenerateManager alloc] init];
    _videoManager.dataSource = self;
    /// 音频处理器
    _audioManager = [[DJAudioHandleManager alloc] init];
    /// 设置【音视频】路径
    _pathManager = [[DJCompleteVideoPathManager alloc] init];
    _completeVideoFilePath = [_pathManager completeVideoPathWithFileName:@"DJGeneratedCompleteVideo"];
    [_pathManager createDirectoryAtPath:_completeVideoFilePath];
    /// 设置【音频】下载路径
    _audioPathManager = [[DJAudioPathManager alloc] init];
    _downloadedAudioFilePath = [_audioPathManager audioPathWithFileName:@"DJDownloadedAudio"];
    [_audioPathManager createDirectoryAtPath:_downloadedAudioFilePath];
}

/// 本地静态图合成视频
-(void)generateCompleteVideoWithImageNameArray:(NSArray <NSString *>*)imageNameArray audioPath:(NSString *)audioPath audioType:(NSString *)audioType isLocalAudio:(BOOL)isLocalAudio videoTime:(NSInteger)videoTime videoSize:(CGSize)videoSize imageCountForSecond:(NSInteger)imageCountForSecond audioVolume:(CGFloat)audioVolume progress:(void(^)(CGFloat progress))progressBlock finishBlock:(void(^)(NSError *error,NSString *path))finishBlock{
    
    dispatch_group_enter(_group);
    __weak DJVideo *weakSelf = self;
    self.originTotalImageCount = imageNameArray.count;
    self.videoTime = videoTime;
    self.videoSize = videoSize;
    self.imageCountForSecond = imageCountForSecond;
    /// 图片生成视频
    [_videoManager generateVideoWithLocalImageNameArray:imageNameArray progress:^(CGFloat progress) {
        if (progressBlock) {
            progressBlock(progress * 0.5);
        }
    } finished:^(NSString * _Nonnull videoPath) {
        
        if ([NSString isBlankString:videoPath]) {
            /// 视频生成失败
            if (finishBlock) {
                NSError *error = [NSError errorWithDomain:NSMachErrorDomain code:-1 userInfo:@{@"message":@"图片生成视频失败"}];
                finishBlock(error,nil);
                dispatch_group_leave(self->_group);
            }
        }else{
            /// 获取本地音频路径
            [weakSelf getAudioLocalPathForAudioPath:audioPath audioType:audioType isLocalPath:isLocalAudio finished:^(NSError *getLocalAudioError, NSString *localAudioPath) {
                if (getLocalAudioError) {
                    /// 本地音频路径获取失败
                    if (finishBlock) finishBlock(getLocalAudioError,@"");
                    dispatch_group_leave(self->_group);
                }else{
                    /// 本地音频路径获取成功
                    [weakSelf mergeVideo:videoPath withAudio:localAudioPath audioVolume:audioVolume progress:^(CGFloat progress) {
                        if (progressBlock) {
                            progressBlock(progress);
                        }
                    } finishBlock:^(NSError *error, NSString *path) {
                        if (finishBlock) {
                            finishBlock(error,path);
                        }
                        dispatch_group_leave(self->_group);
                    }];
                }
            }];
        }
    }];
}

/// 本地gif图合成音视频
-(void)generateCompleteVideoWithGifNameArray:(NSArray <NSString *>*)gifNameArray audioPath:(NSString *)audioPath audioType:(NSString *)audioType isLocalAudio:(BOOL)isLocalAudio videoTime:(NSInteger)videoTime videoSize:(CGSize)videoSize imageCountForSecond:(NSInteger)imageCountForSecond audioVolume:(CGFloat)audioVolume progress:(void(^)(CGFloat progress))progressBlock finishBlock:(void(^)(NSError *error,NSString *path))finishBlock{
    
    dispatch_group_enter(_group);
    __weak DJVideo *weakSelf = self;
    [self.videoManager getImageCountFromGifPathArray:gifNameArray isLocalGif:YES finished:^(NSInteger imageCout) {
        weakSelf.originTotalImageCount = imageCout;
        weakSelf.videoTime = videoTime;
        weakSelf.videoSize = videoSize;
        weakSelf.imageCountForSecond = imageCountForSecond;
        /// 图片生成
        [weakSelf.videoManager generateVideoWithLocalGifNameArray:gifNameArray progress:^(CGFloat progress) {
            if (progressBlock) {
                progressBlock(progress * 0.5);
            }
        } finished:^(NSString * _Nonnull videoPath) {
            if ([NSString isBlankString:videoPath]) {
                /// 视频生成失败
                if (finishBlock) {
                    NSError *error = [NSError errorWithDomain:NSMachErrorDomain code:-1 userInfo:@{@"message":@"图片生成视频失败"}];
                    finishBlock(error,nil);
                    dispatch_group_leave(self->_group);
                }
            }else{
                /// 视频生成成功
                [weakSelf getAudioLocalPathForAudioPath:audioPath audioType:audioType isLocalPath:isLocalAudio finished:^(NSError *getLocalAudioError, NSString *localAudioPath) {
                    if (getLocalAudioError) {
                        /// 本地音频路径获取失败
                        if (finishBlock) finishBlock(getLocalAudioError,nil);
                        dispatch_group_leave(self->_group);
                    }else{
                        /// 本地音频路径获取成功
                        [weakSelf mergeVideo:videoPath withAudio:localAudioPath audioVolume:audioVolume progress:^(CGFloat progress) {
                            if (progressBlock) {
                                progressBlock(progress);
                            }
                        } finishBlock:^(NSError *error, NSString *path) {
                            if (finishBlock) {
                                finishBlock(error,path);
                            }
                            dispatch_group_leave(self->_group);
                        }];
                    }
                }];
            }
        }];
    }];
}

/// 非gif网络图合成音视频
-(void)generateCompleteVideoWithImageUrlStringArray:(NSArray <NSString *>*)imageUrlStringArray audioPath:(NSString *)audioPath audioType:(NSString *)audioType isLocalAudio:(BOOL)isLocalAudio videoTime:(NSInteger)videoTime videoSize:(CGSize)videoSize imageCountForSecond:(NSInteger)imageCountForSecond audioVolume:(CGFloat)audioVolume progress:(void(^)(CGFloat progress))progressBlock finishBlock:(void(^)(NSError *error,NSString *path))finishBlock{
    dispatch_group_enter(_group);
    __weak DJVideo *weakSelf = self;
    self.originTotalImageCount = imageUrlStringArray.count;
    self.videoTime = videoTime;
    self.videoSize = videoSize;
    self.imageCountForSecond = imageCountForSecond;
    /// 图片生成视频
    [_videoManager generateVideoWithNetImagePathArray:imageUrlStringArray progress:^(CGFloat progress) {
        if (progressBlock) {
            progressBlock(progress * 0.5);
        }
    } finished:^(NSString * _Nonnull videoPath) {
        if ([NSString isBlankString:videoPath]) {
            /// 视频生成失败
            if (finishBlock) {
                NSError *error = [NSError errorWithDomain:NSMachErrorDomain code:-1 userInfo:@{@"message":@"图片生成视频失败"}];
                finishBlock(error,nil);
                dispatch_group_leave(self->_group);
            }
        }else{
            /// 获取本地音频路径
            [weakSelf getAudioLocalPathForAudioPath:audioPath audioType:audioType isLocalPath:isLocalAudio finished:^(NSError *getLocalAudioError, NSString *localAudioPath) {
                if (getLocalAudioError) {
                    /// 本地音频路径获取失败
                    if (finishBlock) finishBlock(getLocalAudioError,@"");
                    dispatch_group_leave(self->_group);
                }else{
                    /// 本地音频路径获取成功
                    [weakSelf mergeVideo:videoPath withAudio:localAudioPath audioVolume:audioVolume progress:^(CGFloat progress) {
                        if (progressBlock) {
                            progressBlock(progress);
                        }
                    } finishBlock:^(NSError *error, NSString *path) {
                        if (finishBlock) {
                            finishBlock(error,path);
                        }
                        dispatch_group_leave(self->_group);
                    }];
                }
            }];
        }
        
    }];
}

/// gif网络图合成音视频
-(void)generateCompleteVideoWithGifUrlStringArray:(NSArray <NSString *>*)gifUrlStringArray audioPath:(NSString *)audioPath audioType:(NSString *)audioType isLocalAudio:(BOOL)isLocalAudio videoTime:(NSInteger)videoTime videoSize:(CGSize)videoSize imageCountForSecond:(NSInteger)imageCountForSecond audioVolume:(CGFloat)audioVolume progress:(void(^)(CGFloat progress))progressBlock finishBlock:(void(^)(NSError *error,NSString *path))finishBlock{
    dispatch_group_enter(_group);
    __weak DJVideo *weakSelf = self;
    [self.videoManager getImageCountFromGifPathArray:gifUrlStringArray isLocalGif:NO finished:^(NSInteger imageCout) {
        weakSelf.originTotalImageCount = imageCout;
        weakSelf.videoTime = videoTime;
        weakSelf.videoSize = videoSize;
        weakSelf.imageCountForSecond = imageCountForSecond;
        /// 图片生成视频
        [weakSelf.videoManager generateVideoWithNetGifPathArray:gifUrlStringArray progress:^(CGFloat progress) {
            if (progressBlock) {
                progressBlock(progress * 0.5);
            }
        } finished:^(NSString * _Nonnull videoPath) {
            if ([NSString isBlankString:videoPath]) {
                /// 视频生成失败
                if (finishBlock) {
                    NSError *error = [NSError errorWithDomain:NSMachErrorDomain code:-1 userInfo:@{@"message":@"图片生成视频失败"}];
                    finishBlock(error,nil);
                }
                if (progressBlock) progressBlock(1);
                dispatch_group_leave(self->_group);
            }else{
                /// 视频生成成功
                [weakSelf getAudioLocalPathForAudioPath:audioPath audioType:audioType isLocalPath:isLocalAudio finished:^(NSError *getLocalAudioError, NSString *localAudioPath) {
                    if (getLocalAudioError) {
                        /// 本地音频路径获取失败->程序结束
                        if (finishBlock) finishBlock(getLocalAudioError,nil);
                        if (progressBlock) progressBlock(1);
                        dispatch_group_leave(self->_group);
                    }else{
                        /// 本地音频路径获取成功->音视频合成
                        [weakSelf mergeVideo:videoPath withAudio:localAudioPath audioVolume:audioVolume progress:^(CGFloat progress) {
                            if (progressBlock) {
                                progressBlock(progress);
                            }
                        } finishBlock:^(NSError *error, NSString *path) {
                            if (finishBlock) {
                                finishBlock(error,path);
                            }
                            dispatch_group_leave(self->_group);
                        }];
                    }
                }];
            }
        }];
    }];
}
#pragma mark 通用方法

/// 获取音频的本地路劲
-(void)getAudioLocalPathForAudioPath:(NSString *)audioPath audioType:(NSString *)audioType isLocalPath:(BOOL)isLocalPath finished:(void(^)(NSError *getLocalAudioError,NSString *localAudioPath))finishedBlock{
    
    if (isLocalPath) {
        /// 本地路径
        if (finishedBlock) {
            finishedBlock(nil,audioPath);
        }
    }else{
        /// 网络链接
        __weak DJVideo *weakSelf = self;
        NSString *fileName = [[audioPath md5String] stringByAppendingString:audioType];
        NSString *targetPath = [weakSelf.downloadedAudioFilePath stringByAppendingPathComponent:fileName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:targetPath]) {
            /// 本地存在缓存
            if (finishedBlock) {
                finishedBlock(nil,targetPath);
            }
        }else{
            /// 本地不存在缓存
            [weakSelf.downloader downloadWithUrlString:audioPath finish:^(NSError * _Nonnull error, NSString * _Nonnull resultPath) {
                if (error) {
                    if (finishedBlock) {
                        finishedBlock(error,nil);
                    }
                }else{
                    NSError *copyError = nil;
                    [fileManager moveItemAtPath:resultPath toPath:targetPath error:&copyError];
                    if (copyError) {
                        if (finishedBlock) {
                            finishedBlock(copyError,nil);
                        }
                    }else{
                        if (finishedBlock) {
                            finishedBlock(nil,targetPath);
                        }
                    }
                    
                }
            }];
        }
    }
}

/// 合并视频 与 音频
-(void)mergeVideo:(NSString *)videoPath withAudio:(NSString *)audioPath audioVolume:(CGFloat)audioVolume progress:(void(^)(CGFloat progress))progressBlock finishBlock:(void(^)(NSError *error,NSString *path))finishBlock{
    
    NSURL *videoFileUrl = [NSURL fileURLWithPath:videoPath];
    AVURLAsset * asset = [AVURLAsset assetWithURL:videoFileUrl];
    CMTime time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    __weak DJVideo *weakSelf = self;
    /// 截取音频
    [self.audioManager interceptAnAudio:audioPath withTime:seconds finish:^(NSError * _Nonnull error, NSString * _Nonnull resultPath) {
        if (progressBlock) progressBlock(0.65);
        if (error) {
            if (finishBlock) {
                NSError *newError = [NSError errorWithDomain:NSMachErrorDomain code:-1 userInfo:@{@"message":@"音频截取失败"}];
                finishBlock(newError,nil);
            }
            if (progressBlock) progressBlock(1);
        }else{
            /// 根据音量重新生成音频
            [weakSelf.audioManager regenerateOneAudio:resultPath withVolume:audioVolume finish:^(NSError * _Nonnull error, NSString * _Nonnull resultPath) {
                if (progressBlock) progressBlock(0.8);
                if (error) {
                    if (finishBlock) {
                        NSError *newError = [NSError errorWithDomain:NSMachErrorDomain code:-1 userInfo:@{@"message":@"音频音量调整失败"}];
                        finishBlock(newError,nil);
                    }
                    if (progressBlock) progressBlock(1);
                }else{
                    /// 生成音视频
                    [weakSelf generateCompleteVideoWithVideoPath:videoPath audioPath:resultPath finishBlock:^(NSError *error, NSString *resultPath) {
                        if (progressBlock) progressBlock(1.0);
                        if (error) {
                            if (finishBlock) {
                                NSError *newError = [NSError errorWithDomain:NSMachErrorDomain code:-1 userInfo:@{@"message":@"音视频合成失败"}];
                                finishBlock(newError,nil);
                            }
                        }else{
                            if (finishBlock) {
                                finishBlock(nil,resultPath);
                            }
                        }
                    }];
                }
            }];
        }
    }];
}

-(void)generateCompleteVideoWithVideoPath:(NSString *)videoPath audioPath:(NSString *)audioPath finishBlock:(void(^)(NSError *error,NSString *resultPath))finishBlock{
    
    /// 声音来源
    NSURL *audioInputUrl = [NSURL fileURLWithPath:audioPath];
    /// 视频来源
    NSURL *videoInputUrl = [NSURL fileURLWithPath:videoPath];
    /// 最终合成输出路径
    NSString *outPutFilePath = [_pathManager savedPathForMP4WithFilePath:_completeVideoFilePath];
    /// 添加合成路径
    NSURL *outputFileUrl = [NSURL fileURLWithPath:outPutFilePath];
    /// 时间起点
    CMTime nextClistartTime = kCMTimeZero;
    /// 创建可变的音视频组合
    AVMutableComposition *comosition = [AVMutableComposition composition];
    
    /// 视频采集
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoInputUrl options:nil];
    /// 视频时间范围
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    /// 视频通道 枚举 kCMPersistentTrackID_Invalid = 0
    AVMutableCompositionTrack *videoTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    /// 视频采集通道
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    ///  把采集轨道数据加入到可变轨道之中
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:nextClistartTime error:nil];
    
    /// 声音采集
    AVURLAsset *audioAsset = [[AVURLAsset alloc] initWithURL:audioInputUrl options:nil];
    /// 因为视频短这里就直接用视频长度了,如果自动化需要自己写判断
    CMTimeRange audioTimeRange = videoTimeRange;
    /// 音频通道
    AVMutableCompositionTrack *audioTrack = [comosition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    /// 音频采集通道
    AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    /// 加入合成轨道之中
    [audioTrack insertTimeRange:audioTimeRange ofTrack:audioAssetTrack atTime:nextClistartTime error:nil];
    
    /// 创建一个输出
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:comosition presetName:AVAssetExportPresetMediumQuality];
    /// 输出类型
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    /// 输出地址
    assetExport.outputURL = outputFileUrl;
    /// 优化
    assetExport.shouldOptimizeForNetworkUse = YES;
    /// 合成完毕
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        /// 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            NSFileManager *defaultManager = [NSFileManager defaultManager];
            if ([defaultManager fileExistsAtPath:outPutFilePath]) {
                if (finishBlock) {
                    finishBlock(nil,outPutFilePath);
                }
            }else{
                if (finishBlock) {
                    NSError *error = [NSError errorWithDomain:NSMachErrorDomain code:-1 userInfo:@{@"message":@"音视频合成失败"}];
                    finishBlock(error,nil);
                }
            }
        });
    }];
}

#pragma mark DJVideoGenerateManagerDataSource

/// 自定义视频的尺寸
-(CGSize)customVideoSize{
    return self.videoSize;
}

/// 同一张图片的展示次数【默认为10】
-(NSInteger)getShowTimesForSameImage{
    NSInteger totalImageCount = self.imageCountForSecond * self.videoTime;
    NSInteger remain = totalImageCount % self.originTotalImageCount;
    NSInteger merchant = totalImageCount / self.originTotalImageCount;
    if (remain >= (self.originTotalImageCount * 0.5)) {
        merchant++;
    }
    return merchant;
}

/// 每秒钟图片播放的次数【默认为10】
-(NSInteger)getImageNumbersForOneSeconds{
    return self.imageCountForSecond;
}

/**
 图片的处理
 
 @return 【0:按照视频的尺寸进行缩放「默认为此」】【1:按照视频的尺寸进行裁剪】
 */
-(NSInteger)handleTypeForSourceImage{
    return 1;
}

@end
