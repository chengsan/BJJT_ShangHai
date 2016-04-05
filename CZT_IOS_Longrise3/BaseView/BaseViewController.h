//
//  BaseViewController.h
//  CZT_IOS_Longrise
//
//  Created by 程三 on 15/11/27.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BJJT_Lib/Reachability.h>
#import <BJJT_Lib/MBProgressHUD.h>

@interface BaseViewController : UIViewController
@property (nonatomic, strong) Reachability *conn;

@end
