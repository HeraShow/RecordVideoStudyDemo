//
//  AVAssetWriterManager.m
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import "AVAssetWriterManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AVAssetWriterManager()
@property (nonatomic, strong) dispatch_queue_t writeQueue;
@property (nonatomic, strong) NSURL *videoUrl;

@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInput *videoWriterInput;
@property (nonatomic, strong) AVAssetWriterInput *audioWriterInput;

@property (nonatomic, strong) NSDictionary *videoCompressionSetDic;
@property (nonatomic, strong) NSDictionary *audioCompressionSetDic;

@property (nonatomic, assign) RecordViewSizeType sizeType;

@property (nonatomic, assign) CGSize outputSize;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat recordTime;
@property (nonatomic, assign) BOOL canWriter;


@end
@implementation AVAssetWriterManager
- (id)initWithURL:(NSURL *)url sizeType:(RecordViewSizeType)sizeType
{
    self = [super init];
    if (self) {
        _videoUrl = url;
        _sizeType = sizeType;
        [self setUpWithType:sizeType];
    }
    return self;
}


- (void)setUpWithType:(RecordViewSizeType)sizeType{
    switch (sizeType) {
        case RecordView1x1:
            _outputSize = CGSizeMake(KSCREENWIDTH, KSCREENWIDTH);
            break;
        case RecordView3x4:
            _outputSize = CGSizeMake(KSCREENWIDTH, KSCREENWIDTH/3*4);
            break;
        case RecordView4x3:
            _outputSize = CGSizeMake(KSCREENWIDTH, KSCREENWIDTH/4*3);
            break;
        case RecordViewFull:
            _outputSize = [UIScreen mainScreen].bounds.size;
            break;
        default:
            _outputSize = [UIScreen mainScreen].bounds.size;
            break;
    }
    _writeQueue = dispatch_queue_create("com.5miles", DISPATCH_QUEUE_SERIAL);
    _recordTime = 0;
}

# pragma mark ---- AVAssetWriter 配置 ----
- (void)setUpAVAssetWriter{
    self.assetWriter = [[AVAssetWriter alloc]initWithURL:self.videoUrl fileType:AVFileTypeMPEG4 error:nil];
    self.assetWriter.shouldOptimizeForNetworkUse = YES;
    // 写入视频的大小
    NSInteger numPixels = self.outputSize.width * self.outputSize.height;
    // 每像素比特率
    CGFloat bitPrepixel = 6.0;
    NSInteger bitPerSecond = numPixels * bitPrepixel;
    // 码率和帧率
    NSDictionary *compressionProerties = @{AVVideoAverageBitRateKey:@(bitPerSecond),
                                           AVVideoExpectedSourceFrameRateKey:@(30),
                                           AVVideoMaxKeyFrameIntervalKey:@(30),
                                           AVVideoProfileLevelKey:AVVideoProfileLevelH264BaselineAutoLevel};
    
    
    [self setUpVideoEncodeWith:compressionProerties];
    [self setUpAudioEncodeWith:compressionProerties];
    
    self.writeState = RecordVideoStateRecording;

}

# pragma mark ---- 视频 数据写入配置 ----
- (void)setUpVideoEncodeWith:(NSDictionary *)compressionProerties{
    
    // 视频设置
    self.videoCompressionSetDic = @{AVVideoCodecKey:AVVideoCodecH264,
                                    AVVideoScalingModeKey:AVVideoScalingModeResizeAspectFill,
                                    AVVideoWidthKey:@(self.outputSize.height),
                                    AVVideoHeightKey:@(self.outputSize.width),
                                    AVVideoCompressionPropertiesKey:compressionProerties};
    self.videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:self.videoCompressionSetDic];
    // expectsMediaDataInRealTime 必须设为yes，需要从capture session 实时获取数据
    self.videoWriterInput.expectsMediaDataInRealTime = YES;
    _videoWriterInput.transform = CGAffineTransformMakeRotation(M_PI/2.0);

    
    if ([_assetWriter canAddInput:_videoWriterInput]) {
        [_assetWriter addInput:_videoWriterInput];
    }else {
        NSLog(@"AssetWriter videoInput append Failed");
    }
}

# pragma mark ---- 音频 数据写入配置 ----

