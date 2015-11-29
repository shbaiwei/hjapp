//
//  MyHJViewController.m
//  HJApp
//
//  Created by Bruce He on 15/10/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "MyHJViewController.h"
#import "LoginViewController.h"
#import "AboutMeViewController.h"
#import "HttpEngine.h"
#import "OrderPageViewController.h"
#import "AdressViewController.h"
#import "UserMoneyViewController.h"
#import "FlashViewController.h"
#import "FlowerMoneyViewController.h"
#import "ComplainViewController.h"
#import "MessageCenterViewController.h"

@interface MyHJViewController ()


@property(nonatomic,strong)NSArray*ConsumerArray;
//个人信息
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *userImaButton;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *szLabel;
@property (nonatomic, strong) UIImageView *jtImageV;
@property (nonatomic, strong) UIButton *topButton;
@property(nonatomic,copy)NSString*userName;
//我的订单
@property (nonatomic, strong) UIView *oderView;
@property (nonatomic, strong) UIImageView *oderImageV;
@property (nonatomic, strong) UILabel *myOderLabel;
@property (nonatomic, strong) UIImageView *odJtImageV;
@property (nonatomic, strong) UIButton *oderButton;
//管理收货地址
@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UIImageView *addressImageV;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView *adJtImageV;
@property (nonatomic, strong) UIButton *addsButton;
//花集红包
@property (nonatomic, strong) UIView *saihuView;
@property (nonatomic, strong) UIImageView *saihuImageV;
@property (nonatomic, strong) UILabel *saihuLabel;
@property (nonatomic, strong) UIImageView *shJtImageV;
@property (nonatomic, strong) UIButton *shButton;
//消息中心
@property (nonatomic, strong) UIView *messageView;
@property (nonatomic, strong) UIImageView *messageImageV;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *mesJtImageV;
@property (nonatomic, strong) UIButton *messButton;
//花售余额
@property (nonatomic, strong) UIView *moneyView;
@property (nonatomic, strong) UIImageView *moneyImageV;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIImageView *monJtImageV;
@property (nonatomic, strong) UILabel *czLabel;
@property (nonatomic, strong) UIButton *monButton;
///
@property(nonatomic,strong)NSDictionary*balanceDic;



//我的售后
@property (nonatomic, strong) UIView *aferView;
@property (nonatomic, strong) UIImageView *aferImageV;
@property (nonatomic, strong) UILabel *aferLabel;
@property (nonatomic, strong) UIImageView *afJtImageV;
@property (nonatomic, strong) UIButton *afButton;
//客服电话
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UIImageView *phoneImageV;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *phoneButton;
//退出登录
@property (nonatomic, strong) UIButton *overButton;
@property (nonatomic, strong) UIImageView *overImageV;

///////
@property(nonatomic,strong)UITableView*tableView;

@end




//宏定义宽高
#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

