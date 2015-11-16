//
//  UserMoneyViewController.m
//  HJApp
//
//  Created by Bruce He on 15/11/6.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "UserMoneyViewController.h"
#import "HttpEngine.h"

@interface UserMoneyViewController ()

@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *nokoLabel;
@property (nonatomic, strong) UITextField *monenyNum;
@property (nonatomic, strong) UIButton *zfbBtn;
@property (nonatomic, strong) UIButton *wechatBth;
@property (nonatomic, strong) UIButton *okBtn;



@property (nonatomic, strong) UIImage *zfbOn;
@property (nonatomic, strong) UIImage *zfbOff;

@property (nonatomic, strong) UIImage *wechatOn;
@property (nonatomic, strong) UIImage *wechatOff;

@property (nonatomic, assign) BOOL btnStatus;
@property (nonatomic, assign) BOOL btn2Status;

///////
@property(nonatomic,strong)NSDictionary*dataDic;
@property(nonatomic,unsafe_unretained)int lastTag;

@end

@implementation UserMoneyViewController

//宏定义宽高
#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账户余额";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [tapGes addTarget:self action:@selector(keybordHideAction:)];
    
    tapGes.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGes];
    
}

-(void)viewWillAppear:(BOOL)animated
{

    self.navigationController.navigationBarHidden=NO;
    [HttpEngine getBalance:^(NSDictionary *dic)
     {
        _dataDic=dic;

         [self thePage];
     }];
    

}

- (void)keybordHideAction:(UITapGestureRecognizer *)tap
{
    [self.monenyNum resignFirstResponder];
    
}

- (void)thePage
{
    self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake((LBVIEW_WIDTH1-LBVIEW_WIDTH1/1.5)/2, LBVIEW_HEIGHT1 / 6, LBVIEW_WIDTH1 / 1.5, LBVIEW_HEIGHT1 / 11)];
    // self.moneyLabel.backgroundColor = [UIColor redColor];
    self.moneyLabel.text = _dataDic[@"nmoney"];
    self.moneyLabel.textColor = [UIColor blackColor];
    self.moneyLabel.font = [UIFont systemFontOfSize:42];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.moneyLabel];
    
    self.nokoLabel = [[UILabel alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1 / 2.3, LBVIEW_HEIGHT1 / 4, LBVIEW_WIDTH1 * 0.2, LBVIEW_HEIGHT1 * 0.05)];
    // self.nokoLabel.backgroundColor = [UIColor redColor];
    self.nokoLabel.text = @"账户余额";
    self.nokoLabel.textColor = [UIColor blackColor];
    self.nokoLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.nokoLabel];
    
    self.monenyNum = [[UITextField alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1 / 13, + self.moneyLabel.frame.size.height + self.nokoLabel.frame.size.height + 120, LBVIEW_WIDTH1 / 1.2, LBVIEW_HEIGHT1 / 14)];
    self.monenyNum.backgroundColor = [UIColor clearColor];
    self.monenyNum.placeholder = @"请输入充值金额 如:10000";
    //    [self.monenyNum becomeFirstResponder];
    self.monenyNum.borderStyle = UITextBorderStyleLine;
    self.monenyNum.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.monenyNum];
    
    //button点击之后本身换成另一张图片。此处用于支付按钮的切换
    self.zfbBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.zfbBtn.frame = CGRectMake(LBVIEW_WIDTH1 / 13, + self.moneyLabel.frame.size.height + self.nokoLabel.frame.size.height + 120 + 65, LBVIEW_WIDTH1 / 2.5, LBVIEW_HEIGHT1 / 16);
    self.zfbOn = [UIImage imageNamed:@"zfbBlue.png"];
    self.zfbOff = [UIImage imageNamed:@"zfbGray.png"];
    self.zfbBtn.tag=1;
    [self.zfbBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.zfbBtn setBackgroundImage:self.zfbOn forState:UIControlStateSelected];
    [self.zfbBtn setBackgroundImage:self.zfbOff forState:UIControlStateNormal];
    [self.view addSubview:self.zfbBtn];
    
    self.wechatBth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.wechatBth.frame = CGRectMake(LBVIEW_WIDTH1 / 1.95, + self.moneyLabel.frame.size.height + self.nokoLabel.frame.size.height + 120 + 65, LBVIEW_WIDTH1 / 2.5, LBVIEW_HEIGHT1 / 16);
    self.wechatOn = [UIImage imageNamed:@"wechatGreen.png"];
    self.wechatOff = [UIImage imageNamed:@"wechatGray.png"];
    [self.wechatBth addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.wechatBth setBackgroundImage:self.wechatOff forState:UIControlStateNormal];
    [self.wechatBth setBackgroundImage:self.wechatOn forState:UIControlStateSelected];
    self.wechatBth.tag=2;
    [self.view addSubview:self.wechatBth];
    

    self.okBtn = [[UIButton alloc]init];
    self.okBtn.frame = CGRectMake(LBVIEW_WIDTH1 / 13, + self.moneyLabel.frame.size.height + self.nokoLabel.frame.size.height + 120 + 70 + 70, LBVIEW_WIDTH1 / 1.2, LBVIEW_HEIGHT1 / 19);
    UIImage *okimage = [UIImage imageNamed:@"ok.png"];
    okimage = [okimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.okBtn setImage:okimage forState:UIControlStateNormal];
    self.okBtn.layer.cornerRadius = 10;
    self.okBtn.clipsToBounds=YES;
    [self.view addSubview:self.okBtn];
    
    
}

- (void)click:(UIButton*)sender
{
    if (_lastTag==sender.tag)
    {
        sender.selected=YES;
        return;
    }
    
    if (_lastTag!=0)
    {
        UIButton*btn=[self.view viewWithTag:_lastTag];
        btn.selected=NO;
    }
    
    _lastTag=(int)sender.tag;
    sender.selected=!sender.selected;
}

@end
