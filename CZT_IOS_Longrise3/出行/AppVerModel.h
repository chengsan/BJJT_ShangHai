//
//  AppVerModel.h
//  KCKPLeader
//
//  Created by Siren on 15/12/4.
//  Copyright © 2015年 程三. All rights reserved.
//

#import <BJJT_Lib/JSONModel.h>

@interface AppVerModel : JSONModel
@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *upgrade;
@property (nonatomic, copy) NSString *appversion;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *creator;
@property (nonatomic, copy) NSString *updater;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *beanname;


@end
