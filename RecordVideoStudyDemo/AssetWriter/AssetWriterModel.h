//
//  ZHRecordVideoSection.h
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AVAssetWriterManager.h"

/**
 闪光灯的状态

 - CameraFlashStateAuto: 自动
 - CameraFlashStateOpen: 打开
 - CameraFlashStateClose: 关闭
 */
typedef NS_ENUM(NSInteger, CameraFlashState) {
    CameraFlashStateAuto,
    CameraFlashStateOpen,
    CameraFlashStateClose
};

@protocol AssetWriterModelDelegate <NSObject>

/**
 刷新录制视频状态

 @param recordState 视频录制状态
 */
- (void)updateRecordVideoState:(RecordVideoState)recordState;

/**
 刷新视频录制进度

 @param progress 视频录制进度
 */
- (void)updateRecordingProgress:(CGFloat)progress;

/**
 刷新相机闪光灯状态

 @param cameraFlashState 相机的闪光灯状态
 */
- (void)updateCameraFlashState:(CameraFlashState)cameraFlashState;

@end

@interface AssetWriterModel : NSObject
@property (nonatomic, weak) id<AssetWriterModelDelegate> delegate;
@property (nonatomic, assign) RecordVideoState videoState;
@property (nonatomic, strong, readonly) NSURL *videoUrl;


/**
 ZHRecordVideoSection 初始化配置

 @param sizeType 视频界面类型
 @param superView 所在父视图
 @return ZHRecordVideoSection
 */
- (id)initWithRecordVideoSate:(RecordViewSizeType)sizeType superView:(UIView *)superView;

/**
 转换前后置摄像头
 */
- (void)exchangeCamera;

/**
 控制相机闪光灯的开关
 */
- (void)controlCameraFlash;

/**
 开始录制视频
 */
- (void)startRecordVideo;

/**
 停止录制视频
 */
- (void)stopRecordVideo;

/**
 ZHRecordVideoSection 重置
 */
- (void)recordVideoReset;









@end
