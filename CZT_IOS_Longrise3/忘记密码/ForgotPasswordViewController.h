//
//  ForgotPasswordViewController.h
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 15/12/29.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "PublicViewController.h"
#import <BJJT_Lib/ImgCodeView.h>

@interface ForgotPasswordViewController : PublicViewController<ImgCodeViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
//图片验证码
@property (weak, nonatomic) IBOutlet UITextField *imgCodeText;
//图片验证码背景view
@property (weak, nonatomic) IBOutlet UIView *backCodeView;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@property (weak, nonatomic) IBOutlet UIButton *getVerifyButton;

@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;

@property (weak, nonatomic) IBOutlet UIButton *findPasswordButton;

@property (weak, nonatomic) IBOutlet UILabel *enumNumber;


@end
