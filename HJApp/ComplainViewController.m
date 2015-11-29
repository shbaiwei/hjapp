//
//  ComplainViewController.m
//  HJApp
//
//  Created by Bruce He on 15/11/18.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "ComplainViewController.h"
#import "HttpEngine.h"
#import "UIImageView+WebCache.h"
#import "MyBtn.h"
#import "BigPicWebViewController.h"

@interface ComplainViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic,strong)UITableView*tableView;
@end

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height
@implementation ComplainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    [self hidesTabBar:YES];
    self.title=@"我的售后";
    [HttpEngine complainServerPage:@"1" withPageSize:@"10" completion:^(NSArray *dataArray)
    {
        _dataArray=dataArray;
        [self showTable];
    }];
    
    
}
-(void)showTable
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    _tableView.rowHeight=LBVIEW_HEIGHT1/5;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComplainServe*complain=_dataArray[indexPath.section];

    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIFont*font=[UIFont systemFontOfSize:17];
       // NSString*orderStr=[NSString stringWithFormat:@"投诉类型:%@",complain.content];
        NSString*orderStr=@"投诉类型: 产品质量";
        CGSize size=[orderStr boundingRectWithSize:CGSizeMake(LBVIEW_WIDTH1-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, LBVIEW_WIDTH1-20, size.height)];
        label.text=orderStr;
        label.font=font;
        label.textColor=[UIColor blackColor];
        [cell addSubview:label];
        
        NSArray*imageArray=[complain.images componentsSeparatedByString:@"|"];
        for (int i=0;i<imageArray.count; i++)
        {
            UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(5+i*(LBVIEW_WIDTH1-10)/4, size.height+10, (LBVIEW_WIDTH1-10)/4, LBVIEW_HEIGHT1/5-size.height-20)];
            
            [imageView sd_setImageWithURL:imageArray[i]];
            //imageView.image=[UIImage imageNamed:imageArray[i]];
            [cell addSubview:imageView];
            
            MyBtn*btn=[[MyBtn alloc]initWithFrame:CGRectMake(5+i*(LBVIEW_WIDTH1-10)/4, size.height+10, (LBVIEW_WIDTH1-10)/4, LBVIEW_HEIGHT1/5-size.height-20)];
            btn.section=indexPath.section;
            btn.tag=i;
            [btn addTarget:self action:@selector(bigPic:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            
            
        }
        
    }
    return cell;
}
//查看大图
-(void)bigPic:(MyBtn*)sender
{
    
    BigPicWebViewController*bigVC=[[BigPicWebViewController alloc]init];
    bigVC.section=sender.section;
    bigVC.row=sender.tag;
    [self.navigationController pushViewController:bigVC animated:YES];
    
}
//区头
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ComplainServe*complain=_dataArray[section];
    UIView*view=[[UIView alloc]init];
    
    UIFont*font=[UIFont systemFontOfSize:17];
    NSString*orderStr=[NSString stringWithFormat:@"订单编号:%@",complain.orderNo];
    CGSize size=[orderStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    //@property(nonatomic,copy)NSString *orderNo,*dateCreated,*images,*content;
    UILabel*orderLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, size.width, 30)];
    orderLabel.text=orderStr;
    orderLabel.font=font;
    orderLabel.textColor=[UIColor blackColor];
    [view addSubview:orderLabel];
    
    UILabel*timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(15+size.width, 5, 150, 30)];
    timeLabel.text=complain.dateCreated;
    timeLabel.font=[UIFont systemFontOfSize:13];
    timeLabel.textColor=[UIColor grayColor];
    [view addSubview:timeLabel];
    
    
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

//自定义隐藏tarbtn
-(void)hidesTabBar:(BOOL)hidden
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            if (hidden)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height, view.frame.size.width , view.frame.size.height)];
            }
            else{
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 49, view.frame.size.width, view.frame.size.height)];
                
            }
        }
        else{
            if([view isKindOfClass:NSClassFromString(@"UITransitionView")]){
                if (hidden) {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
                }
                else{
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 49 )];
                }
            }
        }
    }
    [UIView commitAnimations];
}
@end
