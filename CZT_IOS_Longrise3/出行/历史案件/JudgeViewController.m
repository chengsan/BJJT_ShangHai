//
//  JudgeViewController.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/6.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "JudgeViewController.h"
#import "CZT_IOS_Longrise.pch"
#import "HistoryCaseViewController.h"
#import "CustomPickerView.h"
#import <BJJT_Lib/Masonry.h>

@interface JudgeViewController ()<UIAlertViewDelegate,giveDataToService>{
    
    NSMutableArray *dataList;
    NSInteger select;   //选中的选项
    NSString *getReasonName;
    NSString *getReasonCode;
    FVCustomAlertView *FVCAlertView;
    UIAlertView *jugdeAlertView;
    CustomPickerView *pickerView;
}

@end

@implementation JudgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    select = 100;   //未选中的状态
    dataList = [NSMutableArray array];
    getReasonName = nil;
    [self loadXIB];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - loadXib
-(void)loadXIB{
    self.bacScrollView.contentSize = CGSizeMake(0, 700);
    
    //CGFloat pading = 20;
    NSArray *ietms = [[NSBundle mainBundle]loadNibNamed:@"JudgeViewXIB" owner:self options:nil];
    UIView *views = [ietms lastObject];
    views.frame  = CGRectMake(0, 0, self.bacScrollView.bounds.size.width, 700);
    [self.bacScrollView addSubview:views];
    _sureButton.layer.cornerRadius = 3;
    _sureButton.layer.masksToBounds = YES;
    _verySatisfiedButton.layer.masksToBounds = YES;
    _verySatisfiedButton.layer.cornerRadius = 3;
    _verySatisfiedButton.highlighted = NO;
    _satisfiedButton.layer.masksToBounds = YES;
    _satisfiedButton.layer.cornerRadius = 3;
    _satisfiedButton.highlighted = NO;
    _justSoSoButton.layer.masksToBounds = YES;
    _justSoSoButton.layer.cornerRadius = 3;
    _justSoSoButton.highlighted = NO;
    _unsatisfiedButton.layer.masksToBounds = YES;
    _unsatisfiedButton.layer.cornerRadius = 3;
    _unsatisfiedButton.highlighted = NO;
    _suggestTextView.layer.masksToBounds = YES;
    _suggestTextView.layer.cornerRadius = 3;
    
}
                                                 
#pragma mark - 选项点击事件
- (IBAction)btnClicked:(id)sender {
    _verySatisfiedImageView.hidden = YES;
    _satisfiedImageView.hidden = YES;
    _justSoSoImageView.hidden = YES;
    _unsatisfiedImageView.hidden = YES;
    UIButton *clickedButton = (UIButton *)sender;
    NSInteger tag = clickedButton.tag - 1000;
    if (tag == 0) {
        pickerView.hidden = YES;
        _verySatisfiedImageView.hidden = NO;
        select = 0;
        
    }else if (tag == 1){
        
        pickerView.hidden = YES;
        _satisfiedImageView.hidden = NO;
        select = 1;
        
    }else if (tag == 2){
        //如果数据已存在则不重复请求数据
        if (dataList.count > 0) {
            [UIView animateWithDuration:0.3 animations:^{
                
            } completion:^(BOOL finished) {
                pickerView.hidden = NO;
            }];
        }else{
            [self requestData];
        }
        _justSoSoImageView.hidden = NO;
        select = 2;
        
    }else if (tag == 3){
        if (dataList.count > 0) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
            } completion:^(BOOL finished) {
                pickerView.hidden = NO;
            }];
            
        }else{
            [self requestData];
        }
        _unsatisfiedImageView.hidden = NO;
        select = 3;
        
    }
    
    
}

