//
//  FillInformationController.m
//  CZT_IOS_Longrise
//
//  Created by OSch on 15/12/3.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "FillInformationController.h"
#import "CZT_IOS_Longrise.pch"
#import "ResponsViewController.h"
#import "InfimationModel.h"

@interface FillInformationController ()<UISelectListViewDelegate,UIAlertViewDelegate>
{
    UILabel *titlelabel;
    NSString *usCities; //本方选中后的车牌省市
    NSString *otherCities; //对方选中后的车牌省市
    NSString *thirdCities; //第三方选中后的车牌省市
    
    NSString *usCompanies; //本方选中后的公司名
    NSString *otherCompanies; //对方选中后的公司名
    NSString *thirdCompanies; //第三方选中后的公司名
    
    int historyCompanyCodeIndex; //投保公司编码下标
    int usCarCitiesSelectIndex; //本方的车牌省市下标
    int otherCarCitiesSelectIndex; //对方的车牌省市下标
    int thirdCarCitiesSelectIndex; //第三方的车牌省市下标
    
    int usCompanySelectIndex; //本方的公司名下标
    int otherCompanySelectIndex; //对方的公司名下标
    int thirdCompanySelectIndex; //第三方的公司名下标
    
    NSString *usHistoryCompanyName; //历史案件跳转进来  本方车主投保公司的名字
    NSString *otherHistoryCompanyName; //历史案件跳转进来  对方车主投保公司的名字
    NSString *thirdHistoryCompanyName; //历史案件跳转进来  第三方车主投保公司的名字
    
    NSString *usHistoryCompanyCode; //历史案件跳转进来  本方车主投保公司的编码
    NSString *otherHistoryCompanyCode; //历史案件跳转进来  本对方车主投保公司的编码
    NSString *thirdHistoryCompanyCode; //历史案件跳转进来  第三方车主投保公司的编码
    
    NSString *usHistoryCarName; //历史案件跳转进来  本方车主车牌的名字
    NSString *otherHistoryCarName; //历史案件跳转进来  对方车主车牌的名字
    NSString *thirdHistoryCarName; //历史案件跳转进来  第三方车主车牌的名字
}

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableDictionary *recordValue;
@property (strong, nonatomic) NSArray *carCitiesData;
@property (strong, nonatomic) NSArray *titleName;
@property (strong, nonatomic) NSArray *ietms;
@property (strong, nonatomic) NSMutableArray *historyCount;
@end

