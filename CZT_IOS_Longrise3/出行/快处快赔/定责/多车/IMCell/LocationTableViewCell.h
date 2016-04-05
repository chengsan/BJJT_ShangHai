//
//  LocationTableViewCell.h
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/8.
//  Copyright © 2016年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LocationFrame;

@interface LocationTableViewCell : UITableViewCell

@property (nonatomic,strong) LocationFrame *messageFrame;

@property (nonatomic,strong)UIActivityIndicatorView *indicator;

@end
