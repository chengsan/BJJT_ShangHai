//
//  ChooseASController.h
//  CZT_IOS_Longrise
//
//  Created by OSch on 15/12/2.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "PublicViewController.h"
#import <BJJT_Lib/MBProgressHUD.h>
#import "InfimationModel.h"
@interface ChooseASController : PublicViewController <UIScrollViewDelegate>


//历史案件进来 接收已有的车主信息
@property (strong, nonatomic) NSMutableArray *moreHistoryToResponsArray;
//历史案件 事故情形判断显示
@property (strong, nonatomic) NSMutableArray *historyDescribArray;

//判断单车还是双车的跳转 0 单车  1 双车
@property (assign, nonatomic) int carsType;

@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
//案件号
@property (copy, nonatomic) NSString *appcaseno;

@property (weak, nonatomic) IBOutlet UIView *showView1;

@property (weak, nonatomic) IBOutlet UIView *showView2;

@property (weak, nonatomic) IBOutlet UIView *showView3;

@property (weak, nonatomic) IBOutlet UIView *showView4;

@property (weak, nonatomic) IBOutlet UIView *showView5;

@property (weak, nonatomic) IBOutlet UIView *showView6;

@property (weak, nonatomic) IBOutlet UIView *showView7;

@property (weak, nonatomic) IBOutlet UIView *showView8;

@property (weak, nonatomic) IBOutlet UIView *showView9;

@property (weak, nonatomic) IBOutlet UIImageView *checkImage1;

@property (weak, nonatomic) IBOutlet UIImageView *checkImage2;

@property (weak, nonatomic) IBOutlet UIImageView *checkImage3;

@property (weak, nonatomic) IBOutlet UIImageView *checkImage4;

@property (weak, nonatomic) IBOutlet UIImageView *checkImage5;

@property (weak, nonatomic) IBOutlet UIImageView *checkImage6;

@property (weak, nonatomic) IBOutlet UIImageView *checkImage7;

@property (weak, nonatomic) IBOutlet UIImageView *checkImage8;

@property (weak, nonatomic) IBOutlet UIImageView *checkImage9;

//确定按钮
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end