#pragma mark - 请求不满意原因数据
-(void)requestData{
    
    pickerView = [CustomPickerView instancePickerView];
    pickerView.frame = CGRectMake(0, -50*([UIScreen mainScreen].bounds.size.height/667.0), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    pickerView.backgroundColor = [UIColor clearColor];
    pickerView.delegate = self;
    
    
    FVCAlertView = [[FVCustomAlertView alloc] init];
    [FVCAlertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
    [self.view addSubview:FVCAlertView];
    
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setValue:[Globle getInstance].loadDataName forKey:@"username"];
    [bean setValue:[Globle getInstance].loadDataPass forKey:@"password"];
    
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[NSString stringWithFormat:@"%@/zdsearchunsatisfiedreason",kckpzcslrest] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        
        if (nil != result) {
            NSDictionary *bigDic = result;
            if ([bigDic[@"restate"]isEqualToString:@"0"]) {
                if (![bigDic[@"data"]isEqual:@""]) {
                    
                    NSArray *dataArray = bigDic[@"data"];
                    for (NSDictionary *dic in dataArray) {
                        [dataList addObject:dic];
                    }
                    pickerView.dataArray = [NSMutableArray array];
                    pickerView.dataArray = dataList;
                    [self.view addSubview:pickerView];
                    [pickerView.pickerView reloadAllComponents];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:bigDic[@"redes"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"获取不满意原因列表失败，请检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                NSLog(@"%@",bigDic[@"redes"]);
            }
        }
        
        [FVCAlertView dismiss];
        
    }];
    
    
}

#pragma mark - 确定点击事件
- (IBAction)sureClicked:(id)sender {
    
    if (select == 100) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择其中一项!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    FVCAlertView = [[FVCustomAlertView alloc] init];
    [FVCAlertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
    [self.view addSubview:FVCAlertView];
    
    NSDictionary *loginDic = [Globle getInstance].loginInfoDic;
    NSDictionary *userDic = [loginDic valueForKey:@"userinfo"];
    NSString * telephone = [userDic valueForKey:@"mobilephone"];
    
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setValue:_appcaseno forKey:@"appcaseno"];
    [bean setValue:_casecarno forKey:@"casecarno"];
    [bean setValue:telephone forKey:@"casetelephoe"];
    [bean setValue:_suggestTextView.text forKey:@"personevaluate"];
    [bean setValue:[NSString stringWithFormat:@"%ld",select] forKey:@"personescord"];
    if (select == 0) {
    
        [bean setValue:nil forKey:@"reasoncode"];
        
    }else if (select == 1){
        [bean setValue:nil forKey:@"reasoncode"];
        
    }else if (select == 2){
        if (getReasonName == nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择不满意的原因!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [FVCAlertView dismiss];
            return;
        }else{
            [bean setValue:getReasonCode forKey:@"reasoncode"];
        }
        
    }else if (select == 3){
        if (getReasonName == nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择不满意的原因!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [FVCAlertView dismiss];
            return;
        }else{
            [bean setValue:getReasonCode forKey:@"reasoncode"];
        }
        
    }
    [bean setValue:[Globle getInstance].loadDataName forKey:@"username"];
    [bean setValue:[Globle getInstance].loadDataPass forKey:@"password"];
    
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[NSString stringWithFormat:@"%@/zdsubmitcarevaluationinfo",kckpzcslrest] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        if (nil != result) {
            NSDictionary *bigDic = result;
            if ([bigDic[@"restate"]isEqualToString:@"0"]){
                jugdeAlertView = [[UIAlertView alloc]initWithTitle:nil message:@"评价成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [jugdeAlertView show];
            
                
            }else{
                NSString *str = bigDic[@"redes"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"评价失败!" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"评价失败!" message:@"请检查您的网络!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        [FVCAlertView dismiss];
    }];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == jugdeAlertView) {
        //通知历史记录刷新列表
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshHistory" object:@"1"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 自定义pickerView代理
-(void)getSelectReasonName:(NSString *)reasonName andReasonCode:(NSString *)reasonCode{
    getReasonName = reasonName;
    getReasonCode = reasonCode;
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
