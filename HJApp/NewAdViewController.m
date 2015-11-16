//
//  NewAdViewController.m
//  HJApp
//
//  Created by Bruce He on 15/11/6.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "NewAdViewController.h"
#import "HttpEngine.h"

@interface NewAdViewController ()

@property (nonatomic, strong) UITextField *userNameTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *proconTF;
@property (nonatomic, strong) UITextField *adreTF;

@end

//宏定义宽高
#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

@implementation NewAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新建地址";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [tapGes addTarget:self action:@selector(keybordHide:)];
    
    tapGes.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGes];
    
    
    [self newadressPage];
}

- (void)keybordHide:(UITapGestureRecognizer *)tap
{
    [self.userNameTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.proconTF resignFirstResponder];
    [self.adreTF resignFirstResponder];
}


- (void)newadressPage
{
    
    UIView *userV = [[UIView alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1 / 17, LBVIEW_HEIGHT1 / 7, LBVIEW_WIDTH1 / 1.1, LBVIEW_HEIGHT1 / 17)];
    // userV.backgroundColor = [UIColor redColor];
    userV.layer.borderColor = [[UIColor grayColor] CGColor];
    userV.layer.borderWidth = 1;
    [self.view addSubview:userV];
    
    self.userNameTF = [[UITextField alloc] initWithFrame: CGRectMake(LBVIEW_WIDTH1 / 3.5, LBVIEW_HEIGHT1 * 0.001, LBVIEW_WIDTH1 / 1.6, LBVIEW_HEIGHT1 / 17)];
    self.userNameTF.backgroundColor = [UIColor clearColor];
    self.userNameTF.borderStyle = UITextBorderStyleNone;
    self.userNameTF.textColor = [UIColor blackColor];
    self.userNameTF.placeholder=_userName;
    [userV addSubview:self.userNameTF];
    
    UIView *phoneV = [[UIView alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1 / 17, LBVIEW_HEIGHT1 / 4.5, LBVIEW_WIDTH1 / 1.1, LBVIEW_HEIGHT1 / 17)];
    //phoneV.backgroundColor = [UIColor redColor];
    phoneV.layer.borderColor = [[UIColor grayColor] CGColor];
    phoneV.layer.borderWidth = 1;
    [self.view addSubview:phoneV];
    
    
    self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1 / 3.5, LBVIEW_HEIGHT1 * 0.001, LBVIEW_WIDTH1 / 1.6, LBVIEW_HEIGHT1 / 17)];
    self.phoneTF.backgroundColor = [UIColor clearColor];
    self.phoneTF.borderStyle = UITextBorderStyleNone;
    self.phoneTF.textColor = [UIColor blackColor];
    self.phoneTF.placeholder=_phone;
    [phoneV addSubview:self.phoneTF];
    
    UIView *proconV = [[UIView alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1 / 17, LBVIEW_HEIGHT1 / 3.3, LBVIEW_WIDTH1 / 1.1, LBVIEW_HEIGHT1 / 17)];
    proconV.layer.borderColor = [[UIColor grayColor] CGColor];
    proconV.layer.borderWidth = 1;
    [self.view addSubview:proconV];
    
    self.proconTF = [[UITextField alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1 / 3.5, LBVIEW_HEIGHT1 * 0.001, LBVIEW_WIDTH1 / 1.6, LBVIEW_HEIGHT1 / 17)];
    self.proconTF.backgroundColor = [UIColor clearColor];
    self.proconTF.borderStyle = UITextBorderStyleNone;
    self.proconTF.textColor = [UIColor blackColor];
    self.proconTF.placeholder=_procon;
    [proconV addSubview:self.proconTF];
    
    UIView *adreV = [[UIView alloc] init];
    adreV.frame = CGRectMake(LBVIEW_WIDTH1 / 17, LBVIEW_HEIGHT1 / 2.6, LBVIEW_WIDTH1 / 1.1, LBVIEW_HEIGHT1 / 17);
    adreV.layer.borderColor = [[UIColor grayColor] CGColor];
    adreV.layer.borderWidth = 1;
    [self.view addSubview:adreV];
    
    
    self.adreTF = [[UITextField alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1 / 3.5, LBVIEW_HEIGHT1 * 0.001, LBVIEW_WIDTH1 / 1.6, LBVIEW_HEIGHT1 / 17)];
    self.adreTF.backgroundColor = [UIColor clearColor];
    self.adreTF.borderStyle = UITextBorderStyleNone;
    self.adreTF.textColor = [UIColor blackColor];
    self.adreTF.placeholder=@"详细地址";
    [adreV addSubview:self.adreTF];
    

    
//    self.hozonBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    self.hozonBtn.frame = CGRectMake(LBVIEW_WIDTH1 / 17, LBVIEW_HEIGHT1 / 2, LBVIEW_WIDTH1 / 1.1, LBVIEW_HEIGHT1 / 17);
//    [self.hozonBtn setImage:[UIImage imageNamed:@"hozon.png"] forState:UIControlStateNormal];
//    [self.hozonBtn addTarget:self action:@selector(saveDetail) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.hozonBtn];
    
    
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1 / 17, LBVIEW_HEIGHT1 / 2, LBVIEW_WIDTH1 / 1.1, LBVIEW_HEIGHT1 / 17)];
    [btn setImage:[UIImage imageNamed:@"hozon.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(saveDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)saveDetail
{
    //consignee，phone_mob，province，city，town，address
    
    if (_bj==1)
    {
        NSLog(@"123");
        [HttpEngine changeAddress:_addrId Consignee:_userNameTF.text withPhoneMob:_phoneTF.text withProvince:@"4400" withCity:@"441600" withTown:@"441623" withAddress:_adreTF.text];
    }
    else
    {
        [HttpEngine addAdressConsignee:_userNameTF.text withPhoneMob:_phoneTF.text withProvince:@"4400" withCity:@"441600" withTown:@"441623" withAddress:_adreTF.text];
    
    }
  
}


@end
