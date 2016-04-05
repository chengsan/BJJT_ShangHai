//
//  AppVerModel.m
//  KCKPLeader
//
//  Created by Siren on 15/12/4.
//  Copyright © 2015年 程三. All rights reserved.
//

#import "AppVerModel.h"

@implementation AppVerModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper{
    JSONKeyMapper *map = [[JSONKeyMapper alloc]initWithDictionary:@{@"des":@"description"}];
    return map;
}
@end
