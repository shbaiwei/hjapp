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
#import "MyHJTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "RegisterViewController.h"

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
@property(nonatomic,copy)NSString*portrait;
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

@property(nonatomic,strong)MBProgressHUD*hud;

@property(nonatomic,copy)NSString*loginStr;

@end


//宏定义宽高
#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

@implementation MyHJViewController


-(void)viewWillAppear:(BOOL)animated
{
    //self.navigationController.navigationBarHidden=YES;
    self.navigationController.navigationBar.translucent =NO;

    _loginStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    if (!_loginStr)
        return;
    NSString*idStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
    _hud = [BWCommon getHUD];
    [self performSelector:@selector(reMove) withObject:nil afterDelay:1];
    [HttpEngine getConsumerDetailData:idStr completion:^(NSArray *dataArray)
     {
         
         ConsumerDetail*consum=dataArray[0];
         _userName=consum.userid;
         _portrait=consum.portrait;
         [_tableView reloadData];
     }];
    
    //花售余额部分
    [HttpEngine getBalance:^(NSDictionary *dic)
     {
         _balanceDic=dic;
         [_tableView reloadData];
     }];
}

-(void)reMove
{
[_hud removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showTableView];
    
}
-(void)showTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1-70) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.view addSubview:_tableView];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return 80;
    }
    if (indexPath.row==1) {
        return 50;
    }
    if (indexPath.row==2) {
        return 50;
    }
    return 50;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    MyHJTableViewCell *cell0 = [MyHJTableViewCell cellWithTableView:tableView];
    
    if(indexPath.row == 0)
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
        if (!_loginStr)
        {
            NSArray*nameArray=[[NSArray alloc]initWithObjects:@"注册", @"登录",nil];
            for (int i=0; i<2; i++)
            {
                UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake((LBVIEW_WIDTH1-180)/2+i*100, 25,80, 30)];
                btn.layer.borderColor=[UIColor grayColor].CGColor;
                btn.layer.borderWidth=1;
                [btn setTitle:nameArray[i] forState:UIControlStateNormal];
                btn.titleLabel.font=[UIFont systemFontOfSize:14];
                btn.tag=332+i;
                [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:164/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(loginRegister:) forControlEvents:UIControlEventTouchUpInside];
                btn.layer.cornerRadius=5;
                btn.clipsToBounds=YES;
                [cell addSubview:btn];
            }
        }
        else
        {
        UIImageView*headImage=[[UIImageView alloc]initWithFrame: CGRectMake(VIEW_WIDTH * 0.05, (80-VIEW_HEIGHT*0.09)/2, VIEW_HEIGHT * 0.09, VIEW_HEIGHT * 0.09)];
        headImage.layer.cornerRadius=VIEW_HEIGHT * 0.09/2;
        headImage.clipsToBounds=YES;
        NSString*picUrl=[NSString stringWithFormat:@"http://s.huaji.com%@",_portrait];
        [headImage sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"head.png"]];
        [cell addSubview:headImage];
        
        
        self.userLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImage.frame.size.width * 1.6, (80-VIEW_HEIGHT*0.03)/2, VIEW_WIDTH * 0.5, VIEW_HEIGHT * 0.03)];
        self.userLabel.text =_userName;
        self.userLabel.textColor = [UIColor blackColor];
        self.userLabel.font = [UIFont systemFontOfSize:16];
        [cell addSubview:self.userLabel];
        
        self.szLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userLabel.frame.size.width * 3.2, (80-VIEW_HEIGHT*0.03)/2, VIEW_WIDTH * 0.12, VIEW_HEIGHT * 0.03)];
        self.szLabel.text = @"设置";
        self.szLabel.textColor = [UIColor grayColor];
        self.szLabel.font = [UIFont systemFontOfSize:15];
        [cell addSubview:self.szLabel];
        }
    }
    else if (indexPath.row==1)
    {
        
        [cell0.iconImage setImage:[UIImage imageNamed:@"myOder.PNG"]];
        [cell0.textLabel setText:@"我的订单"];
        
        [cell0.rightLabel setText:@"查看全部购买商品"];
        return cell0;
        //[cell addSubview:self.oderImageV];
        //全部订单
        /*
        UIButton*allBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, 60)];
        [allBtn addTarget:self action:@selector(allOrder) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:allBtn];
        */
    }
    else if (indexPath.row==2)
    {
        //订单分类
        
        NSArray*array=[[NSArray alloc]initWithObjects:@"待付款",@"待收货",@"退款／售后", nil];
        
        for (int i=0; i<3; i++)
        {
            
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(i*LBVIEW_WIDTH1/3, 30, LBVIEW_WIDTH1/3, 20)];
            label.text=array[i];
            label.textColor=[UIColor blackColor];
            label.textAlignment=NSTextAlignmentCenter;
            label.font=NJNameFont;
            [label setTextColor:NJFontColor];
            [cell addSubview:label];
            
            UIImageView*imageV=[[UIImageView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/7+i*LBVIEW_WIDTH1/3, 8, 20, 20)];
            imageV.image=[UIImage imageNamed:[NSString stringWithFormat:@"order_state%d.png",i+1]];
            [cell addSubview:imageV];
            
            UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(i*LBVIEW_WIDTH1/3, 0, LBVIEW_WIDTH1/3, 60)];
            btn.tag=i+10;
            [btn addTarget:self action:@selector(chooseOrder:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
            
            
            if (i==0)
            {
                UILabel*line1=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/3, 13, 1, 30)];
                line1.backgroundColor=[UIColor lightGrayColor];
                [cell addSubview:line1];
            }
            if (i==1)
            {
                UILabel*line2=[[UILabel alloc]initWithFrame:CGRectMake(2*LBVIEW_WIDTH1/3, 13, 1, 30)];
                line2.backgroundColor=[UIColor lightGrayColor];
                [cell addSubview:line2];
            }
        }
        
    }
    else if (indexPath.row==3)
    {
        
        [cell0.iconImage setImage:[UIImage imageNamed:@"icons-my-huaji-1.png"]];
        
        [cell0.textLabel setText:@"管理收货地址"];
        [cell0.rightLabel setText:nil];
        return cell0;
    }
    else if (indexPath.row==4)
    {
        [cell0.iconImage setImage:[UIImage imageNamed:@"saihu.PNG"]];
        
        [cell0.textLabel setText:@"花集红包"];
        [cell0.rightLabel setText:nil];
        return cell0;

    }
    else if (indexPath.row==5)
    {
        [cell0.iconImage setImage:[UIImage imageNamed:@"message.PNG"]];
        
        [cell0.textLabel setText:@"消息中心"];
        [cell0.rightLabel setText:nil];
        return cell0;
        
    }
    else if (indexPath.row==6)
    {
        [cell0.iconImage setImage:[UIImage imageNamed:@"money.PNG"]];
        
        if (!_loginStr)
        cell0.textLabel.text=@"花集余额";
        else
        [cell0.textLabel setText:[NSString stringWithFormat:@"花集余额(%@)",_balanceDic[@"nmoney"]]];
        
        [cell0.rightLabel setText:@"充值"];
        
        return cell0;
        
    }
    else if (indexPath.row==7)
    {
        
        [cell0.iconImage setImage:[UIImage imageNamed:@"afer.PNG"]];
        [cell0.textLabel setText:@"我的售后"];
        [cell0.rightLabel setText:nil];
        return cell0;
        
    }
    else if (indexPath.row==8)
    {
        NSString*str=@"客服电话 0571-28980809";
        UIFont*font=[UIFont systemFontOfSize:14];
        CGSize size=[str boundingRectWithSize:CGSizeMake(400, 20) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        
        self.phoneImageV = [[UIImageView alloc] initWithFrame:CGRectMake((VIEW_WIDTH-size.width-VIEW_WIDTH * 0.05)/2, (VIEW_HEIGHT/13.5-VIEW_WIDTH * 0.05)/2, VIEW_WIDTH * 0.05, VIEW_WIDTH * 0.05)];
        self.phoneImageV.image = [UIImage imageNamed:@"icons-my-huaji-6.png"];
        [cell addSubview:self.phoneImageV];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake((VIEW_WIDTH-size.width-VIEW_WIDTH * 0.05-5)/2+VIEW_WIDTH * 0.05+5, VIEW_HEIGHT * 0.02,size.width, VIEW_HEIGHT * 0.035)];
        self.phoneLabel.text = @"客服电话 0571-28980809";
        self.phoneLabel.textColor = [UIColor redColor];
        self.phoneLabel.textAlignment=NSTextAlignmentCenter;
        self.phoneLabel.font = NJTitleFont;
        [cell addSubview:self.phoneLabel];
        
    }
    
    return cell;
}

