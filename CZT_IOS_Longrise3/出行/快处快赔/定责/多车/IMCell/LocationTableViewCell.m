//
//  LocationTableViewCell.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/8.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "LocationTableViewCell.h"
#import "Location.h"
#import "LocationFrame.h"

@interface LocationTableViewCell ()
@property (nonatomic,strong)UIButton *timeBtn;
@property (nonatomic,strong)UIImageView *iconView;
@property (nonatomic,strong)UIButton *contentBtn;
@property (nonatomic,strong)UIImageView *imgView;
@end

@implementation LocationTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cell的背景色必须先设置为clearColor,否则tableView的背景会被遮住
        self.backgroundColor = [UIColor clearColor];
        
        // 1、创建时间按钮
        _timeBtn = [[UIButton alloc] init];
        [_timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = kTimeFont;
        _timeBtn.enabled = NO;
        
        [self.contentView addSubview:_timeBtn];
        
        // 2、创建头像
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        
        // 3、创建内容
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _contentBtn.titleLabel.font = kContentFont;
        _contentBtn.titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_contentBtn];
        
        // 4、初始化菊花
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:_indicator];
        
        // 5、加上一个imgView
        _imgView = [[UIImageView alloc]init];
        _imgView.image = [UIImage imageNamed:@"Location"];
        [self.contentView addSubview:_imgView];
        
    }
    return self;
}

-(void)setMessageFrame:(LocationFrame *)messageFrame{
    _messageFrame = messageFrame;
    Location *message = _messageFrame.message;
    // 1、设置时间
    if (_messageFrame.showTime) {
        [_timeBtn setBackgroundImage:[UIImage imageNamed:@"chat_timeline_bg.png"] forState:UIControlStateNormal];
        [_timeBtn setTitle:message.time forState:UIControlStateNormal];
    }
    _timeBtn.frame = _messageFrame.timeF;
    
    // 2、设置头像
    _iconView.image = [UIImage imageNamed:message.icon];
    _iconView.frame = _messageFrame.iconF;
    
    // 3、设置内容
     _contentBtn.userInteractionEnabled = NO;
//    songData = _messageFrame.message.voice;
    [_contentBtn setTitle:message.content forState:UIControlStateNormal];
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, VContentLeft + 30, kContentBottom, kContentRight);
    //设置小喇叭
//    [_contentBtn addTarget:self action:@selector(playVoice) forControlEvents:UIControlEventTouchUpInside];
    _contentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    _contentBtn.frame = _messageFrame.contentF;
    
    if (message.type == LocationTypeMe) {
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight - 8, kContentBottom, VContentLeft);
    }
    UIImage *normal = [[UIImage alloc]init];
    if (message.type == LocationTypeMe) {
        normal = [UIImage imageNamed:@"picon06.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        _indicator.center = CGPointMake(_messageFrame.contentF.origin.x - 10, _messageFrame.contentF.origin.y + _messageFrame.contentF.size.height/2);
        [_indicator startAnimating];
        _imgView.frame = CGRectMake(_messageFrame.contentF.origin.x + 2, _messageFrame.contentF.origin.y + _messageFrame.contentF.size.height/5, _messageFrame.contentF.size.height/2, _messageFrame.contentF.size.height/2);
        
    }else{
        
        normal = [UIImage imageNamed:@"picon07.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
    }
    [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
