//
//  PPSlideCaptureView.h
//  VedioFilterDemo
//
//  Created by boob on 2017/5/24.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>

@interface PPSlideCaptureView : UIView

@property (nonatomic, strong) GPUImageVideoCamera * camera;

/**
 * 当前滤镜
 */
@property (nonatomic , strong,readonly) GPUImageFilterGroup *currentGroup;

@property (nonatomic, assign) NSInteger   currentIndex;

@property (nonatomic, assign) NSInteger   maskIndex;

@end
