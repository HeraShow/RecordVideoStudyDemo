//
//  AssetWriterViewController.m
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import "AssetWriterViewController.h"
#import "AssetRecordVideoView.h"

@interface AssetWriterViewController ()<AssetRecordVideoViewDelegate>
@property (nonatomic, strong) AssetRecordVideoView *recordVideoView;
@end

@implementation AssetWriterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;

    self.recordVideoView = [[AssetRecordVideoView alloc]initWithRecordVideoViewSizeType:RecordView1x1];
    self.recordVideoView.delegate = self;

    [self.view addSubview:_recordVideoView];
    self.view.backgroundColor = [UIColor blackColor];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_recordVideoView.assetWriterModel.videoState == RecordVideoStateFinish) {
        [_recordVideoView.assetWriterModel recordVideoReset];
    }
}

- (void)recordVideoViewDismiss{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)finshedRecordVideoWithVideoUrl:(NSURL *)videoUrl{
    NSLog(@"videoUrl ----- %@", videoUrl);
    VideoPlayController *videoVc = [[VideoPlayController alloc]init];
    videoVc.videoUrl = videoUrl;
    videoVc.typeNum = 0;
    [self presentViewController:videoVc animated:YES completion:nil];
}


- (void)leftBarButtonAction{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
