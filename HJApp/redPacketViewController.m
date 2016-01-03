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
    self.title=@"红包选择";
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    for (int i=0; i<_dataArray.count; i++)
    {
        NSLog(@"_dataArray===%@",_dataArray);
        NSDictionary*dic=_dataArray[i];
        NSString*str=[NSString stringWithFormat:@"元红包(满%@可用)",dic[@"term_price"]];
        
        UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, i*50, self.view.frame.size.width, 49)];
        view.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:view];
        
        UILabel*picLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 60, 30)];
        picLabel.text=[NSString stringWithFormat:@"%@",dic[@"price"]];
        picLabel.textColor=[UIColor redColor];
        picLabel.font=[UIFont systemFontOfSize:14];
        [view addSubview:picLabel];
        
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, 250, 30)];
        label.text=str;
        label.font=[UIFont systemFontOfSize:12];
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
    int payPrice=[_payPrice intValue];
    int termPrice=[dic[@"term_price"] intValue];
    if (payPrice<termPrice)
    {
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"未达使用额度" message:nil preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                     {
                                     }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    PayViewController*payVC=_payVC;
    payVC.isTagRedPacket=dic[@"price"];
    payVC.couponNo=dic[@"prefer_no"];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
