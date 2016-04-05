//
//  HistoryCaseViewController.m
//  CZT_IOS_Longrise
//
//  Created by 程三 on 15/12/7.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "HistoryCaseViewController.h"
#import "HistoryModel.h"
#import "HistoryTableViewCell.h"
#import "CaseDetailViewController.h"
#import "SGCLViewController.h"
#import "InsuranceReportController.h"
#import "CZT_IOS_Longrise.pch"
#import "WaitPayViewController.h"
#import "JudgeViewController.h"

@interface HistoryCaseViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,CellPush>{
    FVCustomAlertView *alertView;
}
@property (nonatomic,strong)NSMutableArray *dataList;
@property (weak, nonatomic) IBOutlet UITableView *htTableView;
@property (nonatomic,strong)NSMutableDictionary *historyDic;
@end

@implementation HistoryCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // [self requestData];
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
#pragma mark - 配置界面
-(void)configUI{
    //添加下拉刷新
    _dataList = [NSMutableArray array];
    
    self.title = @"历史案件";
    [_htTableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"historyCell"];
    [self addRefresh];
    [self requestData];
    
    //监听回调通知 如果监听到通知则刷新历史记录列表
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData:) name:@"refreshHistory" object:nil];
}

//通知回调方法
-(void)refreshData:(NSNotification *)notify{
    NSString *str = notify.object;
    if ([str isEqualToString:@"1"]) {
        [_dataList removeAllObjects];
        [self requestData];
    }
}
#pragma mark -
#pragma mark - 添加下拉刷新
-(void)addRefresh{
    // __block HistoryCaseViewController *blockSelf = self;
    _htTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //[blockSelf.htTableView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_htTableView.mj_header endRefreshing];
        });
    }];
}

#pragma mark -
#pragma mark - 数据请求
-(void)requestData{
    // NSString *ServiceUrl = @"http://192.168.3.229:86/KCKP/restservices/kckpzcslrest/";
    
    alertView = [[FVCustomAlertView alloc] init];
    [alertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
    [self.view addSubview:alertView];
    
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    
    NSDictionary *loginDic = [Globle getInstance].loginInfoDic;
    NSDictionary *userDic = [loginDic valueForKey:@"userinfo"];
    _telephone = [userDic valueForKey:@"mobilephone"];
    [bean setValue:_telephone forKey:@"telephone"];
    [bean setValue:[Globle getInstance].loadDataName forKey:@"username"];
    [bean setValue:[Globle getInstance].loadDataPass forKey:@"password"];
    
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[NSString stringWithFormat:@"%@/zdsearchallcase",kckpzcslrest] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        NSDictionary *dic = result;
        if ([dic[@"restate"]isEqualToString:@"0"]) {
            if (nil != dic[@"data"]) {
                NSArray *array = dic[@"data"];
                if (![dic[@"data"]isEqual:@""]) {
                    for (NSDictionary * dic in array) {
                        HistoryModel *htModel = [[HistoryModel alloc]initWithDictionary:dic];
                        if (htModel.state != 7) {
                            [_dataList addObject:htModel];
                        }
                    }
                    [_htTableView reloadData];
                }else{
                    
                    [self showAlertViewWith:@"没有历史记录！"];
                }
                
            }else{
                [self showAlertViewWith:@"没有历史记录！"];
            }
            
        }else{
            [self showAlertViewWith:@"加载数据失败，请检查网络！"];
            
        }
        [alertView dismiss];
        
        
    }];
}


#pragma mark -
#pragma mark - 代理方法

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    if (_dataList.count > indexPath.row) {
        HistoryModel *model = _dataList[indexPath.row];
        cell.model = model;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_dataList.count > indexPath.row) {
        HistoryModel *model = _dataList[indexPath.row];
        CaseDetailViewController *CDVC = [[CaseDetailViewController alloc]init];
        CDVC.historyModel = model;
        CDVC.appphone = _telephone;
        CDVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:CDVC animated:YES];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark -
