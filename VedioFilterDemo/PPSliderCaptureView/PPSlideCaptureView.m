//
//  PPSlideCaptureView.m
//  VedioFilterDemo
//
//  Created by boob on 2017/5/24.
//  Copyright © 2017年 YY.COM. All rights reserved.
//


#import "LMCameraFilters.h"
#import "PPSlideCaptureView.h"

@interface PPSlideCaptureView()
{
    CGPoint beginpoint;
    BOOL isdraging;
}

@property (retain, nonatomic)  GPUImageView *mainfilterView;
@property (retain, nonatomic)  GPUImageView *filter2View;

@property (nonatomic, strong)  UIImageView * maskview;

@property (nonatomic, strong) NSArray<GPUImageFilterGroup *> * ftgroups;


@end

@implementation PPSlideCaptureView

-(void)dealloc{
    NSLog(@"%s",__func__);
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createsubviews];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self createsubviews];
}

-(void)createsubviews{
    
    UIImageView * imageview2 = [[UIImageView alloc] init];
    imageview2.backgroundColor = [UIColor whiteColor];
    imageview2.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
    self.filter2View.maskView = imageview2;
    self.maskview = imageview2;
    
    [self.ftgroups enumerateObjectsUsingBlock:^(GPUImageFilterGroup * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.camera addTarget:obj];
    }];
    
    GPUImageFilterGroup *f1 = self.ftgroups[0];//[LMCameraFilters sketch];
    
    [f1 addTarget:self.mainfilterView];
    self.currentIndex = 0;
    
    GPUImageFilterGroup *f2 = self.ftgroups[1]; //[LMCameraFilters contrast];
    [f2 addTarget:self.filter2View];
    self.maskIndex = 1;
    
}


