//
//  AssetWriterModel.m
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import "AssetWriterModel.h"
#import <AVFoundation/AVFoundation.h>
#import "ZHFileManager.h"

@interface AssetWriterModel()<AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, AVAssetWriterManagerDelegate>
@property (nonatomic, strong) UIView *superView;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) dispatch_queue_t videoQueue;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) AVCaptureDeviceInput *videoCaptureInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioCaptureInput;

@property (nonatomic, strong) AVCaptureVideoDataOutput *videoCaptureOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioCaptureOutput;

@property (nonatomic, strong) AVAssetWriterManager *assetWriterManager;
@property (nonatomic, strong, readwrite) NSURL *videoUrl;

@property (nonatomic, assign) CameraFlashState flashState;
@property (nonatomic, assign) RecordViewSizeType sizeType;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat recordTime;

@end

@implementation AssetWriterModel
- (id)initWithRecordVideoSate:(RecordViewSizeType)sizeType superView:(UIView *)superView{
    if (self = [super init]) {
        _superView = superView;
        _sizeType = sizeType;
        
        [self setUpWithType:sizeType];
    }
    return self;
}

- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
        // AVCaptureVideoPreviewLayer 的显示方式
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        return _previewLayer;
    }
    return _previewLayer;
}

- (dispatch_queue_t)videoQueue{
    if (!_videoQueue) {
        _videoQueue = dispatch_queue_create("com.5miles", DISPATCH_QUEUE_SERIAL);
    }
    return _videoQueue;
}

- (AVCaptureSession *)session{
    if (!_session) {
        // 1. 创建捕捉会话
        // 需要确保在同一个队列，最好队列只创建一次
        _session = [[AVCaptureSession alloc]init];
        if ([_session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
            // 录制5秒钟视频 高画质10M,压缩成中画质 0.5M
            // 录制5秒钟视频 中画质0.5M,压缩成中画质 0.5M
            // 录制5秒钟视频 低画质0.1M,压缩成中画质 0.1M
            
            // 设置分辨率com.5miles
            _session.sessionPreset = AVCaptureSessionPresetHigh;
            return _session;
        }
    }
    return _session;
}

- (void)setVideoState:(RecordVideoState)videoState{
    if (_videoState != videoState) {
        _videoState = videoState;
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateRecordVideoState:)]) {
            [self.delegate updateRecordVideoState:videoState];
        }
    }
}

# pragma mark ---- 初始化设置 ----
- (void)setUpRecoedVideoInit{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBack) name:NSExtensionHostDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:NSExtensionHostDidBecomeActiveNotification object:nil];
    
    // 清空文件夹
    [self clearFile];
    // 改变视频录制的状态
    _videoState = RecordVideoStateInit;
}

# pragma mark ---- 存放视频的文件夹 ----
- (NSString *)videoFolder
{
    NSString *cacheDir = [ZHFileManager cachesFileDictionary];
    NSString *direc = [cacheDir stringByAppendingPathComponent:VIDEO_FOLDER];
    if (![ZHFileManager isExistsAtPath:direc]) {
        [ZHFileManager createDirectoryAtPath:direc];
    }
    return direc;
}
//清空文件夹
- (void)clearFile
{
    [ZHFileManager removeItemAtPath:[self videoFolder]];
    
}
//写入的视频路径
- (NSString *)createVideoFilePath
{
    NSString *videoName = [NSString stringWithFormat:@"%@.mp4", [NSUUID UUID].UUIDString];
    NSString *path = [[self videoFolder] stringByAppendingPathComponent:videoName];
    return path;
}

# pragma mark ---- notification  ----
- (void)enterBack{
    self.videoUrl = nil;
    [self.session stopRunning];
    [self.assetWriterManager destroyWrite];
}

- (void)becomeActive{
    [self recordVideoReset];
}


# pragma mark ---- 获取摄像头 ----
- (AVCaptureDevice *)receiveCameraDeviceWithPosition:(AVCaptureDevicePosition)position{
    // devicesWithMediaType ios10后废弃
    NSArray *deviceArr = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in deviceArr) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}


