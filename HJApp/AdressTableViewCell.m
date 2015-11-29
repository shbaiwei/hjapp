//
//  AdressTableViewCell.m
//  HJApp
//
//  Created by Bruce He on 15/11/6.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "AdressTableViewCell.h"

@implementation AdressTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.adressIV = [[UIImageView alloc] init];
        self.adressIV.image = [UIImage imageNamed:@"addr-num.png"];
        [self addSubview:self.adressIV];
        
        self.numAddressLabel=[[UILabel alloc]init];
        self.numAddressLabel.font=[UIFont systemFontOfSize:12];
        self.numAddressLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.numAddressLabel];
        
        self.nameL = [[UILabel alloc] init];
        //self.nameL.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.nameL];
        [self.nameL autoresizingMask];
        
        
        self.numberL = [[UILabel alloc] init];
        self.numberL.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.numberL];
        
        
        self.adressL = [[UILabel alloc] init];
        //self.adressL.font = [UIFont systemFontOfSize:13];
        self.adressL.numberOfLines = 2;
        [self.contentView addSubview:self.adressL];
        
        
        _morenBtn=[[UIButton alloc] init];
       
        [self.contentView addSubview:_morenBtn];
        
        
        
        
        self.bjIV = [[UIImageView alloc] init];
        self.bjIV.image = [UIImage imageNamed:@"ctrl-edit.png"];
        [self.contentView addSubview:self.bjIV];
        
        
        self.deleIV = [[UIImageView alloc] init];
        self.deleIV.image = [UIImage imageNamed:@"ctrl-delete.png"];
        [self.contentView addSubview:self.deleIV];
        
        
        self.bjBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.bjBtn setTitle:@"编辑" forState:(UIControlStateNormal)];
        [self.bjBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        self.bjBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.bjBtn.alpha = 0.6;
        //[self.bjBtn setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:self.bjBtn];
        
        
        self.deleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.deleBtn setTitle:@"删除" forState:(UIControlStateNormal)];
        [self.deleBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        self.deleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.deleBtn.alpha = 0.6;
        //[self.deleBtn setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:self.deleBtn];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width / 5;
    CGFloat height = self.frame.size.height;
    
    self.adressIV.frame = CGRectMake(width / 6, height / 6, width /3, width /2);
    self.numAddressLabel.frame=CGRectMake(width/5.2+(width/4-width/14)/2,height / 6+height /18+height/26, width /13, width /13);
    
    
    self.nameL.frame = CGRectMake(width / 1.5, height / 6, width*4, height / 5);
    self.numberL.frame = CGRectMake(width / 1.5+width /1.5, height / 6, width / 0.6, height / 5);
    
    self.adressL.frame = CGRectMake(width / 1.5, height / 2.7, self.frame.size.width-width/1.5, height / 3);
    
    self.morenBtn.frame = CGRectMake(width / 1.5, height / 1.25,20, 20);
    //self.choiceL.frame = CGRectMake(width / 1.1, height / 1.25, width *2, height / 7);
    
    self.bjIV.frame = CGRectMake(width / 1.1+width*2, height / 1.25, width / 5, height / 6.5);
    self.bjBtn.frame = CGRectMake(width / 1.1+width*2, height / 1.24, width, height / 5);
    
    self.deleIV.frame = CGRectMake(width / 1.1+width*2+width+width/8, height /1.23, width / 5 ,height /6.5);
    self.deleBtn.frame = CGRectMake(width / 1.1+width*2+width+width/8, height / 1.24, width, height / 5);
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
