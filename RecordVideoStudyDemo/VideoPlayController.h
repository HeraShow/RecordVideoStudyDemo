//
//  VideoPlayController.h
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPlayController : UIViewController

@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, assign) BOOL imgSave;
@property (nonatomic, assign) NSInteger typeNum;

@end
