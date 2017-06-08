//
//  FileOutputViewController.m
//  RecordVideoStudyDemo
//
//  Created by 冯文秀 on 2017/5/25.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import "FileOutputViewController.h"
#import "FileOutputVideoView.h"
@interface FileOutputViewController ()<FileOutputVideoViewDelegate>
@property (nonatomic, strong) FileOutputVideoView *videoView;
@end

@implementation FileOutputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    _videoView = [[FileOutputVideoView alloc] initWithFileVideoViewType:FileVideoTypeFullScreen];
    _videoView.delegate = self;
    [self.view addSubview:_videoView];
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_videoView.fileModel.recordState == FileRecordStateFinish) {
        [_videoView.fileModel resetFileRecordVideo];
    }
}


- (void)fileOutputVideoViewDismiss{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)finshedRecordVideoWithVideoUrl:(NSURL *)videoUrl{
    VideoPlayController *videoVc = [[VideoPlayController alloc] init];
    videoVc.videoUrl = videoUrl;
    videoVc.typeNum = 1;
    [self presentViewController:videoVc animated:YES completion:nil];
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
