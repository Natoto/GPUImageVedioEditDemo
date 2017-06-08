//
//  PPCaptureVedioSaveModel.h
//  VedioFilterDemo
//
//  Created by boob on 2017/5/24.
//  Copyright © 2017年 YY.COM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>

@interface PPCaptureVedioSaveModel : NSObject

-(instancetype)initWithCamera:(GPUImageVideoCamera *)camera;

@property (nonatomic,retain) GPUImageOutput<GPUImageInput> *filter;;

- (void)start_stop:(UIButton *)movieButton;
@end
