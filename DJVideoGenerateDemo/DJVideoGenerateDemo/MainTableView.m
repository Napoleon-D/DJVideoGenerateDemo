//
//  MainTableView.m
//  DJVideoGenerateDemo
//
//  Created by Tommy on 2019/4/25.
//  Copyright © 2019年 Tommy. All rights reserved.
//
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define SafeAreaTopHeight (kScreenHeight >= 812.0 ? 88 : 64)

#import "MainTableView.h"
#import "DJVideoHeader.h"

@interface MainTableView()<UITableViewDataSource,UITableViewDelegate,DJVideoGenerateManagerDataSource>

@property(nonatomic,copy)NSArray *functionTitleArray;

/// 音视频生成工具
@property(nonatomic,strong)DJVideoGenerateManager *videoManager;
@property(nonatomic,strong)DJAudioHandleManager *audioManager;
@property(nonatomic,strong)DJVideo *completeManager;

@end

static NSString *identifer = @"UITableViewCell";

@implementation MainTableView

+(MainTableView *)mainTableView{
    return [[MainTableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, kScreenWidth, kScreenHeight- SafeAreaTopHeight) style:UITableViewStylePlain];
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.tableFooterView = [[UIView alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if (@available(iOS 11.0, *)) self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.showsVerticalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:identifer];
        [self initData];
    }
    return self;
}

-(void)initData{
    
    _videoManager = [[DJVideoGenerateManager alloc] init];
    _videoManager.dataSource = self;
    _audioManager = [[DJAudioHandleManager alloc] init];
    _completeManager = [[DJVideo alloc] init];
    _functionTitleArray = @[@"本地静态图，生成视频",
                            @"本地gif图，生成视频",
                            @"网络静态图，生成视频",
                            @"网络gif图，生成视频",
                            @"本地静态图，本地音频，生成音视频",
                            @"本地静态图，网络音频，生成音视频",
                            @"本地gif图，本地音频，生成音视频",
                            @"本地gif图，网络音频，生成音视频",
                            @"网络静态图，本地音频，生成音视频",
                            @"网络静态图，网络音频，生成音视频",
                            @"网络gif图，本地音频，生成音视频",
                            @"网络gif图，网络音频，生成音视频",
                            ];
}
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _functionTitleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    NSString *functionTitle = _functionTitleArray[indexPath.row];
    cell.textLabel.text = functionTitle;
    return cell;
}

