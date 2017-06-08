//
//  FileOutputVideoView.m
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/26.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import "FileOutputVideoView.h"
@interface FileOutputVideoView()<FileOutputModelDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) RecordProgressView *progressView;
@property (nonatomic, assign) CGFloat recordProgress;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIView *timeView;


@end

@implementation FileOutputVideoView

- (id)initWithFileVideoViewType:(FileVideoViewType)type{
    if (self = [super initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT)]) {
        [self buildRecordVideoViewWithViewSizeType:type];
    }
    return self;
}

# pragma mark ---- 布局录制视频界面 ----
- (void)buildRecordVideoViewWithViewSizeType:(FileVideoViewType)viewSizeType{
    self.fileModel = [[FileOutputModel alloc]initWithFileVideoViewType:viewSizeType superView:self];
    self.fileModel.delegate = self;
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.5];
    self.topView.frame = CGRectMake(0, 0, KSCREENWIDTH, 46);
    [self addSubview:self.topView];
    
    
    
    self.timeView = [[UIView alloc] init];
    self.timeView.hidden = YES;
    self.timeView.backgroundColor = [UIColor colorWithRGB:0x242424 alpha:0.7];
    self.timeView.frame = CGRectMake((KSCREENWIDTH - 100)/2, 18, 100, 34);
    self.timeView.layer.cornerRadius = 4;
    self.timeView.layer.masksToBounds = YES;
    [self addSubview:self.timeView];
    
    
    UIView *redPoint = [[UIView alloc] init];
    redPoint.frame = CGRectMake(0, 0, 6, 6);
    redPoint.layer.cornerRadius = 3;
    redPoint.layer.masksToBounds = YES;
    redPoint.center = CGPointMake(25, 17);
    redPoint.backgroundColor = [UIColor redColor];
    [self.timeView addSubview:redPoint];
    
    self.timeLab =[[UILabel alloc] init];
    self.timeLab.font = [UIFont systemFontOfSize:13];
    self.timeLab.textColor = [UIColor whiteColor];
    self.timeLab.frame = CGRectMake(40, 8, 40, 28);
    [self.timeView addSubview:self.timeLab];
    
    
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleButton.frame = CGRectMake(15, 18, 17, 16);
    [self.cancleButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(recordVideoViewDismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.cancleButton];
    
    
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraButton.frame = CGRectMake(KSCREENWIDTH - 60 - 28, 18, 28, 22);
    [self.cameraButton setImage:[UIImage imageNamed:@"listing_camera_lens"] forState:UIControlStateNormal];
    [self.cameraButton addTarget:self action:@selector(exchangeCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraButton sizeToFit];
    [self.topView addSubview:self.cameraButton];
    
    
    
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashButton.frame = CGRectMake(KSCREENWIDTH - 22 - 15, 18, 22, 22);
    [self.flashButton setImage:[UIImage imageNamed:@"listing_flash_off"] forState:UIControlStateNormal];
    [self.flashButton addTarget:self action:@selector(controlFlash) forControlEvents:UIControlEventTouchUpInside];
    [self.flashButton sizeToFit];
    [self.topView addSubview:self.flashButton];
    
    
    self.progressView = [[RecordProgressView alloc] initWithFrame:CGRectMake((KSCREENWIDTH - 62)/2, KSCREENHEIGHT - 32 - 62, 62, 62)];
    self.progressView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.progressView];
    
    
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordButton addTarget:self action:@selector(controlRecordVideo) forControlEvents:UIControlEventTouchUpInside];
    self.recordButton.frame = CGRectMake(5, 5, 52, 52);
    self.recordButton.backgroundColor = [UIColor redColor];
    self.recordButton.layer.cornerRadius = 26;
    self.recordButton.layer.masksToBounds = YES;
    [self.progressView addSubview:self.recordButton];
    [self.progressView resetProgress];
    
}


- (void)recordVideoViewReset{
    [self.fileModel resetFileRecordVideo];
}

- (void)updateViewWithRecording
{
    self.timeView.hidden = NO;
    self.topView.hidden = YES;
    [self changeToRecordStyle];
}

- (void)updateViewWithStop
{
    self.timeView.hidden = YES;
    self.topView.hidden = NO;
    [self changeToRecordStopStyle];
}

- (void)changeToRecordStyle
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.recordButton.center;
        CGRect rect = self.recordButton.frame;
        rect.size = CGSizeMake(28, 28);
        self.recordButton.frame = rect;
        self.recordButton.layer.cornerRadius = 4;
        self.recordButton.center = center;
    }];
}

- (void)changeToRecordStopStyle
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.recordButton.center;
        CGRect rect = self.recordButton.frame;
        rect.size = CGSizeMake(52, 52);
        self.recordButton.frame = rect;
        self.recordButton.layer.cornerRadius = 26;
        self.recordButton.center = center;
    }];
}

# pragma mark ---- 响应事件 ----
- (void)recordVideoViewDismiss{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fileOutputVideoViewDismiss)]) {
        [self.delegate fileOutputVideoViewDismiss];
    }
}

- (void)exchangeCamera{
    [self.fileModel turnCameraAction];
}

- (void)controlFlash{
    [self.fileModel controlCameraFlash];
}

- (void)stopRecord
{
    [self.fileModel stopFileRecordVideo];
}

- (void)resetFileOutputVideoView
{
    [self.fileModel resetFileRecordVideo];
}


- (void)controlRecordVideo{
    if (self.fileModel.recordState == FileRecordStateInit) {
        [self.fileModel startFileRecordVideo];
    } else if (self.fileModel.recordState == FileRecordStateRecording) {
        [self.fileModel stopFileRecordVideo];
    } else if (self.fileModel.recordState == FileRecordStatePause) {
//        [self.fileModel resetFileRecordVideo];
    } else {
//        [self.fileModel resetFileRecordVideo];
    }
}


# pragma mark ---- RecordVideoSectionDelegate ----
- (void)updateRecordState:(FileRecordState)recordState{
    if (recordState == FileRecordStateInit) {
        [self updateViewWithStop];
        [self.progressView resetProgress];
    } else if (recordState == FileRecordStateRecording) {
        [self updateViewWithRecording];
    } else if (recordState == FileRecordStatePause) {
        [self updateViewWithStop];
    } else  if (recordState == FileRecordStateFinish) {
        [self updateViewWithStop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(finshedRecordVideoWithVideoUrl:)]) {
            [self.delegate finshedRecordVideoWithVideoUrl:self.fileModel.videoUrl];
        }
    }
}

- (void)updateRecordingProgress:(CGFloat)progress{
    [self.progressView updateProgressWithValue:progress];
    self.timeLab.text = [self changeToVideotime:progress * RECORDMAXDUR];
    [self.timeLab sizeToFit];
}

- (NSString *)changeToVideotime:(CGFloat)videocurrent {
    return [NSString stringWithFormat:@"%02li:%02li",lround(floor(videocurrent/60.f)),lround(floor(videocurrent/1.f))%60];
}


- (void)updateCameraFlashState:(FileCameraFlashState)state{
    if (state == FileCameraFlashOpen) {
        [self.flashButton setImage:[UIImage imageNamed:@"listing_flash_on"] forState:UIControlStateNormal];
    }
    if (state == FileCameraFlashClose) {
        [self.flashButton setImage:[UIImage imageNamed:@"listing_flash_off"] forState:UIControlStateNormal];
    }
    if (state == FileCameraFlashAuto) {
        [self.flashButton setImage:[UIImage imageNamed:@"listing_flash_auto"] forState:UIControlStateNormal];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
