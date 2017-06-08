//
//  AppSystemService.h
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppSystemService : NSObject

/**
 拨打电话号码

 @param phoneNum 电话号码
 */
+ (void)phoneCallWithPhoneNum:(NSString *)phoneNum;

/**
 询问是否拨打电话

 @param phoneNum 电话号码
 @param alertView 提示框
 */
+ (void)phoneCallWithPhoneNum:(NSString *)phoneNum alertView:(UIView *)alertView;

/**
 跳转至App评论页

 @param appId App的ID号
 */
+ (void)appCommentsWithAppId:(NSString *)appId;

/**
 发送邮件

 @param emailAddress 邮箱号
 */
+ (void)emailSendWithEmailAddress:(NSString *)emailAddress;

/**
 获取App的版本信息

 @return App的版本信息
 */
+ (NSString *)appVersion;


/**
 获取App启动图片

 @return App启动图片
 */
+ (UIImage *)launchImage;

@end
