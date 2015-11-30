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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"忘记密码";
    
    _phone=[[UITextField alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.05, LBVIEW_HEIGHT1 * 0.02+10, LBVIEW_WIDTH1*0.9, LBVIEW_HEIGHT1*0.06)];
    [_phone.layer setBorderWidth:1];
    [_phone.layer setBorderColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor];
    _phone.placeholder=@"手机号码";
    _phone.textColor = [UIColor blackColor];
    [self.view addSubview:_phone];
    
    
    
    
    
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
    [self.view addSubview:self.yzmTF];
    
    self.timeLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.yzmBtn.bounds.size.width, 20)];
    [self.timeLimitLabel setTextColor:[UIColor whiteColor]];
    [self.timeLimitLabel setTextAlignment:NSTextAlignmentCenter];
    [self.yzmBtn addSubview:self.timeLimitLabel];
}
- (void)click2:(id)sender
{
    if (self.hqStatus == NO) {
        
        return;
        //[self.yzmBtn setBackgroundImage:self.hqOn forState:UIControlStateNormal];
        //[self.yzmBtn setBackgroundColor:[UIColor redColor]];
    } else
    {
        //TODO 发送验证码
        [HttpEngine sendMessageMoblie:_phone.text withKind:2];
        self.hqStatus = NO;
        
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
        //[self.yzmBtn setBackgroundImage:self.hqOff forState:UIControlStateNormal];
    }
    //self.hqStatus = !self.hqStatus;
}

-(void)click
{
    NSLog(@"1234");
}
@end
