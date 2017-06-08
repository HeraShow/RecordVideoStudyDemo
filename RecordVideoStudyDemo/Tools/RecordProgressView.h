//
//  RecordProgressView.h
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface RecordProgressView : UIView

/**
 刷新进度值

 @param progress 进度至
 */
- (void)updateProgressWithValue:(CGFloat)progress;

/**
 重置进度
 */
- (void)resetProgress;

@end
