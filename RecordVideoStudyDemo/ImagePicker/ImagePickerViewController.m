//
//  ImagePickerViewController.m
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import "ImagePickerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>  // iOS3.0时引入，提供手机系统基础服务
#import <AssetsLibrary/AssetsLibrary.h>

#import "ImagePickerUIView.h"

@interface ImagePickerViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) ImagePickerUIView *uiView;
@end

@implementation ImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isCustom = YES;
    
    // 首先判断 UIImagePickerController 是否能够使用 UIImagePickerControllerSourceTypeCamera
    if (![self judgeImagePickerVideoRecordAvilable]) {
        return;
    } else {
        // 设置来源为摄像机
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 设置类型为 video
        self.mediaTypes = @[(NSString *)kUTTypeMovie];
        self.delegate = self;
        
        if (_isCustom) {
            [self customConfigureImgPickerUI];
        } else {
            // 隐藏系统自带的UI 默认显示系统自带
            self.showsCameraControls = YES;
            // 设置前后置摄像头
            [self switchCameraIsFront:NO];
            // 设置视频画质类别 默认 UIImagePickerControllerQualityTypeMedium
            self.videoQuality = UIImagePickerControllerQualityTypeMedium;
            // 设置闪光灯类型 默认 UIImagePickerControllerCameraFlashModeAuto
            self.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            // 设置录制的最大时长 默认10秒
            self.videoMaximumDuration = 30;
        }
    }
}


# pragma mark ---- 判断 imagePicker 是否能鼓录制视频 ----
- (BOOL)judgeImagePickerVideoRecordAvilable{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *availableMediaTypesArr = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypesArr containsObject:(NSString *)kUTTypeMovie]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

# pragma mark ---- 设置前后置摄像头 ----
// 先判断是否可用，可用则直接设置
- (void)switchCameraIsFront:(BOOL)front{
    if (front) {
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
            [self setCameraDevice:UIImagePickerControllerCameraDeviceFront];
            
        }
    } else {
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
            [self setCameraDevice:UIImagePickerControllerCameraDeviceRear];
        }
    }
}

# pragma mark ---- 开始录制 ----
- (void)startImgPickerRecord{
    [self startVideoCapture];
    self.uiView.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(refreshTimeLabel) userInfo:nil repeats:YES];
    self.uiView.timeView.hidden = NO;

}

# pragma mark ---- 停止录制 ----
- (void)stopImgPickerRecord{
    [self stopVideoCapture];
    if (self.uiView) {
        self.uiView.timeView.hidden = YES;
        [self.uiView.timer invalidate];
        self.uiView.timer = nil;
        self.uiView.recordTime = 0;
        self.uiView = nil;
    }
}

# pragma mark ---- 隐藏系统自带UI 自定义 ----
- (void)customConfigureImgPickerUI{
    self.showsCameraControls = NO;
    self.uiView = [[ImagePickerUIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, 50)];
    self.cameraOverlayView = self.uiView;
    [self.uiView.backButton addTarget:self action:@selector(getback) forControlEvents:UIControlEventTouchDown];
    [self.uiView.startButton addTarget:self action:@selector(controlRecordVideo:) forControlEvents:UIControlEventTouchDown];

    self.videoQuality = UIImagePickerControllerQualityTypeHigh;
    self.videoMaximumDuration = 10;
}

- (void)refreshTimeLabel
{
    self.uiView.recordTime += TIMER_INTERVAL;
    self.uiView.timelabel.text = [self changeToVideotime:self.uiView.recordTime];
    [self.uiView.timelabel sizeToFit];
    if (self.uiView.recordTime >= RECORDMAXDUR) {
        [self stopImgPickerRecord];
    }
    
}


- (NSString *)changeToVideotime:(CGFloat)videocurrent {
    return [NSString stringWithFormat:@"%02li:%02li",lround(floor(videocurrent/60.f)),lround(floor(videocurrent/1.f))%60];
}

# pragma mark ---- 返回 ----
- (void)getback{
    [self dismissViewControllerAnimated:NO completion:nil];
}

# pragma mark ---- 开关 视频录制 ----
- (void)controlRecordVideo:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        [self startImgPickerRecord];
    } else {
        [self stopImgPickerRecord];
    }
}


# pragma mark ---- UIImagePickerControllerDelegate ----
# warning 无法控制录制的暂停，一旦开启再停止，则默认完成录制，回调以下方法去保存
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        // 取到录制完的视频 跳转播放
        NSURL *recordUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        VideoPlayController *videoVc = [[VideoPlayController alloc] init];
        videoVc.videoUrl = recordUrl;
        videoVc.imgSave = YES;
        videoVc.typeNum = 2;
        [self.viewVc presentViewController:videoVc animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
