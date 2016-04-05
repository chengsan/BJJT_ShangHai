//
//  ForgotPasswordViewController.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 15/12/29.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "CZT_IOS_Longrise.pch"
#import "AppDelegate.h"

@interface ForgotPasswordViewController ()<UITextFieldDelegate>{
    NSTimer *timer;
    int count;
    FVCustomAlertView *alertView;
    NSString *imgCodeID;
}

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    count = 120;
    _findPasswordButton.layer.masksToBounds = YES;
    _findPasswordButton.layer.cornerRadius = 7;
    
    ImgCodeView *imgCodeView = [[ImgCodeView alloc]initWithFrame:CGRectMake(0, 0, self.backCodeView.frame.size.width,self.backCodeView.frame.size.height)];
    imgCodeView.delegate = self;
    [self.backCodeView addSubview:imgCodeView];
    
    [AppDelegate storyBoradAutoLay:self.view];
    // Do any additional setup after loading the view from its nib.
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if(nil != timer)
    {
        //关闭定时器
        [timer setFireDate:[NSDate distantFuture]];
    }
}
#pragma mark - 图片验证码代理
-(void)requestImgCodeViewID:(NSString *)imgId
{
    imgCodeID = imgId;
}

- (IBAction)getVerifyBtnClicked:(id)sender {
    
    if (!self.imgCodeText.text.length)
    {
        [self showAlertViewWith:@"图片验证码不能为空！"];
        return;
    }

    if (_phoneNumberTextField.text.length == 11) {
        alertView = [[FVCustomAlertView alloc] init];
        [alertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
        
        self.getVerifyButton.userInteractionEnabled = NO;  //点击后让获取验证码按钮用户交互关闭
        
        NSMutableDictionary *bean = [NSMutableDictionary dictionary];
        [bean setValue:_phoneNumberTextField.text forKey:@"mobilenumber"];
        [bean setValue:self.imgCodeText.text forKey:@"imgcode"];
        [bean setValue:imgCodeID forKey:@"imgid"];
        
        [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].wxBaseServiceURL ServiceName:[NSString stringWithFormat:@"%@/appgetforgetpwdcode",appbase] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
            BOOL isSucess = false;
            
            if (nil != result) {
                NSDictionary *bigDic = result;
                if ([bigDic[@"restate"]isEqualToString:@"1"]) {
                    [self showAlertViewWith:@"请耐心等待新消息的发送！"];
                    isSucess = true;
                }else{
                    
                    [self showAlertViewWith:bigDic[@"redes"]];
                }
                
            }else{
                [self showAlertViewWith:@"请检查网络是否连接！"];
                
            }
            [alertView dismiss];
            
            if (isSucess) {
                
                //开始计时
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(relpaceTimerFinish) userInfo:nil repeats:YES];
            }else{
                  self.getVerifyButton.userInteractionEnabled = YES;
            }
            
        }];
        
    }else{
        
        [self showAlertViewWith:@"您输入的手机号不正确！"];
    }
    

}

#pragma mark 定时结束
-(void)relpaceTimerFinish
{
    if (count == 1)
    {
        count = 120;
        self.enumNumber.hidden = YES;
        [timer invalidate];
        self.getVerifyButton.userInteractionEnabled = YES;
        [self.getVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    else
    {
        count--;
        self.enumNumber.hidden = NO;
        NSString *title = [NSString stringWithFormat:@"剩余%d秒",count];
        self.enumNumber.text = title;
//        self.getVerifyButton.userInteractionEnabled = NO;
    }
}

#pragma mark -
#pragma mark - 找回密码点击事件

- (IBAction)findPasswordBtnClicked:(id)sender {
    
    if (_phoneNumberTextField.text.length == 11 && _verifyTextField.text.length > 0) {
        
        alertView = [[FVCustomAlertView alloc] init];
        [alertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
        
        _findPasswordButton.userInteractionEnabled = NO;
        
        NSMutableDictionary *bean = [NSMutableDictionary dictionary];
        [bean setValue:_userNameTextField.text forKey:@"userflag"];   //非必传参数
        [bean setValue:@"" forKey:@"email"];
        [bean setValue:_phoneNumberTextField.text forKey:@"mobilephone"];
        [bean setValue:_verifyTextField.text forKey:@"code"];
        [bean setValue:@"0" forKey:@"flag"];
        
        [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].wxBaseServiceURL ServiceName:[NSString stringWithFormat:@"%@/appforgetpwd",appbase] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
            if (nil != result) {
                NSDictionary *bigDic = result;
                if ([bigDic[@"restate"]isEqualToString:@"1"]) {
                    
                    [self showAlertViewWith:@"请耐心等待新密码的发送！"];
                }else{
                    
                    [self showAlertViewWith:bigDic[@"redes"]];
                }
            }else{
                [self showAlertViewWith:@"请检查网络是否连接！"];
            }
            [alertView dismiss];
            _findPasswordButton.userInteractionEnabled = YES;
        }];
        
    }else{
        [self showAlertViewWith:@"信息未填完或者输入手机号有误!"];
    }
    
}

-(void)showAlertViewWith:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:title delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
