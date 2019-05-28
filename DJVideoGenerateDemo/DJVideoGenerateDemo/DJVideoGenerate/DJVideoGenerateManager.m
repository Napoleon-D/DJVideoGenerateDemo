//
//  DJVideoGenerateManager.m
//  ViedeoMakeDemo
//
//  Created by Tommy on 2018/12/25.
//  Copyright © 2018年 Tommy. All rights reserved.
//

#import "DJVideoGenerateManager.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/SDWebImage.h>

@interface DJVideoGenerateManager()
/// 视频基本路径
@property(nonatomic,copy)NSString *videoFilePath;
/// 视频尺寸【可自定义设置，默认为(320,180)】
@property(nonatomic,assign)CGSize videoSize;

@end

@implementation DJVideoGenerateManager

-(instancetype)init{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

-(void)initData{
    _pathManager = [[DJVideoPathManager alloc] init];
    _videoFilePath = [_pathManager videoPathWithFileName:@"DJGeneratedVideo"];
    [_pathManager createDirectoryAtPath:_videoFilePath];
    if ([self.dataSource respondsToSelector:@selector(customVideoSize)]) {
        self.videoSize = [self.dataSource customVideoSize];
    }else{
        self.videoSize = CGSizeMake(320, 180);
    }
}

#pragma mark 本地图片

-(void)generateVideoWithLocalImageNameArray:(NSArray *)imageNameArray progress:(void(^)(CGFloat progress))progressBlock finished:(void(^)(NSString * videoPath))finishedBlock{
    if ((!imageNameArray) || (imageNameArray.count <= 0)) {
        if (finishedBlock) {
            finishedBlock(nil);
        }
    }else{
        [self generateVideoWithImages:imageNameArray isLocalImage:YES isGif:NO progress:^(CGFloat progress) {
            if (progressBlock) {
                progressBlock(progress);
            }
        } finished:^(NSString *videoPath) {
            if (finishedBlock) {
                finishedBlock(videoPath);
            }
        }];
    }
}

-(void)generateVideoWithLocalGifName:(NSString *)gifName progress:(void(^)(CGFloat progress))progressBlock finished:(void(^)(NSString * videoPath))finishedBlock{
    if ([NSString isBlankString:gifName]) {
        if (finishedBlock) {
            finishedBlock(nil);
        }
    }else{
        
        [self generateVideoWithImages:@[gifName] isLocalImage:YES isGif:YES progress:^(CGFloat progress) {
            if (progressBlock) {
                progressBlock(progress);
            }
        } finished:^(NSString *videoPath) {
            if (finishedBlock) {
                finishedBlock(videoPath);
            }
        }];
        
    }
}

-(void)generateVideoWithLocalGifNameArray:(NSArray *)gifNameArray progress:(void(^)(CGFloat progress))progressBlock finished:(void(^)(NSString * videoPath))finishedBlock{
    if ((!gifNameArray) || (gifNameArray.count <= 0)) {
        if (finishedBlock) {
            finishedBlock(nil);
        }
    }else{
        
        [self generateVideoWithImages:gifNameArray isLocalImage:YES isGif:YES progress:^(CGFloat progress) {
            if (progressBlock) {
                progressBlock(progress);
            }
        } finished:^(NSString *videoPath) {
            if (finishedBlock) {
                finishedBlock(videoPath);
            }
        }];
    }
}

#pragma mark 网络图片

-(void)generateVideoWithNetImagePathArray:(NSArray *)imagePathArray progress:(void(^)(CGFloat progress))progressBlock finished:(void(^)(NSString * videoPath))finishedBlock{
    if ((!imagePathArray) || (imagePathArray.count <= 0)) {
        if (finishedBlock) {
            finishedBlock(nil);
        }
    }else{
        
        [self generateVideoWithImages:imagePathArray isLocalImage:NO isGif:NO progress:^(CGFloat progress) {
            if (progressBlock) {
                progressBlock(progress);
            }
        } finished:^(NSString *videoPath) {
            if (finishedBlock) {
                finishedBlock(videoPath);
            }
        }];
        
    }
    
}

-(void)generateVideoWithNetGifPath:(NSString *)gifPath progress:(void(^)(CGFloat progress))progressBlock finished:(void(^)(NSString * videoPath))finishedBlock{
    if ([NSString isBlankString:gifPath]) {
        if (finishedBlock) {
            finishedBlock(nil);
        }
    }else{
        
        [self generateVideoWithImages:@[gifPath] isLocalImage:NO isGif:YES progress:^(CGFloat progress) {
            if (progressBlock) {
                progressBlock(progress);
            }
        } finished:^(NSString *videoPath) {
            if (finishedBlock) {
                finishedBlock(videoPath);
            }
        }];
        
    }
}

-(void)generateVideoWithNetGifPathArray:(NSArray *)gifPathArray progress:(void(^)(CGFloat progress))progressBlock finished:(void(^)(NSString *videoPath))finishedBlock{
    
    if ((!gifPathArray) || (gifPathArray.count <= 0)) {
        if (finishedBlock) {
            finishedBlock(nil);
        }
    }else{

        [self generateVideoWithImages:gifPathArray isLocalImage:NO isGif:YES progress:^(CGFloat progress) {
            if (progressBlock) {
                progressBlock(progress);
            }
        } finished:^(NSString *videoPath) {
            if (finishedBlock) {
                finishedBlock(videoPath);
            }
        }];
    }
    
}

/**
 获取gif图中的静态图总数
 
 @param gifArray 存放gif图的数组，如图片名 xxx.gif 或者 网络链接 如 http://xxxx.gif
 @param isLocalGif 是否是本地gif图
 @param finishedBlock 完成回调
 */
-(void)getImageCountFromGifPathArray:(NSArray *)gifArray isLocalGif:(BOOL)isLocalGif finished:(void(^)(NSInteger imageCout))finishedBlock{
    if (isLocalGif) {
        /// 本地gif图
        NSInteger totalCount = 0;
        NSMutableArray <NSArray *>* allImageArray = [NSMutableArray array];
        for (NSString *gifName in gifArray) {
            NSString *gifPath = [[NSBundle mainBundle] pathForResource:gifName ofType:nil];
            NSURL *gifFileUrl = [NSURL fileURLWithPath:gifPath];
            NSArray *images = [self getImagesFromGIFURL:gifFileUrl];
            [allImageArray addObject:images];
        }
        for (NSArray *imageArray in allImageArray) {
            for (int i = 0; i < imageArray.count; i++) {
                totalCount++;
            }
        }
        if (finishedBlock) {
            finishedBlock(totalCount);
        }
    }else{
        /// 网络gif图
        [self getGifImageSourceWithGifImageStringArray:gifArray isLocalImage:NO finished:^(NSArray<UIImage *> *sourceImgArray) {
            if (finishedBlock) {
                finishedBlock(sourceImgArray.count);
            }
        }];
    }
    
}

#pragma mark 通用方法

/**
 根据 图片链接/图片名 生成视频
 
 @param imageArray 存放图片 本地路径/网络链接 的数组
 @param isLocalImage 是否是本地图片
 @param isGif 是否是gif动态图
 @param finishedBlock 完成时候的回调
 */
-(void)generateVideoWithImages:(NSArray <NSString *>*)imageArray isLocalImage:(BOOL)isLocalImage isGif:(BOOL)isGif progress:(void(^)(CGFloat progress))progressBlock finished:(void(^)(NSString *videoPath))finishedBlock{
    
    NSString *completeVideoPath = [self completeVideoPathWithType:@".mp4"];
    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:completeVideoPath] fileType:AVFileTypeMPEG4 error:&error];
    NSParameterAssert(videoWriter);
    if(error) {
        NSLog(@"error = %@",[error localizedDescription]);
        return;
    }
    NSDictionary *videoSettings = @{
                                    AVVideoCodecKey:AVVideoCodecTypeH264, /// 编码格式
                                    AVVideoWidthKey:[NSNumber numberWithInt:self.videoSize.width], /// 宽
                                    AVVideoHeightKey:[NSNumber numberWithInt:self.videoSize.height] /// 高
                                    };
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    NSDictionary *pixelSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB],kCVPixelBufferPixelFormatTypeKey,nil];
    /// AVAssetWriterInputPixelBufferAdaptor提供CVPixelBufferPool实例,可以使用分配像素缓冲区写入输出文件。使用提供的像素为缓冲池分配通常是更有效的比添加像素缓冲区分配使用一个单独的池
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:pixelSettings];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    __weak DJVideoGenerateManager *weakSelf = self;
    if (progressBlock) {
        progressBlock(0.0f);
    }
    if (isGif) {
        /// 动态图生成视频
        [self getGifImageSourceWithGifImageStringArray:imageArray isLocalImage:isLocalImage finished:^(NSArray<UIImage *> *sourceImgArray) {
            /// 合成多张图片为一个视频文件
            [weakSelf generateVideoWithImageArray:sourceImgArray videoWriter:videoWriter writerInput:writerInput adaptor:adaptor progress:^(CGFloat progress) {
                if (progressBlock) {
                    progressBlock(progress);
                }
            } finished:^{
                if (finishedBlock) {
                    finishedBlock(completeVideoPath);
                }
            }];
        }];
    }else{
        /// 静态图生成视频
        [self getStaticImageSourceWithImageStringArray:imageArray isLocalImage:isLocalImage finished:^(NSArray<UIImage *> *sourceImgArray) {
            /// 合成多张图片为一个视频文件
            [weakSelf generateVideoWithImageArray:sourceImgArray videoWriter:videoWriter writerInput:writerInput adaptor:adaptor progress:^(CGFloat progress) {
                if (progressBlock) {
                    progressBlock(progress);
                }
            } finished:^{
                if (finishedBlock) {
                    finishedBlock(completeVideoPath);
                }
            }];
        }];
    }
}

