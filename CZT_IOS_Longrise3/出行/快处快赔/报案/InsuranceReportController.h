//
//  InsuranceReportController.h
//  CZT_IOS_Longrise
//
//  Created by OSch on 15/12/11.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "PublicViewController.h"

@interface InsuranceReportController : PublicViewController

@property (weak, nonatomic) IBOutlet UIButton *reportCaseBtn;
@property (weak, nonatomic) IBOutlet UIButton *unReportCase;

//判断是否历史案件跳转进来 historyType = 1 回跳到历史案件界面
@property (assign, nonatomic) int historyType;
//历史案件报案接收的数据
@property (strong, nonatomic)NSMutableDictionary *historyCaseDict;


@end