#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            /// 本地静态图，生成视频
            [_videoManager generateVideoWithLocalImageNameArray:@[@"03.jpg",@"04.jpg",@"05.jpg",@"06.jpg"] progress:^(CGFloat progress) {
                NSLog(@"本地静态图，生成视频，进度：%.2f",progress);
            } finished:^(NSString * _Nonnull videoPath) {
                NSLog(@"本地静态图，生成视频，路径：%@",videoPath);
            }];
            break;
        }
        case 1:{
            /// 本地gif图，生成视频
            [_videoManager generateVideoWithLocalGifNameArray:@[@"01.gif",@"02.gif"] progress:^(CGFloat progress) {
                NSLog(@"本地gif图，生成视频，进度：%.2f",progress);
            } finished:^(NSString * _Nonnull videoPath) {
                NSLog(@"本地gif图，生成视频，路径：%@",videoPath);
            }];
            break;
        }
        case 2:{
            /// 网络静态图，生成视频
            NSArray *imageSource = @[
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546425182720&di=c5c31adc11f1a06dbe1ac6dc69b9951f&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F72f082025aafa40faa40fe98a064034f79f019f4.jpg",
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546425182720&di=fc29e945975f7d683aa2e66b04b5387b&imgtype=0&src=http%3A%2F%2Fi1.hdslb.com%2Fbfs%2Farchive%2Fb7419860e1c0182fe6ba3a850ac564701d898ff6.jpg",
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546425182719&di=9378f446f889e98bf144f6a4c626a32c&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201607%2F13%2F20160713162247_j4eFi.jpeg",
                                     @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2698247631,3226570539&fm=26&gp=0.jpg",
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546425182718&di=9c69a4d2e7a2be7205ea61bf4acae114&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201506%2F30%2F20150630140301_rMuSV.jpeg"
                                     ];
            [_videoManager generateVideoWithNetImagePathArray:imageSource progress:^(CGFloat progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *progressStr = [NSString stringWithFormat:@"网络静态图，生成视频，进度：%.2f",progress];
                    NSLog(@"%@",progressStr);
                });
            } finished:^(NSString * _Nonnull videoPath) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"网络静态图，生成视频，路径：%@",videoPath);
                });
            }];
            
            break;
        }
        case 3:{
            /// 网络gif图，生成视频
            NSArray *sourceArray = @[
                                     @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3656631104,1782834538&fm=26&gp=0.gif",
                                     @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2997066680,3442795107&fm=26&gp=0.gif"
                                     ];
            [_videoManager generateVideoWithNetGifPathArray:sourceArray progress:^(CGFloat progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"网络gif图，生成视频，进度：%.2f",progress);
                });
            } finished:^(NSString * _Nonnull videoPath) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"网络gif图，生成视频，路径：%@",videoPath);
                });
            }];
            break;
        }
        case 4:{
            /// 本地静态图，本地音频，生成音视频
            NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"despacito.mp3" ofType:nil];
            [_completeManager generateCompleteVideoWithImageNameArray:@[@"03.jpg",@"04.jpg",@"05.jpg",@"06.jpg"] audioPath:audioPath audioType:@".mp3" isLocalAudio:YES videoTime:10 videoSize:CGSizeMake(320, 180) imageCountForSecond:20 audioVolume:1 progress:^(CGFloat progress) {
                NSLog(@"本地静态图，本地音频，生成音视频，进度:%.2f",progress);
            } finishBlock:^(NSError * _Nonnull error, NSString * _Nonnull path) {
                NSLog(@"本地静态图，本地音频，生成音视频，k路径:%@",path);
            }];
            break;
        }
        case 5:{
            /// 本地静态图，网络音频，生成音视频
            [_completeManager generateCompleteVideoWithImageNameArray:@[@"03.jpg",@"04.jpg",@"05.jpg",@"06.jpg"] audioPath:@"http://img95.699pic.com/audio/960/604/662136_all.mp3" audioType:@".mp3" isLocalAudio:NO videoTime:10 videoSize:CGSizeMake(320, 180) imageCountForSecond:20 audioVolume:1 progress:^(CGFloat progress) {
                NSLog(@"本地静态图，网络音频，生成音视频，进度：%.2f",progress);
            } finishBlock:^(NSError * _Nonnull error, NSString * _Nonnull path) {
                NSLog(@"本地静态图，网络音频，生成音视频，路径：%@",path);
            }];
            break;
        }
        case 6:{
            /// 本地gif图，本地音频，生成音视频
            NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"despacito.mp3" ofType:nil];
            [_completeManager generateCompleteVideoWithGifNameArray:@[@"01.gif",@"02.gif"] audioPath:audioPath audioType:@".mp3" isLocalAudio:YES videoTime:10 videoSize:CGSizeMake(320, 180) imageCountForSecond:20 audioVolume:1 progress:^(CGFloat progress) {
                NSLog(@"本地gif图，本地音频，生成音视频，进度：%.2f",progress);
            } finishBlock:^(NSError * _Nonnull error, NSString * _Nonnull path) {
                NSLog(@"本地gif图，本地音频，生成音视频，路径：%@",path);
            }];
            break;
        }
        case 7:{
            /// 本地gif图，网络音频，生成音视频
            [_completeManager generateCompleteVideoWithGifNameArray:@[@"01.gif",@"02.gif"] audioPath:@"http://img95.699pic.com/audio/960/604/662136_all.mp3" audioType:@".mp3" isLocalAudio:NO videoTime:10 videoSize:CGSizeMake(320, 180) imageCountForSecond:20 audioVolume:1 progress:^(CGFloat progress) {
                NSLog(@"本地gif图，网络音频，生成音视频，进度：%.2f",progress);
            } finishBlock:^(NSError * _Nonnull error, NSString * _Nonnull path) {
                NSLog(@"本地gif图，网络音频，生成音视频，路径：%@",path);
            }];
            break;
        }
        case 8:{
            /// 网络静态图，本地音频，生成音视频
            NSArray *imageSource = @[
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546425182720&di=c5c31adc11f1a06dbe1ac6dc69b9951f&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F72f082025aafa40faa40fe98a064034f79f019f4.jpg",
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546425182720&di=fc29e945975f7d683aa2e66b04b5387b&imgtype=0&src=http%3A%2F%2Fi1.hdslb.com%2Fbfs%2Farchive%2Fb7419860e1c0182fe6ba3a850ac564701d898ff6.jpg",
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546425182719&di=9378f446f889e98bf144f6a4c626a32c&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201607%2F13%2F20160713162247_j4eFi.jpeg",
                                     @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2698247631,3226570539&fm=26&gp=0.jpg",
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546425182718&di=9c69a4d2e7a2be7205ea61bf4acae114&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201506%2F30%2F20150630140301_rMuSV.jpeg"
                                     ];
            NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"despacito.mp3" ofType:nil];
            [_completeManager generateCompleteVideoWithImageUrlStringArray:imageSource audioPath:audioPath audioType:@".mp3" isLocalAudio:YES videoTime:10 videoSize:CGSizeMake(320, 180) imageCountForSecond:20 audioVolume:1 progress:^(CGFloat progress) {
                NSLog(@"网络静态图，本地音频，生成音视频，进度：%.2f",progress);
            } finishBlock:^(NSError * _Nonnull error, NSString * _Nonnull path) {
                NSLog(@"网络静态图，本地音频，生成音视频，路径：%@",path);
            }];
            break;
        }
        case 9:{
            /// 网络静态图，网络音频，生成音视频
            NSArray *imageSource = @[
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546425182720&di=c5c31adc11f1a06dbe1ac6dc69b9951f&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F72f082025aafa40faa40fe98a064034f79f019f4.jpg",
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546425182720&di=fc29e945975f7d683aa2e66b04b5387b&imgtype=0&src=http%3A%2F%2Fi1.hdslb.com%2Fbfs%2Farchive%2Fb7419860e1c0182fe6ba3a850ac564701d898ff6.jpg",
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546425182719&di=9378f446f889e98bf144f6a4c626a32c&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201607%2F13%2F20160713162247_j4eFi.jpeg",
                                     @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2698247631,3226570539&fm=26&gp=0.jpg",
                                     @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1546425182718&di=9c69a4d2e7a2be7205ea61bf4acae114&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201506%2F30%2F20150630140301_rMuSV.jpeg"
                                     ];
            [_completeManager generateCompleteVideoWithImageUrlStringArray:imageSource audioPath:@"http://img95.699pic.com/audio/960/604/662136_all.mp3" audioType:@".mp3" isLocalAudio:NO videoTime:10 videoSize:CGSizeMake(320, 180) imageCountForSecond:20 audioVolume:1 progress:^(CGFloat progress) {
                NSLog(@"网络静态图，网络音频，生成音视频，进度：%.2f",progress);
            } finishBlock:^(NSError * _Nonnull error, NSString * _Nonnull path) {
                NSLog(@"网络静态图，网络音频，生成音视频，路径：%@",path);
            }];
            break;
        }
        case 10:{
            /// 网络gif图，本地音频，生成音视频
            NSArray *sourceArray = @[
                                     @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3656631104,1782834538&fm=26&gp=0.gif",
                                     @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2997066680,3442795107&fm=26&gp=0.gif"
                                     ];
            NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"despacito.mp3" ofType:nil];
            [_completeManager generateCompleteVideoWithGifUrlStringArray:sourceArray audioPath:audioPath audioType:@".mp3" isLocalAudio:YES videoTime:10 videoSize:CGSizeMake(320, 180) imageCountForSecond:20 audioVolume:1 progress:^(CGFloat progress) {
                NSLog(@"网络gif图，本地音频，生成音视频，进度：%.2f",progress);
            } finishBlock:^(NSError * _Nonnull error, NSString * _Nonnull path) {
                NSLog(@"网络gif图，本地音频，生成音视频，路径：%@",path);
            }];
            break;
        }
        case 11:{
            /// 网络gif图，网络音频，生成音视频
            NSArray *sourceArray = @[
                                     @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3656631104,1782834538&fm=26&gp=0.gif",
                                     @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2997066680,3442795107&fm=26&gp=0.gif"
                                     ];
            [_completeManager generateCompleteVideoWithGifUrlStringArray:sourceArray audioPath:@"http://img95.699pic.com/audio/960/604/662136_all.mp3" audioType:@".mp3" isLocalAudio:NO videoTime:10 videoSize:CGSizeMake(320, 180) imageCountForSecond:20 audioVolume:1 progress:^(CGFloat progress) {
                NSLog(@"网络gif图，网络音频，生成音视频，进度：%.2f",progress);
            } finishBlock:^(NSError * _Nonnull error, NSString * _Nonnull path) {
                NSLog(@"网络gif图，网络音频，生成音视频，路径：%@",path);
            }];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark DJVideoGenerateManagerDataSource

/// 同一张图片的展示次数【默认为10】
-(NSInteger)getShowTimesForSameImage{
    return 20;
}

/// 每秒钟图片播放的次数【默认为10】
-(NSInteger)getImageNumbersForOneSeconds{
    return 15;
}

-(NSInteger)handleTypeForSourceImage{
    return 1;
}

@end
