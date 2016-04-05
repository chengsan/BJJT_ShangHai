//
//  ChooseASController.m
//  CZT_IOS_Longrise
//
//  Created by OSch on 15/12/2.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "ChooseASController.h"
#import "CZT_IOS_Longrise.pch"
#import "ChooseCarViewController.h"
#import "LoginViewController.h"
#import "FillInformationController.h"
#import "InfimationModel.h"
#import "ResponsViewController.h"
#import "SetViewController.h"
#import <BJJT_Lib/Masonry.h>


@interface ChooseASController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    UITextView *destextView;
    FVCustomAlertView *fvalertView;
    UIAlertView *alertCarNumber; //查询车牌号码
}

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSMutableArray *describeData;

@end

@implementation ChooseASController

- (NSArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)describeData
{
    if (_describeData == nil) {
        _describeData = [NSMutableArray array];
    }
    return _describeData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backScrollView.delegate = self;
    
    //设置显示的View
    [self setTabView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.sureButton.userInteractionEnabled = YES;
}

#pragma mark  - 下一步

- (IBAction)sureNextButton:(id)sender {
    
    if (self.moreHistoryToResponsArray.count)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FillInfomation" bundle:nil];
        FillInformationController *fillController = [storyboard instantiateViewControllerWithIdentifier:@"fillinfomationID"];
        fillController.hidesBottomBarWhenPushed = YES;
        fillController.appcaseno = self.appcaseno;
        fillController.describeData = self.describeData;
        fillController.describeString = [self.historyDescribArray lastObject];
        fillController.moreHistoryToResponsArray = self.moreHistoryToResponsArray;
        [self.navigationController pushViewController:fillController animated:YES];
    }
    else
    {

        if (self.showView1.tag == 0 && self.showView2.tag == 0 && self.showView3.tag == 0 && self.showView4.tag == 0 && self.showView5.tag == 0 && self.showView6.tag == 0 && self.showView7.tag == 0 && self.showView8.tag == 0 && self.showView9.tag == 0 ) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择事故类型" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else
        {
            [self startLoadData];
        }
        
    }
    

    
    self.sureButton.userInteractionEnabled =  NO;
}

