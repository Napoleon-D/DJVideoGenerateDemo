//
//  DJVideoPathManager.m
//  ViedeoMakeDemo
//
//  Created by Tommy on 2018/12/25.
//  Copyright © 2018年 Tommy. All rights reserved.
//

#import "DJVideoPathManager.h"

@interface DJVideoPathManager()

@end

@implementation DJVideoPathManager

-(NSString *)basePath{
    NSString *basePath;
    if ([self.dataSource respondsToSelector:@selector(customBasePath)]) {
        basePath = [self.dataSource customBasePath];
    }else{
        basePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    }
    return basePath;
}

-(NSString *)videoPathWithFileName:(NSString *)fileName{
    NSString *basePath = [self basePath];
    NSString *path = [basePath stringByAppendingPathComponent:fileName];
    NSAssert(path, @"视频路径不能为空");
    return path;
}

-(void)createDirectoryAtPath:(NSString *)videoPath{
    NSAssert(videoPath, @"视频路径不能为空");
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

@end