#pragma mark - cell代理方法
-(void)pushNextControllerWith:(HistoryModel *)historyModel{
    //待定则状态
    if (historyModel.state == 1)
    {
        
        alertView = [[FVCustomAlertView alloc] init];
        [alertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
        [self.view addSubview:alertView];
        
        NSMutableArray *casecarlistArray = [NSMutableArray array];
        NSMutableArray *historyDescribArray = [NSMutableArray array];
        NSMutableDictionary *bean = [NSMutableDictionary dictionary];
        [bean setObject:historyModel.casenumber forKey:@"casenumber"];
        [bean setObject:_telephone forKey:@"appphone"];
        [bean setObject:[Globle getInstance].loadDataName forKey:@"username"];
        [bean setObject:[Globle getInstance].loadDataPass forKey:@"password"];
        
        [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[NSString stringWithFormat:@"%@/zdsearchcasedetailinfo",kckpzcslrest] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
            NSDictionary *bigDic = result;
            if ([bigDic[@"restate"]isEqualToString:@"0"]) {
                if (![bigDic[@"data"]isEqual:@""]) {
                    NSDictionary *dataDic = bigDic[@"data"];
                    NSArray *dataArray = dataDic[@"casecarlist"];
                    for (NSDictionary *dic in dataArray) {
                        [casecarlistArray addObject:dic];
                    }
                    [casecarlistArray addObject:historyModel.casecarno];
                    [historyDescribArray addObject:dataDic[@"accidenttype"]];
                    [historyDescribArray addObject:dataDic[@"accidentdes"]];
                    
                }else{
                    [self showAlertViewWith:@"加载失败，请确认网络是否开启！"];
                }
                
            }else{
                [self showAlertViewWith:@"加载失败，请确认网络是否开启！"];
            }
            
            [alertView dismiss];
        }];
        
        SGCLViewController *SGL = [[SGCLViewController alloc]init];
        SGL.currentMark = 1;
        SGL.appcaseno = historyModel.appcaseno;
        if (historyModel.casetype == 0) {
            SGL.type = 1;
            
        }else{
            
            SGL.type = 2;
            SGL.moreHistoryToResponsArray = [NSMutableArray array];
            SGL.moreHistoryToResponsArray = casecarlistArray;
            SGL.historyDescribArray = [NSMutableArray array];
            SGL.historyDescribArray = historyDescribArray;
        }
        
        
        SGL.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:SGL animated:YES];
        
    }
    //待保险报案
    else if (historyModel.state == 2)
    {
        
        FVCustomAlertView *alertView1 = [[FVCustomAlertView alloc]init];
        [alertView1 showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
        [self.view addSubview:alertView1];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Insurance" bundle:nil];
        InsuranceReportController *InReVC = [storyboard instantiateViewControllerWithIdentifier:@"InsuranceReport"];
        
        NSMutableDictionary *bean = [NSMutableDictionary dictionary];
        [bean setValue:historyModel.casenumber forKey:@"casenumber"];
        [bean setValue:_telephone forKey:@"appphone"];
        [bean setValue:[Globle getInstance].loadDataName forKey:@"username"];
        [bean setValue:[Globle getInstance].loadDataPass forKey:@"password"];
        [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[NSString stringWithFormat:@"%@/zdsearchcasedetailinfo",kckpzcslrest] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
            NSDictionary *reDic = result;
            if ([reDic[@"restate"]isEqualToString:@"0"]) {
                if (![reDic[@"data"]isEqual:@""]) {
                    NSArray *array = reDic[@"data"][@"casecarlist"];
                    for (NSDictionary *dic in array) {
                        if ([dic[@"casecarno"]isEqualToString:historyModel.casecarno]) {
                            if ([dic[@"dutytype"]isEqualToNumber:@1]) {
                                
                                [self showAlertViewWith:@"无责信息无需处理"];
                                [alertView1 dismiss];
                                return;
                            }else{
                                NSMutableArray *casecarlistArray = [NSMutableArray array];
                                
                                for (int i = 0; i < array.count; i++) {
                                    
                                    NSMutableDictionary *dicArr = [NSMutableDictionary dictionary];
                                    NSDictionary *arrDic = array[i];
                                    if ([arrDic[@"casecarno"]isEqualToString:historyModel.casecarno]) {
                                        [dicArr setValue:arrDic[@"casecarno"] forKey:@"casecarno"];
                                        [dicArr setValue:arrDic[@"dutytype"] forKey:@"dutytype"];
                                        [dicArr setValue:arrDic[@"inscomname"] forKey:@"inscomname"];
                                        [dicArr setValue:arrDic[@"inscomcode"] forKey:@"inscomcode"];
                                        [dicArr setValue:arrDic[@"carownname"] forKey:@"carownname"];
                                        [dicArr setValue:arrDic[@"carownphone"] forKey:@"carownphone"];
                                        [dicArr setValue:arrDic[@"driverno"] forKey:@"driverno"];
                                        [dicArr setValue:arrDic[@"signimgurl"] forKey:@"signimgurl"];
                                        [dicArr setValue:arrDic[@"signdate"] forKey:@"signdate"];
                                        [casecarlistArray addObject:dicArr];
                                    }
                                }

                                for (int i = 0; i < array.count; i++) {
    
                                    NSMutableDictionary *dicArr = [NSMutableDictionary dictionary];
                                    NSDictionary *arrDic = array[i];
                                    if (![arrDic[@"casecarno"]isEqualToString:historyModel.casecarno]) {
                                        [dicArr setValue:arrDic[@"casecarno"] forKey:@"casecarno"];
                                        [dicArr setValue:arrDic[@"dutytype"] forKey:@"dutytype"];
                                        [dicArr setValue:arrDic[@"inscomname"] forKey:@"inscomname"];
                                        [dicArr setValue:arrDic[@"inscomcode"] forKey:@"inscomcode"];
                                        [dicArr setValue:arrDic[@"carownname"] forKey:@"carownname"];
                                        [dicArr setValue:arrDic[@"carownphone"] forKey:@"carownphone"];
                                        [dicArr setValue:arrDic[@"driverno"] forKey:@"driverno"];
                                        [dicArr setValue:arrDic[@"signimgurl"] forKey:@"signimgurl"];
                                        [dicArr setValue:arrDic[@"signdate"] forKey:@"signdate"];
                                        [casecarlistArray addObject:dicArr];
                                    }
                                }
                                
                                _historyDic = [NSMutableDictionary dictionary];
                                [_historyDic setValue:historyModel.appcaseno forKey:@"appcaseno"];
                                [_historyDic setValue:historyModel.casecarno forKey:@"casecarno"];
                                [_historyDic setValue:_telephone forKey:@"casetelephone"];
                                [_historyDic setValue:[NSString stringWithFormat:@"%lf",[Globle getInstance].imagelon] forKey:@"caselon"];
                                [_historyDic setValue:[NSString stringWithFormat:@"%lf",[Globle getInstance].imagelat] forKey:@"caselat"];
                                [_historyDic setValue:reDic[@"data"][@"caseaddress"] forKey:@"caseaddress"];
                                [_historyDic setValue:historyModel.casedate forKey:@"casedate"];
                                [_historyDic setValue:historyModel.inscomcode forKey:@"inscomcode"];
                                [_historyDic setValue:@"0" forKey:@"reportway"];
                                [_historyDic setValue:[Globle getInstance].areaid forKey:@"areaid"];
                                [_historyDic setValue:casecarlistArray forKey:@"casecarlist"];
                                [_historyDic setValue:[Globle getInstance].loadDataName forKey:@"username"];
                                [_historyDic setValue:[Globle getInstance].loadDataPass forKey:@"password"];
                                InReVC.historyCaseDict = _historyDic;
                                InReVC.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:InReVC animated:YES];
                                break;
                            }
                        }
                    }
                    
                    
                }else{
                    [self showAlertViewWith:reDic[@"redes"]];
                }
                
            }else{
                
                [self showAlertViewWith:@"请检查网络是否连接！"];
            }
            [alertView1 dismiss];
        }];
        
        
    }
    //待理赔
    else if (historyModel.state == 3)
    {
        [self showAlertViewWith:@"请等待理赔！"];
        
    }
    //待评价
    else if (historyModel.state == 4)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"JudgeViewSB" bundle:nil];
        JudgeViewController *JVC = [storyboard instantiateViewControllerWithIdentifier:@"JudgeViewID"];
        JVC.appcaseno = historyModel.appcaseno;
        JVC.casecarno = historyModel.casecarno;
        [self.navigationController pushViewController:JVC animated:YES];
        
    }
    //完成
    else if (historyModel.state == 5)
    {
        [self showAlertViewWith:@"案件已完成！"];
    }
    //撤销案件
    else if (historyModel.state == 6)
    {
        [self showAlertViewWith:@"案件已撤消！"];
    }
    //转现场
    else if (historyModel.state == 8)
    {
        [self showAlertViewWith:@"案件已转现场处理！"];
    }else{
        [self showAlertViewWith:@"案件已完成！"];
    }
    
}

-(void)showAlertViewWith:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:title delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
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
