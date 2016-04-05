//
//  ModifyCellPhoneController.m
//  CZT_IOS_Longrise
//
//  Created by OSch on 16/1/20.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "ModifyPhoneController.h"
#import "AppDelegate.h"
#import "CZT_IOS_Longrise.pch"
#import "DESCript.h"

@interface ModifyPhoneController ()<ImgCodeViewDelegate,UIAlertViewDelegate>
{
    NSTimer *timer;
    int count;
    FVCustomAlertView *alertView;
    NSString *imgCodeID;
    UIAlertView *sucessAlertView;
}
@end

@implementation ModifyPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"修改手机号"];
    
    count = 120;
    
    self.SureBtn.layer.masksToBounds = YES;
    self.SureBtn.layer.cornerRadius = 3;
    
    self.oldCellphoneLabel.text = self.cellphoneNumber;
    
    ImgCodeView *imgCodeView = [[ImgCodeView alloc]initWithFrame:CGRectMake(0, 0, self.imgCodeView.frame.size.width,self.imgCodeView.frame.size.height)];
    imgCodeView.delegate = self;
    [self.imgCodeView addSubview:imgCodeView];
    
    
    [AppDelegate storyBoradAutoLay:self.view];
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



- (IBAction)loadCellPhoneCode:(id)sender {
    
    if (!self.imgCodetext.text.length)
    {
        [self showAlertView:@"图片验证码不能为空！"];
        return;
    }
    
    if (self.oldCellphoneLabel.text.length == 11) {
        alertView = [[FVCustomAlertView alloc] init];
        [alertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
        
        self.loadCellCodeBtn.userInteractionEnabled = NO;  //点击后让获取验证码按钮用户交互关闭
        
        NSMutableDictionary *bean = [NSMutableDictionary dictionary];
        [bean setValue:self.oldCellphoneLabel.text forKey:@"mobilenumber"];
        [bean setValue:self.imgCodetext.text forKey:@"imgcode"];
        [bean setValue:imgCodeID forKey:@"imgid"];
        
        [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].wxBaseServiceURL ServiceName:[NSString stringWithFormat:@"%@/appgetmodfiyphonecode",appbase] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
            BOOL isSucess = false;
            if (nil != result) {
                NSDictionary *bigDic = result;
                if ([bigDic[@"restate"]isEqualToString:@"1"]) {
                    [self showAlertView:@"请耐心等待新消息的发送！"];
                    isSucess = true;
                }else{
                    
                    [self showAlertView:bigDic[@"redes"]];
                }
                
            }else{
                [self showAlertView:@"请检查网络是否连接！"];
//                NSLog(@"没有请求到数据！");
            }
            
            if (isSucess) {
                
                //开始计时
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nsTimerFinish) userInfo:nil repeats:YES];
            }
            [alertView dismiss];
            self.loadCellCodeBtn.userInteractionEnabled = YES;
        }];
        
    }else{
        
        [self showAlertView:@"您输入的手机号不正确！"];
    }
    
    
}

#pragma mark 定时结束
-(void)nsTimerFinish
{
    if (count == 1)
    {
        count = 120;
        self.loadCellCodeBtn.hidden = NO;
        self.remainTimeText.hidden = YES;
        [timer invalidate];
        //        self.getVerifyButton.userInteractionEnabled = YES;
        [self.loadCellCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    else
    {
        count--;
        self.loadCellCodeBtn.hidden = YES;
        self.remainTimeText.hidden = NO;
        NSString *title = [NSString stringWithFormat:@"剩余%d秒",count];
        self.remainTimeText.text = title;
        //        self.getVerifyButton.userInteractionEnabled = NO;
    }
    
}

#pragma mark - 确认修改手机号
- (IBAction)sureNextBtn:(id)sender
{
    if (!self.imgCodetext.text.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"图片验证码不能为空" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (!self.cellCodeText.text.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"验证码不能为空" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (self.PhoneNumber.text.length == 11) {
        alertView = [[FVCustomAlertView alloc] init];
        [alertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
        [self.view addSubview:alertView];
        self.loadCellCodeBtn.userInteractionEnabled = NO;  //点击后让获取验证码按钮用户交互关闭
        
        NSMutableDictionary *bean = [NSMutableDictionary dictionary];
        NSString *p = [UserDefaultsUtil getDataForKey:@"passWord"];
        NSDictionary *bigDic = [Globle getInstance].loginInfoDic;
        NSDictionary *userdic = [bigDic objectForKey:@"userinfo"];
        NSString *token = [bigDic objectForKey:@"token"];
        NSString *userflag = [userdic objectForKey:@"userflag"];
        [bean setValue:userflag forKey:@"userflag"];
        [bean setValue:self.oldCellphoneLabel.text forKey:@"mobilephoneold"];
        [bean setValue:self.PhoneNumber.text forKey:@"mobilephone"];
        [bean setValue:self.cellCodeText.text forKey:@"code"];
        [bean setValue:token forKey:@"token"];
        NSString *passWord = [DESCript encrypt:p encryptOrDecrypt:kCCEncrypt key:[Util getKey]];
        [bean setValue:passWord forKey:@"password"];
        
        [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].wxBaseServiceURL ServiceName:[NSString stringWithFormat:@"%@/appmodifyphone",appbase] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
            BOOL isSucess = false;
            if (nil != result) {
                if ([result[@"restate"]isEqualToString:@"1"])
                {
                    NSDictionary *dict = result[@"data"];
                    if (self.delegate != nil)
                    {
                        [self.delegate modifyUserPhoneNumber:dict[@"mobilephone"] Status:1];
                     }
//
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:dict[@"mobilephone"] forKey:@"newPhoneNumber"];
                     [userDefaults synchronize];
                    NSMutableDictionary *dict1  =[NSMutableDictionary dictionary];
                    [dict1 setValue:dict[@"mobilephone"] forKey:@"mobilephone"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"newmobilephone" object:nil userInfo:dict];
                    
                    sucessAlertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:result[@"redes"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [sucessAlertView show];
                }
                else
                {
                    [self showAlertView:result[@"redes"]];
                }
            }else{

                [self showAlertView:@"保存修改信息失败，请检查您的网络！"];
               // NSLog(@"没有请求到数据！");
            }
            
            if (isSucess) {
                
                //开始计时
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nsTimerFinish) userInfo:nil repeats:YES];
            }
            [alertView dismiss];
            self.loadCellCodeBtn.userInteractionEnabled = YES;
        }];
        
    }else{
        
        [alertView dismiss];
        [self showAlertView:@"保存修改信息失败，请检查您的网络！"];
    }
}

-(void)showAlertView:(NSString *)notice
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:notice delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (sucessAlertView)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
