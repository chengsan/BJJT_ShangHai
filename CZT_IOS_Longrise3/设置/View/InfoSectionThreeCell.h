//
//  InfoSectionThreeCell.h
//  CZT_IOS_Longrise
//
//  Created by OSch on 16/1/20.
//  Copyright © 2016年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfoSectionThreeCellDelegate <NSObject>

-(void)modifyInfomation:(NSString *)modifyInfo IndexPath:(NSIndexPath *) indexPath;

@end

@interface InfoSectionThreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UITextField *rightText;

@property (nonatomic, assign) NSIndexPath *cellIndexpath;

@property (weak, nonatomic) id<InfoSectionThreeCellDelegate> delegate;

@end
