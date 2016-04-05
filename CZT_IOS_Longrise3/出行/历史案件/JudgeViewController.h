//
//  JudgeViewController.h
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/6.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "PublicViewController.h"

@interface JudgeViewController : PublicViewController

@property (nonatomic,copy)NSString *appcaseno;

@property (nonatomic,copy)NSString *casecarno;

@property (weak, nonatomic) IBOutlet UIImageView *verySatisfiedImageView;

@property (weak, nonatomic) IBOutlet UIImageView *satisfiedImageView;

@property (weak, nonatomic) IBOutlet UIImageView *justSoSoImageView;

@property (weak, nonatomic) IBOutlet UIImageView *unsatisfiedImageView;

@property (weak, nonatomic) IBOutlet UITextView *suggestTextView;

@property (weak, nonatomic) IBOutlet UIScrollView *bacScrollView;

//@property (weak, nonatomic) IBOutlet UIPickerView *selectPickerView;
//
//@property (weak, nonatomic) IBOutlet UIButton *pickerBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIButton *verySatisfiedButton;

@property (weak, nonatomic) IBOutlet UIButton *satisfiedButton;

@property (weak, nonatomic) IBOutlet UIButton *justSoSoButton;

@property (weak, nonatomic) IBOutlet UIButton *unsatisfiedButton;


@end
