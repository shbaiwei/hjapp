//
//  RegisterViewController.m
//  HJApp
//
//  Created by Bruce He on 15/11/2.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "RegisterViewController.h"
#import "HttpEngine.h"
#import "BWCommon.h"


@interface RegisterViewController ()

@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *yzmLabel;
@property (nonatomic, strong) UILabel *pswLabel;
@property (nonatomic, strong) UILabel *psw2Label;

@property (nonatomic, strong) UIButton *yzmBtn;
@property (nonatomic, strong) UIButton *zcBtn;
@property (nonatomic,strong) UILabel *timeLimitLabel;

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *yzmTF;
@property (nonatomic, strong) UITextField *pswTF;
@property (nonatomic, strong) UITextField *psw2TF;

@property (nonatomic, strong) UIButton *getBtn;
@property (nonatomic, strong) UILabel *agreeL;
@property (nonatomic, strong) UIButton *hozonBtn;

@property (nonatomic, strong) UIImage *hqOn;
@property (nonatomic, strong) UIImage *hqOff;

@property (nonatomic, strong) UIImage *getOn;
@property (nonatomic, strong) UIImage *getOff;

@property (nonatomic, assign) BOOL hqStatus;
@property (nonatomic, assign) BOOL getStatus;

//花集协议页面
@property(nonatomic,strong)UIView*hJView;
@property(nonatomic,strong)UIView*shadowView;

@end

#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height


@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;
   // self.navigationController.navigationBarHidden=NO;
    
//    self.navigationItem.hidesBackButton=YES;
//    
//    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backLoginRegister)];
    
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self registerPage];
    
}

//-(void)backLoginRegister
//{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

- (void)keybordHide:(UITapGestureRecognizer *)tap
{
    [self.phoneTF resignFirstResponder];
    [self.yzmTF resignFirstResponder];
    [self.pswTF resignFirstResponder];
    [self.psw2TF resignFirstResponder];
    
}

- (void)registerPage
{
//    UIView *phoneV = [[UIView alloc] initWithFrame:CGRectMake(0, 58, LBVIEW_WIDTH1 , LBVIEW_HEIGHT1-58)];
//    phoneV.layer.borderColor = [[UIColor grayColor] CGColor];
//    phoneV.layer.borderWidth = 0.5;
//    [self.view addSubview:phoneV];
    
    self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.05, LBVIEW_HEIGHT1 * 0.02+10, LBVIEW_WIDTH1*0.9, LBVIEW_HEIGHT1*0.06)];
    self.phoneTF.backgroundColor = [UIColor clearColor];
    
    [self.phoneTF setBorderStyle:UITextBorderStyleLine];
    [self.phoneTF.layer setBorderWidth:1];
    [self.phoneTF.layer setBorderColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor];
    self.phoneTF.textColor = [UIColor blackColor];
    self.phoneTF.placeholder=@"手机号码";
    [self.view addSubview:self.phoneTF];
    

    
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
    [self.view addSubview:self.yzmBtn];
    
    self.timeLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.yzmBtn.bounds.size.width, 20)];
    [self.timeLimitLabel setTextColor:[UIColor whiteColor]];
    [self.timeLimitLabel setTextAlignment:NSTextAlignmentCenter];
    [self.yzmBtn addSubview:self.timeLimitLabel];
    
    
    self.yzmTF = [[UITextField alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1* 0.05, LBVIEW_HEIGHT1 * 0.15+25, LBVIEW_WIDTH1*0.9, LBVIEW_HEIGHT1*0.06)];
    self.yzmTF.backgroundColor = [UIColor clearColor];
    
    self.yzmTF.textColor = [UIColor blackColor];
    [self.yzmTF setBorderStyle:UITextBorderStyleLine];
    [self.yzmTF.layer setBorderWidth:1];
    [self.yzmTF.layer setBorderColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor];
    self.yzmTF.placeholder=@"验证码";
    [self.view addSubview:self.yzmTF];
    
    
    self.pswTF = [[UITextField alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.05, LBVIEW_HEIGHT1 * 0.23+25, LBVIEW_WIDTH1*0.9, LBVIEW_HEIGHT1*0.06)];
    self.pswTF.backgroundColor = [UIColor clearColor];
    [self.pswTF setBorderStyle:UITextBorderStyleLine];
    [self.pswTF.layer setBorderWidth:1];
    [self.pswTF.layer setBorderColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor];
    self.pswTF.textColor = [UIColor blackColor];
    self.pswTF.placeholder=@"密码";
    [self.view addSubview:self.pswTF];
    
    self.psw2TF = [[UITextField alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.05, LBVIEW_HEIGHT1 * 0.31+25, LBVIEW_WIDTH1*0.9, LBVIEW_HEIGHT1*0.06)];
    self.psw2TF.backgroundColor = [UIColor clearColor];
    [self.psw2TF setBorderStyle:UITextBorderStyleLine];
    [self.psw2TF.layer setBorderWidth:1];
    [self.psw2TF.layer setBorderColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor];
    self.psw2TF.textColor = [UIColor blackColor];
    self.psw2TF.placeholder=@"确认密码";
    [self.view addSubview:self.psw2TF];
    
    self.getBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.getBtn.frame = CGRectMake(LBVIEW_WIDTH1 * 0.05, LBVIEW_HEIGHT1*0.39+25, 24,24);
    self.getOff = [UIImage imageNamed:@"agreeG.png"];
    self.getOn = [UIImage imageNamed:@"agreeR.png"];
    self.getStatus = YES;
    [self.getBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.getBtn setBackgroundImage:self.getOff  forState:UIControlStateNormal];
    [self.view addSubview:self.getBtn];
    
    self.agreeL = [[UILabel alloc] init];
    self.agreeL.text = @"我已阅读并同意";
    self.agreeL.textAlignment=NSTextAlignmentRight;
    self.agreeL.textColor = [UIColor grayColor];
    self.agreeL.font = [UIFont systemFontOfSize:16];
    self.agreeL.frame = CGRectMake(LBVIEW_WIDTH1 * 0.10, LBVIEW_HEIGHT1*0.38+25, LBVIEW_WIDTH1*0.4, LBVIEW_HEIGHT1*0.05);
    [self.view addSubview:self.agreeL];
    
    
    UILabel*userProtocolLabel = [[UILabel alloc] init];
    userProtocolLabel.text = @"花集网用户协议";
    userProtocolLabel.textColor = [UIColor colorWithRed:37/255.0f green:119/255.0f blue:188/255.0f alpha:1];
    userProtocolLabel.font = [UIFont systemFontOfSize:16];
    userProtocolLabel.frame = CGRectMake(LBVIEW_WIDTH1*0.51, LBVIEW_HEIGHT1*0.38+25, LBVIEW_WIDTH1*0.4, LBVIEW_HEIGHT1*0.05);
    [self.view addSubview:userProtocolLabel];
    
    UIButton *userProtocol=[[UIButton alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.52, LBVIEW_HEIGHT1*0.39+25, LBVIEW_WIDTH1*0.4, LBVIEW_HEIGHT1*0.05)];
    [userProtocol addTarget:self action:@selector(userProtocolBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userProtocol];
    
    self.hozonBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //UIImage *hozonI = [UIImage imageNamed:@"zhuce.png"];
    //hozonI = [hozonI imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.hozonBtn.frame = CGRectMake(LBVIEW_WIDTH1 * 0.05, LBVIEW_HEIGHT1*0.46+25, LBVIEW_WIDTH1*0.9, LBVIEW_HEIGHT1/15);
    //[self.hozonBtn setImage:hozonI forState:UIControlStateNormal];
    [self.hozonBtn setBackgroundColor:[UIColor redColor]];
    [self.hozonBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.hozonBtn setTitle:@"注 册" forState:UIControlStateNormal];
    [self.view addSubview:self.hozonBtn];
    
    
}

