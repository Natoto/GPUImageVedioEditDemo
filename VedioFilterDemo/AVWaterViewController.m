

//
//  AVWaterViewController.m
//  VedioFilterDemo
//
//  Created by boob on 2017/6/8.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import "AVWaterViewController.h"
#import <PPSliderCaptureView/PPVideoWaterMarkModel.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <PPSliderCaptureView/PPVideoPlayerViewController.h>
#import <AVFoundation/AVFoundation.h>

@interface AVWaterViewController ()

@property (nonatomic, strong) PPVideoWaterMarkModel * model;

@end

@implementation AVWaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL * url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"abc" ofType:@"mp4"]];
    
    [SVProgressHUD show];
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:url options:nil];
    CGSize sizeOfVideo=[videoAsset naturalSize];
    [self.model av_createWatermark:[self createtextlayer:sizeOfVideo] video:url complete:^(NSURL *savepath) {
        NSLog(@"savepath: %@",savepath.relativePath);
        
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PPVideoPlayerViewController *ctr = [PPVideoPlayerViewController new];
            ctr.videoPath = savepath.relativePath;
            [self.navigationController pushViewController:ctr animated:YES];
        });
        
    }];
}
-(CATextLayer *)createtextlayer:(CGSize)sizeOfVideo{
 
       CATextLayer *textOfvideo = [[CATextLayer alloc] init];
        textOfvideo.string=@"text is shows the text that you want aext is shows the text that you want add in video.";
        textOfvideo.fontSize = 60;
        [textOfvideo setFrame:CGRectMake(0, 0, sizeOfVideo.width, sizeOfVideo.height/6)];
        textOfvideo.shadowOpacity = 1;
        [textOfvideo setAlignmentMode:kCAAlignmentCenter];
        [textOfvideo setForegroundColor:[[UIColor redColor] CGColor]];
    
    
    return textOfvideo;
}
-(PPVideoWaterMarkModel *)model{
    if (!_model) {
        _model = [PPVideoWaterMarkModel new];
    }
    return _model;
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
