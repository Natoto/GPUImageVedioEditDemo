//
//  ViewController.m
//  VedioFilterDemo
//
//  Created by boob on 2017/5/24.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage/GPUImage.h>
#import "PPCameraFilters.h"
#import "IF1977Filter.h"

#import "FeSlideViewController.h"

@interface ViewController ()
{
    NSString *pathToMovie;
    
}
@property (weak, nonatomic) IBOutlet GPUImageView *filterView;
@property (weak, nonatomic) IBOutlet GPUImageView *filter2View;
@property (weak, nonatomic) IBOutlet UIButton *movieButton;

@property (nonatomic,retain) GPUImageMovieWriter *writer;
@property (nonatomic,retain) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic,retain) GPUImageVideoCamera *camera;

@property (nonatomic, strong) GPUImageFilterGroup * filterGroup1;
@property (nonatomic, strong) GPUImageFilterGroup * filterGroup2;


@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    test(1, 3);
    
    self.camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.camera.horizontallyMirrorFrontFacingCamera = NO;
    self.camera.horizontallyMirrorRearFacingCamera = NO;
    
    
    
    GPUImageFilterGroup *f1 = [[IF1977Filter alloc] init];
    //[PPCameraFilters sketch];
    
    [self.camera addTarget:f1];
    [f1 addTarget:self.filterView];
    
    
    GPUImageFilterGroup *f2 = [PPCameraFilters contrast];
    [self.camera addTarget:f2];
    [f2 addTarget:self.filter2View];
    
    self.filter = f1;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.camera startCameraCapture];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.camera stopCameraCapture];
}
- (IBAction)buttonTap:(id)sender {
    [self start_stop];
}
- (IBAction)avfoundationTap:(id)sender {
}



#pragma mark 选择滤镜
-(void)choose_callBack:(GPUImageOutput<GPUImageInput> *)filter
{
    BOOL isSelected = self.movieButton.isSelected;
    if (isSelected) {
        return;
    }
    self.filter = filter;
    [self.camera removeAllTargets];
    [self.camera addTarget:_filter];
    
    [_filter addTarget:_filterView];
}

- (void)start_stop
{
    BOOL isSelected = self.movieButton.isSelected;
    [self.movieButton setSelected:!isSelected];
    if (isSelected) {
        [self.filter removeTarget:self.writer];
        self.camera.audioEncodingTarget = nil;
        [self.writer finishRecording];
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"是否保存到相册" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        [alertview show];
    }else{
        NSString *fileName = [@"Documents/" stringByAppendingFormat:@"Movie%d.m4v",(int)[[NSDate date] timeIntervalSince1970]];
        pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
        
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        self.writer = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:[UIScreen mainScreen].bounds.size];
        [self.filter addTarget:self.writer];
        self.camera.audioEncodingTarget = self.writer;
        [self.writer startRecording];
        
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"baocun");
        [self save_to_photosAlbum:pathToMovie];
    }
}
-(void)save_to_photosAlbum:(NSString *)path
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
            
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    });
}

// 视频保存回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
