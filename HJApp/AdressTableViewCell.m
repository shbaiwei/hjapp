//
//  AdressTableViewCell.m
//  HJApp
//
//  Created by Bruce He on 15/11/6.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "AdressTableViewCell.h"

@implementation AdressTableViewCell
@synthesize morenBtn,btnStatue;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.adressIV = [[UIImageView alloc] init];
        self.adressIV.image = [UIImage imageNamed:@"themap.png"];
        [self addSubview:self.adressIV];
        
        self.numAddressLabel=[[UILabel alloc]init];
        //self.numAddressLabel.text=@"1";
        self.numAddressLabel.font=[UIFont systemFontOfSize:12];
        self.numAddressLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.numAddressLabel];
        
        self.nameL = [[UILabel alloc] init];
        //self.nameL.text = @"Amanda";
        self.nameL.font = [UIFont systemFontOfSize:17];
        //self.nameL.backgroundColor = [UIColor grayColor];
        //self.nameL.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:self.nameL];
        [self.nameL autoresizingMask];
        
        
        self.numberL = [[UILabel alloc] init];
        //self.numberL.text = @"13453489765";
        self.numberL.font = [UIFont systemFontOfSize:17];
        //  self.numberL.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.numberL];
        
        
        self.adressL = [[UILabel alloc] init];
        //self.adressL.text = @"上海市 浦东新区 商城路618号良友大厦1403室";
        self.adressL.font = [UIFont systemFontOfSize:13];
        //self.adressL.textColor = [UIColor grayColor];
        //   self.adressL.backgroundColor = [UIColor grayColor];
        self.adressL.numberOfLines = 2;
        [self.contentView addSubview:self.adressL];
        
        
        btnStatue=NO;
        morenBtn=[[UIButton alloc] init];
        [morenBtn setImage:[UIImage imageNamed:@"maru.png"] forState:UIControlStateNormal];
        //morenBtn.imageView.image=[UIImage imageNamed:@"maru.png"];
        [morenBtn addTarget:self action:@selector(morenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:morenBtn];
        
        

        self.choiceL = [[UILabel alloc] init];
        self.choiceL.text = @"设为默认地址";
        self.choiceL.font = [UIFont systemFontOfSize:14];
        self.choiceL.alpha = 0.5;
        [self.contentView addSubview:self.choiceL];
        
        
        
        self.bjIV = [[UIImageView alloc] init];
        self.bjIV.image = [UIImage imageNamed:@"bj.png"];
        [self.contentView addSubview:self.bjIV];
        
        
        self.deleIV = [[UIImageView alloc] init];
        self.deleIV.image = [UIImage imageNamed:@"delet.png"];
        [self.contentView addSubview:self.deleIV];
        
        
        self.bjBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.bjBtn setTitle:@"编辑" forState:(UIControlStateNormal)];
        [self.bjBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        self.bjBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.bjBtn.alpha = 0.6;
        [self.contentView addSubview:self.bjBtn];
        
        
        self.deleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.deleBtn setTitle:@"删除" forState:(UIControlStateNormal)];
        [self.deleBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        self.deleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.deleBtn.alpha = 0.6;
        [self.contentView addSubview:self.deleBtn];
        
    }
    
    return self;
}

-(void)morenBtnClick:(UIButton *)sender
{
    if (btnStatue==YES) {
        [morenBtn setImage:[UIImage imageNamed:@"maru.png"] forState:UIControlStateNormal];
    }
    else{
        [morenBtn setImage:[UIImage imageNamed:@"Dg.png"] forState:UIControlStateNormal];
    }
    btnStatue=!btnStatue;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width / 5;
    CGFloat height = self.frame.size.height;
    
    self.adressIV.frame = CGRectMake(width / 5, height / 6, width /4, width /3);
    self.numAddressLabel.frame=CGRectMake(width/5.2+(width/4-width/14)/2,height / 6+height /18+height/26, width /13, width /13);
    
    
    self.nameL.frame = CGRectMake(width / 1.5, height / 6, width / 1.5, height / 5);
    self.numberL.frame = CGRectMake(width / 1.5+width /1.5, height / 6, width / 0.6, height / 5);
    
    self.adressL.frame = CGRectMake(width / 1.5, height / 2.7, width / 0.25, height / 3);
    
    morenBtn.frame = CGRectMake(width / 1.5, height / 1.25, width / 4.5, height / 7);
    self.choiceL.frame = CGRectMake(width / 1.1, height / 1.25, width *2, height / 7);
    
    self.bjIV.frame = CGRectMake(width / 1.1+width*2, height / 1.25, width / 5, height / 6.5);
    self.bjBtn.frame = CGRectMake(width / 1.1+width*2, height / 1.24, width, height / 6.5);
    
    self.deleIV.frame = CGRectMake(width / 1.1+width*2+width+width/8, height /1.23, width / 5 ,height / 6.5);
    self.deleBtn.frame = CGRectMake(width / 1.1+width*2+width+width/8, height / 1.24, width, height / 6.5);
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
