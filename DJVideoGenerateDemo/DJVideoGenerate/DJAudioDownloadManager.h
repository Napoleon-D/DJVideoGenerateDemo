//
//  DJAudioDownloadManager.h
//  DJVideoGenerateDemo
//
//  Created by Tommy on 2019/4/10.
//  Copyright © 2019年 Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJAudioDownloadManager : NSObject

-(void)downloadWithUrlString:(NSString *)urlString finish:(void(^)(NSError *error,NSString *resultPath))finishedBlock;

@end

NS_ASSUME_NONNULL_END
