//
//  CaseDetailViewController.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 15/12/17.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "CaseDetailViewController.h"
#import "AccidentCarViewController.h"
#import "AccidentPhotoViewController.h"
#import "FastOperateViewController.h"
#import "insuranceViewController.h"
#import "chatViewController.h"
#import "CZT_IOS_Longrise.pch"
#import "WaitPayViewController.h"
#import "HistoryModel.h"

@interface CaseDetailViewController ()<UIAlertViewDelegate>{
    FVCustomAlertView *alertView;
}
@property (weak, nonatomic) IBOutlet UILabel *caseTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accidentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accidentPlaceLabel;
@property (weak, nonatomic) IBOutlet UIView *accidentCarView;
@property (weak, nonatomic) IBOutlet UIView *accidentPhotoView;
@property (weak, nonatomic) IBOutlet UIView *fastOperateView;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIView *insuranceView;
@property (weak, nonatomic) IBOutlet UIView *chatView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (nonatomic,strong)NSDictionary *dataList;
@property (nonatomic,strong)NSMutableArray *dataListArray;
@end

@implementation CaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self addGesture];
    [self requestData];

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

#pragma mark -
#pragma mark - 配置UI
-(void)configUI{
    _accidentCarView.layer.masksToBounds = YES;
    _accidentCarView.layer.cornerRadius = 7;
    
    _accidentPhotoView.layer.masksToBounds = YES;
    _accidentPhotoView.layer.cornerRadius = 7;
    
    _fastOperateView.layer.masksToBounds = YES;
    _fastOperateView.layer.cornerRadius = 7;
    
    _payView.layer.masksToBounds = YES;
    _payView.layer.cornerRadius = 7;
    
    _insuranceView.layer.masksToBounds = YES;
    _insuranceView.layer.cornerRadius = 7;
    
    _chatView.layer.masksToBounds = YES;
    _chatView.layer.cornerRadius = 7;
    
    _titleView.layer.masksToBounds = YES;
    _titleView.layer.cornerRadius = 7;
    
    [self setTitle:@"案件详情"];
    if (_historyModel.casetype == 0) {
        _caseTypeLabel.text = @"单车";
    }else if (_historyModel.casetype == 1){
         _caseTypeLabel.text = @"双车";
    }else if (_historyModel.casetype == 2){
         _caseTypeLabel.text = @"多车";
    }
    
    NSArray *array = [_historyModel.casehaptime componentsSeparatedByString:@"."];
    NSString *timeStr = array[0];
    _accidentTimeLabel.text = timeStr;
    _accidentPlaceLabel.text = _historyModel.accidentplace;
    
    alertView = [[FVCustomAlertView alloc]init];
    [alertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
    [self.view addSubview:alertView];
}

#pragma mark -
#pragma mark - 历史记录详细信息数据请求
-(void)requestData{
    _dataList = [NSDictionary dictionary];
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setObject:_historyModel.casenumber forKey:@"casenumber"];
    [bean setObject:_appphone forKey:@"appphone"];
    [bean setObject:[Globle getInstance].loadDataName forKey:@"username"];
    [bean setObject:[Globle getInstance].loadDataPass forKey:@"password"];

    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[NSString stringWithFormat:@"%@/zdsearchcasedetailinfo",kckpzcslrest] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        NSDictionary *dic = result;
        if ([dic[@"restate"]isEqualToString:@"0"]) {
            if (![dic[@"data"]isEqual:@""]) {
                _dataList = dic[@"data"];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:dic[@"redes"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"加载失败，请确认网络是否开启！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        [alertView dismiss];
    }];
}

#pragma mark -
#pragma mark - 添加手势
-(void)addGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAccidentCar:)];
    [_accidentCarView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAccidentPhoto:)];
    [_accidentPhotoView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFastOperate:)];
    [_fastOperateView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPay:)];
    [_payView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInsurance:)];
    [_insuranceView addGestureRecognizer:tap4];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChat:)];
    [_chatView addGestureRecognizer:tap5];
}

