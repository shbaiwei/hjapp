//
//  MessageCenterViewController.m
//  HJApp
//
//  Created by Bruce He on 15/11/18.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "HttpEngine.h"
#import "MessageDetailViewController.h"

@interface MessageCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray*dataArray;
@end
#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height
@implementation MessageCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.translucent =NO;
    [self hidesTabBar:YES];
    self.title=@"消息中心";
    [HttpEngine messageCentercompletion:^(NSArray *dataArray) {
        _dataArray=dataArray;
        [self showTableView];
    }];
    
}
-(void)showTableView
{
    UITableView*tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1-64) style:UITableViewStylePlain];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*dic=_dataArray[indexPath.row];
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIFont*font=[UIFont systemFontOfSize:16];
        CGSize size=[dic[@"title"] boundingRectWithSize:CGSizeMake(LBVIEW_WIDTH1, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, size.width, 20)];
        titleLabel.text=dic[@"title"];
        titleLabel.font=font;
        titleLabel.textColor=[UIColor blackColor];
        [cell addSubview:titleLabel];
        
        UIFont*font1=[UIFont systemFontOfSize:14];
        CGSize size1=[dic[@"content"] boundingRectWithSize:CGSizeMake(LBVIEW_WIDTH1-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font1} context:nil].size;
        UILabel*contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 30, LBVIEW_WIDTH1-20, size1.height)];
        contentLabel.text=dic[@"content"];
        contentLabel.font=font1;
        contentLabel.textColor=[UIColor grayColor];
        [cell addSubview:contentLabel];
        
        UILabel*timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-160, 5, 150, 30)];
        timeLabel.text=dic[@"date_created"];
        timeLabel.font=[UIFont systemFontOfSize:14];
        timeLabel.textColor=[UIColor grayColor];
        [cell addSubview:timeLabel];
        
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*dic=_dataArray[indexPath.row];
    UIFont*font1=[UIFont systemFontOfSize:14];
    CGSize size1=[dic[@"content"] boundingRectWithSize:CGSizeMake(LBVIEW_WIDTH1-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font1} context:nil].size;
    return 40+size1.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetailViewController*messVC=[[MessageDetailViewController alloc]init];
    messVC.row=indexPath.row;
    [self.navigationController pushViewController:messVC animated:YES];

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
