//
//  AccidentPhotoViewController.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 15/12/18.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "AccidentPhotoViewController.h"
#import "AccidentPhotoTableViewCell.h"
#import "CZT_IOS_Longrise.pch"

@interface AccidentPhotoViewController ()<UITableViewDataSource,UITableViewDelegate>{
    FVCustomAlertView * alertView;
}

@property (nonatomic,strong)NSMutableArray *dataList;

@property (weak, nonatomic) IBOutlet UITableView *PhotoTableView;
@end

@implementation AccidentPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadData];
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
    self.title = @"事故影像";
    [_PhotoTableView registerNib:[UINib nibWithNibName:@"AccidentPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"accidentCell"];
}

#pragma mark -
#pragma mark - 展示数据
-(void)loadData{
    _dataList = [NSMutableArray array];
    if (nil != _dataListDic) {
        NSArray *accidentimagelist = _dataListDic[@"accidentimagelist"];
            for (NSDictionary *dic1 in accidentimagelist) {
                [_dataList addObject:dic1];
            }
            [_PhotoTableView reloadData];
        }
}

#pragma mark - 
#pragma mark - tableView代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccidentPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accidentCell" forIndexPath:indexPath];
    NSDictionary *dic = _dataList[indexPath.row];
    [cell.carPhotoImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]]placeholderImage:[UIImage imageNamed:@"loadingPhoto"]];
    if ([dic[@"imagetypename"]isEqual:@""]) {
        cell.photoLocationLabel.text = @"其它现场照片";
    }else{
        cell.photoLocationLabel.text = dic[@"imagetypename"];
    }
    
    return cell;
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