/// 合成多张图片为一个视频文件
-(void)generateVideoWithImageArray:(NSArray <UIImage *>*)sourceImageArray videoWriter:(AVAssetWriter *)videoWriter writerInput:(AVAssetWriterInput *)writerInput adaptor:(AVAssetWriterInputPixelBufferAdaptor *)adaptor progress:(void(^)(CGFloat progress))progressBlock finished:(void(^)(void))finishedBlock{
    [videoWriter addInput:writerInput];
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    dispatch_queue_t dispatchQueue = dispatch_queue_create("mediaInputQueue",NULL);
    int __block offset = 0;
    NSInteger sameImageShowTimes = 10;
    NSInteger imageNumbersForOneSecond = 10;
    if ([self.dataSource respondsToSelector:@selector(getShowTimesForSameImage)]) {
        sameImageShowTimes = [self.dataSource getShowTimesForSameImage];
    }
    if ([self.dataSource respondsToSelector:@selector(getImageNumbersForOneSeconds)]) {
        imageNumbersForOneSecond = [self.dataSource getImageNumbersForOneSeconds];
    }
    __weak DJVideoGenerateManager *weakSelf = self;
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        while([writerInput isReadyForMoreMediaData]) {
            NSInteger totalCount = [sourceImageArray count] * sameImageShowTimes;
            if(offset >= totalCount) {
                [writerInput markAsFinished];
                [videoWriter finishWritingWithCompletionHandler:^{
                    if (finishedBlock) {
                        finishedBlock();
                    }
                }];
                break;
            }
            int idx = offset / sameImageShowTimes;
            CVPixelBufferRef buffer = NULL;
            buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[[sourceImageArray objectAtIndex:idx] CGImage] size:weakSelf.videoSize];
            if(buffer){
                /// 设置每秒钟播放图片的个数
                [adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(offset,(int)imageNumbersForOneSecond)];
                CFRelease(buffer);
            }
            offset++;
            CGFloat progress = offset / (CGFloat)totalCount;
            if (progressBlock) {
                progressBlock(progress);
            }
        }
    }];
}


