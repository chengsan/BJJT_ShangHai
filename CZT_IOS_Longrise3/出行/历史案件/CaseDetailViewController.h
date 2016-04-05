//
//  CaseDetailViewController.h
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 15/12/17.
//  Copyright © 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicViewController.h"
@class HistoryModel;

@interface CaseDetailViewController : PublicViewController
@property (nonatomic,copy)NSString * appphone;  //报案手机号
@property (nonatomic,strong)HistoryModel *historyModel;
@end
