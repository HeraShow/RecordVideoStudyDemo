//
//  ImagePickerViewController.h
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerViewController : UIImagePickerController
//  基于 UIImagePickerController 来实现 系统摄像

@property (nonatomic, assign) BOOL isCustom;
@property (nonatomic, strong) id viewVc;

@end