@implementation FillInformationController
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)historyCount
{
    if (_historyCount == nil) {
        _historyCount = [NSMutableArray array];
    }
    return _historyCount;
}
- (NSArray *)carCitiesData
{
    if (_carCitiesData == nil) {
        _carCitiesData = [NSArray array];
    }
    return _carCitiesData;
}
- (NSArray *)ietms
{
    if (_ietms == nil) {
        _ietms = [NSArray array];
    }
    return _ietms;
}
- (NSArray *)titleName
{
    if (_titleName == nil) {
        _titleName = [NSArray array];
    }
    return _titleName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"填写信息";
    self.view.backgroundColor = BackColor;
    
    //设置数据
    [self setData];
    
//    [self setShowView];
    
    [self setCompanyData];
    
    
    
    //toolbar的样式
    [self setKeyBoard];
    
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)setShowView
{
    FVCustomAlertView *fvalertView = [[FVCustomAlertView alloc]init];
    [fvalertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:0];
    [self.view addSubview:fvalertView];
    self.thirdView.frame = CGRectMake(0, 0, 300, 345);
    if (self.moreHistoryToResponsArray.count)
    {
        self.backScrollView.contentSize = CGSizeMake(0, (self.moreHistoryToResponsArray.count - 1) * 370);
    }
    else
    {
        self.backScrollView.contentSize = CGSizeMake(0, self.dataSource.count * 370);
    }
    CGFloat pading = 20;
    NSArray *ietms = [[NSBundle mainBundle]loadNibNamed:@"Filecell" owner:self options:nil];
    for (int i = 0; i < 3; i++)
    {
        UIView *views = ietms[i];
        views.layer.masksToBounds = YES;
        views.layer.cornerRadius = 2;
        [self.backScrollView addSubview:views];
        [views mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(345);
            make.left.equalTo(self.backScrollView).with.offset(0);
            make.top.mas_equalTo((views.frame.origin.y + views.frame.size.height + pading)* i + pading);
            make.width.mas_equalTo(self.backScrollView.mas_width);
        }];
    }
    if ((self.moreHistoryToResponsArray.count - 1) == 3)
    {
        self.hiddenThirdView.hidden = YES;
    }
    else if ((self.moreHistoryToResponsArray.count - 1) == 2)
    {
        self.hiddenThirdView.hidden = NO;
    }
    [fvalertView dismiss];
}
- (void)setData
{
    
    
    self.deletCar.layer.borderColor=NavColor.CGColor;
    self.deletCar.layer.borderWidth = 1;
    self.deletCar.layer.masksToBounds = YES;
    
    self.titleName = @[@"本方驾驶人及车辆信息",@"对方驾驶人及车辆信息",@"其他驾驶人及车辆信息"];
    for (int i = 0; i < 2; i++) {
        [self.dataSource addObject:self.titleName[i]];
        
    }
    
    
    //车牌省市
    NSArray *cityArr = [NSArray array];
    cityArr = @[@"京",@"津",@"沪",@"渝",@"冀",@"豫",@"云",@"辽",@"黑",@"湘",@"皖",@"鲁",@"新",@"苏",@"浙",@"赣",@"鄂",@"桂",@"甘",@"晋",@"蒙",@"陕",@"吉",@"闽",@"贵",@"粤",@"青",@"藏",@"川",@"宁",@"琼"];
    
    
    NSMutableArray *citydata = [NSMutableArray array];
    for (int i = 0; i < cityArr.count; i++) {
        
        NSMutableDictionary  *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:cityArr[i] forKey:@"cities"];
        [citydata addObject:dic];
    }
    self.carCitiesData = citydata;
    
}




#pragma mark - 查询公司名
-(void)setCompanyData
{
    
    //投保公司
    NSMutableDictionary *bean1 = [[NSMutableDictionary alloc] init];
    [bean1 setValue:[Globle getInstance].loadDataName forKey:@"username"];
    [bean1 setValue:[Globle getInstance].loadDataPass forKey:@"password"];
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].serviceURL ServiceName:[NSString stringWithFormat:@"%@/zdsearchallinscompanylist",kckpzcslrest] params:bean1 httpMethod:@"POST" resultIsDictionary:YES completeBlock:^(id result) {
        
        
        if (result != nil)
        {
            [self setSeletViewCompanyData:result[@"data"]];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"查询投保公司失败，请检查您的网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } ];
    
    
}




#pragma mark - 设置button的样式
-(void)setKeyBoard
{
    //下方按钮背景View的样式
    self.toolView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.toolView.layer.borderWidth = 1;
    self.toolView.layer.masksToBounds = YES;
    
    //删除第三者车的样式
    self.deletCar.layer.borderColor=NavColor.CGColor;
    self.deletCar.layer.borderWidth = 1;
    self.deletCar.layer.masksToBounds = YES;
    
    self.nextStep.backgroundColor = NavColor;
    [self.deletCar setTitleColor:NavColor forState:UIControlStateNormal];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 61/255.0, 166/255.0, 265/255.0, 1 });
    [self.deletCar.layer setBorderColor:colorref];
    
    self.ietms = [[NSBundle mainBundle]loadNibNamed:@"Filecell" owner:self options:nil];
    
    
    
}


#pragma mark - 下一步
- (IBAction)nextstep:(id)sender {
    
    if (self.moreHistoryToResponsArray.count)
    {
        self.nextStep.enabled = YES;
        ResponsViewController *responsVC = [[ResponsViewController alloc]init];
        responsVC.hidesBottomBarWhenPushed = YES;
        [self passInfomation:responsVC];
        [self.navigationController pushViewController:responsVC animated:YES];
    }
    else
    {
        [self JudgmentInformation];
    }

    
    
}

