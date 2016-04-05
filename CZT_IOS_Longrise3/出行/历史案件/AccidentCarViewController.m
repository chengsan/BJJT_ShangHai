//
//  AccidentCarViewController.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 15/12/17.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "AccidentCarViewController.h"
#import <BJJT_Lib/Masonry.h>
#import "CZT_IOS_Longrise.pch"


@interface AccidentCarViewController ()<UIAlertViewDelegate>{
    NSString *usduty;
    NSString *otherduty;
    NSString *thirdduty;
    NSString *alertTel;
}

@end

@implementation AccidentCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.title = @"事故车辆";
    // Do any additional setup after loading the view from its nib.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        self.hidesBottomBarWhenPushed = YES;
        //self.isShowController = true;
    }
    return self;
}

//展示数据
-(void)loadData{
    
    _dataSource = [NSMutableArray array];
    NSArray *data = _dataList[@"casecarlist"];
    for (NSDictionary *dic in data) {
        [_dataSource addObject:dic];
    }
    [self setShow];
    [self getData];
}


//加载xib
-(void)setShow{
    
    self.backSrollView.contentSize = CGSizeMake(0, self.dataSource.count * 330);
    CGFloat pading = 20;
    NSArray *ietms = [[NSBundle mainBundle]loadNibNamed:@"AccidentCarViewController" owner:self options:nil];
    for (int i = 0; i < self.dataSource.count; i++)
    {
        UIView *views = ietms[i];
        [self.backSrollView addSubview:views];
        [views mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(300);
            make.left.equalTo(self.backSrollView).with.offset(0);
            make.top.mas_equalTo((views.frame.origin.x + views.frame.size.height + pading)* i +pading);
                
            make.width.mas_equalTo(self.backSrollView.mas_width);
        }];
    }
}

//展示xib的内容
- (void)getData
{
    NSDictionary *usInfoDict = [NSDictionary dictionary];
    NSDictionary *otherDict = [NSDictionary dictionary];
    NSDictionary *thirdDict = [NSDictionary dictionary];
    
    int number = 0;
    
    //单车
    if (_dataSource.count == 1)
    {
        usInfoDict  = _dataSource[0];
        
    }
    //双车
    else if (_dataSource.count == 2)
    {
        for (NSDictionary *dic in _dataSource) {
            if ([dic[@"casecarno"]isEqualToString:_casecarno]) {
                usInfoDict = dic;
                
            }else{
                otherDict = dic;
            }
        }
    }
    //三车
    else if (_dataSource.count == 3)
    {
        for (int i = 0; i < _dataSource.count; i++) {
            NSDictionary *dic = _dataSource[i];
            if ([dic[@"casecarno"]isEqualToString:_casecarno]) {
                usInfoDict = _dataSource[i];
                number = i;
            }
        }
        if (number == 0) {
            otherDict = _dataSource[1];
            thirdDict = _dataSource[2];
        }else if (number == 1){
            otherDict = _dataSource[0];
            thirdDict = _dataSource[2];
        }else if (number == 2){
            otherDict = _dataSource[0];
            thirdDict = _dataSource[1];
        }
        
    }
    
    self.usName.text = usInfoDict[@"carownname"];
    self.usCarNumber.text = usInfoDict[@"casecarno"];
    self.usCompanyName.text = usInfoDict[@"inscomname"];
    self.usPhoneNumber.text = usInfoDict[@"carownphone"];
    self.usDirverNumber.text = usInfoDict[@"driverno"];
    
    _otherName.text = otherDict[@"carownname"];
    self.otherCarNumber.text = otherDict[@"casecarno"];
    self.otherCompanyName.text = otherDict[@"inscomname"];
    self.otherPhoneNumber.text = otherDict[@"carownphone"];
    self.otherDirverNumber.text = otherDict[@"driverno"];
    
    self.thirdName.text = thirdDict[@"carownname"];
    self.thirdCarName.text = thirdDict[@"casecarno"];
    self.thirdCompanyName.text = thirdDict[@"inscomname"];
    self.thirdPhoneNumber.text = thirdDict[@"carownphone"];
    self.thirdDirverNumber.text = thirdDict[@"driverno"];

}

#pragma mark -
#pragma mark - 点击事件
- (IBAction)usClicked:(id)sender {
    //己方号码
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"你要拨打%@吗",self.usPhoneNumber.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    alertTel = _usPhoneNumber.text;
    [alert show];
}

- (IBAction)otherClicked:(id)sender {
    //他人号码
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"你要拨打%@吗",self.otherPhoneNumber.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    alertTel = _otherPhoneNumber.text;
    [alert show];
}
- (IBAction)thirdClicked:(id)sender {
    //第三方号码
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"你要拨打%@吗",self.thirdPhoneNumber.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
    alertTel = _thirdPhoneNumber.text;
    [alert show];
}

#pragma mark -
#pragma mark - alert代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",alertTel]]];
    }
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
