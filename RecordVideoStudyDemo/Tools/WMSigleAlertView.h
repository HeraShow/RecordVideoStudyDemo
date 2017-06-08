//
//  WMCartAlertView.h
//  Wemart
//
//  Created by 冯文秀 on 16/8/26.
//  Copyright © 2016年 冯文秀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMSigleAlertView : NSObject

/**
 简易提示弹框

 @param title 提示内容
 @param bgView 显示父视图
 */
- (void)showAlertViewTitle:(NSString *)title bgView:(UIView *)bgView;
@end
