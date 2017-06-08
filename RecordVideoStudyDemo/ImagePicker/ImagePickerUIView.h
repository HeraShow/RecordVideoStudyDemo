//
//  ImagePickerUIView.h
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/26.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ImagePickerUIView : UIView

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UILabel *timelabel;
@property (nonatomic, assign) CGFloat recordTime;
@end
