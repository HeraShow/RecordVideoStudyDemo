//
//  AppSystemService.m
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import "AppSystemService.h"

@implementation AppSystemService
+ (void)phoneCallWithPhoneNum:(NSString *)phoneNum{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNum]]options:@{} completionHandler:nil];
}

+ (void)phoneCallWithPhoneNum:(NSString *)phoneNum alertView:(UIView *)alertView {
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNum]]]];
    [alertView addSubview:callWebview];
}

+ (void)appCommentsWithAppId:(NSString *)appId{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" stringByAppendingString:appId]]options:@{} completionHandler:nil];
}

+ (void)emailSendWithEmailAddress:(NSString *)emailAddress{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"mailto://" stringByAppendingString:emailAddress]]options:@{} completionHandler:nil];
}

+ (NSString *)appVersion {
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (UIImage *)launchImage {
    
    UIImage               *lauchImage      = nil;
    NSString              *viewOrientation = nil;
    CGSize                 viewSize        = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation orientation     = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        
        viewOrientation = @"Landscape";
        
    } else {
        
        viewOrientation = @"Portrait";
    }
    
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary) {
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    return lauchImage;
}

@end
