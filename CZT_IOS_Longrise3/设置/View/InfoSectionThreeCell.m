//
//  InfoSectionThreeCell.m
//  CZT_IOS_Longrise
//
//  Created by OSch on 16/1/20.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "InfoSectionThreeCell.h"
//#import "IQKeyboardManager.h"
@interface InfoSectionThreeCell ()<UITextFieldDelegate>

@end

@implementation InfoSectionThreeCell 

- (void)awakeFromNib {
    
   self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.rightText.delegate = self;
    NSLog(@"cellindexPath = %ld",self.cellIndexpath.row);
//    IQKeyboardManager *manger = [IQKeyboardManager sharedManager];
//    manger.enable = NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate != nil)
    {
        [self.delegate modifyInfomation:textField.text IndexPath:self.cellIndexpath];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
