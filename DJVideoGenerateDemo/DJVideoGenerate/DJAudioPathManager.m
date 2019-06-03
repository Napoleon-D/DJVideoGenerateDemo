//
//  DJAudioPathManager.m
//  DJVideoGenerateDemo
//
//  Created by Tommy on 2019/3/12.
//  Copyright © 2019年 Tommy. All rights reserved.
//

#import "DJAudioPathManager.h"

@implementation DJAudioPathManager

-(NSString *)basePath{
    NSString *basePath;
    if ([self.dataSource respondsToSelector:@selector(customBasePath)]) {
        basePath = [self.dataSource customBasePath];
    }else{
        basePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    }
    return basePath;
}

-(NSString *)audioPathWithFileName:(NSString *)fileName{
    NSString *basePath = [self basePath];
    NSString *path = [basePath stringByAppendingPathComponent:fileName];
    NSAssert(path, @"音频路径不能为空");
    return path;
}

-(void)createDirectoryAtPath:(NSString *)audioPath{
    NSAssert(audioPath, @"音频路径不能为空");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExists = NO;
    if ([fileManager fileExistsAtPath:audioPath isDirectory:&isDir]) {
        isExists = YES;
    }
    if ((!isDir)&&(!isExists)){
        [fileManager createDirectoryAtPath:audioPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

/**
 获取音频在沙盒中的存放位置(.m4a格式的文件全路径)

 @param filePath 音频所在的文件夹路径
 @return 录音文件存在路径
 */
-(NSString *)savedPathForM4aAudioForFilePath:(NSString *)filePath{
    return [self savedPathWithType:@".m4a" filePath:filePath];
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
