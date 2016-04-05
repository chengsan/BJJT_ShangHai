//
//  WaitPayViewController.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/6.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "WaitPayViewController.h"
#import "JudgeViewController.h"
#import "CZT_IOS_Longrise.pch"

@interface WaitPayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UIButton *judgeButton;

@end

@implementation WaitPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"理赔信息";
    _judgeButton.layer.masksToBounds = YES;
    _judgeButton.layer.cornerRadius = 3;
    _payLabel.text = _insresult;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)jugdeClicked:(id)sender {
    
    JudgeViewController *JVC = [[JudgeViewController alloc]init];
    JVC.appcaseno = _appcaseno;
    JVC.casecarno = _casecarno;
    [self.navigationController pushViewController:JVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
