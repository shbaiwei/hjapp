//
//  CooperateViewController.m
//  HJApp
//
//  Created by Bruce He on 15/11/2.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "CooperateViewController.h"
#import "HttpEngine.h"

@interface CooperateViewController ()

@end
#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height
@implementation CooperateViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title=@"商务合作";
    [self hidesTabBar:YES];
    
    [self showPage];
    

}

-(void)showPage
{
    UIScrollView*scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1)];
    scrollView.contentSize=CGSizeMake(LBVIEW_WIDTH1, LBVIEW_HEIGHT1+LBVIEW_HEIGHT1/5);
    [self.view addSubview:scrollView];
    
    NSArray*nameArray=[[NSArray alloc]initWithObjects:@"姓名＊",@"手机号＊",@"E-Mail＊",@"单位名称＊", nil];
    NSArray*fieldArray=[[NSArray alloc]initWithObjects:@"请输入您的姓名",@"请输入您的手机号码",@"请输入您的邮箱地址",@"请输入您所在单位名称", nil];
    for (int i=0; i<4; i++)
    {
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 10+i*LBVIEW_HEIGHT1/7, 100, 30)];
        nameLabel.text=nameArray[i];
        [scrollView addSubview:nameLabel];
        
        UITextField*field=[[UITextField alloc]initWithFrame:CGRectMake(10, 60+i*LBVIEW_HEIGHT1/7, LBVIEW_WIDTH1-20, 50)];
        field.borderStyle=UITextBorderStyleLine;
        field.placeholder=fieldArray[i];
        field.tag=i+1;
        [scrollView addSubview:field];
    }

    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(5, 130+3*LBVIEW_HEIGHT1/7, 100, 30)];
    label.text=@"其它信息";
    [scrollView addSubview:label];
    
    UITextView*tView=[[UITextView alloc]initWithFrame:CGRectMake(10, 160+3*LBVIEW_HEIGHT1/7, LBVIEW_WIDTH1-20, LBVIEW_HEIGHT1/5)];
    tView.layer.borderColor =[UIColor grayColor].CGColor;
    tView.layer.borderWidth =1.0;
    tView.layer.cornerRadius =5.0;
    tView.tag=5;
    [scrollView addSubview:tView];
    
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(10, LBVIEW_HEIGHT1-50, LBVIEW_WIDTH1-20, 30)];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(comit) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn];
    

}
-(void)comit
{
    UITextField*field1=(UITextField*)[self.view viewWithTag:1];
    UITextField*field2=(UITextField*)[self.view viewWithTag:2];
    UITextField*field3=(UITextField*)[self.view viewWithTag:3];
    UITextField*field4=(UITextField*)[self.view viewWithTag:4];
    UITextField*field5=(UITextField*)[self.view viewWithTag:5];
    [HttpEngine cooperateName:field1.text withMoblie:field2.text withEmail:field3.text withDanWei:field4.text withOther:field5.text withIp:@"122.192.197.71"];

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
