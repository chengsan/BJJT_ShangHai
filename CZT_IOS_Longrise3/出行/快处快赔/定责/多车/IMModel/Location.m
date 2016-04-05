//
//  Location.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/8.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "Location.h"

@implementation Location
-(void)setDict:(NSDictionary *)dict{
    _dict  = dict;
    
    self.icon = dict[@"icon"];
    self.content = dict[@"content"];
    self.time = dict[@"time"];
    self.type = [dict[@"type"]intValue];
    self.isSucess = [dict[@"isSucess"]intValue];
    self.longtime = dict[@"longtime"];
}
@end