/**
 获取静态图片素材
 
 @param imgStringArray 图片链接/图片名
 @param isLocalImage 网络图/本地图
 @param finishedBlock 完成时候的回调
 */
-(void)getStaticImageSourceWithImageStringArray:(NSArray <NSString *>*)imgStringArray isLocalImage:(BOOL)isLocalImage finished:(void(^)(NSArray <UIImage *>*sourceImgArray))finishedBlock{
    NSMutableArray <UIImage *>*sourceImgArray = [NSMutableArray arrayWithArray:imgStringArray];
    __weak DJVideoGenerateManager *weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    if (isLocalImage) {
        /// 本地图片路径
        for (int i = 0; i < imgStringArray.count; i++) {
            dispatch_group_enter(group);
            NSString *imgName = imgStringArray[i];
            NSString *imgPath = [[NSBundle mainBundle] pathForResource:imgName ofType:nil];
            NSURL *imgUrl = [NSURL fileURLWithPath:imgPath];
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl]];
            img = [weakSelf imageWithImage:img scaledToSize:weakSelf.videoSize];
            [sourceImgArray replaceObjectAtIndex:i withObject:img];
            dispatch_group_leave(group);
        }
    }else{
        /// 网络图片路径
        for (int i = 0; i < imgStringArray.count; i++) {
            dispatch_group_enter(group);
            NSString *imgUrlString = imgStringArray[i];
            NSURL *imgUrl = [NSURL URLWithString:imgUrlString];
            [[SDWebImageManager sharedManager] loadImageWithURL:imgUrl options:SDWebImageHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                image = [weakSelf imageWithImage:image scaledToSize:weakSelf.videoSize];
                [sourceImgArray replaceObjectAtIndex:i withObject:image];
                dispatch_group_leave(group);
            }];
        }
    }
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        if (finishedBlock) {
            finishedBlock(sourceImgArray);
        }
    });
    
}