# pragma mark ---- 配置 视频 输入和输出 ----
- (void)setUpVideoConfigure{
    // 获取视频输入设备
    AVCaptureDevice *videoDevice = [self receiveCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    // 视频输入源
    NSError *error = nil;
    self.videoCaptureInput = [[AVCaptureDeviceInput alloc]initWithDevice:videoDevice error:&error];
    // 将视频输入源添加到对话
    if ([self.session canAddInput:_videoCaptureInput]) {
        [self.session addInput:_videoCaptureInput];
    }
    
    // 输出
    self.videoCaptureOutput = [[AVCaptureVideoDataOutput alloc]init];
    //立即丢弃旧帧，节省内存，默认YES
    self.videoCaptureOutput.alwaysDiscardsLateVideoFrames = YES;
    // 确保在一个队列
    [self.videoCaptureOutput setSampleBufferDelegate:self queue:self.videoQueue];
    if ([self.session canAddOutput:_videoCaptureOutput]) {
        [self.session addOutput:_videoCaptureOutput];
    }
    
}

# pragma mark ---- 配置 音频 输入和输出 ----
- (void)setUpAudioConfigure{
    // 获取音频输入设备
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    // 音频输入源
    NSError *error = nil;
    self.audioCaptureInput = [[AVCaptureDeviceInput alloc]initWithDevice:audioDevice error:&error];
    // 将音频输入源添加到对话
    if ([self.session canAddInput:_audioCaptureInput]) {
        [self.session addInput:_audioCaptureInput];
    }
    
    // 输出
    self.audioCaptureOutput = [[AVCaptureAudioDataOutput alloc]init];
    // 确保在一个队列
    [self.audioCaptureOutput setSampleBufferDelegate:self queue:self.videoQueue];
    if ([self.session canAddOutput:_audioCaptureOutput]) {
        [self.session addOutput:_audioCaptureOutput];
    }
}

# pragma mark ---- 添加视频 预览层 画面设置 ----
- (void)setUpVideoPreviewLayerWithType:(RecordViewSizeType)sizeType{
    CGRect size = CGRectZero;
    switch (sizeType) {
        case RecordView1x1:
            size = CGRectMake(0, 0, KSCREENWIDTH, KSCREENWIDTH);
            break;
        case RecordView3x4:
            size = CGRectMake(0, 0, KSCREENWIDTH, KSCREENWIDTH/3*4);
            break;
        case RecordView4x3:
            size = CGRectMake(0, 0, KSCREENWIDTH, KSCREENWIDTH/4*3);
            break;
        case RecordViewFull:
            size = _superView.frame;
            break;
        default:
            size = _superView.frame;
            break;
    }
    
    self.previewLayer.frame = size;
    [_superView.layer insertSublayer:self.previewLayer atIndex:0];
}

# pragma mark ---- 采集画面 ----
- (void)captureRecordView{
    [self.session startRunning];
}

# pragma mark ---- 初始化 AVAssetwriter ----
- (void)initAvAssetwriter{
    self.videoUrl = [[NSURL alloc] initFileURLWithPath:[self createVideoFilePath]];
    self.assetWriterManager = [[AVAssetWriterManager alloc]initWithURL:self.videoUrl sizeType:self.sizeType];
    self.assetWriterManager.delegate = self;

}

# pragma mark ---- 数据流处理 ----
- (void)setUpWithType:(RecordViewSizeType )type{
    ///1. 初始化捕捉会话，数据的采集都在会话中处理
    [self setUpRecoedVideoInit];
    ///2. 设置视频的输入输出
    [self setUpVideoConfigure];
    
    ///3. 设置音频的输入输出
    [self setUpAudioConfigure];
    
    ///4. 视频的预览层
    [self setUpVideoPreviewLayerWithType:type];
    
    ///5. 开始采集画面
    [self.session startRunning];
    
    ///6. 初始化writer， 用writer 把数据写入文件
    [self initAvAssetwriter];

}


# pragma mark ---- ZHRecordVideoSection 公有方法 ----
- (void)controlCameraFlash{
    if(_flashState == CameraFlashStateClose){
        if ([self.videoCaptureInput.device hasTorch]) {
            [self.videoCaptureInput.device lockForConfiguration:nil];
            [self.videoCaptureInput.device setTorchMode:AVCaptureTorchModeOn];
            [self.videoCaptureInput.device unlockForConfiguration];
            _flashState = CameraFlashStateOpen;
        }
    }else if(_flashState == CameraFlashStateOpen){
        if ([self.videoCaptureInput.device hasTorch]) {
            [self.videoCaptureInput.device lockForConfiguration:nil];
            [self.videoCaptureInput.device setTorchMode:AVCaptureTorchModeAuto];
            [self.videoCaptureInput.device unlockForConfiguration];
            _flashState = CameraFlashStateAuto;
        }
    }else if(_flashState == CameraFlashStateAuto){
        if ([self.videoCaptureInput.device hasTorch]) {
            [self.videoCaptureInput.device lockForConfiguration:nil];
            [self.videoCaptureInput.device setTorchMode:AVCaptureTorchModeOff];
            [self.videoCaptureInput.device unlockForConfiguration];
            _flashState = CameraFlashStateClose;
        }
    };
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateCameraFlashState:)]) {
        [self.delegate updateCameraFlashState:_flashState];
    }
}

