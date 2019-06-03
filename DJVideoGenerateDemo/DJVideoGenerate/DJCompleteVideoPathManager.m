//
//  DJCompleteVideoPathManager.m
//  DJVideoGenerateDemo
//
//  Created by Tommy on 2019/3/14.
//  Copyright © 2019年 Tommy. All rights reserved.
//

#import "DJCompleteVideoPathManager.h"

@implementation DJCompleteVideoPathManager

-(NSString *)basePath{
    NSString *basePath;
    if ([self.dataSource respondsToSelector:@selector(customBasePath)]) {
        basePath = [self.dataSource customBasePath];
    }else{
        basePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    }
    return basePath;
}

-(NSString *)completeVideoPathWithFileName:(NSString *)fileName{
    NSString *basePath = [self basePath];
    NSString *path = [basePath stringByAppendingPathComponent:fileName];
    NSAssert(path, @"音视频路径不能为空");
    return path;
}

-(void)createDirectoryAtPath:(NSString *)videoPath{
    NSAssert(videoPath, @"音视频路径不能为空");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExists = NO;
    if ([fileManager fileExistsAtPath:videoPath isDirectory:&isDir]) {
        isExists = YES;
    }
    if ((!isDir)&&(!isExists)){
        [fileManager createDirectoryAtPath:videoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

/**
 获取音视频在沙盒中的存放位置(.mp4格式的文件全路径)
 
 @param filePath 音视频所在的文件夹路径
 @return 合成之后的音视频文件存在路径
 */
-(NSString *)savedPathForMP4WithFilePath:(NSString *)filePath{
    return [self savedPathWithType:@".mp4" filePath:filePath];
}

-(NSString *)savedPathWithType:(NSString *)type filePath:(NSString *)filePath{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSDate *now = [NSDate date];
    NSString *prefixName = [dateFormatter stringFromDate:now];
    NSString *suffixName = type;
    NSString *fileName = [NSString stringWithFormat:@"%@%@",prefixName,suffixName];
    NSString *audioPath = [filePath stringByAppendingPathComponent:fileName];
    return audioPath;
    
}

@end
