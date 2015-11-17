//
//  IdeaBackViewController.m
//  HJApp
//
//  Created by Bruce He on 15/11/2.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "IdeaBackViewController.h"
#import "HttpEngine.h"

@interface IdeaBackViewController ()
@property(nonatomic,copy)NSString*mobile;
//@property(nonatomic,copy)NSString*nameTF;
//@property(nonatomic,copy)NSString*mobileTF;
//@property(nonatomic,copy)NSString*contentTF;
@end

@implementation IdeaBackViewController
#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title=@"意见反馈";
    [self hidesTabBar:YES];
    
    NSString*strId=[[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
    [HttpEngine getConsumerDetailData:strId completion:^(NSArray *dataArray)
    {
        ConsumerDetail*cons=dataArray[0];
        _mobile=cons.mobile;
        [self showPage];
    }];
    
}
-(void)showPage
{
    NSArray*nameArray=[[NSArray alloc]initWithObjects:@"姓名",@"手机号", nil];
    for (int i=0; i<2; i++)
    {
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 74+i*LBVIEW_HEIGHT1/7, 100, 30)];
        nameLabel.text=nameArray[i];
        [self.view addSubview:nameLabel];
        
        UITextField*field=[[UITextField alloc]initWithFrame:CGRectMake(10, 124+i*LBVIEW_HEIGHT1/7, LBVIEW_WIDTH1-20, 50)];
        field.borderStyle=UITextBorderStyleLine;
        if (i==0)
        {
            field.placeholder=@"请输入您的姓名";
            field.tag=1;
        }
        else
        {
            field.text=_mobile;
            field.tag=2;
        }
        [self.view addSubview:field];
    }

    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(5, 194+LBVIEW_HEIGHT1/7, 100, 30)];
    label.text=@"详细内容";
    [self.view addSubview:label];
    
    UITextView*tView=[[UITextView alloc]initWithFrame:CGRectMake(10, 230+LBVIEW_HEIGHT1/7, LBVIEW_WIDTH1-20, LBVIEW_HEIGHT1/5)];
    tView.layer.borderColor =[UIColor grayColor].CGColor;
    tView.layer.borderWidth =1.0;
    tView.layer.cornerRadius =5.0;
    tView.tag=3;
    [self.view addSubview:tView];
    
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(10, LBVIEW_HEIGHT1-100, LBVIEW_WIDTH1-20, 30)];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(comit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)comit
{
    //NSLog(@"=======%@%@%@",_nameTF,_mobileTF,_contentTF);
    UITextField*field1=(UITextField*)[self.view viewWithTag:1];
    UITextField*field2=(UITextField*)[self.view viewWithTag:2];
    UITextView*tfView=(UITextView*)[self.view viewWithTag:3];
    
    [HttpEngine ideaFeedBackName:field1.text withMoblie:field2.text withContent:tfView.text];

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
