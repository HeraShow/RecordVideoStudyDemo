//
//  AVAssetWriterManager.h
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/**
  录制视频的状态

 - RecordVideoStateInit: 视频录制初始化
 - RecordVideoStatePreRecoring: 视频录制前
 - RecordVideoStateRecoring: 视频录制中
 - RecordVideoStateStop: 视频录制暂停
 - RecordVideoStateFinish: 视频录制完成
 - RecordVideoStateFaile: 视频录制失败
 */
typedef NS_ENUM(NSInteger, RecordVideoState) {
    RecordVideoStateInit,
    RecordVideoStatePreRecoring,
    RecordVideoStateRecording,
    RecordVideoStatePause,
    RecordVideoStateFinish,
    RecordVideoStateFaile
};

/**
 录制视频的长宽比

 - RecordView1x1: 长宽比例1:1
 - RecordView4x3: 长宽比例4:3
 - RecordView6x9: 长宽比例6:9
 - RecordViewFull: 与手机同等长宽
 */
typedef NS_ENUM(NSInteger, RecordViewSizeType) {
    RecordView1x1,
    RecordView3x4,
    RecordView4x3,
    RecordViewFull
};

@protocol AVAssetWriterManagerDelegate <NSObject>

/**
 完成视频录制数据写入文件
 */
- (void)finishAssetWriering;

/**
 更新视频录制写入进度

 @param progress 视频录制数据写入进度
 */
- (void)updateAssetWriterProgress:(CGFloat)progress;


@end

@interface AVAssetWriterManager : NSObject

@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputVideoFormatDescription;
@property (nonatomic, retain) __attribute__((NSObject)) CMFormatDescriptionRef outputAudioFormatDescription;

@property (nonatomic, assign) RecordVideoState writeState;
@property (nonatomic, weak) id<AVAssetWriterManagerDelegate> delegate;


/**
  初始化 AVAssetWriterManager

 @param url  录制的视频的url
 @param sizeType 视频画面尺寸的类型
 @return AVAssetWriterManager
 */
- (id)initWithURL:(NSURL *)url sizeType:(RecordViewSizeType)sizeType;

/**
 开始写入
 */
- (void)startWriteManager;

/**
 停止写入
 */
- (void)stopWriteManager;

/**
 拼接数据流

 @param sampleBuffer 数据流
 @param mediaType 数据类型
 */
- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer ofMediaType:(NSString *)mediaType;

/**
 销毁相关参数和设置
 */
- (void)destroyWrite;

@end
