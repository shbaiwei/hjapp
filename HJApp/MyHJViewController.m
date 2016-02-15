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


//个人信息
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *szLabel;
@property(nonatomic,copy)NSString*userName;
@property(nonatomic,copy)NSString*portrait;
@property(nonatomic,strong)NSDictionary*balanceDic;
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

//账单数目
@property(nonatomic,unsafe_unretained)NSUInteger Fnum;
@property(nonatomic,unsafe_unretained)NSUInteger Snum;
@property(nonatomic,unsafe_unretained)NSUInteger Tnum;

@end


//宏定义宽高
#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height
#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

@implementation MyHJViewController


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent =NO;

    _hud = [BWCommon getHUD];
    
    //用户是否登录了
    _loginStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    if (!_loginStr)
    {
       [_hud removeFromSuperview];
       return;
    }
    //获取用户信息
    NSString*idStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
    [HttpEngine getConsumerDetailData:idStr completion:^(NSArray *dataArray)
     {
         ConsumerDetail*consum=dataArray[0];
         _userName=consum.userid;
         _portrait=consum.portrait;
         [_hud removeFromSuperview];
         [_tableView reloadData];
     }];
    //花售余额部分
    [HttpEngine getBalance:^(NSDictionary *dic)
     {
         _balanceDic=dic;
         [_tableView reloadData];
     }];
    //账单数目显示
    for (int i=0; i<3; i++)
    {
        NSString*str;
        if (i==0)
        {
            str=[NSString stringWithFormat:@"%d",i];
        }
        else
        {
            str=[NSString stringWithFormat:@"%d",i+1];
        }
        [HttpEngine myOrder:@"1" with:@"1" with:@"10" with:str completion:^(NSArray *dataArray)
         {
             if (i==0)
             {
                 _Fnum=dataArray.count;
             }
             else if (i==1)
             {
                 _Snum=dataArray.count;
             }
             else
             {
                 _Tnum=dataArray.count;
             }
             [_tableView reloadData];
        }];
    }
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
                btn.layer.borderColor=[UIColor colorWithRed:37/255.0 green:119/255.0 blue:188/255.0 alpha:1].CGColor;
                btn.layer.borderWidth=1;
                [btn setTitle:nameArray[i] forState:UIControlStateNormal];
                btn.titleLabel.font=[UIFont systemFontOfSize:14];
                btn.tag=332+i;
                [btn setTitleColor:[UIColor colorWithRed:37/255.0 green:119/255.0 blue:188/255.0 alpha:1] forState:UIControlStateNormal];
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
            
            if (i==0)
            {
                if (_Fnum!=0)
                {
                    UIImageView*imageNum=[self imageOrder];
                    imageNum.frame=CGRectMake(LBVIEW_WIDTH1/7+18, 5, 14, 14);
                    [cell addSubview:imageNum];
                    
                    UILabel*numLabel=[self numOrder:_Fnum];
                    numLabel.frame=CGRectMake(LBVIEW_WIDTH1/7+18, 5, 14, 14);
                    [cell addSubview:numLabel];
                }
            }
            else if (i==1)
            {
                if (_Snum!=0)
                {
                    UIImageView*imageNum=[self imageOrder];
                    imageNum.frame=CGRectMake(LBVIEW_WIDTH1/7+LBVIEW_WIDTH1/3+18, 5, 14, 14);
                    [cell addSubview:imageNum];
                    
                    UILabel*numLabel=[self numOrder:_Snum];
                    numLabel.frame=CGRectMake(LBVIEW_WIDTH1/7+LBVIEW_WIDTH1/3+18, 5, 14, 14);
                    [cell addSubview:numLabel];
                }
            }
            else
            {
                if (_Tnum!=0)
                {
                    UIImageView*imageNum=[self imageOrder];
                    imageNum.frame=CGRectMake(LBVIEW_WIDTH1/7+2*LBVIEW_WIDTH1/3+18, 5, 14, 14);
                    [cell addSubview:imageNum];
                    
                    UILabel*numLabel=[self numOrder:_Tnum];
                    numLabel.frame=CGRectMake(LBVIEW_WIDTH1/7+2*LBVIEW_WIDTH1/3+18, 5, 14, 14);
                    [cell addSubview:numLabel];
                }
            }
            
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
#pragma mark ------  账单数目
-(UIImageView*)imageOrder
{
    UIImageView*imageNum=[[UIImageView alloc]init];
    imageNum.backgroundColor=[UIColor redColor];
    imageNum.layer.cornerRadius=7;
    imageNum.clipsToBounds=YES;
    return imageNum;
}
-(UILabel*)numOrder:(NSUInteger)num
{
    UILabel*numLabel=[[UILabel alloc]init];
    numLabel.text=[NSString stringWithFormat:@"%lu",num];
    numLabel.font=[UIFont boldSystemFontOfSize:12];
    numLabel.textColor=[UIColor whiteColor];
    numLabel.textAlignment=NSTextAlignmentCenter;
    return numLabel;
}

//切换到登陆
-(void)loginRegister:(UIButton*)sender
{
    if (sender.tag==333)
    {
        LoginViewController*loginVC=[[LoginViewController alloc]init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    else
    {
        RegisterViewController*registerVC=[[RegisterViewController alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:registerVC];
        [self presentViewController:navigationController animated:YES completion:nil];
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
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navigationController animated:YES completion:nil];
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
}
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
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navigationController animated:YES completion:nil];
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
        complainVC.tabBarVC=_tabBarVC;
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
            [self saveData];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"TOKEN_KEY"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"CITYNAME"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"CODE"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"AREA"];
            FlashViewController*flashVC=[[FlashViewController alloc]init];
            [self.navigationController pushViewController:flashVC animated:YES];
        }];
    [alert addAction:cancel];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)saveData {
     NSString *sendAera = [[NSUserDefaults standardUserDefaults]objectForKey:@"AREA"];
    if (sendAera) {
        AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
        NSString*idStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
        NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/users/%@/",idStr];
        NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
        NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
        [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
        NSDictionary*parameters;
        if ([sendAera isEqualToString:@"本地"]) {
           parameters=@{@"default_delivery":@"local"};
        } else {
           parameters=@{@"default_delivery":@"origin"};
        }
        [manager PATCH:str parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             //NSLog(@"保存我的信息==JSON:%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //NSLog(@"保存我的信息==Error:%@",error);
        }];
    }
}
@end
