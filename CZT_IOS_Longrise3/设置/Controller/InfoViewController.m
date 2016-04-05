//
//  InfoViewController.m
//  CZT_IOS_Longrise
//
//  Created by Siren on 15/12/12.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "InfoViewController.h"
#import "InfoSectionOneCell.h"
#import "InfoSectionTwoCell.h"
#import "CZT_IOS_Longrise.pch"
#import "PersonInfoModel.h"
#import "ModifyPhoneController.h"
#import "InfoSectionThreeCell.h"
#import "SetViewController.h"


@interface InfoViewController ()
<UITableViewDataSource,
UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate,UIAlertViewDelegate,ModifyPhoneControllerDElegate,UITextFieldDelegate>
{
    UITableView *table;
    NSArray *sectionTitleOne;
    NSArray *sectionTitleTwo;
    NSArray *iconAry;
    
    PersonInfoDataModel *dataModel;
    FVCustomAlertView *alertView;
    FVCustomAlertView *fvalertView;
    
    UIImageView *iconImage;//头像
    UIImage *upImage; //上传的头像
    BOOL isChanged;  //判断头像是否更改
    UIBarButtonItem *rightBarButton;//编辑按钮
    NSInteger editType;//编辑按钮 状态判定
    NSInteger photoType;
    NSString *nickName; //昵称
    NSString *realName; //真实姓名
    NSString *dirverNumber; //驾驶证号
    
    NSString *modifyPhoneNumber; //修改完后的手机号
    NSInteger cellStatusType; //修改手机号完成 判断 1 修改成功
    
    UIAlertView *backAlertView; //返回提示
}
@property (strong,nonatomic) UINavigationController *myNavtionController;
@property (nonatomic, copy) NSArray *oldriverData;
@end

@implementation InfoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    fvalertView = [[FVCustomAlertView alloc]init];
//    [fvalertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:0];
//    [self.view addSubview:fvalertView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNavgationBarItem];
    //加载UI 和数据
    [self loadUIInfomation];
    
    //加载个人信息
    [self loadPersonInfoData];
    
}

-(void)loadUIInfomation
{
    editType = -1;
    photoType = -1;
    cellStatusType = -1;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人信息";
    //    sectionTitleOne = @[@"头像",@"昵称",@"真实姓名",@"驾驶证号"];
    //    sectionTitleTwo = @[@"手机",@"微信",@"QQ",@"微博"];
    sectionTitleOne = @[@"昵称",@"真实姓名",@"驾驶证号"];
    sectionTitleTwo = @[@"手机"];
    //    iconAry = @[@"icon17",@"icon18",@"icon19",@"icon20"];
    iconAry = @[@"icon17"];
   
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:table];
    
    [table registerNib:[UINib nibWithNibName:@"InfoSectionOneCell" bundle:nil] forCellReuseIdentifier:@"InfoSectionOneCell"];
    
    [table registerNib:[UINib nibWithNibName:@"InfoSectionTwoCell" bundle:nil] forCellReuseIdentifier:@"InfoSectionTwoCell"];
    
    [table registerNib:[UINib nibWithNibName:@"InfoSectionThreeCell" bundle:nil] forCellReuseIdentifier:@"InfoSectionThreeCell"];
}

#pragma mark - NavgationBarItem
-(void)setNavgationBarItem
{
    
    rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonClick)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"public_back"] forState:UIControlStateNormal];
    backBtn.highlighted = NO;
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?20:0))
        
    {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                       target:nil action:nil];
        negativeSpacer.width = -10;//这个数值可以根据情况自由变化
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, item];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = item;
    }
}

