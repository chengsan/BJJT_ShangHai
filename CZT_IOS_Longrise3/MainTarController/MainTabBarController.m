//
//  MainTabBarController.m
//  CZT_IOS_Longrise
//
//  Created by 程三 on 15/11/27.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "MainTabBarController.h"

@implementation MainTabBarController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSArray *names = @[@"出行",@"维修",@"设置"];
//    NSArray *imgAry = @[@"nav01",@"nav02",@"nav03"];
//    NSArray *selectedImgAry = @[@"nav01_on",@"nav02_on",@"nav03_on"];
//    for (int i=0; i<3; i++) {
//        UINavigationController *nav = self.viewControllers[i];
//        UIViewController *vc = nav.viewControllers[0];
//        UIImage *image = [UIImage imageNamed:imgAry[i]];
//        UIImage *selectedImage = [UIImage imageNamed:selectedImgAry[i]];
//        vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:names[i] image:image selectedImage:selectedImage];
//    }
    
    NSArray *names = @[@"事故处理",@"我的"];
    NSArray *imgAry = @[@"nav01@x2",@"nav03@x2"];
    NSArray *selectedImgAry = @[@"nav01on@x2",@"nav03on@x2"];
    for (int i=0; i<2; i++) {
        UINavigationController *nav = self.viewControllers[i];
        UIViewController *vc = nav.viewControllers[0];
        UIImage *image = [UIImage imageNamed:imgAry[i]];
        UIImage *selectedImage = [UIImage imageNamed:selectedImgAry[i]];
        vc.tabBarItem = [[UITabBarItem alloc]initWithTitle:names[i] image:image selectedImage:selectedImage];
    }

    
}

@end
