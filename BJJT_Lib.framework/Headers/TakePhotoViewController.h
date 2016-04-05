//
//  TakePhotoViewController.h
//  TestPhotocaputure
//
//  Created by 张博林 on 15/12/21.
//  Copyright © 2015年 张博林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol TakePhotoViewControllerDelegate <NSObject>

-(void)takeTheCamera:(UIImage *)image;

@end

@interface TakePhotoViewController : UIViewController

@property (nonatomic,strong)UIImage *imageFromLast; //从上个页面得到的image
@property (nonatomic,copy) NSString *stringFromLast; //从上个页面得到的string

@property (nonatomic, strong)       AVCaptureSession            * session;
//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong)       AVCaptureDeviceInput        * videoInput;
//AVCaptureDeviceInput对象是输入流
@property (nonatomic, strong)       AVCaptureStillImageOutput   * stillImageOutput;
//照片输出流对象，当然我的照相机只有拍照功能，所以只需要这个对象就够了
@property (nonatomic, strong)       AVCaptureVideoPreviewLayer  * previewLayer;
//是否隐藏warnLabel2  默认隐藏  1、不隐藏
@property (nonatomic, copy)NSString *hidesWarnLabel2;
//是否隐藏staticView  默认不隐藏  1、隐藏
@property (nonatomic, copy)NSString *hidesStaticView;

@property (nonatomic,assign) NSInteger photoType;

@property (copy, nonatomic) NSString *currntMark;  //判断是否从即时通讯进来的

@property (weak, nonatomic) IBOutlet UIView *cameraShowView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *autoButton;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel2;


@property (nonatomic, assign) id<TakePhotoViewControllerDelegate>delegate;
@end