@implementation MyHJViewController


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    self.navigationController.navigationBar.translucent =NO;
    [self hidesTabBar:NO];
    //判断是否需要登陆
    NSString*str=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    if (str==NULL)
    {
        LoginViewController*loginVC=[[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }

    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1,64)];
    headView.backgroundColor=[UIColor colorWithRed:0.23 green:0.67 blue:0.89 alpha:1];
    [self.view addSubview:headView];
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, LBVIEW_WIDTH1, 30)];
    titleLabel.text=@"我的花集";
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headView addSubview:titleLabel];
    
    NSString*idStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
    
    [HttpEngine getConsumerDetailData:idStr completion:^(NSArray *dataArray)
     {
         ConsumerDetail*consum=dataArray[0];
         _userName=consum.userid;
         [self showTableView];
     }];
    
    //花售余额部分
    [HttpEngine getBalance:^(NSDictionary *dic)
     {
         _balanceDic=dic;
         [_tableView reloadData];
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
-(void)showTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, LBVIEW_WIDTH1, LBVIEW_HEIGHT1-110) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.view addSubview:_tableView];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 60;
    }
    if (indexPath.row==1) {
        return 60;
    }
    return LBVIEW_HEIGHT1 / 13.5;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row==0)
    {
        self.oderImageV = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_WIDTH * 0.06, 17.5, VIEW_WIDTH * 0.06, 25)];
        self.oderImageV.image = [UIImage imageNamed:@"myOder.PNG"];
        [cell addSubview:self.oderImageV];
        
        self.myOderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.oderImageV.frame.size.width * 2.3, 15, VIEW_WIDTH * 0.5, 30)];
        self.myOderLabel.text = @"我的订单";
        self.myOderLabel.font = [UIFont systemFontOfSize:17];
        [cell addSubview:self.myOderLabel];
        
        UILabel*selectLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-15*VIEW_WIDTH * 0.043+10, 20, VIEW_WIDTH * 0.5, 20)];
        selectLabel.text=@"查看全部购买商品";
        selectLabel.textAlignment=NSTextAlignmentRight;
        selectLabel.font=[UIFont systemFontOfSize:14];
        selectLabel.textColor=[UIColor grayColor];
        [cell addSubview:selectLabel];
        
        //全部订单
        UIButton*allBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, 60)];
        [allBtn addTarget:self action:@selector(allOrder) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:allBtn];
        
        self.odJtImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.oderImageV.frame.size.width * 15,(60-VIEW_HEIGHT * 0.025)/2, VIEW_WIDTH * 0.043, VIEW_HEIGHT * 0.025)];
        self.odJtImageV.image = [UIImage imageNamed:@"jt.png"];
        [cell addSubview:self.odJtImageV];
        
    }
    if (indexPath.row==1)
    {
        //订单分类
        
        NSArray*array=[[NSArray alloc]initWithObjects:@"待付款",@"待收货",@"退款／售后", nil];
        
        for (int i=0; i<3; i++)
        {
            
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(i*LBVIEW_WIDTH1/3, 35, LBVIEW_WIDTH1/3, 20)];
            label.text=array[i];
            label.textColor=[UIColor blackColor];
            label.textAlignment=NSTextAlignmentCenter;
            label.font=[UIFont systemFontOfSize:13];
            [cell addSubview:label];
            
            UIImageView*imageV=[[UIImageView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/7+i*LBVIEW_WIDTH1/3-5, 5, 30, 30)];
            imageV.image=[UIImage imageNamed:[NSString stringWithFormat:@"order_state%d.png",i+1]];
            [cell addSubview:imageV];
            
            UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(i*LBVIEW_WIDTH1/3, 0, LBVIEW_WIDTH1/3, 60)];
            btn.tag=i+10;
            [btn addTarget:self action:@selector(chooseOrder:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            
            
            if (i==0)
            {
                UILabel*line1=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/3, 10, 1, 37)];
                line1.backgroundColor=[UIColor grayColor];
                [cell addSubview:line1];
            }
            if (i==1)
            {
                UILabel*line2=[[UILabel alloc]initWithFrame:CGRectMake(2*LBVIEW_WIDTH1/3, 10, 1, 37)];
                line2.backgroundColor=[UIColor grayColor];
                [cell addSubview:line2];
            }
        }
        
    }
    if (indexPath.row==2)
    {
        self.addressImageV = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_WIDTH * 0.06, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.05, VIEW_HEIGHT * 0.033)];
        self.addressImageV.image = [UIImage imageNamed:@"icons-my-huaji-1.png"];
        [cell addSubview:self.addressImageV];
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.addressImageV.frame.size.width * 2.6, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.5, VIEW_HEIGHT * 0.033)];
        self.addressLabel.text = @"管理收货地址";
        self.addressLabel.font = [UIFont systemFontOfSize:17];
        [cell addSubview:self.addressLabel];
        
        self.adJtImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.addressImageV.frame.size.width * 18, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.043, VIEW_HEIGHT * 0.025)];
        self.adJtImageV.image = [UIImage imageNamed:@"jt.png"];
        [cell addSubview:self.adJtImageV];
        
    }
    if (indexPath.row==3)
    {
        self.saihuImageV = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_WIDTH * 0.06, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.06, VIEW_HEIGHT * 0.033)];
        self.saihuImageV.image = [UIImage imageNamed:@"saihu.PNG"];
        [cell addSubview:self.saihuImageV];
        
        self.saihuLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.saihuImageV.frame.size.width * 2.3, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.5, VIEW_HEIGHT * 0.033)];
        self.saihuLabel.text = @"花集红包";
        self.saihuLabel.font = [UIFont systemFontOfSize:17];
        [cell addSubview:self.saihuLabel];
        
        self.shJtImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.saihuImageV.frame.size.width * 15, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.043, VIEW_HEIGHT * 0.025)];
        self.shJtImageV.image = [UIImage imageNamed:@"jt.png"];
        [cell addSubview:self.shJtImageV];

    }
    if (indexPath.row==4)
    {
        
        self.messageImageV = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_WIDTH * 0.06, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.06, VIEW_HEIGHT * 0.033)];
        self.messageImageV.image = [UIImage imageNamed:@"message.PNG"];
        [cell addSubview:self.messageImageV];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.messageImageV.frame.size.width * 2.3, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.5, VIEW_HEIGHT * 0.033)];
        self.messageLabel.text = @"消息中心";
        self.messageLabel.font = [UIFont systemFontOfSize:17];
        [cell addSubview:self.messageLabel];
        
        self.mesJtImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.messageImageV.frame.size.width * 15, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.043, VIEW_HEIGHT * 0.025)];
        self.mesJtImageV.image = [UIImage imageNamed:@"jt.png"];
        [cell addSubview:self.mesJtImageV];
        
    }
    if (indexPath.row==5)
    {
        self.moneyImageV = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_WIDTH * 0.06, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.06, VIEW_HEIGHT * 0.033)];
        self.moneyImageV.image = [UIImage imageNamed:@"money.PNG"];
        [cell addSubview:self.moneyImageV];
        
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.moneyImageV.frame.size.width * 2.3, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.5, VIEW_HEIGHT * 0.033)];
        self.moneyLabel.text =[NSString stringWithFormat:@"花集余额(%@)",_balanceDic[@"nmoney"]];
        self.moneyLabel.font = [UIFont systemFontOfSize:17];
        [cell addSubview:self.moneyLabel];
        
        self.monJtImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.moneyImageV.frame.size.width * 15, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.043, VIEW_HEIGHT * 0.025)];
        self.monJtImageV.image = [UIImage imageNamed:@"jt.png"];
        [cell addSubview:self.monJtImageV];
        
        self.czLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.moneyImageV.frame.size.width * 13.3, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.12, VIEW_HEIGHT * 0.03)];
        self.czLabel.text = @"充值";
        self.czLabel.textColor = [UIColor grayColor];
        self.czLabel.font = [UIFont systemFontOfSize:15];
        [cell addSubview:self.czLabel];
        
    }
    if (indexPath.row==6)
    {
        UIImageView*secuIV= [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_WIDTH * 0.06, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.06, VIEW_HEIGHT * 0.033)];
        secuIV.image = [UIImage imageNamed:@"afer.PNG"];
        [cell addSubview:secuIV];
        
        UILabel*secuLB = [[UILabel alloc] initWithFrame:CGRectMake(secuIV.frame.size.width * 2.3, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.5, VIEW_HEIGHT * 0.033)];
        secuLB.text =@"我的售后";
        secuLB.font = [UIFont systemFontOfSize:17];
        [cell addSubview:secuLB];
        
        UIImageView*leftDwon = [[UIImageView alloc] initWithFrame:CGRectMake(secuIV.frame.size.width * 15, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.043, VIEW_HEIGHT * 0.025)];
        leftDwon.image = [UIImage imageNamed:@"jt.png"];
        [cell addSubview:leftDwon];
        
      }
    if (indexPath.row==7)
    {
        self.phoneImageV = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_WIDTH * 0.18, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.055, VIEW_HEIGHT * 0.035)];
        self.phoneImageV.image = [UIImage imageNamed:@"icons-my-huaji-6.png"];
        [cell addSubview:self.phoneImageV];
    
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.phoneImageV.frame.size.width * 4.6, VIEW_HEIGHT * 0.02, VIEW_WIDTH * 0.9, VIEW_HEIGHT * 0.035)];
        self.phoneLabel.text = @"客服电话 0571-28980809";
        self.phoneLabel.textColor = [UIColor redColor];
        self.phoneLabel.font = [UIFont systemFontOfSize:18];
        [cell addSubview:self.phoneLabel];
        
    }
    
    return cell;
}


