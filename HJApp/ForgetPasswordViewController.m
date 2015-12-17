//
//  ForgetPasswordViewController.m
//  HJApp
//
//  Created by Bruce He on 15/11/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "BWCommon.h"
#import "HttpEngine.h"


@interface ForgetPasswordViewController ()

@property(nonatomic,strong)UIButton*yzmBtn;
@property(nonatomic,strong)UITextField*phone;
@property (nonatomic, strong) UITextField *pswTF;
@property (nonatomic, strong) UITextField *psw2TF;
@property(nonatomic,strong)UITextField*yzmTF;

@property (nonatomic, strong) UIImage *hqOn;
@property (nonatomic, strong) UIImage *hqOff;

@property (nonatomic, strong) UIImage *getOn;
@property (nonatomic, strong) UIImage *getOff;

@property (nonatomic, assign) BOOL hqStatus;
@property (nonatomic, assign) BOOL getStatus;

@property (nonatomic,strong) UILabel *timeLimitLabel;
@end

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

@implementation ForgetPasswordViewController


NSString *username;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"忘记密码";
    
    _phone=[[UITextField alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.05, LBVIEW_HEIGHT1 * 0.02+10, LBVIEW_WIDTH1*0.9, LBVIEW_HEIGHT1*0.06)];
    [_phone.layer setBorderWidth:1];
    [_phone.layer setBorderColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor];
    _phone.placeholder=@"手机号码";
    _phone.textColor = [UIColor blackColor];
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(10,0,10,LBVIEW_HEIGHT1*0.06)];
    leftView.backgroundColor = [UIColor clearColor];
    _phone.leftView = leftView;
    _phone.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:_phone];
    
    
    
    username = @"";
    
    self.yzmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.yzmBtn.frame = CGRectMake(LBVIEW_WIDTH1 * 0.05, LBVIEW_HEIGHT1 *0.09+15, LBVIEW_WIDTH1*0.9, LBVIEW_HEIGHT1*0.06);
    self.hqOn = [UIImage imageNamed:@"huoqu1.png"];
    self.hqOff = [UIImage imageNamed:@"huoqu2.png"];
    self.hqStatus = YES;
    [self.yzmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.yzmBtn addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
    //[self.yzmBtn setBackgroundImage:self.hqOn forState:UIControlStateNormal];
    [self.yzmBtn setBackgroundColor:[UIColor redColor]];
    [self.yzmBtn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
    self.yzmBtn.layer.cornerRadius=5;
    self.yzmBtn.clipsToBounds=YES;
    [self.view addSubview:self.yzmBtn];
    
    
    
    self.yzmTF = [[UITextField alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1* 0.05, LBVIEW_HEIGHT1 * 0.15+25, LBVIEW_WIDTH1*0.9, LBVIEW_HEIGHT1*0.06)];
    self.yzmTF.backgroundColor = [UIColor clearColor];
    
    self.yzmTF.textColor = [UIColor blackColor];
    [self.yzmTF setBorderStyle:UITextBorderStyleLine];
    [self.yzmTF.layer setBorderWidth:1];
    [self.yzmTF.layer setBorderColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor];
    self.yzmTF.placeholder=@"验证码";
    UIView * leftView1 = [[UIView alloc] initWithFrame:CGRectMake(10,0,10,LBVIEW_HEIGHT1*0.06)];
    leftView1.backgroundColor = [UIColor clearColor];
    _yzmTF.leftView = leftView1;
    _yzmTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.yzmTF];
    
    self.timeLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.yzmBtn.bounds.size.width, 20)];
    [self.timeLimitLabel setTextColor:[UIColor whiteColor]];
    [self.timeLimitLabel setTextAlignment:NSTextAlignmentCenter];
    [self.yzmBtn addSubview:self.timeLimitLabel];
    
    
    self.pswTF = [[UITextField alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.05, LBVIEW_HEIGHT1 * 0.21+35, LBVIEW_WIDTH1*0.9, LBVIEW_HEIGHT1*0.06)];
    self.pswTF.backgroundColor = [UIColor clearColor];
    [self.pswTF setBorderStyle:UITextBorderStyleLine];
    [self.pswTF.layer setBorderWidth:1];
    [self.pswTF.layer setBorderColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor];
    self.pswTF.textColor = [UIColor blackColor];
    self.pswTF.placeholder=@"请输入新密码";
    self.pswTF.secureTextEntry=YES;
    UIView * leftView2 = [[UIView alloc] initWithFrame:CGRectMake(10,0,10,LBVIEW_HEIGHT1*0.06)];
    leftView2.backgroundColor = [UIColor clearColor];
    _pswTF.leftView = leftView2;
    _pswTF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.pswTF];
    
    self.psw2TF = [[UITextField alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.05, LBVIEW_HEIGHT1 * 0.27+45, LBVIEW_WIDTH1*0.9, LBVIEW_HEIGHT1*0.06)];
    self.psw2TF.backgroundColor = [UIColor clearColor];
    [self.psw2TF setBorderStyle:UITextBorderStyleLine];
    [self.psw2TF.layer setBorderWidth:1];
    [self.psw2TF.layer setBorderColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor];
    self.psw2TF.textColor = [UIColor blackColor];
    self.psw2TF.placeholder=@"确认密码";
    self.psw2TF.secureTextEntry=YES;
    UIView * leftView3 = [[UIView alloc] initWithFrame:CGRectMake(10,0,10,LBVIEW_HEIGHT1*0.06)];
    leftView3.backgroundColor = [UIColor clearColor];
    _psw2TF.leftView = leftView3;
    _psw2TF.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.psw2TF];
    
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1* 0.05, LBVIEW_HEIGHT1 * 0.33+55, LBVIEW_WIDTH1*0.9, LBVIEW_HEIGHT1*0.06)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius=5;
    btn.clipsToBounds=YES;
    [self.view addSubview:btn];

}
- (void)click2:(id)sender
{
    if (self.hqStatus == NO) {
        
        return;
        //[self.yzmBtn setBackgroundImage:self.hqOn forState:UIControlStateNormal];
        //[self.yzmBtn setBackgroundColor:[UIColor redColor]];
    } else
    {
        
        [HttpEngine queryUser:_phone.text with:^(NSDictionary *dict) {
            self.hqStatus = NO;
            
            username = dict[@"username"];
            
            [self.yzmBtn setTitle:@"" forState:UIControlStateNormal];
            [self.yzmBtn setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
            [BWCommon verificationCode:^{
                [self.yzmBtn setBackgroundColor:[UIColor redColor]];
                [self.yzmBtn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
                self.hqStatus = YES;
                [self.timeLimitLabel setText:@""];
            } blockNo:^(id time) {
                
                [self.timeLimitLabel setText:[NSString stringWithFormat:@"%@秒后重新获取验证码",time]];
            }];
            
            //TODO 发送验证码
            [HttpEngine sendMessageMoblie:_phone.text withKind:2];
        }
        failure:^(NSString *error){
            [self alert:error];
        }];
        
        
        
        //[self.yzmBtn setBackgroundImage:self.hqOff forState:UIControlStateNormal];
    }
    //self.hqStatus = !self.hqStatus;
}

-(void)nextPage
{
    NSString*str=[[NSUserDefaults standardUserDefaults]objectForKey:@"LPASSWORD"];
    if (![_yzmTF.text isEqualToString:str])
    {
        [self alert:@"验证码错误"];
    }
    else
    {
        [HttpEngine momodifyPasswordUser:username withPassword:_pswTF.text complete:^(NSString *fail)
        {
            if ([fail isEqualToString:@"true"])
            {
                [self alert:@"修改成功"];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [self alert:@"修改失败"];
            }
        }];
    }
}
-(void)alert:(NSString*)str
{
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:str preferredStyle: UIAlertControllerStyleAlert];
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