#pragma mark - 添加或者删除第三者车
- (IBAction)delegateCar:(id)sender {
    
    
    NSString *str = [self.deletCar titleLabel].text;
    
    if ([str isEqualToString:@"添加第三者车"])
    {
        [self.dataSource addObject:[self.titleName lastObject]];
        [self.deletCar setTitle:@"删除第三者车" forState:UIControlStateNormal];
        self.backScrollView.contentSize = CGSizeMake(0, self.dataSource.count * 370);
        self.hiddenThirdView.hidden = YES;
        
    }
    else if([str isEqualToString:@"删除第三者车"])
    {
        [self.dataSource removeObjectAtIndex:2];
        [self.deletCar setTitle:@"添加第三者车" forState:UIControlStateNormal];
        self.backScrollView.contentSize = CGSizeMake(0, self.dataSource.count * 370);
        self.hiddenThirdView.hidden = NO;
        
    }
    
    
}


#pragma mark - selectList Delegate
-(void)selectListView:(UISelectListView *)selectListView index:(NSUInteger)index content:(NSDictionary *)dic
{
    if (selectListView == carSelectCities) {
        usCities = dic[@"cities"];
    }
    else if (selectListView == usSelectCompany)
    {
        usCompanies = dic[@"inscomname"];
        self.usCompanyCode = dic[@"inscomcode"];
        
    }
    else if (selectListView == otherCarSelectCities)
    {
        otherCities = dic[@"cities"];
    }
    else if (selectListView == otherSelectCompany)
    {
        otherCompanies = dic[@"inscomname"];
        self.otherCompanyCode = dic[@"inscomcode"];
    }
    else if (selectListView == thirdCarSelectCities)
    {
        thirdCities = dic[@"cities"];
    }
    else if (selectListView == thirdSelectCompany)
    {
        thirdCompanies = dic[@"inscomname"];
        self.thirdCompanyCode = dic[@"inscomcode"];
    }
    
}


