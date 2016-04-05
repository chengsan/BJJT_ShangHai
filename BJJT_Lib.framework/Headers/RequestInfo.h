//
//  RequestInfo.h
//  BJJT_KEY_iOS
//
//  Created by 程三 on 16/2/18.
//  Copyright (c) 2016年 张博林. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^RequestCompelete)(id result);
@interface RequestInfo : NSObject

@property(nonatomic,copy)NSString *serviceIP;
@property(nonatomic,copy)NSString *serviceName;
@property(nonatomic,retain)NSMutableDictionary *params;
@property(nonatomic,copy)NSString *httpMethod;
@property(nonatomic,assign)BOOL *resultIsDictionary;
@property(nonatomic,copy)RequestCompelete block;

@end