//切换到登陆
-(void)loginRegister:(UIButton*)sender
{
    if (sender.tag==333)
    {
        LoginViewController*loginVC=[[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else
    {
        RegisterViewController*registerVC=[[RegisterViewController alloc]init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
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
    if (!_loginStr)
    {
        LoginViewController*loginVC=[[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else
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
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
    //return 80;
}

//-(void)theTopButtonAction:(UIButton *)sender
//{
//    AboutMeViewController *aboutVC = [[AboutMeViewController alloc] init];
//    aboutVC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:aboutVC animated:YES];
//}


//选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        if (!_loginStr)
            return;
        AboutMeViewController *aboutVC = [[AboutMeViewController alloc] init];
        aboutVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    if (!_loginStr)
    {
        LoginViewController*loginVC=[[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    if(indexPath.row == 1)
    {
        _tabBarVC.selectedIndex=2;
        return;
    }
    //管理收货地址
    if(indexPath.row==3)
    {
        AdressViewController *adressVC = [[AdressViewController alloc] init];
        adressVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:adressVC animated:YES];
    }
    //花集红包
    if(indexPath.row==4)
    {
        FlowerMoneyViewController*flowerVC=[[FlowerMoneyViewController alloc]init];
        flowerVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:flowerVC animated:YES];
    }
    //消息中心
    if(indexPath.row==5)
    {
        MessageCenterViewController*messageVC=[[MessageCenterViewController alloc]init];
        messageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messageVC animated:YES];
        
    }
    //花集余额
    if(indexPath.row==6)
    {
        UserMoneyViewController *userMVC = [[UserMoneyViewController alloc] init];
        userMVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userMVC animated:YES];
    }
    //我的售后
    if(indexPath.row==7)
    {
        ComplainViewController*complainVC=[[ComplainViewController alloc]init];
        complainVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:complainVC animated:YES];
    }
    //客服电话
    if(indexPath.row==8)
    {
        // 跳转页面
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否拨打客服热线" preferredStyle: UIAlertControllerStyleAlert];
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
    
    if (!_loginStr)
    {
        return view;
    }
    
    self.overButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.overButton.frame = CGRectMake(10,LBVIEW_HEIGHT1/20, LBVIEW_WIDTH1-20, 40);
//    UIImage *over = [UIImage imageNamed:@"over.png"];
//    over = [over imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [self.overButton setImage:over forState:UIControlStateNormal];
    [self.overButton setTitle:@"退出登录" forState:UIControlStateNormal];
    self.overButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.overButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.overButton setBackgroundColor:[UIColor redColor]];
    self.overButton.layer.cornerRadius=5;
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
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action)
        {
            
        }];
    UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action)
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
@end