#pragma mark - 添加下拉选择菜单
-(void)setSeletViewCompanyData:(NSArray *)array
{
    //加载显示的View
    [self setShowView];
    
    //车辆的省市
    [self loadUIInfomationsCompanyData:array];
    
    if (self.reciveCarNumber) {
        self.carNumber.text = [self.reciveCarNumber substringFromIndex:1];
        usCities = [self.reciveCarNumber substringToIndex:1];
        usCarCitiesSelectIndex = [self judeCarCities:usCities CarCiteiesDataArray:self.carCitiesData];
        usCompanies = self.usCompanyName;
        usCompanySelectIndex = [self judeCompanyName:self.usCompanyCode CompanyDataArray:array];
    }
    
    CGFloat top = 8;
    CGFloat left = 5;
    CGFloat bottom = 8;
    CGFloat right = 5;
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImage *backLine = [[UIImage imageNamed:@"select_line"] resizableImageWithCapInsets:insets];
    self.name.background = backLine;
    self.carBackViewLine.image = backLine;
    self.usPHBackLine.image = backLine;
    self.driverNumber.background = backLine;
    
    
    self.otherPartyName.background = backLine;
    self.otherCarBackViewLine.image = backLine;
    self.otherPartyPhoneNumber.background = backLine;
    self.otherPartyDriverNumber.background = backLine;
    
    self.thirdPartyName.background = backLine;
    self.thirdCarBackViewLine.image = backLine;
    self.thirdPartyPhoneNumber.background = backLine;
    self.thirdPartyDriverNumber.background = backLine;
    
    
    
    
    //本方 车牌号
    self.carView.userInteractionEnabled = YES;
    carSelectCities  = [[UISelectListView alloc]initWithFrame:self.carView.bounds];
    carSelectCities.currentView = self.view;
    carSelectCities.delegate = self;
    
    [carSelectCities addArray:self.carCitiesData forKey:@"cities"];
    
    if (self.reciveCarNumber || self.moreHistoryToResponsArray.count) {
        [carSelectCities setSelectIndex:usCarCitiesSelectIndex];
    }
    
    carSelectCities.backgroundColor = [UIColor whiteColor];
    [carSelectCities setIcon:[UIImage imageNamed:@"select_input"]];
    [carSelectCities setDropWidth:50];
    [self.carView addSubview:carSelectCities];
    
    usSelectCompany = [[UISelectListView alloc]initWithFrame:CGRectMake(0, 0,self.backScrollView.frame.size.width-125, self.companyView.bounds.size.height)];
    usSelectCompany.currentView = self.view;
    usSelectCompany.delegate = self;
    usSelectCompany.titleLabel.font = [UIFont systemFontOfSize:13];
    [usSelectCompany addArray:array forKey:@"inscomname"];
    if (self.moreHistoryToResponsArray.count || self.reciveCarNumber) {
        [usSelectCompany setSelectIndex:usCompanySelectIndex];
    }
    usSelectCompany.backgroundColor = [UIColor whiteColor];
    [usSelectCompany setBackgroundImage:backLine forState:UIControlStateNormal];
    [usSelectCompany setIcon:[UIImage imageNamed:@"select_input"]];
    [usSelectCompany setDropWidth:50];
    [self.companyView addSubview:usSelectCompany];
    
    
    //对方 车牌号
    otherCarSelectCities = [[UISelectListView alloc]initWithFrame:self.otherCarView.bounds];
    otherCarSelectCities.currentView = self.view;
    otherCarSelectCities.delegate = self;
    [otherCarSelectCities addArray:self.carCitiesData forKey:@"cities"];
    if (self.moreHistoryToResponsArray.count) {
        [otherCarSelectCities setSelectIndex:otherCarCitiesSelectIndex];
    }
    otherCarSelectCities.backgroundColor = [UIColor whiteColor];
    [otherCarSelectCities setIcon:[UIImage imageNamed:@"select_input"]];
    [otherCarSelectCities setDropWidth:50];
    [self.otherCarView addSubview:otherCarSelectCities];
    
    otherSelectCompany = [[UISelectListView alloc]initWithFrame:CGRectMake(0, 0, self.backScrollView.frame.size.width-125, self.otherPartyCompanyView.frame.size.height)];
    otherSelectCompany.currentView = self.view;
    otherSelectCompany.delegate = self;
    [otherSelectCompany addArray:array forKey:@"inscomname"];
    if (self.moreHistoryToResponsArray.count) {
        [otherSelectCompany setSelectIndex:otherCompanySelectIndex];
    }
    otherSelectCompany.backgroundColor = [UIColor whiteColor];
    [otherSelectCompany setBackgroundImage:backLine forState:UIControlStateNormal];
    [otherSelectCompany setIcon:[UIImage imageNamed:@"select_input"]];
    [otherSelectCompany setDropWidth:50];
    [self.otherPartyCompanyView addSubview:otherSelectCompany];
    
    //其他 车牌号
    thirdCarSelectCities = [[UISelectListView alloc]initWithFrame:self.thirdCarView.bounds];
    thirdCarSelectCities.currentView = self.view;
    thirdCarSelectCities.delegate = self;
    [thirdCarSelectCities addArray:self.carCitiesData forKey:@"cities"];
    if (self.moreHistoryToResponsArray.count) {
        [thirdCarSelectCities setSelectIndex:thirdCarCitiesSelectIndex];
    }
    thirdCarSelectCities.backgroundColor = [UIColor whiteColor];
    [thirdCarSelectCities setIcon:[UIImage imageNamed:@"select_input"]];
    [thirdCarSelectCities setDropWidth:50];
    [self.thirdCarView addSubview:thirdCarSelectCities];
    
    thirdSelectCompany = [[UISelectListView alloc]initWithFrame:CGRectMake(0, 0, self.backScrollView.frame.size.width-125, self.thirdPartyCompanyView.bounds.size.height)];
    thirdSelectCompany.currentView = self.view;
    thirdSelectCompany.delegate = self;
    [thirdSelectCompany addArray:array forKey:@"inscomname"];
    if (self.moreHistoryToResponsArray.count) {
        [thirdSelectCompany setSelectIndex:thirdCompanySelectIndex];
    }
    thirdSelectCompany.backgroundColor = [UIColor whiteColor];
    [thirdSelectCompany setBackgroundImage:backLine forState:UIControlStateNormal];
    [thirdSelectCompany setIcon:[UIImage imageNamed:@"select_input"]];
    [thirdSelectCompany setDropWidth:50];
    [self.thirdPartyCompanyView addSubview:thirdSelectCompany];
    
    
    
}


