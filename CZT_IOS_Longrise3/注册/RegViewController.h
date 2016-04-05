//
//  RegViewController.h
//  CZT_IOS_Longrise
//
//  Created by 程三 on 15/12/1.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "PublicViewController.h"
#import <BJJT_Lib/FVCustomAlertView.h>
#import "DESCript.h"
#import <BJJT_Lib/ImgCodeView.h>

@class RegViewController;
@protocol RegViewControllerDelegate <NSObject>

@optional

-(void)regViewControllerClose:(RegViewController *)viewController sucess:(BOOL)b;

@end

@interface RegViewController : PublicViewController<UITextFieldDelegate,ImgCodeViewDelegate>
{
    NSString *userNameStr;
    NSString *phoneNumStr;
    NSString *verificationCodeStr;
    NSString *passWordTextStr;
    NSString *againPasswordTextStr;
    
    NSString *imgCodeViewId; //图片验证码id
    
    //是否同意协议
    BOOL isAgree;
    //定时器
    NSTimer *timer;
    int count;
    
    UITextField *tempField;
    // 是否注册成功
    BOOL isRegSucess;
    
}

@property(nonatomic,weak) id<RegViewControllerDelegate> regViewControllerDelegate;
//用户名
@property (weak, nonatomic) IBOutlet UITextField *userName;
//电话
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
//图片验证码
@property (weak, nonatomic) IBOutlet UITextField *imgCodeText;

//获取图片验证码背景View
@property (weak, nonatomic) IBOutlet UIView *backImgCodeView;

//验证码
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;
//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
//确认密码
@property (weak, nonatomic) IBOutlet UITextField *againPasswordText;
//同意协议
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
//确认
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
//剩余时间
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;

@end