#pragma mark  - 加载数据
-(void)startLoadData
{
   
        fvalertView = [[FVCustomAlertView alloc]init];
        [fvalertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:0];
        [self.view addSubview:fvalertView];
        NSMutableDictionary *bean = [[NSMutableDictionary alloc] init];
        NSDictionary *userinfo = [[Globle getInstance].loginInfoDic objectForKey:@"userinfo"];
        [bean setValue:userinfo[@"userflag"] forKey:@"userflag"];
        [bean setValue:[Globle getInstance].loginInfoDic[@"token"] forKey:@"token"];
        [bean setValue:@"1" forKey:@"pagenum"];
        [bean setValue:@"100" forKey:@"pagesize"];

        
        [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].wxBaseServiceURL ServiceName:[NSString stringWithFormat:@"%@/appsearchcarlist",baseapp] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
            
            NSLog(@"result = %@",result[@"data"]);
            [fvalertView dismiss];
            if ([result[@"restate"]isEqualToString:@"-4"])
            {
//                alertCarNumber = [[UIAlertView alloc]initWithTitle:nil message:@"验证失效，是否退出重新登录！" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"确定", nil];
                alertCarNumber = [[UIAlertView alloc]initWithTitle:nil message:result[@"redes"] delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"确定", nil];
                [alertCarNumber show];
            }
            else
            {
                if([result[@"data"]isEqual:@""])
                {
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FillInfomation" bundle:nil];
                    FillInformationController *fillController = [storyboard instantiateViewControllerWithIdentifier:@"fillinfomationID"];
                    fillController.hidesBottomBarWhenPushed = YES;
                    fillController.appcaseno = self.appcaseno;
                    fillController.describeData = self.describeData;
                    fillController.describeString = destextView.text;
                    fillController.moreHistoryToResponsArray = self.moreHistoryToResponsArray;
                    [self.navigationController pushViewController:fillController animated:YES];
                }
                else
                {
                    
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ChooseCar" bundle:nil];
                    ChooseCarViewController *araVC = [storyboard instantiateViewControllerWithIdentifier:@"ChooseCarStoryboard"];
                    araVC.hidesBottomBarWhenPushed = YES;
                    araVC.CarDict = result[@"data"];
                    araVC.appcaseno = self.appcaseno;
                    araVC.describeData = self.describeData;
                    araVC.describeString = destextView.text;
                    araVC.carsType = self.carsType;
                    araVC.moreHistoryToResponsArray = self.moreHistoryToResponsArray;
                    [self.navigationController pushViewController:araVC animated:YES];
                    
                    
                }
            }
            
            
        }];

  
    
}
#pragma mark - 设置tabView
- (void)setTabView
{
    self.title = @"选择事故情形";
    self.view.backgroundColor = BackColor;
    self.dataSource = @[@"追尾的",@"逆行的",@"倒车的",@"溜车的",@"开车门的",@"违反交通信号的",@"未按规定让行的",@"并线的",@"全部责任的其他情形"];
    
    
    self.backScrollView.contentSize = CGSizeMake(0, 770);
    NSArray *item = [[NSBundle mainBundle]loadNibNamed:@"ChooseAS" owner:self options:nil];
    UIView *Views = [item lastObject];
    //    Views.frame = CGRectMake(-20, 0, self.backScrollView.frame.size.width, self.backScrollView.frame.size.height);
    [self.backScrollView addSubview:Views];
    [Views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(590);
        make.left.equalTo(self.backScrollView).with.offset(0);
        make.top.equalTo(self.backScrollView).with.offset(0);
        make.width.mas_equalTo(self.backScrollView.mas_width);
        
    }];
    destextView =  [[UITextView alloc]init];
    destextView.backgroundColor = [UIColor whiteColor];
    destextView.delegate = self;
    destextView.layer.cornerRadius = 3;
    destextView.layer.masksToBounds = YES;
    [self.backScrollView addSubview:destextView];
    [destextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Views.mas_bottom).with.offset(0);
        make.left.equalTo(self.backScrollView).with.offset(0);
        make.height.mas_equalTo(160);
        make.width.mas_equalTo(self.backScrollView.mas_width);
        
    }];
    
    //历史案件进来 显示已选择的数据
    [self judgeDescribShow];
    
    
    [self.sureButton.layer setCornerRadius:4];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]init];
    [tap1 addTarget:self action:@selector(viewClick:)];
    [self.showView1 addGestureRecognizer:tap1];
    [self.showView1.layer setCornerRadius:2];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]init];
    [tap2 addTarget:self action:@selector(viewClick:)];
    [self.showView2 addGestureRecognizer:tap2];
    [self.showView2.layer setCornerRadius:2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]init];
    [tap3 addTarget:self action:@selector(viewClick:)];
    [self.showView3 addGestureRecognizer:tap3];
    [self.showView3.layer setCornerRadius:2];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]init];
    [tap4 addTarget:self action:@selector(viewClick:)];
    [self.showView4 addGestureRecognizer:tap4];
    [self.showView4.layer setCornerRadius:2];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]init];
    [tap5 addTarget:self action:@selector(viewClick:)];
    [self.showView5 addGestureRecognizer:tap5];
    [self.showView5.layer setCornerRadius:2];
    
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc]init];
    [tap6 addTarget:self action:@selector(viewClick:)];
    [self.showView6 addGestureRecognizer:tap6];
    [self.showView6.layer setCornerRadius:2];
    
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc]init];
    [tap7 addTarget:self action:@selector(viewClick:)];
    [self.showView7 addGestureRecognizer:tap7];
    [self.showView7.layer setCornerRadius:4];
    
    UITapGestureRecognizer *tap8 = [[UITapGestureRecognizer alloc]init];
    [tap8 addTarget:self action:@selector(viewClick:)];
    [self.showView8 addGestureRecognizer:tap8];
    [self.showView8.layer setCornerRadius:2];
    
    UITapGestureRecognizer *tap9 = [[UITapGestureRecognizer alloc]init];
    [tap9 addTarget:self action:@selector(viewClick:)];
    [self.showView9 addGestureRecognizer:tap9];
    [self.showView9.layer setCornerRadius:2];
}

