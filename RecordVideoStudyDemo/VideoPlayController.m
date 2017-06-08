//
//  VideoPlayController.m
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import "VideoPlayController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface VideoPlayController ()
@property (nonatomic, strong) MPMoviePlayerController *videoPlayer;
@property (nonatomic, strong) NSString *from;

@property (nonatomic, strong) UIImage *videoCover;
@property (nonatomic, assign) NSTimeInterval enterTime;
@property (nonatomic, assign) BOOL hasRecordEvent;

@end

@implementation VideoPlayController

- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.videoPlayer = [[MPMoviePlayerController alloc] init];
    [self.videoPlayer.view setFrame:self.view.bounds];
    self.videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.videoPlayer.view];
    [self.videoPlayer prepareToPlay];
    self.videoPlayer.controlStyle = MPMovieControlStyleNone;
    self.videoPlayer.shouldAutoplay = YES;
    self.videoPlayer.repeatMode = MPMovieRepeatModeOne;
    self.title = NSLocalizedString(@"PreView", nil);
    
    
    self.videoPlayer.contentURL = self.videoUrl;
    [self.videoPlayer play];
    
    [self buildPlayVideoUI];
    _enterTime = [[NSDate date] timeIntervalSince1970];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChanged) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayer];
}

- (void)buildPlayVideoUI{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"video_play_nav_bg"];
    imageView.frame = CGRectMake(0, 0, KSCREENWIDTH, 44);
    imageView.userInteractionEnabled = YES;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(dismissViewAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(0, 0, 44, 44);
    [imageView addSubview:cancelBtn];
    
    UIButton *Done = [UIButton buttonWithType:UIButtonTypeCustom];
    [Done addTarget:self action:@selector(doneRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [Done setTitle:@"Done" forState:UIControlStateNormal];
    Done.frame = CGRectMake(KSCREENWIDTH - 70, 0, 50, 44);
    [imageView addSubview:Done];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:imageView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.videoPlayer stop];
    self.videoPlayer = nil;
}

# pragma mark ---- 播放状态 ----
- (void)stateChanged{
    switch (self.videoPlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            [self trackPreloadingTime];
            break;
        case MPMoviePlaybackStatePaused:
            break;
        case MPMoviePlaybackStateStopped:
            break;
        default:
            break;
    }
}

- (void)videoFinished:(NSNotification*)aNotification{
    int value = [[aNotification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (value == MPMovieFinishReasonPlaybackEnded) {   // 视频播放结束
      
    }
}

- (void)trackPreloadingTime{
    
}

- (void)dismissViewAction{
    [self.videoPlayer stop];
    self.videoPlayer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)doneRecordAction{
    if (_imgSave) {
        // 保存视频到相册
        NSString *urlStr = [_videoUrl path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
        
        
        // 使用ALAssetsLibrary来保存 以下两个方法 在ios9.0之后被弃
//            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc]init];
//            if ([assetLibrary videoAtPathIsCompatibleWithSavedPhotosAlbum:_videoUrl]) {
//                [assetLibrary writeVideoAtPathToSavedPhotosAlbum:_videoUrl completionBlock:^(NSURL *assetURL, NSError *error) {
//                    if (error) {
//                        NSLog(@"ALAssetsLibrary 发生错误，错误信息:%@",error.localizedDescription);
//                    }else{
//                        NSLog(@"ALAssetsLibrary 视频保存成功.");
//                    }
//                }];
//            }

    }
    else{
        NSString *typeStr;
        switch (_typeNum) {
            case 0:
                typeStr = @"AVAssetWriter";
                break;
            case 1:
                typeStr = @"FileOutput";
                break;
            default:
                break;
        }
        WMSigleAlertView *sigleAlertView = [[WMSigleAlertView alloc]init];
        [sigleAlertView showAlertViewTitle:[NSString stringWithFormat:@"视频保存成功！- %@", typeStr] bgView:[UIApplication sharedApplication].delegate.window];
        NSLog(@"视频保存成功！");
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark ---- 手机 保存到相册 产生错误的自定义方法 ----
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"保存视频信息:%@",contextInfo);
        WMSigleAlertView *sigleAlertView = [[WMSigleAlertView alloc]init];
        [sigleAlertView showAlertViewTitle:@"视频保存成功！- UIImagePicker" bgView:[UIApplication sharedApplication].delegate.window];
        NSLog(@"视频保存成功！");
    }
}

- (void)captureImageAtTime:(float)time{
    [self.videoPlayer requestThumbnailImagesAtTimes:@[@(time)] timeOption:MPMovieTimeOptionNearestKeyFrame];
}

- (void)captureFinished:(NSNotification *)notification{
    self.videoCover = notification.userInfo[MPMoviePlayerThumbnailImageKey];
    if (self.videoCover == nil) {
        self.videoCover = [self coverIamgeAtTime:1];
    }
}

- (UIImage*)coverIamgeAtTime:(NSTimeInterval)time{
    [self.videoPlayer requestThumbnailImagesAtTimes:@[@(time)] timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoUrl options:nil];
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : [UIImage new];
    
    return thumbnailImage;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
