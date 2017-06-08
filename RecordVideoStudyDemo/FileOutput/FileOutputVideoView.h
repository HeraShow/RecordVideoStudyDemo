//
//  FileOutputVideoView.h
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/26.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileOutputModel.h"
@protocol FileOutputVideoViewDelegate <NSObject>

/**
 FileOutputVideoView 消失
 */
- (void)fileOutputVideoViewDismiss;

/**
 完成视频录制

 @param videoUrl 视频录制的url
 */
- (void)finshedRecordVideoWithVideoUrl:(NSURL *)videoUrl;

@end

@interface FileOutputVideoView : UIView
@property (nonatomic, assign) FileVideoViewType viewType;
@property (nonatomic, strong) FileOutputModel *fileModel;
@property (nonatomic, weak) id<FileOutputVideoViewDelegate> delegate;


/**
 初始化 FileOutputVideoView

 @param type 视频界面的类型
 @return FileOutputVideoView
 */
- (instancetype)initWithFileVideoViewType:(FileVideoViewType)type;


/**
 重置 FileOutputVideoView
 */
- (void)resetFileOutputVideoView;
@end
