//
//  redPacketViewController.m
//  HJApp
//
//  Created by Bruce He on 15/11/29.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "redPacketViewController.h"

@interface redPacketViewController ()

@end

@implementation redPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"配送时间";
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    for (int i=0; i<_dataArray.count; i++)
    {
        NSDictionary*dic=_dataArray[i];
        NSString*str=[NSString stringWithFormat:@"%@元红包",dic[@"price"]];
        
        UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, i*50, self.view.frame.size.width, 49)];
        view.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:view];
        
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 30)];
        label.text=str;
        [view addSubview:label];
        
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
        [btn addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
        [view addSubview:btn];
        
    }
    
}

-(void)chooseSex:(UIButton*)sender
{
    NSDictionary*dic=_dataArray[sender.tag];
    NSString*str=[NSString stringWithFormat:@"%@元红包",dic[@"price"]];
    PayViewController*payVC=_payVC;
    payVC.isTagRedPacket=str;
    [self.navigationController popViewControllerAnimated:NO];
}

@end
