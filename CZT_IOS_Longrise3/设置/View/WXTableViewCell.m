//
//  WXTableViewCell.m
//  CZT_IOS_Longrise
//
//  Created by Siren on 15/12/9.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "WXTableViewCell.h"
#import "AppDelegate.h"

@implementation WXTableViewCell

-(void)setUIWithInfo:(CarModel *)model{
    
    self.license.text = model.carno;
    self.carUseage.text = model.usertype;
    self.carModel.text = model.brandtype;
    self.carType.text = model.cartype;
    self.CellCarNo = model.carno;
//    cell.carType.text = model.cartype;
    self.VINCode = model.identificationnum;
    self.engineNumber = model.enginenumber;
    self.isApprove = model.isapprove;
    if ([model.isapprove isEqualToString:@"1"]) {
        [self.carVarifyStateButton setTitle:@"已验证" forState:UIControlStateNormal];
        self.carVarifyStateButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:125/255.0 blue:4/255.0 alpha:1];
        
    }else if([model.isapprove isEqualToString:@"0"]){
        [self.carVarifyStateButton setTitle:@"未验证" forState:UIControlStateNormal];
        self.carVarifyStateButton.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    }
    
}

#pragma mark -
#pragma mark - 健康档案点击事件
- (IBAction)btnClicked:(id)sender {
    [_delegate pushToNextViewControllerWith:_CellCarNo];
}

- (IBAction)varifyBtnClicked:(id)sender {
    [_delegate pushToNextViewControllerWith:_CellCarNo and:_VINCode and:_engineNumber and:_isApprove];
}

- (void)awakeFromNib {
    // Initialization code
    [AppDelegate storyBoradAutoLay:self];
    self.carVarifyStateButton.layer.masksToBounds = YES;
    self.carVarifyStateButton.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