/**
 获取gif动态图片素材
 
 @param imgStringArray 网络连接/图片名
 @param isLocalImage 网络图片/本地图片
 @param finishedBlock 完成时候的回调
 */
-(void)getGifImageSourceWithGifImageStringArray:(NSArray <NSString *>*)imgStringArray isLocalImage:(BOOL)isLocalImage finished:(void(^)(NSArray <UIImage *>*sourceImgArray))finishedBlock{
    __block NSMutableArray <NSArray *>*sourceImgArray = [NSMutableArray array];
    for(NSString * imgUrlString in imgStringArray){
        [sourceImgArray addObject:@[imgUrlString]];
    }
    __weak DJVideoGenerateManager *weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    if (isLocalImage) {
        /// 本地图片
        for (int i = 0; i < imgStringArray.count; i++) {
            dispatch_group_enter(group);
            NSString *gifName = imgStringArray[i];
            NSString *gifPath = [[NSBundle mainBundle] pathForResource:gifName ofType:nil];
            NSURL *fileURL = [NSURL fileURLWithPath:gifPath];
            NSArray <UIImage *>*resultImages = [self getImagesFromGIFURL:fileURL];
            [sourceImgArray replaceObjectAtIndex:i withObject:resultImages];
            dispatch_group_leave(group);
        }
    }else{
        /// 网络图片
        for (int i = 0; i < imgStringArray.count; i++) {
            dispatch_group_enter(group);
            NSString *imgUrlString = imgStringArray[i];
            NSURL *imgUrl = [NSURL safeUrlForString:imgUrlString];
            [[SDWebImageManager sharedManager] loadImageWithURL:imgUrl options:SDWebImageLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                NSArray <UIImage *>*resultImages = [weakSelf getImagesFromGIFURL:imageURL];
                [sourceImgArray replaceObjectAtIndex:i withObject:resultImages];
                dispatch_group_leave(group);
            }];
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (finishedBlock) {
            NSMutableArray <UIImage *>*originImageArray = [NSMutableArray array];
            for (NSArray <UIImage *>*resultImages in sourceImgArray) {
                for (UIImage *sourceImage in resultImages) {
                    UIImage *resultImg = [weakSelf imageWithImage:sourceImage scaledToSize:weakSelf.videoSize];
                    [originImageArray addObject:resultImg];
                }
            }
            if (finishedBlock) {
                finishedBlock(originImageArray);
            }
        }
    });
}