-(void)userProtocolBtn
{
    
    //协议阅读界面
    _hJView=[[UIView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.1, LBVIEW_HEIGHT1*0.2, LBVIEW_WIDTH1*0.8, LBVIEW_HEIGHT1*0.6)];
    _hJView.backgroundColor=[UIColor whiteColor];
    _hJView.layer.cornerRadius=10;
    _hJView.clipsToBounds=YES;
    
//    UILabel*btnLineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, LBVIEW_HEIGHT1*0.2-1, LBVIEW_WIDTH1*0.8, 1)];
//    btnLineLabel.textColor=[UIColor grayColor];
//    [_hJView addSubview:btnLineLabel];
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, _hJView.frame.size.width-20,50)];
    label.text=@"请自觉遵守花集用户协议";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:20];
    label.textColor=[UIColor redColor];
    [_hJView addSubview:label];
    
    
    UIButton*timeBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, LBVIEW_HEIGHT1*0.55+1, LBVIEW_WIDTH1*0.8, LBVIEW_HEIGHT1*0.05-1)];
    [timeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [timeBtn setTintColor:[UIColor blackColor]];
    [timeBtn setBackgroundColor:[UIColor redColor]];
    [timeBtn addTarget:self action:@selector(accomplishReadBtn) forControlEvents:UIControlEventTouchUpInside];
    [_hJView addSubview:timeBtn];
    
    

       
    _shadowView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _shadowView.backgroundColor=[UIColor darkGrayColor];
    _shadowView.alpha=0.9;
    
    //找window
    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
    [window addSubview:_shadowView];
    [_shadowView addSubview:_hJView];
    
}
//
-(void)accomplishReadBtn
{
    [_shadowView removeFromSuperview];
    
    //[HttpEngine registerRequestUsername:@"zms" withPassword:_pswTF.text withMobile:_phoneTF.text withRegIp:@"192" withFlorist:@"true"];
}


- (void)click:(id)sender
{
    if (self.getStatus == NO) {
        [self.getBtn setBackgroundImage:self.getOff forState:UIControlStateNormal];
    } else {
        [self.getBtn setBackgroundImage:self.getOn forState:UIControlStateNormal];
    }
    self.getStatus = !self.getStatus;
}

- (void)click2:(id)sender
{
    if (self.hqStatus == NO) {
        
        return;
        //[self.yzmBtn setBackgroundImage:self.hqOn forState:UIControlStateNormal];
        //[self.yzmBtn setBackgroundColor:[UIColor redColor]];
    } else
    {
        self.hqStatus = NO;
        
        [self.yzmBtn setTitle:@"" forState:UIControlStateNormal];
        //TODO 发送验证码
        [self.yzmBtn setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
        [BWCommon verificationCode:^{
            [self.yzmBtn setBackgroundColor:[UIColor redColor]];
            [self.yzmBtn setTitle:@"获取手机验证码" forState:UIControlStateNormal];
            self.hqStatus = YES;
        } blockNo:^(id time) {
            
            [self.timeLimitLabel setText:[NSString stringWithFormat:@"%@秒后重新获取验证码",time]];
        }];
        //[self.yzmBtn setBackgroundImage:self.hqOff forState:UIControlStateNormal];
    }
    //self.hqStatus = !self.hqStatus;
}
@end
