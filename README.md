

### 实时滤镜


![实时滤镜](http://7xicym.com1.z0.glb.clouddn.com/popaimg/shishilvjing3.gif)

##### 申明
```
@property (weak,nonatomic) IBOutlet PPSlideCaptureView * captureView;
```
#### 处理

```
    //TODO:拍摄完成视频去编辑处理界面
    __weak FeSlideViewController * weakself = self;
    self.model.captureblock = ^(PPCAPTURE_STATE state){
        if (state == PPCAPTURE_STATE_END) { 
            VedioElementViewController * ctr =
            [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PPVideoPlayerViewController"]; // [[VedioElementViewController alloc] init];
            ctr.videoPath = weakself.model.videoPath;
            [weakself.navigationController pushViewController:ctr animated:YES];
              
        }
    };
```

#### 拍摄按钮
```
长按拍摄，点击拍照


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


```

### 动态水印
![动态水印](http://7xicym.com1.z0.glb.clouddn.com/popaimg/shishilvjing2.gif)

```
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
```

### 保存到本地
```
    [self.model saveToAblum:^(NSURL *assetURL) {
        [self showmsg:assetURL.relativePath];
    }];
```

### 水印合成

