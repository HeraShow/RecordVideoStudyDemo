//
//  ImagePickerUIView.m
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/26.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import "ImagePickerUIView.h"

@implementation ImagePickerUIView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutImgPickerRecordVideoView];

        self.backgroundColor = COLORRGB(0, 0, 0, 0.5);
        
        self.startButton = [[UIButton alloc]initWithFrame:CGRectMake(KSCREENWIDTH - 96, 11, 66, 28)];
        [self.startButton setTitle:@"start" forState:UIControlStateNormal];
        [self.startButton setTitle:@"stop" forState:UIControlStateSelected];
        [self addSubview:_startButton];
        
        
        self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(35, 11, 60, 28)];
        [self.backButton setTitle:@"back" forState:UIControlStateNormal];
        [self addSubview:_backButton];
        
        
        self.timeView = [[UIView alloc] init];
        self.timeView.hidden = YES;
        self.timeView.frame = CGRectMake(102 + (KSCREENWIDTH - 304)/2, 8, 100, 34);
        self.timeView.backgroundColor = [UIColor colorWithRGB:0x242424 alpha:0.7];
        self.timeView.layer.cornerRadius = 4;
        self.timeView.layer.masksToBounds = YES;
        [self addSubview:self.timeView];
        
        
        UIView *redPoint = [[UIView alloc] init];
        redPoint.frame = CGRectMake(0, 0, 6, 6);
        redPoint.layer.cornerRadius = 3;
        redPoint.layer.masksToBounds = YES;
        redPoint.center = CGPointMake(25, 17);
        redPoint.backgroundColor = [UIColor redColor];
        [self.timeView addSubview:redPoint];
        
        self.timelabel =[[UILabel alloc] init];
        self.timelabel.font = [UIFont systemFontOfSize:13];
        self.timelabel.textColor = [UIColor whiteColor];
        self.timelabel.frame = CGRectMake(40, 8, 40, 28);
        [self.timeView addSubview:self.timelabel];

    }
    return self;
}

- (void)layoutImgPickerRecordVideoView{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