//点击事故车辆
-(void)tapAccidentCar:(UITapGestureRecognizer *)tap{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AccidentCar" bundle:nil];
    AccidentCarViewController *araVC = [storyboard instantiateViewControllerWithIdentifier:@"accidentID"];
    if (![_dataList[@"casecarlist"]isEqual:@""]) {
        araVC.dataList = [NSMutableDictionary dictionary];
        [araVC.dataList setValue:_dataList[@"casecarlist"] forKey:@"casecarlist"];
        //NSLog(@"%@",araVC.dataList);
        araVC.casenumber = _historyModel.casenumber;
        araVC.casecarno = _historyModel.casecarno;
        araVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:araVC animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"无事故车辆信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
   
}

//点击事故影像
-(void)tapAccidentPhoto:(UITapGestureRecognizer *)tap{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AccidentPhoto" bundle:nil];
    AccidentPhotoViewController *APVC = [storyboard instantiateViewControllerWithIdentifier:@"accidentphotoID"];
    
    if (![_dataList[@"accidentimagelist"]isEqual:@""]) {
        APVC.dataListDic = [NSMutableDictionary dictionary];
        [APVC.dataListDic setValue:_dataList[@"accidentimagelist"] forKey:@"accidentimagelist"];
        APVC.casenumber = _historyModel.casenumber;
        APVC.appphone = _appphone;
        APVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:APVC animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"无事故影像信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}

//点击快处信息
-(void)tapFastOperate:(UITapGestureRecognizer *)tap{
    if ((![_dataList[@"resbookimgurl"]isKindOfClass:[NSNull class]])&&(_dataList[@"resbookimgurl"]!=nil)&&([_dataList[@"resbookimgurl"] length]>0)) {
        FastOperateViewController *FOVC = [[FastOperateViewController alloc]init];
        FOVC.resbookimgurl = _dataList[@"resbookimgurl"];
        FOVC.casenumber = _historyModel.casenumber;
        FOVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:FOVC animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"无快处信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}

//点击理赔信息
-(void)tapPay:(UITapGestureRecognizer *)tap{
    
    alertView = [[FVCustomAlertView alloc]init];
    [alertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
    [self.view addSubview:alertView];
    
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setValue:_historyModel.appcaseno forKey:@"appcaseno"];
    [bean setValue:@"3" forKey:@"msgtype"];
    [bean setValue:[Globle getInstance].loadDataName forKey:@"username"];
    [bean setValue:[Globle getInstance].loadDataPass forKey:@"password"];
    
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[NSString stringWithFormat:@"%@/zdsearchunreceivemsg",kckpzcslrest] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        if (nil != result) {
            NSDictionary *bigDic = result;
            if ([bigDic[@"restate"]isEqualToString:@"0"]) {
                
                if (![bigDic[@"data"]isEqual:@""]) {
                    NSDictionary *dic = bigDic[@"data"];
                    if (![dic isEqual:@""]) {
                        NSDictionary *msgDic = dic[@"msgdata"];
                        if (nil != msgDic) {
                            
                            NSString *insresultStr = msgDic[@"insresult"];
                            WaitPayViewController *WPVC = [[WaitPayViewController alloc]init];
                            WPVC.insresult = insresultStr;
                            WPVC.appcaseno = _historyModel.appcaseno;
                            WPVC.casecarno = _historyModel.casecarno;
                            [self.navigationController pushViewController:WPVC animated:YES];
                        }
                    }
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"暂无理赔信息!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
                
            }
            
        }else{
         
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"查询理赔信息失败" message:@"请检查网络!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        [alertView dismiss];
    }];
}

//点击保险报案信息
-(void)tapInsurance:(UITapGestureRecognizer *)tap{
    if (_historyModel.insreporttel.length > 0) {
        insuranceViewController *IVC = [[insuranceViewController alloc]init];
        IVC.hidesBottomBarWhenPushed = YES;
        IVC.casedate = _historyModel.casedate;
        IVC.insreporttel = _historyModel.insreporttel;
        [self.navigationController pushViewController:IVC animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"暂无保险报案信息!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}

//点击交警沟通记录
-(void)tapChat:(UITapGestureRecognizer *)tap{
    if ([_dataList[@"chaturl"]length]>0) {
        chatViewController *CVC = [[chatViewController alloc]init];
        CVC.chatUrl = _dataList[@"chaturl"];
        CVC.casenumber = _historyModel.casenumber;
        CVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:CVC animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"暂无沟通信息!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
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