- (void)loadUIInfomationsCompanyData:(NSArray *)array
{
    
    
    
    if (self.moreHistoryToResponsArray != nil)
    {
        NSString *carString = [self.moreHistoryToResponsArray lastObject];
        
        NSDictionary *usInfoDict = [NSDictionary dictionary];
        NSDictionary *otherDict = [NSDictionary dictionary];
        NSDictionary *thirdDict = [NSDictionary dictionary];
        
        if (self.moreHistoryToResponsArray.count == 3)
        {
            NSDictionary *dict = self.moreHistoryToResponsArray[0];
            if ([carString isEqualToString:dict[@"casecarno"]]) {
                usInfoDict = self.moreHistoryToResponsArray[0];
                otherDict = self.moreHistoryToResponsArray[1];
            }
            else
            {
                usInfoDict = self.moreHistoryToResponsArray[1];
                otherDict = self.moreHistoryToResponsArray[0];
            }
            
        }
        else 
        {
            int number = 0;
            for (int i = 0; i < self.moreHistoryToResponsArray.count - 1; i++)
            {
                NSDictionary *dict = self.moreHistoryToResponsArray[i];
                if ([carString isEqualToString:dict[@"casecarno"]]) {
                    usInfoDict = self.moreHistoryToResponsArray[i];
                    number = i;
                }
            }
            if (number == 0)
            {
                otherDict = self.moreHistoryToResponsArray[1];
                thirdDict = self.moreHistoryToResponsArray[2];
            }
            else if (number == 1)
            {
                otherDict = self.moreHistoryToResponsArray[0];
                thirdDict = self.moreHistoryToResponsArray[2];
            }
            else
            {
                otherDict = self.moreHistoryToResponsArray[0];
                thirdDict = self.moreHistoryToResponsArray[1];
            }
        }
        
        // NSLog(@"-----------------------%@",usInfoDict);
        
        self.name.text = usInfoDict[@"carownname"];
        self.carNumber.text = [usInfoDict[@"casecarno"] substringFromIndex:1];
        usHistoryCarName = usInfoDict[@"casecarno"];
        usCarCitiesSelectIndex = [self judeCarCities:[usInfoDict[@"casecarno"] substringToIndex:1] CarCiteiesDataArray:self.carCitiesData];
        usCompanySelectIndex = [self judeCompanyName:usInfoDict[@"inscomcode"] CompanyDataArray:array];
        
        usHistoryCompanyCode = array[usCompanySelectIndex][@"inscomcode"];
        usHistoryCompanyName = usInfoDict[@"inscomname"];
        self.phoneNumber.text = usInfoDict[@"carownphone"];
        self.driverNumber.text = usInfoDict[@"driverno"];
        
        self.otherPartyName.text = otherDict[@"carownname"];
        otherHistoryCarName = otherDict[@"casecarno"];
        self.otherCarNumber.text = [otherDict[@"casecarno"] substringFromIndex:1];
        otherCarCitiesSelectIndex = [self judeCarCities:[otherDict[@"casecarno"] substringToIndex:1] CarCiteiesDataArray:self.carCitiesData];
        otherCompanySelectIndex = [self judeCompanyName:otherDict[@"inscomcode"] CompanyDataArray:array];
        otherHistoryCompanyCode = array[otherCompanySelectIndex][@"inscomcode"];
        otherHistoryCompanyName = otherDict[@"inscomname"];
        self.otherPartyPhoneNumber.text = otherDict[@"carownphone"];
        self.otherPartyDriverNumber.text = otherDict[@"driverno"];
        
        self.thirdPartyName.text = thirdDict[@"carownname"];
        thirdHistoryCarName = thirdDict[@"casecarno"];
        self.thirdCarNumber.text = [thirdDict[@"casecarno"] substringFromIndex:1];
        thirdCarCitiesSelectIndex = [self judeCarCities:[thirdDict[@"casecarno"] substringToIndex:1] CarCiteiesDataArray:self.carCitiesData];
        thirdCompanySelectIndex = [self judeCompanyName:thirdDict[@"inscomcode"] CompanyDataArray:array];
        thirdHistoryCompanyCode = array[thirdCompanySelectIndex][@"inscomcode"];
        thirdHistoryCompanyName = thirdDict[@"inscomname"];
        self.thirdPartyPhoneNumber.text = thirdDict[@"carownphone"];
        self.thirdPartyDriverNumber.text = thirdDict[@"driverno"];
        
    }
    NSDictionary *userinfo = [[Globle getInstance].loginInfoDic objectForKey:@"userinfo"];
    self.phoneNumber.text = userinfo[@"mobilephone"];
    
    [self.historyCount addObjectsFromArray:self.moreHistoryToResponsArray];
    [self.historyCount removeLastObject];
}