- (void)startRecordVideo{
    if (self.videoState == RecordVideoStateInit) {
        [self.assetWriterManager startWriteManager];
        self.videoState = RecordVideoStateRecording;
    }
}

- (void)stopRecordVideo{
    [self.assetWriterManager stopWriteManager];
    [self.session stopRunning];
    self.videoState = RecordVideoStateFinish;
}

- (void)recordVideoReset{
    self.videoState = RecordVideoStateInit;
    [self.session startRunning];
    [self initAvAssetwriter];
}

- (void)exchangeCamera{
    
    [self.session stopRunning];
    // 1. 获取当前摄像头
    AVCaptureDevicePosition position = self.videoCaptureInput.device.position;
    
    //2. 获取当前需要展示的摄像头
    if (position == AVCaptureDevicePositionBack) {
        position = AVCaptureDevicePositionFront;
    } else {
        position = AVCaptureDevicePositionBack;
    }
    
    // 3. 根据当前摄像头创建新的device
    AVCaptureDevice *device = [self receiveCameraDeviceWithPosition:position];
    
    // 4. 根据新的device创建input
    AVCaptureDeviceInput *newInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //5. 在session中切换input
    [self.session beginConfiguration];
    [self.session removeInput:self.videoCaptureInput];
    [self.session addInput:newInput];
    [self.session commitConfiguration];
    self.videoCaptureInput = newInput;
    
    [self.session startRunning];
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate AVCaptureAudioDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    @autoreleasepool {
        
        //视频
        if (connection == [self.videoCaptureOutput connectionWithMediaType:AVMediaTypeVideo]) {
            if (!self.assetWriterManager.outputVideoFormatDescription) {
                @synchronized(self) {
                    CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                    self.assetWriterManager.outputVideoFormatDescription = formatDescription;
                }
            } else {
                @synchronized(self) {
                    if (self.assetWriterManager.writeState == RecordVideoStateRecording) {
                        [self.assetWriterManager appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeVideo];
                    }
                }
            }
        }
        
        //音频
        if (connection == [self.audioCaptureOutput connectionWithMediaType:AVMediaTypeAudio]) {
            if (!self.assetWriterManager.outputAudioFormatDescription) {
                @synchronized(self) {
                    CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
                    self.assetWriterManager.outputAudioFormatDescription = formatDescription;
                }
            }
            @synchronized(self) {
                if (self.assetWriterManager.writeState == RecordVideoStateRecording) {
                    [self.assetWriterManager appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeAudio];
                }
            }
        }
    }
    
}

# pragma mark ---- AVAssetWriterManagerDelegate ----
- (void)finishAssetWriering{
    [self.session stopRunning];
    self.videoState = RecordVideoStateFinish;
}

- (void)updateAssetWriterProgress:(CGFloat)progress{
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateRecordingProgress:)]) {
        [self.delegate updateRecordingProgress:progress];
    }
}

- (void)destroy
{
    [self.session stopRunning];
    self.session = nil;
    self.videoQueue = nil;
    self.videoCaptureOutput = nil;
    self.videoCaptureInput = nil;
    self.audioCaptureOutput = nil;
    self.audioCaptureInput = nil;
    [self.assetWriterManager destroyWrite];
    
}

- (void)dealloc
{
    [self destroy];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   
}



@end
