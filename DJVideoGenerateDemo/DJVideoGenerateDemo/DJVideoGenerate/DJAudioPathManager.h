//
//  DJAudioPathManager.h
//  DJVideoGenerateDemo
//
//  Created by Tommy on 2019/3/12.
//  Copyright © 2019年 Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DJAudioPathManagerDataSource <NSObject>

@optional
/// 自定义音频存储路径【默认存储在library中】
-(NSString *)customBasePath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DJAudioPathManager : NSObject

@property(nonatomic,weak)id<DJAudioPathManagerDataSource>dataSource;

/**
 音频生成的基本路径
 
 @return 基本路径【本地路径】
 */
-(NSString *)basePath;

/**
 根据文件名生成音频路径
 
 @param fileName 文件名
 @return 音频路径【本地路径】
 */
-(NSString *)audioPathWithFileName:(NSString *)fileName;

/**
 在沙盒文件中创建存储音频的目录
 
 @param audioPath 音频文件所存在的目录
 */
-(void)createDirectoryAtPath:(NSString *)audioPath;

/**
 获取音频在沙盒中的存放位置(.m4a格式的文件全路径)
 
 @param filePath 音频所在的文件夹路径
 @return 录音文件存在路径
 */
-(NSString *)savedPathForM4aAudioForFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
