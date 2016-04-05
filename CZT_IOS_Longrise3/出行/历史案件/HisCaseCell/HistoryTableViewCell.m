//
//  HistoryTableViewself.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 15/12/16.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "SGCLViewController.h"
#import "InsuranceReportController.h"
#import "HistoryModel.h"

@interface HistoryTableViewCell ()<UIAlertViewDelegate>

@end

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
//

#pragma mark -设置模型
-(void)setModel:(HistoryModel *)model{
    _model = model;
    if (model.casetype == 0) {
        self.caseType.text = @"单车";
    }else if (model.casetype == 1){
        self.caseType.text = @"双车";
    }else if (model.casetype == 2){
        self.caseType.text = @"多车";
    }
    if (model.state == 1) {
        self.caseState.text = @"待定责";
        [self.caseHandleState setTitle:@"处理" forState:UIControlStateNormal];
        self.caseHandleState.backgroundColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:15/255.0 alpha:1.0];
    }else if (model.state == 2){
        self.caseState.text = @"待保险报案";
        [self.caseHandleState setTitle:@"处理" forState:UIControlStateNormal];
        self.caseHandleState.backgroundColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:15/255.0 alpha:1.0];
    }else if (model.state == 3){
        self.caseState.text = @"待理赔";
        [self.caseHandleState setTitle:@"待理赔" forState:UIControlStateNormal];
        self.caseHandleState.backgroundColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:15/255.0 alpha:1.0];
    }else if (model.state == 4){
        self.caseState.text = @"待评价";
        [self.caseHandleState setTitle:@"评价" forState:UIControlStateNormal];
        self.caseHandleState.backgroundColor = [UIColor colorWithRed:255/255.0 green:192/255.0 blue:15/255.0 alpha:1.0];
    }else if (model.state == 5){
        self.caseState.text = @"完成";
        [self.caseHandleState setTitle:@"完成" forState:UIControlStateNormal];
        self.caseHandleState.backgroundColor = [UIColor colorWithRed:107/255.0 green:220/255.0 blue:91/255.0 alpha:1.0];
    }else if (model.state == 6){
        self.caseState.text = @"撤销案件";
        [self.caseHandleState setTitle:@"已撤销" forState:UIControlStateNormal];
        self.caseHandleState.backgroundColor = [UIColor colorWithRed:107/255.0 green:220/255.0 blue:91/255.0 alpha:1.0];
    }else if (model.state == 8){
        self.caseState.text = @"转现场处理";
        [self.caseHandleState setTitle:@"完成" forState:UIControlStateNormal];
        self.caseHandleState.backgroundColor = [UIColor colorWithRed:107/255.0 green:220/255.0 blue:91/255.0 alpha:1.0];
    }else{
        self.caseState.text = @"完成";
        [self.caseHandleState setTitle:@"完成" forState:UIControlStateNormal];
        self.caseHandleState.backgroundColor = [UIColor colorWithRed:107/255.0 green:220/255.0 blue:91/255.0 alpha:1.0];
    }
    NSArray *array = [model.casehaptime componentsSeparatedByString:@"."];
    NSString *timeStr = array[0];
    self.caseHapTime.text = timeStr;

}

- (IBAction)btnClicked:(id)sender {
    
    [self.delegate pushNextControllerWith:_model];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
