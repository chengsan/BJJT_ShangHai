//
//  InsuranceReportController.m
//  CZT_IOS_Longrise
//
//  Created by OSch on 15/12/11.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "InsuranceReportController.h"
#import "CZT_IOS_Longrise.pch"
#import "HomeViewController.h"

extern NSMutableDictionary *caseDict;
extern NSMutableDictionary *onlyCaseDict;
extern NSNumber *caseDutyType;

@interface InsuranceReportController ()<UIAlertViewDelegate>
{
    FVCustomAlertView *fvalertView;
    UIAlertView *suessAlert;
    UIAlertView *falseAlert;
}
@end

@implementation InsuranceReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"保险报案";
    
    
    self.reportCaseBtn.layer.cornerRadius = 3;
    self.reportCaseBtn.layer.masksToBounds = YES;
    
    self.unReportCase.layer.cornerRadius = 3;
    self.unReportCase.layer.masksToBounds = YES;
}

#pragma mark -  保险报案
- (IBAction)reportCase:(id)sender {
   if (caseDict != nil) {
        
        if ([caseDutyType isEqualToNumber:[NSNumber numberWithInt:1]]) {
            falseAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您是无责任方，暂不允许报案！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [falseAlert show];
            
        }
        else
        {
            [self upCaseInormationCompany:caseDict];
        }
    }
    else if (onlyCaseDict != nil)
    {
        [self upCaseInormationCompany:onlyCaseDict];
        
    }
    else if (self.historyCaseDict != nil)
    {
        [self upCaseInormationCompany:self.historyCaseDict];
    }
    
    
}
#pragma mark -  暂不报案
- (IBAction)unReportCase:(id)sender {
    
    if (self.historyType == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)upCaseInormationCompany:(NSMutableDictionary *)dict
{
    fvalertView = [[FVCustomAlertView alloc]init];
    [fvalertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:0];
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[NSString stringWithFormat:@"%@/zdsubmitcaseinforinscompany",kckpzcslrest] params:dict httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        [fvalertView dismiss];
        NSLog(@"保险报案  %@",result);
        NSLog(@"resdes = %@",result[@"redes"]);
        if (result != nil)
        {
            if ([result[@"restate"] isEqualToString:@"0"]) {
                suessAlert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"已报案，请耐心等待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [suessAlert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"报案失败，请检查您的网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨 提示" message:@"报案失败，请检查您的网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        onlyCaseDict = nil;
        caseDict = nil;
        
    } ];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == suessAlert)
    {
        
        if (self.historyType == 1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if (alertView == falseAlert)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}- (void)didReceiveMemoryWarning {
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
