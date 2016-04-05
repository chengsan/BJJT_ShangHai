//
//  ModifyPhoneController.h
//  CZT_IOS_Longrise
//
//  Created by OSch on 16/1/20.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "PublicViewController.h"

@protocol ModifyPhoneControllerDElegate <NSObject>

-(void)modifyUserPhoneNumber:(NSString *)cellPhone Status:(NSInteger) statusType;

@end
@interface ModifyPhoneController : PublicViewController

@property (copy, nonatomic) NSString *cellphoneNumber;

@property (weak, nonatomic) IBOutlet UILabel *oldCellphoneLabel;

@property (weak, nonatomic) IBOutlet UITextField *imgCodetext;

@property (weak, nonatomic) IBOutlet UIView *imgCodeView;

@property (weak, nonatomic) IBOutlet UITextField *cellCodeText;

@property (weak, nonatomic) IBOutlet UILabel *remainTimeText;

@property (weak, nonatomic) IBOutlet UIButton *loadCellCodeBtn;

@property (weak, nonatomic) IBOutlet UITextField *PhoneNumber;

@property (weak, nonatomic) IBOutlet UIButton *SureBtn;

@property (weak, nonatomic) id<ModifyPhoneControllerDElegate> delegate;

@end
