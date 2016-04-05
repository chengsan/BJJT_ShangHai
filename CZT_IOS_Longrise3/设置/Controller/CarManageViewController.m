//
//  CarManageViewController.m
//  CZT_IOS_Longrise
//
//  Created by Siren on 15/12/12.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "CarManageViewController.h"
#import "AddCarViewController.h"
#import "WXTableViewCell.h"
#import "CarDetailViewController.h"
#import "AppDelegate.h"
#import "WXModel.h"
#import "CarModel.h"
#import "VerifyInfoViewController.h"
#import "CZT_IOS_Longrise.pch"

@interface CarManageViewController ()
<UITableViewDataSource,UITableViewDelegate,WXTableViewCellDelegate>
{
    UITableView *table;
    NSMutableArray *carDataArray;
    NSInteger carPage;
    NSInteger carCount;
    NSMutableDictionary *carBean;
    WXModel *wxModel;
    FVCustomAlertView *FVAlertView;
}
@end

@implementation CarManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"车辆管理";
    
    carDataArray = [NSMutableArray array];
    carBean = [NSMutableDictionary dictionary];
    carPage = 1;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [rightBtn setTitle:@"添加车辆" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBtn addTarget:self action:@selector(addCar) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refreshCarData];
        [table.mj_header endRefreshing];
        
    }];
    
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMoreCarData];
        [table.mj_footer endRefreshing];
        
    }];
    
    UINib *nib1 = [UINib nibWithNibName:@"WXTableViewCell" bundle:nil];
    [table registerNib:nib1 forCellReuseIdentifier:@"WXTableViewCell"];
    [self loadCarData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCarList:) name:@"refreshCarData" object:nil];
}

#pragma mark  监听回调方法
-(void)refreshCarList:(NSNotification *)notify{
    NSString *str = notify.object;
    if ([str isEqualToString:@"1"]) {
        [self refreshCarData];
    }
}

-(void)addCar{
    AddCarViewController *vc = [AddCarViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreatevd.
}

#pragma mark - 查询车辆列表
-(void)loadCarData{
   // carDataArray = [NSMutableArray array];
    NSDictionary *bigDic = [Globle getInstance].loginInfoDic;
  //  NSLog(@"bigdic%@",bigDic);
    NSDictionary *userdic = [bigDic objectForKey:@"userinfo"];
    NSString *token = [bigDic objectForKey:@"token"];
    NSString *userflag = [userdic objectForKey:@"userflag"];
    
    [carBean setValue:userflag forKey:@"userflag"];
    [carBean setValue:token forKey:@"token"];
    [carBean setValue:[NSNumber numberWithInteger:carPage] forKey:@"pagenum"];
    [carBean setValue:@"5" forKey:@"pagesize"];
    
   // NSLog(@"CarManagerBean%@",carBean);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *url = [NSString stringWithFormat:@"%@%@/",[Globle getInstance].wxBaseServiceURL,baseapp];
   // NSLog(@"url%@",url);
    [[Globle getInstance].service requestWithServiceIP:url ServiceName:@"appsearchcarlist" params:carBean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        
        [hud hide:YES afterDelay:0];
//        NSLog(@"result%@",result);
        if (nil != result) {
            NSDictionary *bigDic = result;
            
            carCount = [bigDic[@"count"] integerValue];
//            NSLog(@"count -> %@",bigDic[@"count"]);
            
            if (nil != bigDic) {
                if ([bigDic[@"restate"] isEqualToString:@"1"]) {
                    
                    NSString *json = [Util objectToJson:result];
//                    NSLog(@"CarManage车辆数据%@",json);
                    wxModel= [[WXModel alloc]initWithString:json error:nil];
                    //    NSLog(@"CarManage车辆模型个数%ld",wxModel.data.count);
                    [carDataArray addObjectsFromArray:wxModel.data];
                    
                }else{
                    [self showAlertView:bigDic[@"redes"]];
                }
            }
        }
        [table reloadData];
    } ];
}

