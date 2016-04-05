//
//  CustomPickerView.h
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/14.
//  Copyright © 2016年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol giveDataToService <NSObject>

-(void)getSelectReasonName:(NSString *)reasonName andReasonCode:(NSString *)reasonCode;

@end

@interface CustomPickerView : UIView

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIView *backgView;

@property (weak, nonatomic) IBOutlet UIButton *clearButton;


@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic,copy)NSString *reasonName;

@property (nonatomic,copy)NSString *reasonCode;

@property (nonatomic,assign)id <giveDataToService> delegate;

+(CustomPickerView *)instancePickerView;

@end
