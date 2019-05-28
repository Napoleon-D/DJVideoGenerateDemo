//
//  DJCompleteVideoPathManager.h
//  DJVideoGenerateDemo
//
//  Created by Tommy on 2019/3/14.
//  Copyright © 2019年 Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DJCompleteVideoPathManagerDataSource <NSObject>

@optional
/// 自定义音视频存储路径【默认存储在library中】
-(NSString *)customBasePath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DJCompleteVideoPathManager : NSObject

@property(nonatomic,weak)id<DJCompleteVideoPathManagerDataSource>dataSource;

/**
 音视频生成的基本路径
 
 @return 基本路径【本地路径】
 */
-(NSString *)basePath;

/**
 根据文件名生成音视频路径
 
 @param fileName 文件名
 @return 音视频路径【本地路径】
 */
-(NSString *)completeVideoPathWithFileName:(NSString *)fileName;

/**
 在沙盒文件中创建存储音视频的目录
 
 @param videoPath 音视频文件所存在的目录
 */
-(void)createDirectoryAtPath:(NSString *)videoPath;

/**
 获取音视频在沙盒中的存放位置(.mp4格式的文件全路径)
 
 @param filePath 音视频所在的文件夹路径
 @return 合成之后的音视频文件存在路径
 */
-(NSString *)savedPathForMP4WithFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
