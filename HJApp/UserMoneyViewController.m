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
    
//    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
//    [tapGes addTarget:self action:@selector(keybordHideAction:)];
//    
//    tapGes.cancelsTouchesInView = NO;
//    
//    [self.view addGestureRecognizer:tapGes];
    
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

//- (void)keybordHideAction:(UITapGestureRecognizer *)tap
//{
//    [self.monenyNum resignFirstResponder];
//    
//}

- (void)thePage
{
    self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake((LBVIEW_WIDTH1-LBVIEW_WIDTH1/1.5)/2, 40, LBVIEW_WIDTH1 / 1.5, 60)];
    // self.moneyLabel.backgroundColor = [UIColor redColor];
    self.moneyLabel.text = _dataDic[@"nmoney"];
    self.moneyLabel.textColor = [UIColor blackColor];
    self.moneyLabel.font = [UIFont systemFontOfSize:42];
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.moneyLabel];
    
    
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1 / 2.3-10,  95, 15, 15)];
    imageView.image=[UIImage imageNamed:@"balance.png"];
    [self.view addSubview:imageView];
    
    self.nokoLabel = [[UILabel alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1 / 2.3+10, 90, LBVIEW_WIDTH1 * 0.2, 30)];
    self.nokoLabel.text = @"账户余额";
    self.nokoLabel.textColor = [UIColor blackColor];
    self.nokoLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.nokoLabel];
    
    self.monenyNum = [[UITextField alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1 / 13, + self.moneyLabel.frame.size.height + self.nokoLabel.frame.size.height + LBVIEW_WIDTH1 / 9, LBVIEW_WIDTH1 / 1.2, LBVIEW_HEIGHT1 / 14)];
   // self.monenyNum.backgroundColor = [UIColor clearColor];
    self.monenyNum.placeholder = @"请输入充值金额 如:8888";
    //    [self.monenyNum becomeFirstResponder];
    self.monenyNum.layer.borderColor=[UIColor grayColor].CGColor;
    //self.monenyNum.borderStyle = UITextBorderStyleLine;
    self.monenyNum.layer.borderWidth=1;
    self.monenyNum.layer.cornerRadius=5;
    self.monenyNum.clipsToBounds=YES;
    self.monenyNum.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.monenyNum];
    
    //button点击之后本身换成另一张图片。此处用于支付按钮的切换
    self.zfbBtn = [[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1 / 13, + self.moneyLabel.frame.size.height + self.nokoLabel.frame.size.height + LBVIEW_WIDTH1 / 9 + 65, LBVIEW_WIDTH1 / 2.5, LBVIEW_HEIGHT1 / 16)];
    self.zfbBtn.tag=1;
    [self.zfbBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.zfbBtn setBackgroundImage:[UIImage imageNamed:@"zfbBlue.png"] forState:UIControlStateSelected];
    [self.zfbBtn setBackgroundImage:[UIImage imageNamed:@"zfbGray.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.zfbBtn];
    
    self.wechatBth = [[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1 / 1.95, + self.moneyLabel.frame.size.height + self.nokoLabel.frame.size.height + LBVIEW_WIDTH1 / 9 + 65, LBVIEW_WIDTH1 / 2.5, LBVIEW_HEIGHT1 / 16)];
    [self.wechatBth addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.wechatBth setBackgroundImage:[UIImage imageNamed:@"wechatGray.png"] forState:UIControlStateNormal];
    [self.wechatBth setBackgroundImage:[UIImage imageNamed:@"wechatGreen.png"] forState:UIControlStateSelected];
    self.wechatBth.tag=2;
    [self.view addSubview:self.wechatBth];
    

    self.okBtn = [[UIButton alloc]init];
    self.okBtn.frame = CGRectMake(LBVIEW_WIDTH1 / 13, + self.moneyLabel.frame.size.height + self.nokoLabel.frame.size.height + LBVIEW_WIDTH1 / 9+LBVIEW_HEIGHT1 / 16+ 90 , LBVIEW_WIDTH1 / 1.2, 40);
    [self.okBtn setTitle:@"确定充值" forState:UIControlStateNormal];
    [self.okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okBtn setBackgroundColor:[UIColor redColor]];
    [self.okBtn addTarget:self action:@selector(addMoney) forControlEvents:UIControlEventTouchUpInside];
    self.okBtn.layer.cornerRadius = 5;
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

-(void)addMoney
{
    
    if (_lastTag!=0)
    {
        if (_lastTag==1)
        {
            //NSLog(@"点击事件");
        }
        else
        {
        
        }
    }
}

@end
