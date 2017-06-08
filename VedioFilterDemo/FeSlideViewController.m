//
//  FeSlideViewController.m
//  VedioFilterDemo
//
//  Created by boob on 2017/5/24.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import "FeSlideViewController.h"
#import <FeSlideFilterView/FeSlideFilterView.h>
#import <GPUImage/GPUImage.h>
#import "PPCameraFilters.h"
#import "PPCaptureVedioSaveModel.h"
#import "PPSlideCaptureView.h"
#import "PPCircleProcessView.h"
#import "PPVideoPlayerViewController.h"
#import "VedioElementViewController.h"
#import <PPSliderCaptureView/PPVideoWaterMarkModel.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface FeSlideViewController ()<PPSlideCaptureViewDelegate>

@property (nonatomic, strong) PPCaptureVedioSaveModel * model;

@property (weak,nonatomic) IBOutlet PPSlideCaptureView * captureView;
@property (weak, nonatomic) IBOutlet UIButton *btnCapture;
@property (nonatomic, strong) PPCircleProcessView * circleView;

@property (nonatomic, strong) NSArray * fsv_ftgroups;

@property (nonatomic, strong) PPVideoWaterMarkModel * watermodel;
@end


int test(int a,int b){
    
    NSLog(@"%s",__func__);
    printf("%s a:%d b:%d",__func__,a,b);
    return a+b;
}

@implementation FeSlideViewController
-(PPVideoWaterMarkModel *)watermodel{
    if (!_watermodel) {
        _watermodel = [PPVideoWaterMarkModel new];
    }
    return _watermodel;
}
-(PPCaptureVedioSaveModel *)model{
    if (!_model) {
        _model = [[PPCaptureVedioSaveModel alloc] initWithCamera:self.captureView.stillCamera vedioImageView:self.captureView.vidioImageView];
    }
    return _model;
}


- (void)viewDidLoad {

    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.captureView.stillCamera startCameraCapture];
    self.captureView.delegate = self;
    [self.view bringSubviewToFront: self.btnCapture];

    //TODO:去视频编辑处理界面
    __weak FeSlideViewController * weakself = self;
    self.model.captureblock = ^(PPCAPTURE_STATE state){
        if (state == PPCAPTURE_STATE_END) {
         
            VedioElementViewController * ctr =
            [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PPVideoPlayerViewController"]; // [[VedioElementViewController alloc] init];
            ctr.videoPath = weakself.model.videoPath;
            [weakself.navigationController pushViewController:ctr animated:YES];
              
        }
    };
    
    [self.view addSubview:self.circleView];
}
 
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
}

-(NSArray<GPUImageFilterGroup *> *)ftgroupsOfslideCaptureView:(PPSlideCaptureView *)captureView{

    if (!_fsv_ftgroups) { 
        GPUImageFilterGroup *f6 = [PPCameraFilters normal];
        GPUImageFilterGroup *f1 = [PPCameraFilters shiguang];
        GPUImageFilterGroup *f2 = [PPCameraFilters shaolv];
        GPUImageFilterGroup *f3 = [PPCameraFilters yese];
        GPUImageFilterGroup *f4 = [PPCameraFilters heibai];
        _fsv_ftgroups = @[f6,f1,f2,f3,f4];
    }
    return _fsv_ftgroups;
}

/**
 * 点击
 */
- (void)circleViewTapTouch:(UILongPressGestureRecognizer *)longGesture
{
    __weak typeof(self) weakself = self;
    [self.captureView.stillCamera capturePhotoAsImageProcessedUpToFilter:self.captureView.currentGroup withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        PPVideoPlayerViewController * ctr = [[PPVideoPlayerViewController alloc] init];
        ctr.image = processedImage;
        [weakself.navigationController pushViewController:ctr animated:NO];
        
    }];
}
//拍视频按钮点击
- (void)circleViewLongTouch:(UILongPressGestureRecognizer *)longGesture
{
    self.model.filter = self.captureView.currentGroup;
    if(longGesture.state == UIGestureRecognizerStateBegan)
    {
        [self.circleView startAnimation];
        [self.model start_stop:NO];
    }
    else if (longGesture.state == UIGestureRecognizerStateEnded)
    {
       [self.model start_stop:YES];
        [self.circleView stopAnimation];
    }
}


- (PPCircleProcessView *)circleView
{
//capturePhotoProcessedUpToFilter:filter
    if(_circleView == nil)
    {
        _circleView = [[PPCircleProcessView alloc]initWithMaxTime:15 circleSize:CGSizeMake(80, 80) callBackCurrentProcessTime:^(NSInteger current) {
            
        }];
        _circleView.frame = CGRectMake(0, 0, 80, 80);
        _circleView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2., self.view.bounds.size.height - 100);
        [_circleView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(circleViewLongTouch:)]];
        [_circleView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(circleViewTapTouch:)]];
    }
    return _circleView;
}

- (IBAction)btnCaptureTap:(UIButton *)sender {
    
    self.model.filter = self.captureView.currentGroup;
    [self.model start_stop:sender.selected];
    sender.selected = !sender.selected;
    
}

-(UIView *)creatsubview:(CGSize)size{
    
    // 水印
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    label.text = @"HELLO,我是水印";
    label.font = [UIFont systemFontOfSize:30];
    label.textColor = [UIColor redColor];
    [label sizeToFit];
    //    label.transform = CGAffineTransformMakeRotation(M_PI/2.);
    
    UIImage *image = [UIImage imageNamed:@"watermark.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    //    subView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    imageView.center = CGPointMake(subView.bounds.size.width / 2, subView.bounds.size.height / 2);
    [subView addSubview:imageView];
    [subView addSubview:label];
    subView.opaque = NO;
    return subView;
}
@end