/**
 获取gif图中的每一帧图片
 
 @param fileURL gif图的本地URL
 @return 存放所有静态图的数组
 */
-(NSArray <UIImage *>*)getImagesFromGIFURL:(NSURL *)fileURL{
    
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileURL, NULL);
    size_t gifCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *images = [[NSMutableArray alloc]init];
    for (size_t i = 0; i< gifCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [images addObject:image];
        CGImageRelease(imageRef);
    }
    return images;
}


/// 对图片尺寸进行处理
-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    NSInteger type = 0;
    if ([self.dataSource respondsToSelector:@selector(handleTypeForSourceImage)]) {
        type = [self.dataSource handleTypeForSourceImage];
    }
    UIImage *newImage = nil;
    if (type == 0) {
        /// 按照视频比例进行缩放
        
        /// 新创建的位图上下文 newSize为其大小
        UIGraphicsBeginImageContext(newSize);
        /// 对图片进行尺寸的改变
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        /// 从当前上下文中获取一个UIImage对象  即获取新的图片对象
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
    }
    if (type == 1) {
        /// 按照视频比例进行裁剪
        CGSize oldSize = image.size;
        CGSize resultSize = newSize;
        CGFloat oldRatio = oldSize.width / oldSize.height;
        CGFloat videoRatio = _videoSize.width / _videoSize.height;
        if (oldRatio > videoRatio) {
            /// 按照高度进行等比例缩放
            resultSize = CGSizeMake(oldSize.width / oldSize.height * newSize.height, newSize.height);
        }
        if (oldRatio < videoRatio) {
            /// 按照宽度进行等比例缩放
            resultSize = CGSizeMake(newSize.width, oldSize.height / oldSize.width * newSize.width);
        }
        /// 新创建的位图上下文 newSize为其大小
        UIGraphicsBeginImageContext(resultSize);
        /// 对图片进行尺寸的改变
        [image drawInRect:CGRectMake(0,0,resultSize.width,resultSize.height)];
        /// 从当前上下文中获取一个UIImage对象  即获取新的图片对象
        UIImage *handleImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        newImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([handleImage CGImage], CGRectMake((resultSize.width - newSize.width) * 0.5, (resultSize.height - newSize.height) * 0.5, newSize.width, newSize.height))];
    }
    return newImage;
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size {
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,size.width,size.height,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options,&pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    CVPixelBufferLockBaseAddress(pxbuffer,0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata !=NULL);
    CGColorSpaceRef rgbColorSpace=CGColorSpaceCreateDeviceRGB();
    /// 当你调用这个函数的时候，Quartz创建一个位图绘制环境，也就是位图上下文。当你向上下文中绘制信息时，Quartz把你要绘制的信息作为位图数据绘制到指定的内存块。一个新的位图上下文的像素格式由三个参数决定：每个组件的位数，颜色空间，alpha选项
    CGContextRef context = CGBitmapContextCreate(pxdata,size.width,size.height,8,4*size.width,rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    /// 使用CGContextDrawImage绘制图片  这里设置不正确的话 会导致视频颠倒
    /// 当通过CGContextDrawImage绘制图片到一个context中时，如果传入的是UIImage的CGImageRef，因为UIKit和CG坐标系y轴相反，所以图片绘制将会上下颠倒
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    /// 释放色彩空间
    CGColorSpaceRelease(rgbColorSpace);
    /// 释放context
    CGContextRelease(context);
    /// 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(pxbuffer,0);
    
    return pxbuffer;
}

-(NSString *)completeVideoPathWithType:(NSString *)type{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSDate *now = [NSDate date];
    NSString *prefixName = [dateFormatter stringFromDate:now];
    NSString *suffixName = type;
    NSString *fileName = [NSString stringWithFormat:@"%@%@",prefixName,suffixName];
    NSString *completePath = [_videoFilePath stringByAppendingPathComponent:fileName];
    return completePath;
}

@end
