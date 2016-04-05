//
//  ChooseCarViewController.h
//  CZT_IOS_Longrise
//
//  Created by OSch on 15/12/7.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "PublicViewController.h"

@interface ChooseCarViewController : PublicViewController


@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

//历史案件进来 接收已有的车主信息
@property (strong, nonatomic) NSMutableArray *moreHistoryToResponsArray;

@property (strong, nonatomic)NSArray *CarDict;

//案件号
@property (copy, nonatomic) NSString *appcaseno;
//事故选择
@property (strong, nonatomic) NSArray *describeData;
//事故详情描述
@property (copy, nonatomic) NSString *describeString;

//判断单车还是双车的跳转 0 单车  1 双车
@property (assign, nonatomic) int carsType;
@end
