//
//  ViewController.h
//  CZT_IOS_Longrise3
//
//  Created by 张博林 on 16/2/19.
//  Copyright © 2016年 张博林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstGuideViewController.h"
#import "SecondViewController.h"
#import "GuidePageViewController.h"

@interface ViewController : UIViewController<UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