#pragma mark - 判断车主信息的保险公司名下标
- (int)judeCompanyName:(NSString *)companyName CompanyDataArray:(NSArray *)array
{
    int number = 0;
    for (int i = 0; i < array.count ; i++)
    {
        if ([companyName isEqualToString:array[i][@"inscomcode"]])
        {
            number = i;
            historyCompanyCodeIndex = i;
        }
    }
    
    return number;
    
}

#pragma mark - 判断车主车牌号的下标
- (int)judeCarCities:(NSString *)carName CarCiteiesDataArray:(NSArray *)array
{
    int number = 0;
    for (int i = 0; i < array.count ; i++)
    {
        if ([carName isEqualToString:array[i][@"cities"]])
        {
            number = i;
        }
    }
    
    return number;
    
}

#pragma mark - 跳转下一步
- (void)JudgmentInformation
{
    
    if (self.dataSource.count == 3) {
        
        if (!self.name.text.length || !self.carNumber.text.length || !usCities || !usCompanies || !self.phoneNumber.text.length || !self.driverNumber.text.length || !self.otherPartyName.text.length || !otherCities || !otherCompanies || !self.otherCarNumber.text.length || !self.otherPartyPhoneNumber.text.length || !self.otherPartyDriverNumber.text.length || !self.thirdPartyName.text.length || !thirdCities || !thirdCompanies || !self.thirdCarNumber.text.length || !self.thirdPartyPhoneNumber.text.length || !self.thirdPartyDriverNumber.text.length || ![self checkDriveNoRationality:self.driverNumber.text]|| ![self checkDriveNoRationality:self.otherPartyDriverNumber.text]|| ![self checkDriveNoRationality:self.thirdPartyDriverNumber.text])
        {
            [self dataCountTwoJudgment];
            [self dataCountThirdJudgment];
            
        }
        else
        {
            if (self.phoneNumber.text.length != 11 || self.otherPartyPhoneNumber.text.length != 11 || self.thirdPartyPhoneNumber.text.length != 11)
            {
                [self judgmentPhoneNumberCount];
            }
            else if ([self.phoneNumber.text isEqualToString:self.otherPartyPhoneNumber.text] && [self.phoneNumber.text isEqualToString:self.thirdPartyPhoneNumber.text])
            {
                [self infomationNoticeShowAlertViewMessage:@"手机号码不能相同，请您更改！！！"];
            }
            else if ([self.carNumber.text isEqualToString:self.otherCarNumber.text] && [self.carNumber.text isEqualToString:self.thirdCarNumber.text])
            {
                [self infomationNoticeShowAlertViewMessage:@"车牌号不能相同，请您更改！！！"];
            }
            else
            {
                self.nextStep.enabled = YES;
                ResponsViewController *responsVC = [[ResponsViewController alloc]init];
                responsVC.hidesBottomBarWhenPushed = YES;
                [self passInfomation:responsVC];
                [self.navigationController pushViewController:responsVC animated:YES];
            }
            
            
            
        }
    }
    else
    {
        if (!self.name.text.length || !self.carNumber.text.length || !usCities || !usCompanies || !self.phoneNumber.text.length || !self.driverNumber.text.length || !self.otherPartyName.text.length || !otherCities || !otherCompanies || !self.otherCarNumber.text.length || !self.otherPartyPhoneNumber.text.length || !self.otherPartyDriverNumber.text.length || ![self checkDriveNoRationality:self.driverNumber.text]|| ![self checkDriveNoRationality:self.otherPartyDriverNumber.text])
        {
            [self dataCountTwoJudgment];
            
        }
        else
        {
            if (self.phoneNumber.text.length != 11 || self.otherPartyPhoneNumber.text.length != 11)
            {
                [self judgmentPhoneNumberCount];
            }
            else if ([self.phoneNumber.text isEqualToString:self.otherPartyPhoneNumber.text])
            {
                [self infomationNoticeShowAlertViewMessage:@"手机号码不能相同，请您更改！！！"];
            }
            else if ([self.carNumber.text isEqualToString:self.otherCarNumber.text])
            {
                [self infomationNoticeShowAlertViewMessage:@"车牌号不能相同，请您更改！！！"];
            }
            else
            {
                self.nextStep.enabled = YES;
                ResponsViewController *responsVC = [[ResponsViewController alloc]init];
                responsVC.hidesBottomBarWhenPushed = YES;
                [self passInfomation:responsVC];
                [self.navigationController pushViewController:responsVC animated:YES];
            }
            
        }
    }
    
    
    
    
}