//我的订单
//所有订单
-(void)allOrder
{
    _tabBarVC.selectedIndex=2;
}
//账单选择
-(void)chooseOrder:(UIButton*)sender
{
    NSString*str;
    if(sender.tag==10)
    {
        str=@"0";
    }
    if (sender.tag==11)
    {
        str=@"2";
    }
    if (sender.tag==12)
    {
        str=@"3";
    }
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"THREETAG"];
    _tabBarVC.selectedIndex=2;
}

//区头
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]init];
    view.backgroundColor=[UIColor whiteColor];
    
    self.userImaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *userImage = [UIImage imageNamed:@"head.png"];
    userImage = [userImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.userImaButton.contentMode = UIViewContentModeScaleAspectFill;
    self.userImaButton.frame = CGRectMake(VIEW_WIDTH * 0.05, (80-VIEW_HEIGHT*0.09)/2, VIEW_HEIGHT * 0.09, VIEW_HEIGHT * 0.09);
    [self.userImaButton setImage:userImage forState:UIControlStateNormal];
    self.userImaButton.layer.cornerRadius = 20;
    self.userImaButton.clipsToBounds = YES;
    [view addSubview:self.userImaButton];
    
    self.userLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userImaButton.frame.size.width * 1.4, (80-VIEW_HEIGHT*0.03)/2, VIEW_WIDTH * 0.25, VIEW_HEIGHT * 0.03)];
    self.userLabel.text =_userName;
    self.userLabel.textColor = [UIColor blackColor];
    self.userLabel.font = [UIFont systemFontOfSize:16];
    [view addSubview:self.userLabel];
    
    self.szLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userLabel.frame.size.width * 3.2, (80-VIEW_HEIGHT*0.03)/2, VIEW_WIDTH * 0.12, VIEW_HEIGHT * 0.03)];
    self.szLabel.text = @"设置";
    self.szLabel.textColor = [UIColor grayColor];
    self.szLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:self.szLabel];
    
    self.jtImageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.szLabel.frame.size.width * 7.5, (80-VIEW_HEIGHT*0.025)/2, VIEW_WIDTH * 0.043, VIEW_HEIGHT * 0.025)];
    self.jtImageV.image = [UIImage imageNamed:@"jt.png"];
    [view addSubview:self.jtImageV];
    
    self.topButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.topButton.frame = CGRectMake(0, 0, LBVIEW_WIDTH1, 80);
    self.topButton.backgroundColor = [UIColor clearColor];
    [self.topButton addTarget:self action:@selector(theTopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.topButton];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

-(void)theTopButtonAction:(UIButton *)sender
{
    AboutMeViewController *aboutVC = [[AboutMeViewController alloc] init];
    [self hidesTabBar:YES];
    [self.navigationController pushViewController:aboutVC animated:YES];
}


//选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //管理收货地址
    if(indexPath.row==2)
    {
        AdressViewController *adressVC = [[AdressViewController alloc] init];
        [self hidesTabBar:YES];
        [self.navigationController pushViewController:adressVC animated:YES];
    }
    //花集红包
    if(indexPath.row==3)
    {
        FlowerMoneyViewController*flowerVC=[[FlowerMoneyViewController alloc]init];
        [self hidesTabBar:YES];
        [self.navigationController pushViewController:flowerVC animated:YES];
    }
    //消息中心
    if(indexPath.row==4)
    {
        MessageCenterViewController*messageVC=[[MessageCenterViewController alloc]init];
        [self.navigationController pushViewController:messageVC animated:YES];
        
    }
    //花集余额
    if(indexPath.row==5)
    {
        UserMoneyViewController *userMVC = [[UserMoneyViewController alloc] init];
        [self.navigationController pushViewController:userMVC animated:YES];
    }
    //我的售后
    if(indexPath.row==6)
    {
        ComplainViewController*complainVC=[[ComplainViewController alloc]init];
        [self.navigationController pushViewController:complainVC animated:YES];
    }
    //客服电话
    if(indexPath.row==7)
    {
        // 跳转页面
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否拨打客服电话" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action)
                              {
                                  
                              }];
        UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action)
                              {
                                  NSString *allString = [NSString stringWithFormat:@"tel://057128980809"];
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
                              }];
        [alert addAction:cancel];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
}

//设置区尾
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]init];
    
    self.overButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.overButton.frame = CGRectMake(10,LBVIEW_HEIGHT1/20, LBVIEW_WIDTH1-20, 40);
//    UIImage *over = [UIImage imageNamed:@"over.png"];
//    over = [over imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [self.overButton setImage:over forState:UIControlStateNormal];
    [self.overButton setTitle:@"退出登陆" forState:UIControlStateNormal];
    self.overButton.titleLabel.font=[UIFont systemFontOfSize:19];
    [self.overButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.overButton setBackgroundColor:[UIColor redColor]];
    self.overButton.layer.cornerRadius=7;
    self.overButton.clipsToBounds=YES;
    
    [self.overButton addTarget:self action:@selector(goToSleep) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.overButton];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return LBVIEW_HEIGHT1/5;
}

-(void)goToSleep
{
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"亲是要走了嘛" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"再玩一会" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action)
        {
            
        }];
    UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:@"残忍离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action)
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"TOKEN_KEY"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"CITYNAME"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"CODE"];
            FlashViewController*flashVC=[[FlashViewController alloc]init];
            [self.navigationController pushViewController:flashVC animated:YES];
        }];
    [alert addAction:cancel];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
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
