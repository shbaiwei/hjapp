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
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title=@"意见反馈";
    
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
    UIScrollView*scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1)];
    scrollView.contentSize=CGSizeMake(LBVIEW_WIDTH1, LBVIEW_HEIGHT1+LBVIEW_HEIGHT1/5);
    [self.view addSubview:scrollView];
    
    NSArray*nameArray=[[NSArray alloc]initWithObjects:@"姓名",@"手机号", nil];
    for (int i=0; i<2; i++)
    {
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 10+i*120, 100, 30)];
        nameLabel.text=nameArray[i];
        [scrollView addSubview:nameLabel];
        
        UITextField*field=[[UITextField alloc]initWithFrame:CGRectMake(10, 60+i*120, LBVIEW_WIDTH1-20, 50)];
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
        [scrollView addSubview:field];
    }

    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(5,270, 100, 30)];
    label.text=@"详细内容";
    [scrollView addSubview:label];
    
    UITextView*tView=[[UITextView alloc]initWithFrame:CGRectMake(10, 320, LBVIEW_WIDTH1-20, LBVIEW_HEIGHT1/5)];
    tView.layer.borderColor =[UIColor grayColor].CGColor;
    tView.layer.borderWidth =1.0;
    tView.layer.cornerRadius =5.0;
    tView.tag=3;
    [scrollView addSubview:tView];
    
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(10,350+ LBVIEW_HEIGHT1/5, LBVIEW_WIDTH1-20, 30)];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(comit) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn];
}

-(void)comit
{
    //NSLog(@"=======%@%@%@",_nameTF,_mobileTF,_contentTF);
    UITextField*field1=(UITextField*)[self.view viewWithTag:1];
    UITextField*field2=(UITextField*)[self.view viewWithTag:2];
    UITextView*tfView=(UITextView*)[self.view viewWithTag:3];
    
    [HttpEngine ideaFeedBackName:field1.text withMoblie:field2.text withContent:tfView.text];
    
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"反馈成功" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action)
                          {
                              
                          }];
    UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action)
                                 {
                                    
                                 }];
    [alert addAction:cancel];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}
@end