-(void)passInfomation:(ResponsViewController *)VC
{
    if (self.moreHistoryToResponsArray.count)
    {
        VC.dataSource = self.historyCount;
    }
    else
    {
        VC.dataSource = self.dataSource;
    }
    
    VC.describeData = self.describeData;
    VC.appcaseno = self.appcaseno;
    VC.describeString = self.describeString;
    NSLog(@"respons = %@",self.appcaseno);
    
    //本方
    
    VC.usUserName = self.name.text;
    if (self.moreHistoryToResponsArray.count)
    {
        VC.usCarNumber = usHistoryCarName;
        VC.usCompanyName = usHistoryCompanyName;
    }
    else
    {
        VC.usCarNumber = [NSString stringWithFormat:@"%@%@",usCities,self.carNumber.text];
        VC.usCompanyName = usCompanies;
    }
    
    VC.usCompanyCode = self.usCompanyCode;
    VC.usPhoneNumber = self.phoneNumber.text;
    VC.usDriverNumber = self.driverNumber.text;
    
    //对方
    
    VC.otherUserName = self.otherPartyName.text;
    if (self.moreHistoryToResponsArray.count)
    {
        VC.otherCarNumber = otherHistoryCarName;
        VC.otherCompName = otherHistoryCompanyName;
    }
    else
    {
        VC.otherCarNumber = [NSString stringWithFormat:@"%@%@",otherCities,self.otherCarNumber.text];
        VC.otherCompName = otherCompanies;
    }
    
    VC.otherCompanyCode = self.otherCompanyCode;
    VC.otherPhoneNumber = self.otherPartyPhoneNumber.text;
    VC.otherDriverNumber = self.otherPartyDriverNumber.text;
    
    //其他
    
    VC.thirdUserName = self.thirdPartyName.text;
    if (self.moreHistoryToResponsArray.count)
    {
        VC.thirdCarNumber = thirdHistoryCarName;
        VC.thirdCompName = thirdHistoryCompanyName;
    }
    else
    {
        VC.thirdCarNumber = [NSString stringWithFormat:@"%@%@",thirdCities,self.thirdCarNumber.text];
        VC.thirdCompName = thirdCompanies;
    }
    VC.thirdCompanyCode = self.thirdCompanyCode;
    VC.thirdPhoneNum = self.thirdPartyPhoneNumber.text;
    VC.thirdDriverNum = self.thirdPartyDriverNumber.text;
    
}

