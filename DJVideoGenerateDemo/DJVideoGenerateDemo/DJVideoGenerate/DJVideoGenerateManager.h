//
//  DJVideoGenerateManager.h
//  ViedeoMakeDemo
//
//  Created by Tommy on 2018/12/25.
//  Copyright © 2018年 Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DJVideoPathManager.h"
#import "NSString+Tool.h"
#import "NSURL+Extension.h"

@protocol DJVideoGenerateManagerDataSource <NSObject>

@optional

/// 自定义视频的尺寸,默认为(320,180)
-(CGSize)customVideoSize;

/// 同一张图片的展示次数【默认为10】
-(NSInteger)getShowTimesForSameImage;

/// 每秒钟图片播放的次数【默认为10】
-(NSInteger)getImageNumbersForOneSeconds;

/**
 图片的处理

 @return 【0:按照视频的尺寸进行缩放「默认为此」】【1:按照视频的尺寸进行裁剪】
 */
-(NSInteger)handleTypeForSourceImage;

@end

@class DJVideoPathManager;

NS_ASSUME_NONNULL_BEGIN

@interface DJVideoGenerateManager : NSObject

@property(nonatomic,weak)id<DJVideoGenerateManagerDataSource>dataSource;

///【勿传值】暴露出来是用于外部设置dataSource，实现自定义存储路径
@property(nonatomic,strong)DJVideoPathManager *pathManager;

#pragma mark 本地图片

/**
 多个静态图片合成视频

 @param imageNameArray 存放图片名的数组【例：xxx.png,xxx.jpg】
 @param progressBlock 进度回调
 @param finishedBlock 完成时候的回调【videoPath == nil,合成失败】【videoPath != nil,合成成功】
 */
-(void)generateVideoWithLocalImageNameArray:(NSArray *)imageNameArray progress:(void(^)(CGFloat progress))progressBlock finished:(void(^)(NSString *videoPath))finishedBlock;

/**
 单个动态图片合成视频

 @param gifName 图片名【例：xxx.gif】
 */
-(void)generateVideoWithLocalGifName:(NSString *)gifName progress:(void(^)(CGFloat progress))progressBlock finished:(void(^)(NSString *videoPath))finishedBlock;

/**
 多个动态图片合成视频

 @param gifNameArray 存放gif图的数组 【例：xxx.gif】
 */
-(void)generateVideoWithLocalGifNameArray:(NSArray *)gifNameArray progress:(void(^)(CGFloat progress))progressBlock finished:(void(^)(NSString *videoPath))finishedBlock;

#pragma mark 网络图片

/**
 多个静态图片合成视频

 @param imagePathArray 存放图片网络链接的数组【如http://xxx.png】【如https://xxx.jpg】
 @param progressBlock 进度回调
 @param finishedBlock 完成时候的回调【videoPath == nil,合成失败】【videoPath != nil,合成成功】
 */
-(void)generateVideoWithNetImagePathArray:(NSArray *)imagePathArray progress:(void(^)(CGFloat progress))progressBlock finished:(void(^)(NSString *videoPath))finishedBlock;

/**
 单个动态图片合成视频

 @param gifPath 图片网络链接【如http://xxx.gif】
 @param progressBlock 进度回调
 @param finishedBlock 完成时候的回调【videoPath == nil,合成失败】【videoPath != nil,合成成功】
 */
-(void)generateVideoWithNetGifPath:(NSString *)gifPath progress:(void(^)(CGFloat progress))progressBlock finished:(void(^)(NSString *videoPath))finishedBlock;

/**
 多个动态图片合成视频

 @param gifPathArray 存放gif图片网络链接的数组【如http://xxx.gif】
 @param progressBlock 进度回调
 @param finishedBlock 完成时候的回调【videoPath == nil,合成失败】【videoPath != nil,合成成功】
 */
-(void)generateVideoWithNetGifPathArray:(NSArray *)gifPathArray progress:(void(^)(CGFloat progress))progressBlock finished:(void(^)(NSString *videoPath))finishedBlock;

/**
 获取gif图中的静态图总数

 @param gifArray 存放gif图的数组，如图片名 xxx.gif 或者 网络链接 如 http://xxxx.gif
 @param isLocalGif 是否是本地gif图
 @param finishedBlock 完成回调
 */
-(void)getImageCountFromGifPathArray:(NSArray *)gifArray isLocalGif:(BOOL)isLocalGif finished:(void(^)(NSInteger imageCout))finishedBlock;

@end

NS_ASSUME_NONNULL_END
