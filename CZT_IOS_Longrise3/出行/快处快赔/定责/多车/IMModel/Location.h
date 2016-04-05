//
//  Location.h
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/8.
//  Copyright © 2016年 程三. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    LocationTypeMe = 0, //自己的消息
    LocationTypeOther = 1 //别人的消息
    
}LocationType;

@interface Location : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) LocationType type;
@property (nonatomic, assign)int isSucess;   //判断消息是否发送成功
@property (nonatomic, copy) NSString *longtime;   //发送时的时间

@property (nonatomic, copy) NSDictionary *dict;

@end
