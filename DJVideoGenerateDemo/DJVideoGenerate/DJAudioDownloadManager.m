//
//  DJAudioDownloadManager.m
//  DJVideoGenerateDemo
//
//  Created by Tommy on 2019/4/10.
//  Copyright © 2019年 Tommy. All rights reserved.
//

#import "DJAudioDownloadManager.h"
#import "NSString+Tool.h"
#import "NSURL+Extension.h"

@interface DJAudioDownloadManager()

@end

@implementation DJAudioDownloadManager

-(void)downloadWithUrlString:(NSString *)urlString finish:(void(^)(NSError *error,NSString *resultPath))finishedBlock{
    if ([NSString isBlankString:urlString]) {
        NSError *error = [NSError errorWithDomain:NSMachErrorDomain code:-1 userInfo:@{@"message":@"下载链接为空"}];
        if (finishedBlock) finishedBlock(error,nil);
        return;
    }
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *downloadSession = [NSURLSession sessionWithConfiguration:config];
    NSURL *downloadUrl = [NSURL safeUrlForString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:downloadUrl];
    request.timeoutInterval = 10;
    [[downloadSession downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (finishedBlock) {
            finishedBlock(error,location.path);
        }
    }] resume];
}

@end