#pragma mark - tableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1)
    {
        return 3;
    }
    else return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        InfoSectionOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoSectionOneCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLab.text = @"头像";
        iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-90, 2, 56, 56)];
        if (photoType == 0) iconImage.image = upImage;
        else [iconImage sd_setImageWithURL:[NSURL URLWithString:dataModel.photo]];
        
        iconImage.layer.cornerRadius = 28;
        iconImage.clipsToBounds = YES;
        [cell.contentView addSubview:iconImage];
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0){
            InfoSectionThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoSectionThreeCell"];
            cell.leftLabel.text = sectionTitleOne[indexPath.row];
            cell.cellIndexpath = indexPath;
            cell.rightText.delegate = self;
            cell.rightText.tag = 1000;
            if (nickName) cell.rightText.text = nickName;
            else cell.rightText.text = dataModel.showname;

            if (editType == 0)
            {
                cell.rightText.enabled = YES;
                cell.rightText.textColor = [UIColor lightGrayColor];
            }
            else
            {
                cell.rightText.enabled = NO;
                cell.rightText.textColor = [UIColor blackColor];
            }
            return cell;
        }
        else if (indexPath.row == 1){
            InfoSectionThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoSectionThreeCell"];
            cell.leftLabel.text = sectionTitleOne[indexPath.row];
            cell.cellIndexpath = indexPath;
            cell.rightText.delegate = self;
            cell.rightText.tag = 2000;
            if (realName) cell.rightText.text = realName;
            else cell.rightText.text = dataModel.name;
            
            if (editType == 0)
            {
                cell.rightText.enabled = YES;
                cell.rightText.textColor = [UIColor lightGrayColor];
            }
            else
            {
                cell.rightText.enabled = NO;
                cell.rightText.textColor = [UIColor blackColor];
            }
            return cell;
        }
        else{
            InfoSectionThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoSectionThreeCell"];
            cell.leftLabel.text = sectionTitleOne[indexPath.row];
            cell.cellIndexpath = indexPath;
            cell.rightText.delegate = self;
            cell.rightText.tag = 3000;
            if (dirverNumber.length > 15)
            {
                NSString *dirverNum = dirverNumber;
                NSMutableString *dirverNu = [NSMutableString stringWithString:dirverNum];
                [dirverNu replaceCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
                cell.rightText.text = dirverNu;
            }
            else
            {
                if (dataModel.cardno.length > 15)
                {
                    NSString *dirverNum = dataModel.cardno;
                    NSMutableString *dirverNu = [NSMutableString stringWithString:dirverNum];
                    [dirverNu replaceCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
                    cell.rightText.text = dirverNu;
                }
                else
                {
                    cell.rightText.text = dataModel.cardno;
                }
            }
            if (editType == 0)
            {
                cell.rightText.enabled = YES;
                cell.rightText.textColor = [UIColor lightGrayColor];
            }
            else
            {
                cell.rightText.enabled = NO;
                cell.rightText.textColor = [UIColor blackColor];
            }
            return cell;
        }
    }
    else{
        InfoSectionTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoSectionTwoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLab.text = sectionTitleTwo[indexPath.row];
        cell.icon.image = [UIImage imageNamed:iconAry[indexPath.row]];
        if (indexPath.row == 0) {
            if (editType == 0) cell.rightLab.textColor = [UIColor lightGrayColor];
            else cell.rightLab.textColor = [UIColor blackColor];
            if (modifyPhoneNumber)
            {
                cell.rightLab.text = modifyPhoneNumber;
            }
            else
            {
                if (dataModel != nil)
                {
                    NSString *cellphone = dataModel.mobilephone;
                    NSMutableString *phoneNum = [NSMutableString stringWithString:cellphone];
                    [phoneNum replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                    cell.rightLab.text = phoneNum;
                }
                else
                {
                    cell.rightLab.text = dataModel.mobilephone;
                }
            }
            
        }
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        return 60;
        
    }
    else return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 30;
    }
    else return 10;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return @"账号绑定";
    }
    
    else return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        if (editType == 0)
        {
            [self replaceTheIcon];

        }
        
    }
    else if(indexPath.section == 2)
    {
        if (editType == 0)
        {
//            NSDictionary *bigDic = [Globle getInstance].loginInfoDic;
//            NSDictionary *userdic = [bigDic objectForKey:@"userinfo"];
            ModifyPhoneController *cellVc = [[ModifyPhoneController alloc]init];
            cellVc.cellphoneNumber = dataModel.mobilephone;
            cellVc.delegate = self;
            [self.navigationController pushViewController:cellVc animated:YES];
        }
        
    }
    
}

#pragma mark - ScrollView代理方法
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - 编辑按钮
-(void)editButtonClick
{
    
    if ([rightBarButton.title isEqualToString:@"编辑"])
    {
        editType = 0;
        [rightBarButton setTitle:@"保存"];
        [table reloadData];
    }
    else
    {
        [self upInfomation];
    }
    
}

