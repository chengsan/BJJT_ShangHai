//
//  ARAViewController.m
//  CZT_IOS_Longrise
//
//  Created by OSch on 15/12/5.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "ARAViewController.h"
#import <BJJT_Lib/Masonry.h>
#import "CZT_IOS_Longrise.pch"
#import "SureResponsController.h"
@interface ARAViewController ()<UIWebViewDelegate,UIAlertViewDelegate>
{
    FVCustomAlertView *fvAlert;
    UIAlertView *sendUnloadView;
}
@end

@implementation ARAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"事故责任协议书";
    
    [self setWebViewStatus];
    
    [self setPromptBackViewStatus];
    
}


-(void)setPromptBackViewStatus
{

    self.promptImageView.userInteractionEnabled = YES;
    self.responsWebView.backgroundColor = [UIColor clearColor];
    self.responsWebView.scalesPageToFit =YES;
    self.responsWebView.delegate =self;
    
    fvAlert = [[FVCustomAlertView alloc]init];
    [fvAlert showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:true Duration:-1];
    [self.view addSubview:fvAlert];
    NSURL *url =[[NSURL alloc] initWithString:self.ARVWebString];
    NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:url];
    [self.responsWebView loadRequest:request];
}

-(void)setWebViewStatus
{
    for (UIView *_aView in [self.responsWebView subviews]) {
        if ([_aView isKindOfClass:[UIScrollView class]]) {
            //右侧
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            //下侧
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
        }
    }
}
//点击确定显示提示图片 确认是否确定
- (IBAction)SureResponsBtn:(id)sender {
    
    self.noticeBackView.hidden = NO;
    self.promptImageView.hidden = NO;
    
    //取证完成通知
    NSString *name = NotificationNameForOneStepFinish;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"2" forKey:@"dealCaseStep"];
    [center postNotificationName:name object:nil userInfo:dic];
    
    //通知历史记录刷新列表
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshHistory" object:@"1"];
}

- (IBAction)sureButton:(id)sender {
    
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    [self.navigationController popToViewController:[navigationArray objectAtIndex:1] animated:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
   
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [fvAlert dismiss];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [fvAlert dismiss];
    self.sureResponsBtn.userInteractionEnabled = NO;
    sendUnloadView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"加载网页失败，请检查您的网络，重新加载！" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [sendUnloadView show];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerUnloadWebView) userInfo:nil repeats:NO];
    
}

- (void)timerUnloadWebView
{
    [sendUnloadView dismissWithClickedButtonIndex:0 animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
