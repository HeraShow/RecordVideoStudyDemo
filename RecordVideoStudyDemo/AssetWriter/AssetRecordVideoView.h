//
//  AssetRecordVideoView.h
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetWriterModel.h"

@protocol AssetRecordVideoViewDelegate <NSObject>

/**
 录制视频视图消失
 */
- (void)recordVideoViewDismiss;

/**
 完成视频录制

 @param videoUrl 录制视频url
 */
- (void)finshedRecordVideoWithVideoUrl:(NSURL *)videoUrl;

@end

@interface AssetRecordVideoView : UIView
@property (nonatomic, assign) RecordViewSizeType viewSizeType;
@property (nonatomic, weak) id<AssetRecordVideoViewDelegate> delegate;
@property (nonatomic, strong) AssetWriterModel *assetWriterModel;

/**
 ZHRecordVideoView 初始化配置

 @param viewSizeType 视频画面显示比例
 @return ZHRecordVideoView
 */
- (id)initWithRecordVideoViewSizeType:(RecordViewSizeType)viewSizeType;

/**
 ZHRecordVideoView 重置
 */
- (void)recordVideoViewReset;

@end
