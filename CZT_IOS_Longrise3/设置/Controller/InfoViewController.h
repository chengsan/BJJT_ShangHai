//
//  InfoViewController.h
//  CZT_IOS_Longrise
//
//  Created by Siren on 15/12/12.
//  Copyright © 2015年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicViewController.h"


typedef void(^IconImageStringBlock)(NSString *iconURLString);

@interface InfoViewController : PublicViewController
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phoneNum;

@property (nonatomic, copy) IconImageStringBlock returnUrlblock;
-(void)passIconToSetView:(IconImageStringBlock) block;
@end