#pragma mark - 判断
- (void)dataCountTwoJudgment
{
    //本方
    if (!self.name.text.length) {
        [self infomationNoticeShowAlertViewMessage:@"车主姓名不能为空！"];
    }
    else if (!usCities && !self.reciveCarNumber) {
        [self infomationNoticeShowAlertViewMessage:@"车主车辆车牌号省市不能为空！"];
    }
    else if (!self.carNumber.text.length) {
        [self infomationNoticeShowAlertViewMessage:@"车主车辆车牌号不能为空！"];
    }
    else if (!usCompanies) {
        [self infomationNoticeShowAlertViewMessage:@"车主车辆投保公司不能为空！"];
    }
    else if (!self.phoneNumber.text.length) {
        [self infomationNoticeShowAlertViewMessage:@"车主电话号码不能为空！"];
        
    }
    else if (!self.driverNumber.text.length) {
        [self infomationNoticeShowAlertViewMessage:@"车主驾驶证号不能为空！"];
    }
    else if (![self checkDriveNoRationality:self.driverNumber.text])
    {
        [self infomationNoticeShowAlertViewMessage:@"驾驶证号有误！"];
    }
    
    //对方
    else if (!self.otherPartyName.text.length) {
        [self infomationNoticeShowAlertViewMessage:@"对方车主姓名不能为空！"];
    }
    else if (!otherCities) {
        [self infomationNoticeShowAlertViewMessage:@"对方车辆车牌号省市不能为空！"];
    }
    else if (!self.otherCarNumber.text.length) {
        [self infomationNoticeShowAlertViewMessage:@"对方车主车辆车牌号不能为空！"];
    }
    else if (!otherCompanies) {
        [self infomationNoticeShowAlertViewMessage:@"对方车主车辆投保公司不能为空！"];
    }
    else if (!self.otherPartyPhoneNumber.text.length) {
        [self infomationNoticeShowAlertViewMessage:@"对方车主电话号码不能为空！"];
        
    }
    else if (!self.otherPartyDriverNumber.text.length) {
        [self infomationNoticeShowAlertViewMessage:@"对方车主驾驶证号不能为空！！"];
    }
    else if (![self checkDriveNoRationality:self.otherPartyDriverNumber.text])
    {
        [self infomationNoticeShowAlertViewMessage:@"驾驶证号有误！"];
    }
    
}
- (void)dataCountThirdJudgment
{
    //第三方
    if (!self.thirdPartyName.text.length) {
        [self infomationNoticeShowAlertViewMessage:@"第三方车主姓名不能为空！"];
    }
    else if (!thirdCities) {
        [self infomationNoticeShowAlertViewMessage:@"第三方车辆车牌号省市不能为空！"];
    }
    else if (!self.thirdCarNumber.text.length) {
        [self infomationNoticeShowAlertViewMessage:@"第三方车主车辆车牌号不能为空！"];
    }
    else if (!thirdCompanies) {
        [self infomationNoticeShowAlertViewMessage:@"第三方车主电话号码不能为空！"];
    }
    else if (!self.thirdPartyPhoneNumber.text.length) {
        [self infomationNoticeShowAlertViewMessage:@"第三方车主电话号码不能为空！"];
    }
    else if (!self.thirdPartyDriverNumber.text.length) {
        [self infomationNoticeShowAlertViewMessage:@"第三方车主驾驶证号不能为空！"];
    }
    else if (![self checkDriveNoRationality:self.thirdPartyDriverNumber.text])
    {
        [self infomationNoticeShowAlertViewMessage:@"驾驶证号有误！"];
    }
    
    
}


#pragma mark - 判断电话号码是否是11位
- (void)judgmentPhoneNumberCount
{
    if (self.dataSource.count == 2)
    {
        if (self.otherPartyPhoneNumber.text.length != 11)
        {
            [self infomationNoticeShowAlertViewMessage:@"对方车主的电话号码不是11位，请仔细检查！"];
        }
        else if (self.phoneNumber.text.length != 11)
        {
            [self infomationNoticeShowAlertViewMessage:@"您的电话号码不是11位，请仔细检查！"];
        }
        
    }
    else
    {
        if (self.otherPartyPhoneNumber.text.length != 11)
        {
            [self infomationNoticeShowAlertViewMessage:@"对方车主的电话号码不是11位，请仔细检查！"];
        }
        else if (self.phoneNumber.text.length != 11)
        {
            [self infomationNoticeShowAlertViewMessage:@"您的电话号码不是11位，请仔细检查！"];
        }
        else if (self.thirdPartyPhoneNumber.text.length != 11)
        {
            [self infomationNoticeShowAlertViewMessage:@"第三方车主的电话号码不是11位，请仔细检查！"];
        }
        
    }
    
    
    
}

- (void)infomationNoticeShowAlertViewMessage:(NSString *)message
{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
}
#pragma mark - 正则驾驶证号
- (BOOL)checkDriveNoRationality:(NSString *)rationalityString
{
    BOOL isMatch =  [Util validateIDCardNumber:rationalityString];
    return isMatch;
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