#pragma mark - 返回按钮
-(void)backClick
{
    if (editType == 0)
    {
        backAlertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定放弃编辑返回吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [backAlertView show];
    }
    else [self.navigationController popToRootViewControllerAnimated:YES];
        
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark - 上传修改信息
-(void)upInfomation
{
    UITextField *textField1 = (UITextField *)[self.view viewWithTag:1000];
    nickName = textField1.text;
    UITextField *textField2 = (UITextField *)[self.view viewWithTag:2000];
    realName = textField2.text;
    UITextField *textField3 = (UITextField *)[self.view viewWithTag:3000];
    dirverNumber = textField3.text;
    alertView = [[FVCustomAlertView alloc] init];
    [alertView showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
    
    upImage = [Util originImage:upImage scaleToSize:CGSizeMake(640,480)];
    NSData *_data = UIImageJPEGRepresentation(upImage, 0.9);
    NSString * encodedImageStr = [_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    encodedImageStr = [encodedImageStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    encodedImageStr = [encodedImageStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    encodedImageStr = [encodedImageStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    encodedImageStr = [encodedImageStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    encodedImageStr = [NSString stringWithFormat:@"\"%@\"",encodedImageStr];
    
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    
    NSDictionary *bigDic = [Globle getInstance].loginInfoDic;
    NSDictionary *userdic = [bigDic objectForKey:@"userinfo"];
    NSString *token = [bigDic objectForKey:@"token"];
    NSString *userflag = [userdic objectForKey:@"userflag"];
    [bean setValue:userflag forKey:@"userflag"];
    if (photoType == 0)
    {
        [bean setValue:encodedImageStr forKey:@"photo"];
    }
    else
    {
        [bean setValue:nil forKey:@"photo"];
    }
    
    [bean setValue:nickName forKey:@"showname"];
    [bean setValue:realName forKey:@"name"];
    
    //判断驾驶证号是否正确
    if (dirverNumber.length && dataModel.cardno.length)
    {
        if (dirverNumber.length != 18)
        {
            [self showAlertView:@"您输入的驾驶证号不正确！"];
            [alertView dismiss];
            return;
        }
        for (int i = 0; i < dirverNumber.length; i++)
        {
            NSString *judgeNewString = [dirverNumber substringWithRange:NSMakeRange(i, 1)];
            NSString *judgeOldString = [dataModel.cardno substringWithRange:NSMakeRange(i, 1)];
            if (![judgeNewString isEqualToString:judgeOldString] && ![judgeNewString isEqualToString:@"*"])
            {
                NSString *dirverNum = dirverNumber;
                NSMutableString *dirverNu = [NSMutableString stringWithString:dirverNum];
                [dirverNu replaceCharactersInRange:NSMakeRange(i, 1) withString:[NSString stringWithFormat:@"%@",judgeNewString]];
                dirverNumber = dirverNu;
            }
            else if ([judgeNewString isEqualToString:@"*"])
            {
                NSString *dirverNum = dirverNumber;
                NSMutableString *dirverNu = [NSMutableString stringWithString:dirverNum];
                [dirverNu replaceCharactersInRange:NSMakeRange(i, 1) withString:[NSString stringWithFormat:@"%@",judgeOldString]];
                dirverNumber = dirverNu;
            }
        }
        if (![self checkDriveNoRationality:dirverNumber])
        {
            [self showAlertView:@"驾驶证号有误！"];
            [alertView dismiss];
            return;
        }
        
    }
    
    //判断个人信息是否有修改
    if ([dirverNumber isEqualToString:dataModel.cardno]&&[nickName isEqualToString:dataModel.showname] && [realName isEqualToString:dataModel.name] && !isChanged && (cellStatusType == -1)) {
        [self showAlertView:@"没有需要修改的信息！"];
        [alertView dismiss];
        return;
    }
    isChanged = NO;
    cellStatusType = -1;
    [bean setValue:dirverNumber forKey:@"usercode"];
    [bean setValue:dirverNumber forKey:@"cardno"];
    [bean setValue:nil forKey:@"emails"];
    [bean setValue:token forKey:@"token"];
    
    [[Globle getInstance].service requestWithServiceIP:[Globle getInstance].wxBaseServiceURL ServiceName:[NSString stringWithFormat:@"%@/appusermodifyinfo",appbase] params:bean httpMethod:@"POST"resultIsDictionary:YES completeBlock:^(id result)
     {
         NSLog(@"result = %@",result);
         
         [alertView dismiss];
         if (result != nil)
         {
             if ([result[@"restate"]isEqualToString:@"1"])
             {
                 NSMutableDictionary *dataDic = result[@"data"];
                 NSMutableDictionary *dict  =[NSMutableDictionary dictionary];
                 [dict setValue:dataDic[@"photourl"] forKey:@"photo"];
                 [[NSNotificationCenter defaultCenter]postNotificationName:@"iconurl" object:nil userInfo:dict];
                 
//                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                 [userDefaults setObject:result[@"data"] forKey:@"UserInfo"];
//                 [userDefaults synchronize];
                 NSDictionary *loginInfo = [Globle getInstance].loginInfoDic;
                 NSMutableDictionary *loginInfo1 = [NSMutableDictionary new];
                 [loginInfo1 setValue:loginInfo[@"token"] forKey:@"token"];
                 [loginInfo1 setValue:dataDic forKey:@"userinfo"];
                 //将登陆信息存到本地
                 [UserDefaultsUtil saveNSUserDefaultsForObject:loginInfo1 forKey:LoginFileName];
                 
                 [rightBarButton setTitle:@"编辑"];
                 editType = 1;
                 
                 [self showAlertView:@"修改个人信息成功！"];
                 
                 [self loadPersonInfoData];
             }
             else
             {
                 [self showAlertView:result[@"redes"]];
             }
         }
         else
         {
             [self showAlertView:@"上传修改信息异常，请检查您的网络！"];
         }
     }];
}


#pragma mark - 加载个人信息
-(void)loadPersonInfoData{
    
   FVCustomAlertView *alertView1 = [[FVCustomAlertView alloc] init];
    [alertView1 showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
    [self.view addSubview:alertView1];
    NSMutableDictionary *bean = [NSMutableDictionary dictionary];
    
    NSDictionary *bigDic = [Globle getInstance].loginInfoDic;
    NSDictionary *userdic = [bigDic objectForKey:@"userinfo"];
    NSString *token = [bigDic objectForKey:@"token"];
    NSString *userflag = [userdic objectForKey:@"userflag"];
    [bean setValue:userflag forKey:@"userflag"];
    [bean setValue:token forKey:@"token"];

    
    NSString *url = [NSString stringWithFormat:@"%@%@/",[Globle getInstance].wxBaseServiceURL,baseapp];
    
    [[Globle getInstance].service requestWithServiceIP:url  ServiceName:@"appsearchpersoninfo" params:bean httpMethod:@"POST"resultIsDictionary:YES completeBlock:^(id result) {
        [alertView1 dismiss];
//        [fvalertView dismiss];
        if (nil != result) {
            
            NSLog(@"个人信息%@",[Util objectToJson:result]);
            PersonInfoModel *model = [[PersonInfoModel alloc]initWithString:[Util objectToJson:result] error:nil];
            dataModel = model.data;
            [table reloadData];
            
        }
        
    }];

    
}


#pragma mark - ModifyPhoneControllerDElegate
-(void)modifyUserPhoneNumber:(NSString *)cellPhone Status:(NSInteger)statusType
{
    modifyPhoneNumber = cellPhone;
    editType = 1;
    cellStatusType = statusType;
    [rightBarButton setTitle:@"编辑"];
    [table reloadData];
}

#pragma mark - blcok传值
-(void)passIconToSetView:(IconImageStringBlock)block
{
    //block 复给它的属性
    self.returnUrlblock = block;
}

#pragma mark - 点击头像
-(void)replaceTheIcon
{
    if (IOS8)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //相机
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePickerController animated:YES completion:^{}];
            }];
            
            [alertController addAction:defaultAction];
        }
        
        UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //相册
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [alertController addAction:cancelAction];
        
        [alertController addAction:defaultAction1];
        
        //弹出提示的action
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        UIActionSheet *sheet;
        
        // 判断是否支持相机
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            
        {
            sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
            
        }
        
        else {
            
            sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
            
        }
        
        sheet.tag = 255;
        
        [sheet showInView:self.view];
    }
    
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                    
                case 2:
                    // 取消
                    return;
                    
            }
        }
        //        else {
        //            if (buttonIndex == 0) {
        //
        //                return;
        //            } else {
        //                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //            }
        //        }
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.myNavtionController = navigationController;
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    photoType = 0;
    
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    [iconImage setImage:savedImage];
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:savedImage  cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;
    [self.myNavtionController pushViewController:imageCropVC animated:YES];
    
    
}

#pragma mark - ios7 ios8 都要调用，取消按钮的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
//    [self.myNavtionController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    iconImage.image = croppedImage;
    upImage = croppedImage;
    isChanged = YES;  //头像更改了
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)showAlertView:(NSString *)notice
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:notice delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
#pragma mark - 正则驾驶证号
- (BOOL)checkDriveNoRationality:(NSString *)rationalityString
{
    BOOL isMatch =  [Util validateIDCardNumber:rationalityString];
    return isMatch;
}
@end