#pragma mark - 点击手势
- (void)viewClick:(UITapGestureRecognizer *)recognizer
{
    self.showView1.tag = 0;
    self.showView2.tag = 0;
    self.showView3.tag = 0;
    self.showView4.tag = 0;
    self.showView5.tag = 0;
    self.showView6.tag = 0;
    self.showView7.tag = 0;
    self.showView8.tag = 0;
    self.showView9.tag = 0;
    UIView *checkView = recognizer.view;
    checkView.tag = 1;
    
    if (self.showView1.tag == 1) {
        self.checkImage1.hidden = NO;
        [self.describeData removeAllObjects];
        [self.describeData addObject:self.dataSource[0]];
        
    }else
    {
        self.checkImage1.hidden = YES;
    }
    if (self.showView2.tag == 1) {
        self.checkImage2.hidden = NO;
        [self.describeData removeAllObjects];
        [self.describeData addObject:self.dataSource[1]];
    }else
    {
        self.checkImage2.hidden = YES;
    }
    if (self.showView3.tag == 1) {
        self.checkImage3.hidden = NO;
        [self.describeData removeAllObjects];
        [self.describeData addObject:self.dataSource[2]];
    }else
    {
        self.checkImage3.hidden = YES;
    }
    if (self.showView4.tag == 1) {
        self.checkImage4.hidden = NO;
        [self.describeData removeAllObjects];
        [self.describeData addObject:self.dataSource[3]];
    }else
    {
        self.checkImage4.hidden = YES;
    }
    if (self.showView5.tag == 1) {
        self.checkImage5.hidden = NO;
        [self.describeData removeAllObjects];
        [self.describeData addObject:self.dataSource[4]];
    }else
    {
        self.checkImage5.hidden = YES;
    }
    if (self.showView6.tag == 1) {
        self.checkImage6.hidden = NO;
        [self.describeData removeAllObjects];
        [self.describeData addObject:self.dataSource[5]];
    }else
    {
        self.checkImage6.hidden = YES;
    }
    if (self.showView7.tag == 1) {
        self.checkImage7.hidden = NO;
        [self.describeData removeAllObjects];
        [self.describeData addObject:self.dataSource[6]];
    }else
    {
        self.checkImage7.hidden = YES;
    }
    if (self.showView8.tag == 1) {
        self.checkImage8.hidden = NO;
        [self.describeData removeAllObjects];
        [self.describeData addObject:self.dataSource[7]];
    }else
    {
        self.checkImage8.hidden = YES;
    }
    if (self.showView9.tag == 1) {
        self.checkImage9.hidden = NO;
        [self.describeData removeAllObjects];
        [self.describeData addObject:self.dataSource[8]];
    }else
    {
        self.checkImage9.hidden = YES;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.sureButton.userInteractionEnabled = YES;
//    if (alertView == alertCarNumber)
//    {
//        if (buttonIndex == 0)
//        {
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FillInfomation" bundle:nil];
//            FillInformationController *fillController = [storyboard instantiateViewControllerWithIdentifier:@"fillinfomationID"];
//            fillController.hidesBottomBarWhenPushed = YES;
//            fillController.appcaseno = self.appcaseno;
//            fillController.describeData = self.describeData;
//            fillController.describeString = destextView.text;
//            fillController.moreHistoryToResponsArray = self.moreHistoryToResponsArray;
//            [self.navigationController pushViewController:fillController animated:YES];
//        }
//        else
//        {
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//        
//    }

}

#pragma mark - 历史案件进来判断显示的状态
- (void)judgeDescribShow
{
    if (self.historyDescribArray.count)
    {
        
        if ([[self.historyDescribArray firstObject] isEqualToString:@"0"])
        {
            ((UIView *)[self.showView1.subviews lastObject]).hidden = NO;
            [self.describeData removeAllObjects];
            [self.describeData addObject:self.dataSource[0]];
        }
        else if ([[self.historyDescribArray firstObject] isEqualToString:@"1"])
        {
            ((UIView *)[self.showView2.subviews lastObject]).hidden = NO;
            [self.describeData removeAllObjects];
            [self.describeData addObject:self.dataSource[1]];
        }
        else if ([[self.historyDescribArray firstObject] isEqualToString:@"2"])
        {
            ((UIView *)[self.showView3.subviews lastObject]).hidden = NO;
            [self.describeData removeAllObjects];
            [self.describeData addObject:self.dataSource[2]];
        }
        else if ([[self.historyDescribArray firstObject] isEqualToString:@"3"])
        {
            ((UIView *)[self.showView4.subviews lastObject]).hidden = NO;
            [self.describeData removeAllObjects];
            [self.describeData addObject:self.dataSource[3]];
        }
        else if ([[self.historyDescribArray firstObject] isEqualToString:@"4"])
        {
            ((UIView *)[self.showView5.subviews lastObject]).hidden = NO;
            [self.describeData removeAllObjects];
            [self.describeData addObject:self.dataSource[4]];
        }
        else if ([[self.historyDescribArray firstObject] isEqualToString:@"5"])
        {
            ((UIView *)[self.showView6.subviews lastObject]).hidden = NO;
            [self.describeData removeAllObjects];
            [self.describeData addObject:self.dataSource[5]];
        }
        else if ([[self.historyDescribArray firstObject] isEqualToString:@"6"])
        {
            ((UIView *)[self.showView7.subviews lastObject]).hidden = NO;
            [self.describeData removeAllObjects];
            [self.describeData addObject:self.dataSource[6]];
        }
        else if ([[self.historyDescribArray firstObject] isEqualToString:@"7"])
        {
            ((UIView *)[self.showView8.subviews lastObject]).hidden = NO;
            [self.describeData removeAllObjects];
            [self.describeData addObject:self.dataSource[7]];
        }
        else
        {
            ((UIView *)[self.showView9.subviews lastObject]).hidden = NO;
            [self.describeData removeAllObjects];
            [self.describeData addObject:self.dataSource[8]];
            destextView.text = [self.historyDescribArray lastObject];
        }
    }
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
