//
//  DJVideoPathManager.h
//  ViedeoMakeDemo
//
//  Created by Tommy on 2018/12/25.
//  Copyright © 2018年 Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DJVideoPathManagerDataSource <NSObject>

@optional
/// 自定义视频存储路径【默认存储在library中】
-(NSString *)customBasePath;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DJVideoPathManager : NSObject

@property(nonatomic,weak)id<DJVideoPathManagerDataSource>dataSource;

/**
 视频生成的基本路径

 @return 基本路径【本地路径】
 */
-(NSString *)basePath;

/**
 根据文件名生成视频路径

 @param fileName 文件名
 @return 视频路径【本地路径】
 */
-(NSString *)videoPathWithFileName:(NSString *)fileName;

/**
 在沙盒文件中创建存储视频的目录

 @param videoPath 视频文件所存在的目录
 */
-(void)createDirectoryAtPath:(NSString *)videoPath;

@end

NS_ASSUME_NONNULL_END
