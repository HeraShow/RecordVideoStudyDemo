//
//  ViewController.m
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import "ViewController.h"

#import "AssetWriterViewController.h"
#import "FileOutputViewController.h"
#import "ImagePickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"三种视频录制方式";
    
    [self layoutHomeView];
}

# pragma mark --- 界面 ---
- (void)layoutHomeView{
    UIButton *assetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    assetButton.backgroundColor = VIEWBGCOLOR;
    assetButton.layer.cornerRadius = 5;
    assetButton.layer.borderColor = LINECOLOR.CGColor;
    assetButton.layer.borderWidth = 0.5f;
    [assetButton setTitle:@"assetWriter" forState:UIControlStateNormal];
    assetButton.frame = CGRectMake(KSCREENWIDTH/2 - 60, KSCREENHEIGHT/4 - 51, 120, 44);
    [assetButton addTarget:self action:@selector(assetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:assetButton];
    
    UIButton *fileButton = [UIButton buttonWithType:UIButtonTypeSystem];
    fileButton.backgroundColor = VIEWBGCOLOR;
    fileButton.layer.cornerRadius = 5;
    fileButton.layer.borderColor = LINECOLOR.CGColor;
    fileButton.layer.borderWidth = 0.5f;
    [fileButton setTitle:@"fileOutput" forState:UIControlStateNormal];
    fileButton.frame = CGRectMake(KSCREENWIDTH/2 - 60, KSCREENHEIGHT/4*2 - 58 , 120, 44);
    [fileButton addTarget:self action:@selector(fileButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fileButton];
    
    UIButton *pickerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    pickerButton.backgroundColor = VIEWBGCOLOR;
    pickerButton.layer.cornerRadius = 5;
    pickerButton.layer.borderColor = LINECOLOR.CGColor;
    pickerButton.layer.borderWidth = 0.5f;
    [pickerButton setTitle:@"imagePicker" forState:UIControlStateNormal];
    pickerButton.frame = CGRectMake(KSCREENWIDTH/2 - 60, KSCREENHEIGHT/4*3 - 58 , 120, 44);
    [pickerButton addTarget:self action:@selector(pickerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pickerButton];
}

# pragma mark ---- AVAssetWriter 音视频 单独输出 ----
// 数据采集在AVCaptureSession中进行,AVAssetWriter 需要 AVCaptureVideoDataOutput 和 AVCaptureAudioDataOutput 两个单独的输出，拿到各自的输出数据后，然后自己进行相应的处理。
// AVAssetWriter我们拿到的是数据流，还没有合成视频，对数据流进行处理。
// AVAssetWriter可以配置更多的参数
- (void)assetButtonPressed{
    AssetWriterViewController *assetVc = [[AssetWriterViewController alloc]init];
    
    [self presentViewController:assetVc animated:YES completion:nil];
    
//    [self.navigationController pushViewController:assetVc animated:NO];
}

# pragma mark ---- AVCaptureMovieFileOutput 一个输出 ----
// 数据采集在AVCaptureSession中进行,AVCaptureMovieFileOutput 只需要一个输出即可，指定一个文件路后，视频和音频会写入到指定路径，不需要其他复杂的操作。
// AVCaptureMovieFileOutput 如果要剪裁视频，因为系统已经把数据写到文件中了，我们需要从文件中独到一个完整的视频，然后处理。
- (void)fileButtonPressed{
    FileOutputViewController *fileVc = [[FileOutputViewController alloc]init];
    [self.navigationController pushViewController:fileVc animated:NO];
}

# pragma mark ---- UIImagePickerController 录制 ----
// 只能设置一些简单参数，自定义程度不高,只能自定义界面上的操作按钮，还有视频的画质等。
- (void)pickerButtonPressed{
    ImagePickerViewController *pickerVc = [[ImagePickerViewController alloc]init];
    pickerVc.viewVc = self;
    [self presentViewController:pickerVc animated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
