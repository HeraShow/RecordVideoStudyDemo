//
//  FileOutputModel.h
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/6/1.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 录制视频的长宽比

 - Type1X1: 1:1
 - Type4X3: 4:3
 - TypeFullScreen: 全屏
 */
typedef NS_ENUM(NSInteger, FileVideoViewType) {
    FileVideoType1X1 = 0,
    FileVideoType4X3,
    FileVideoTypeFullScreen
};

/**
 闪光灯状态

 - FMFlashClose: 关闭
 - FMFlashOpen: 开启
 - FMFlashAuto: 自动
 */
typedef NS_ENUM(NSInteger, FileCameraFlashState) {
    FileCameraFlashClose = 0,
    FileCameraFlashOpen,
    FileCameraFlashAuto,
};

/**
 录制状态

 - FMRecordStateInit: 初始化
 - FMRecordStateRecording: 正在录制
 - FMRecordStatePause: 暂停
 - FMRecordStateFinish: 完成
 */
typedef NS_ENUM(NSInteger, FileRecordState) {
    FileRecordStateInit = 0,
    FileRecordStateRecording,
    FileRecordStatePause,
    FileRecordStateFinish,
};

@protocol FileOutputModelDelegate <NSObject>

/**
 刷新闪光灯状态

 @param state 闪光灯状态
 */
- (void)updateCameraFlashState:(FileCameraFlashState)state;

/**
 刷新录制进度

 @param progress 视频录制进度
 */
- (void)updateRecordingProgress:(CGFloat)progress;

/**
 刷新视频录制状态

 @param recordState 视频录制状态
 */
- (void)updateRecordState:(FileRecordState)recordState;

@end

@interface FileOutputModel : NSObject
@property (nonatomic, weak  ) id<FileOutputModelDelegate>delegate;
@property (nonatomic, assign) FileRecordState recordState;
@property (nonatomic, strong, readonly) NSURL *videoUrl;


/**
 初始化 FileOutputModel

 @param type 视频界面类型
 @param superView 父视图
 @return FileOutputModel
 */
- (instancetype)initWithFileVideoViewType:(FileVideoViewType )type superView:(UIView *)superView;

/**
 转换相机
 */
- (void)turnCameraAction;

/**
 转换闪光灯
 */
- (void)controlCameraFlash;

/**
 开始录制
 */
- (void)startFileRecordVideo;

/**
 停止录制
 */
- (void)stopFileRecordVideo;

/**
 重设录制配置
 */
- (void)resetFileRecordVideo;
@end

