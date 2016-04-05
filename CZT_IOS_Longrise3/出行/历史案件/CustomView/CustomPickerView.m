//
//  CustomPickerView.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/14.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "CustomPickerView.h"

@interface CustomPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
}

@end

@implementation CustomPickerView

+(CustomPickerView *)instancePickerView{
    
    NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:@"CustomPickerView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

-(void)awakeFromNib{
    self.backgView.layer.masksToBounds = YES;
    self.backgView.layer.cornerRadius = 5;
    self.backgView.layer.borderWidth = 1;
    self.backgView.layer.borderColor = [[UIColor clearColor] CGColor];
    
    /*确定按钮*/
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = 4;
    self.sureButton.layer.borderWidth = 1;
    self.sureButton.layer.borderColor = [[UIColor colorWithRed:38/255.0 green:183/255.0 blue:243/255.0 alpha:1] CGColor];
    
    /*取消按钮*/
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.cornerRadius = 4;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [[UIColor colorWithRed:186/255.0 green:185/255.0 blue:185/255.0 alpha:1] CGColor];
    
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
}

- (IBAction)btnClicked:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
//        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (IBAction)cancelBtnClicked:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
//        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (IBAction)sureBtnClicked:(id)sender {
    
    if ((_reasonName!=nil) && (_reasonCode!=nil)) {
         [self.delegate getSelectReasonName:_reasonName andReasonCode:_reasonCode];
    }else{
        if (self.dataArray.count > 0) {
            NSDictionary *dic = _dataArray[0];
            _reasonName = dic[@"reasonname"];
            _reasonCode = dic[@"reasoncode"];
            [self.delegate getSelectReasonName:_reasonName andReasonCode:_reasonCode];
        }
    }
   
    [UIView animateWithDuration:0.3 animations:^{
//        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - 代理方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _dataArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *unsatisfiedReasonStr = nil;
    if (_dataArray.count > row) {
        NSDictionary *dic = _dataArray[row];
        unsatisfiedReasonStr = dic[@"reasonname"];
    }
    return unsatisfiedReasonStr;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_dataArray.count > row) {
        NSDictionary *dic = _dataArray[row];
        _reasonName = dic[@"reasonname"];
        _reasonCode = dic[@"reasoncode"];
    }
}

@end