-(GPUImageView *)mainfilterView{
    if (!_mainfilterView) {
        _mainfilterView = [[GPUImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_mainfilterView];
    }
    return _mainfilterView;
}

-(GPUImageView *)filter2View{
    if (!_filter2View) {
        _filter2View = [[GPUImageView alloc] initWithFrame:self.mainfilterView.bounds];
        [self.mainfilterView addSubview:_filter2View];
    }
    return _filter2View;
}

/**
 * 当前滤镜
 */
-(GPUImageFilterGroup *)currentGroup{
    return self.ftgroups[_currentIndex];
}

//更新maskview滤镜
- (void)updateMaskFilterAtIndex:(NSInteger)index {
    
    NSLog(@"%s %d",__func__,index);
    GPUImageFilterGroup * oldf2 = self.ftgroups[self.maskIndex];
    [oldf2 removeTarget:self.filter2View];
    
    GPUImageFilterGroup * f2 = self.ftgroups[index];
    [f2 addTarget:self.filter2View];
    self.maskIndex = index;
    
}
//本身
- (void)updateFilterAtIndex:(NSInteger)index {
    
    NSLog(@"%s %d",__func__,index);
    [self.currentGroup removeTarget:self.mainfilterView];
    GPUImageFilterGroup *filter = self.ftgroups[index];
    [filter addTarget:self.mainfilterView];
    _currentIndex = index;
    
}

-(NSArray<GPUImageFilterGroup *> *)ftgroups{
    if (!_ftgroups) {
        GPUImageFilterGroup *f1 = [LMCameraFilters sketch];
        GPUImageFilterGroup *f2 = [LMCameraFilters saturation];
        GPUImageFilterGroup *f3 = [LMCameraFilters exposure];
        GPUImageFilterGroup *f4 = [LMCameraFilters normal];
        _ftgroups = @[f1,f2,f3,f4];
    }
    return _ftgroups;
}


-(void)nextfliter:(NSInteger)idx{
    
    NSLog(@"%s %d",__func__,idx);
    NSInteger nextidx = [self nextindex:idx];
    //    [self updateMaskFilterAtIndex:[self nextindex:nextidx]];
    [self updateFilterAtIndex:nextidx];
    
}

-(void)lastfilter:(NSInteger)idx{
    
    NSLog(@"%s %d",__func__,idx);
    NSInteger lastidx = [self lastindex:idx];
    [self updateFilterAtIndex:lastidx];
    //    [self updateMaskFilterAtIndex:[self lastindex:lastidx]];
}
-(NSInteger)lastindex:(NSInteger)idx{
    return  (idx-1)<0?(self.ftgroups.count - 1):(idx-1);
}

-(NSInteger)nextindex:(NSInteger)idx{
    return  (idx+1)>(self.ftgroups.count-1)?(0):(idx+1);
}

-(void)movemaskviewfromLeft:(BOOL)isfromLeft isToRight:(BOOL)istoRight{
    
    NSLog(@"isfromleft:%d istoright:%d",isfromLeft,istoRight);
    if (isfromLeft) {
        
        [UIView animateWithDuration:0.5 animations:^{
            if (istoRight) {
                self.maskview.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            }
            else{
                self.maskview.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
            }
        } completion:^(BOOL finished) {
            if (isfromLeft && istoRight) {
                [self lastfilter:self.currentIndex];
                //                self.maskview.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
            }
        }];
    }
    else{
        
        [UIView animateWithDuration:0.5 animations:^{
            if (istoRight) {
                self.maskview.frame = CGRectMake(self.bounds.size.width, 0, 0, self.bounds.size.height);
            }
            else{
                self.maskview.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            }
        } completion:^(BOOL finished) {
            if (!isfromLeft && !istoRight) {
                [self nextfliter:self.currentIndex];
                //                self.maskview.frame = CGRectMake(self.bounds.size.width, 0, 0, self.bounds.size.height);
            }
        }];
    }
}


#pragma mark - 手势

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    CGFloat offsetx = touchPoint.x - beginpoint.x;
    CGFloat absoffsetx = fabs(offsetx);
    //    NSLog(@"%f",offsetx);
    
    if (isdraging == NO) {
        if (absoffsetx > 5) {
            isdraging = YES;
            if (offsetx<0) {//向左滑动
                [self updateMaskFilterAtIndex:[self nextindex:self.currentIndex]];
            }
            else{
                [self updateMaskFilterAtIndex:[self lastindex:self.currentIndex]];
            }
        }
        else{
            NSLog(@"无效滑动....");
        }
        
    }
    else{
        if (offsetx > 0) {//向左走
            self.maskview.frame = CGRectMake(0, 0,  absoffsetx, self.bounds.size.height);
            NSLog(@">>>>>");
        }else{
            self.maskview.frame = CGRectMake(self.bounds.size.width  - absoffsetx, 0,  absoffsetx, self.bounds.size.height);
            //        NSLog(@"<<<<");
        }
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    beginpoint = touchPoint;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    CGFloat offsetx = touchPoint.x - beginpoint.x ;
    
    NSLog(@"%f",offsetx);
    
    CGFloat criticalwidth = 100;
    isdraging = NO;
    if (offsetx>0) {//从左向右滑动
        if (offsetx > criticalwidth) {//向右滑动
            [self movemaskviewfromLeft:YES isToRight:YES];
        }
        else{
            [self movemaskviewfromLeft:YES isToRight:NO];
        }
    }
    else{//从右向左滑动
        
        if (fabs(offsetx) < criticalwidth) {
            [self movemaskviewfromLeft:NO isToRight:YES];
        }
        else{
            [self movemaskviewfromLeft:NO isToRight:NO];
        }
    }
    
}


#pragma mark - setter getter 

-(GPUImageVideoCamera *)camera{
    if (!_camera) {
        GPUImageVideoCamera * camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
        camera.outputImageOrientation = UIInterfaceOrientationPortrait;
        camera.horizontallyMirrorFrontFacingCamera = NO;
        camera.horizontallyMirrorRearFacingCamera = NO;
        _camera = camera;
    }
    return _camera;
}


@end
