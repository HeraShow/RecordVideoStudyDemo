//
//  PublicHeader.h
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#ifndef PublicHeader_h
#define PublicHeader_h
#define KSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define COLORRGB(a,b,c,d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]
#define VIEWBGCOLOR COLORRGB(240, 243, 245, 1)
#define LINECOLOR COLORRGB(195, 198, 198, 1)

#define LIGHTFONT(FontSize) [UIFont fontWithName:@"PingFangSC-Light" size:FontSize]
#define MEDIUMFONT(FontSize) [UIFont fontWithName:@"PingFangSC-Medium" size:FontSize]

#define RECORDMAXDUR 10
#define TIMER_INTERVAL 0.05         //计时器刷新频率
#define VIDEO_FOLDER @"videoFolder" //视频录制存放文件夹


#import "WMSigleAlertView.h"
#import "ZHFileManager.h"
#import "UIColor+Hex.h"
#import "VideoPlayController.h"
#import "RecordProgressView.h"

#endif /* PublicHeader_h */