- (void)setUpAudioEncodeWith:(NSDictionary *)compressionProerties{
    
    // 音频设置
    self.audioCompressionSetDic =  @{ AVEncoderBitRatePerChannelKey : @(28000),
                                      AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                      AVNumberOfChannelsKey : @(1),
                                      AVSampleRateKey : @(22050) };
    
    self.audioWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:self.audioCompressionSetDic];
    // expectsMediaDataInRealTime 必须设为yes，需要从capture session 实时获取数据
    self.audioWriterInput.expectsMediaDataInRealTime = YES;
    if ([_assetWriter canAddInput:_audioWriterInput]) {
        [_assetWriter addInput:_audioWriterInput];
    }else {
        NSLog(@"AssetWriter audioInput Append Failed");
    }
}


# pragma mark ---- 公有方法 ----
- (void)startWriteManager{
    self.writeState = RecordVideoStatePreRecoring;
    if (!self.assetWriter) {
        [self setUpAVAssetWriter];
    }
}

- (void)stopWriteManager{
    self.writeState = RecordVideoStateFinish;
    [self.timer invalidate];
    self.timer = nil;
    __weak __typeof(self)weakSelf = self;
    if(_assetWriter && _assetWriter.status == AVAssetWriterStatusWriting){
        dispatch_async(self.writeQueue, ^{
            [_assetWriter finishWritingWithCompletionHandler:^{
                ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
                [lib writeVideoAtPathToSavedPhotosAlbum:weakSelf.videoUrl completionBlock:nil];
                
            }];
        });
    }
}

- (void)updateProgress
{
    if (_recordTime >= RECORDMAXDUR) {
        [self stopWriteManager];
        if (self.delegate && [self.delegate respondsToSelector:@selector(finishAssetWriering)]) {
            [self.delegate finishAssetWriering];
        }
        return;
    }
    _recordTime += TIMER_INTERVAL;
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateAssetWriterProgress:)]) {
        [self.delegate updateAssetWriterProgress:_recordTime/RECORDMAXDUR * 1.0];
    }
}


- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer ofMediaType:(NSString *)mediaType{
    if (sampleBuffer == NULL){
        NSLog(@"empty sampleBuffer");
        return;
    }
    
    @synchronized(self){
        if (self.writeState < RecordVideoStateRecording){
            NSLog(@"not ready yet");
            return;
        }
    }
    
    
    
    CFRetain(sampleBuffer);
    dispatch_async(self.writeQueue, ^{
        @autoreleasepool {
            @synchronized(self) {
                if (self.writeState > RecordVideoStateRecording){
                    CFRelease(sampleBuffer);
                    return;
                }
            }
            
            
            
            
            if (!self.canWriter && mediaType == AVMediaTypeVideo) {
                [self.assetWriter startWriting];
                [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
                self.canWriter = YES;
            }
            
            if (!_timer) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
                });
                
            }
            //写入视频数据
            if (mediaType == AVMediaTypeVideo) {
                if (self.videoWriterInput.readyForMoreMediaData) {
                    BOOL success = [self.videoWriterInput appendSampleBuffer:sampleBuffer];
                    if (!success) {
                        @synchronized (self) {
                            [self stopWriteManager];
                            [self destroyWrite];
                        }
                    }
                }
            }
            
            //写入音频数据
            if (mediaType == AVMediaTypeAudio) {
                if (self.audioWriterInput.readyForMoreMediaData) {
                    BOOL success = [self.audioWriterInput appendSampleBuffer:sampleBuffer];
                    if (!success) {
                        @synchronized (self) {
                            [self stopWriteManager];
                            [self destroyWrite];
                        }
                    }
                }
            }
            
            CFRelease(sampleBuffer);
        }
    } );
}

//检查写入地址
- (BOOL)checkPathUrl:(NSURL *)url
{
    if (!url) {
        return NO;
    }
    if ([ZHFileManager isExistsAtPath:[url path]]) {
        return [ZHFileManager removeItemAtPath:[url path]];
    }
    return YES;
}


- (void)destroyWrite
{
    self.assetWriter = nil;
    self.audioWriterInput = nil;
    self.videoWriterInput = nil;
    self.videoUrl = nil;
    self.recordTime = 0;
    [self.timer invalidate];
    self.timer = nil;
    
}



- (void)dealloc{
    [self destroyWrite];
}


@end
