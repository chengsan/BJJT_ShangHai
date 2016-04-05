//
//  SignViewController.m
//  qianming
//
//  Created by 张博林 on 15/12/5.
//  Copyright © 2015年 张博林. All rights reserved.
//

#import "SignViewController.h"
#import <BJJT_Lib/Masonry.h>
#import "SureResponsController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEGHT [UIScreen mainScreen].bounds.size.height

@interface SignViewController ()

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setButton];
    [self addSignatureView];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark -
#pragma mark - 添加画布View
-(void)addSignatureView{
    __block SignViewController *blockSelf = self;
    signatureView = [[PJRSignatureView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEGHT/1.5)];
    signatureView.backgroundColor = [UIColor colorWithRed:235/255.0 green:236/255.0 blue:239/255.0 alpha:1];
    [self.view addSubview:signatureView];   //手动给自定义的View拉约束
    [signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(blockSelf.view.mas_centerX);
        make.center.equalTo(blockSelf.view.mas_centerY);
        make.width.mas_equalTo(480*(SCREEN_HEGHT/667));
        make.height.mas_equalTo(270*(SCREEN_WIDTH/375));
    }];
}

#pragma mark -
#pragma mark - 设置button的边框和圆角
-(void)setButton{
    self.sureButton.layer.masksToBounds = YES;
    self.resignButton.layer.masksToBounds = YES;
    [self.resignButton.layer setBorderWidth:1];
    [self.resignButton.layer setBorderColor:[UIColor colorWithRed:63/255.0 green:171/255.0 blue:244/255.0 alpha:1].CGColor];
}

#pragma mark -
#pragma mark - 点击事件
- (IBAction)sure:(id)sender {
//    SureResponsController *sureVC = [[SureResponsController alloc]init];
    //若没有签名
    if (signatureView.lblSignature.superview == signatureView) {
        [self dismissViewControllerAnimated:YES completion:nil];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请签名!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIImage *image = [[UIImage alloc]init];
    image = [[signatureView getSignatureImage]resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1) resizingMode:UIImageResizingModeStretch];
    if (self.delegate && [_delegate respondsToSelector:@selector(passSignImage:)]) {
        [_delegate passSignImage:image];
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)resign:(id)sender {
     [signatureView clearSignature];  //清空画布
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设置屏幕为横屏
- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
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
