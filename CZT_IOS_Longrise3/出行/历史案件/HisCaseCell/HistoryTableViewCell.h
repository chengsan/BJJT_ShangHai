//
//  HistoryTableViewCell.h
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 15/12/16.
//  Copyright © 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryModel;

@protocol CellPush <NSObject>

-(void)pushNextControllerWith:(HistoryModel *)historyModel;

@end

@interface HistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *caseType;
@property (weak, nonatomic) IBOutlet UILabel *caseState;
@property (weak, nonatomic) IBOutlet UILabel *caseHapTime;
@property (weak, nonatomic) IBOutlet UIButton *caseHandleState;

@property (nonatomic,strong)HistoryModel *model;
@property (nonatomic,assign) id<CellPush>delegate;

@end
