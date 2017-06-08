//
//  VedioElementViewController.m
//  VedioFilterDemo
//
//  Created by boob on 2017/6/4.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import "VedioElementViewController.h"
#import <GPUImage/GPUImage.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <PPSliderCaptureView/PPVideoWaterMarkModel.h>
#import <PPSliderCaptureView/PPVideoPlayerViewController.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface VedioElementViewController ()<PPVideoWaterMarkModelDelegate>
{
    GPUImageOutput<GPUImageInput> *filter;
    
    
//    GPUImageView * vwVideo;
//    GPUImageMovie * movieFile;
//    GPUImageBrightnessFilter * filter;
//    GPUImageAlphaBlendFilter *blendFilter;
}
@property (nonatomic, strong) GPUImageView *filterView ;
@property (nonatomic, strong) GPUImageMovieWriter * movieWriter;
@property (nonatomic, strong) GPUImageMovie *movieFile;

@property (nonatomic, strong) GPUImageUIElement * uiElementInput;

@property (nonatomic, strong) NSString * sbxvideoPath;

@property (nonatomic, strong) PPVideoWaterMarkModel * model;

@end

@implementation VedioElementViewController

-(void)PPVideoWaterMarkModel:(PPVideoWaterMarkModel *)model uielementupdate:(UIView *)subview progress:(CGFloat)progress{
    
    {
        [subview.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            if (0 == idx) {
                CGRect frame = view.frame;
                frame.origin.x -=10;
                view.frame = frame;
            }
            else{
                CGRect frame = view.frame;
                frame.origin.x -= arc4random()%20;
                frame.origin.y -= arc4random()%20;
                frame.size.width +=1;
                frame.size.height +=1;
                view.frame = frame;
                view.alpha = 1 - progress;
            }
        }];
        
     }
    
}

-(PPVideoWaterMarkModel *)model{
    if (!_model) {
        _model = [PPVideoWaterMarkModel new];
        _model.delegate = self;
    }
    return _model;
}
- (IBAction)playorginvideo:(id)sender {
    
    PPVideoPlayerViewController * ctr = [PPVideoPlayerViewController new];
    ctr.videoPath = self.videoPath;
    [self.navigationController pushViewController:ctr animated:YES];

}
- (IBAction)playwatervedio:(id)sender {
    NSLog(@"%@",self.sbxvideoPath);
    PPVideoPlayerViewController * ctr = [PPVideoPlayerViewController new];
    ctr.videoPath = self.sbxvideoPath;
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview: self.filterView];
    [self.view sendSubviewToBack:self.filterView];
    
    NSString * path;
    if (!self.videoPath) {
        path = [[NSBundle mainBundle] pathForResource:@"abc" ofType:@"mp4"];
        self.videoPath = path;
    }
    else{
        path = self.videoPath;
    }
    NSURL *sampleURL = [NSURL fileURLWithPath:path];
    AVAsset *asset = [AVAsset assetWithURL:sampleURL];
    //    CGSize size = self.view.bounds.size;
    CGSize size = asset.naturalSize;
    UIView * subview = [self creatsubview:size];
    
    //TODO:添加水印的方法
         __weak typeof(self) weakself = self;
    self.sbxvideoPath = [self.model MixVideoPathWithVedioUrl:sampleURL
    subView:subview
    fromFilterView:self.filterView
    progress:^(CGFloat progress) {
        [SVProgressHUD showProgress:progress status:@"水印合成中.."];
        NSLog(@"---->progress: %f",progress);
    }
     complete:^(NSURL *savepath) {
        [weakself.model saveToAblum:^(NSURL *assetURL) {
            [SVProgressHUD dismiss];
            [weakself showmsg:assetURL.absoluteString];
        }];
    }];
    //[self MixVideoWit hText:sampleURL  subView:subview];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savetap:)];
}

-(IBAction)savetap:(id)sender
{
    [self.model saveToAblum:^(NSURL * url) {
        [self showmsg:url.relativeString];
    }];
}

-(void)showmsg:(NSString *)url{
    if (!url) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存成功" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)save_to_photosAlbum:(NSString *)pathToMovie
{
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie))
    {
        [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:pathToMovie] completionBlock:^(NSURL *assetURL, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{ 
                 [self showmsg:assetURL.relativePath];
             });
         }];
    }
    else {
        NSLog(@"error mssg)");
    }
}

-(UIView *)creatsubview:(CGSize)size{
    
    // 水印
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    label.text = @"HELLO,我是水印,我是水影，我是水英，我是水银~~~";
    label.font = [UIFont systemFontOfSize:60];
    label.textColor = [UIColor redColor];
    label.center = CGPointMake(size.width/2, size.height/2);
    [label sizeToFit];
    //    label.transform = CGAffineTransformMakeRotation(M_PI/2.);
    
    UIImage *image = [UIImage imageNamed:@"watermark.png"];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//    subView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    
    [subView addSubview:label];
    for (int index = 0; index<2; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(size.width-20, size.height-20);
        [subView addSubview:imageView];
    }
    subView.opaque = NO;
    return subView;
    
}


- (void)updateProgress
{
}

// 视频保存回调
- (void)video:(NSString *)sbxvideoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
    
}


 -(void)savetolocal{
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