#pragma mark - 刷新车辆维修记录
-(void)refreshCarData{
    
    [carDataArray removeAllObjects];
    carPage = 1;
    [carBean setValue:[NSNumber numberWithInteger:carPage] forKey:@"pagenum"];
    [self loadCarData];
}

#pragma mark - 加载更多车辆维修记录
-(void)loadMoreCarData{
    
    carPage ++;
    NSInteger totalPage = carCount/5 + 1;
    if (carPage > totalPage) {
        table.mj_footer.hidden = YES;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"没有更多数据啦";
        [hud hide:YES afterDelay:2.0];
    }
    else{
        [carBean setValue:[NSNumber numberWithInteger:carPage] forKey:@"pagenum"];
        [self loadCarData];
    }
}

#pragma mark - tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return carDataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /**
     *  车辆管理的cell可以push2个控制器
     *  点击cellpush车辆详情 点击查询健康档案push健康档案
     */
    WXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WXTableViewCell"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell.checkHealth addTarget:self action:@selector(jumpToHealth) forControlEvents:UIControlEventTouchUpInside];
    if (carDataArray.count > indexPath.section) {
        CarModel *model = carDataArray[indexPath.section];
//        cell.carVarifyStateButton.hidden = NO;
        [cell setUIWithInfo:model];
        
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130*SCALE;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarDetailViewController *vc = [CarDetailViewController new];
    if (carDataArray.count > indexPath.section) {
        CarModel *model = carDataArray[indexPath.section];
        if (nil != model.Id) {
            vc.Id = model.Id;
            vc.carType = model.cartype;
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
#pragma mark - cell的代理方法
-(void)pushToNextViewControllerWith:(NSString *)carNo and:(NSString *)VINCode and:(NSString *)engineNumber and:(NSString *)isApprove{
    
    if ([isApprove isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"车辆已经验证了!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    FVAlertView = [[FVCustomAlertView alloc] init];
    [FVAlertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
    [self.view addSubview:FVAlertView];
    
    NSMutableArray * dataList = [NSMutableArray array];
    
    NSDictionary *bigDic = [Globle getInstance].loginInfoDic;
    NSDictionary *userDic = [bigDic objectForKey:@"userinfo"];
    NSString *token = [bigDic objectForKey:@"token"];
    // NSString *str = @"WDDFH3DB0AJ541602";
    
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    [bean setValue:userDic[@"userflag"] forKey:@"userflag"];
    [bean setValue:token forKey:@"token"];
    [bean setValue:@"420111111111111111" forKey:@"areaid"];
    [bean setValue:carNo forKey:@"carno"];
    [bean setValue:VINCode forKey:@"carvin"];
    //  [bean setValue:_engineNumber forKey:@"enginenumber"];
    [bean setValue:engineNumber forKey:@"enginenumber"];
    
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].wxSericeURL ServiceName:[NSString stringWithFormat:@"%@/appcarapprove",businessapp] params:bean httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        if (nil != result) {
            NSDictionary *bigDic = result;
            if ([bigDic[@"restate"]isEqualToString:@"1"]) {
                if (![bigDic[@"data"]isEqual:@""]) {
                    NSArray *array = bigDic[@"data"];
                    
                    for (NSDictionary *dic in array) {

                        NSString *companyname = dic[@"companyname"];
                        NSString *address = dic[@"address"];
                        NSString *totalString = [NSString stringWithFormat:@"%@(%@)",companyname,address];
                        [dataList addObject:totalString];
                    }
                    VerifyInfoViewController *vc = [VerifyInfoViewController new];
                    vc.carNumber = carNo;
                    vc.VINCode = VINCode;
                    vc.engineNumber = engineNumber;
                    vc.dataArray = [NSMutableArray array];
                    vc.dataArray = dataList;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    
                    [self showAlertView:bigDic[@"redes"]];
                }
                
            }else{
                [self showAlertView:bigDic[@"redes"]];
              
            }
            
        }else{
            [self showAlertView:@"数据请求失败，请检查网络是否连接！"];
           
        }
        [FVAlertView dismiss];
    }];
    
}

-(void)showAlertView:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:title delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
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
