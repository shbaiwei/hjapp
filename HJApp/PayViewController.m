//
//  PayViewController.m
//  HuaJiWang
//
//  Created by Bruce He on 15/8/27.
//  Copyright (c) 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "PayViewController.h"
#import "AdressViewController.h"
#import "HttpEngine.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ZhiFuBaoOrder.h"
#import "DataSigner.h"


@interface PayViewController () <UIScrollViewDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSArray*payStyleArray;
@property(nonatomic,strong)NSArray*orderArray;
@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic,copy)NSString*totalPrice;
@property(nonatomic,copy)NSString*shippingFee;
@property(nonatomic,copy)NSString*paymentPrice;
@property(nonatomic,strong)NSArray*priceOrderArray;
@property(nonatomic,strong)UILabel*okaneL;
@property(nonatomic,strong)UIButton*kessanBtn;
@property(nonatomic,unsafe_unretained)int lastTag;
@property(nonatomic,strong)NSArray*adressArray;
@property(nonatomic,strong)UIView*shadowView;
@property(nonatomic,copy)NSString*addrId;
@property(nonatomic,copy)NSString*password;
@property(nonatomic,copy)UITextField*tf;


@end

@implementation PayViewController



#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

-(void)viewWillAppear:(BOOL)animated
{
    [self hidesTabBar:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"确认订单";
    
    //(0, 0, LBVIEW_WIDTH1-VIEW_WIDTH / 2.95+1, VIEW_HEIGHT / 13);
    
    
    
    [HttpEngine getCart:^(NSArray *dataArray, NSString *totalPrice, NSString *shippingFee, NSString *paymentPrice) {
        _dataArray=dataArray;
        _totalPrice=totalPrice;
        _paymentPrice=paymentPrice;
        _shippingFee=shippingFee;
        [self showTableView];
        
    }];
}

-(void)showTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, LBVIEW_WIDTH1, LBVIEW_HEIGHT1-118) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    _payStyleArray=[[NSArray alloc]initWithObjects:@"花集余额",@"微信支付",@"支付宝",nil];
    _orderArray=[[NSArray alloc]initWithObjects:@"总价",@"配送费",@"花集红包", nil];
    _priceOrderArray=[[NSArray alloc]initWithObjects:_totalPrice,_shippingFee,@"0", nil];
    
    [self showBtn];
}
-(void)showBtn
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, LBVIEW_HEIGHT1-LBVIEW_HEIGHT1/13, LBVIEW_WIDTH1-LBVIEW_WIDTH1/2.95, LBVIEW_HEIGHT1/13)];
    label.backgroundColor=[UIColor blackColor];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=[NSString stringWithFormat:@"实付款:  ¥%@",_paymentPrice];
    [self.view addSubview:label];
    
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-LBVIEW_WIDTH1/2.95, LBVIEW_HEIGHT1-LBVIEW_HEIGHT1/13, LBVIEW_WIDTH1/2.95,LBVIEW_HEIGHT1/13)];
    [btn setBackgroundImage:[UIImage imageNamed:@"kessan.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotopayAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

//去支付
-(void)gotopayAction
{
    if(_lastTag==10)
    {
        [self inputPassword];
    }
    if (_lastTag==11)
    {
        [self goWeiXin];
    }
    if (_lastTag==12)
    {
        [self goZhiFuBao];
    }
    
}
//输入密码
-(void)inputPassword
{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.1, LBVIEW_HEIGHT1*0.45, LBVIEW_WIDTH1*0.8, LBVIEW_HEIGHT1*0.2)];
    //_view=[[UIView alloc]initWithFrame:CGSizeMake(280, 120)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=10;
    view.clipsToBounds=YES;
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 150, 20)];
    titleLabel.text=@"输入支付密码:";
    titleLabel.font=[UIFont systemFontOfSize:14];
    [view addSubview:titleLabel];
    
    _tf=[[UITextField alloc]initWithFrame:CGRectMake(10, 40, LBVIEW_WIDTH1*0.8-20, 30)];
    //[tfText setBorderStyle:UITextBorderStyleNone];
    [_tf setBorderStyle:UITextBorderStyleLine];
    [view addSubview:_tf];
    
    
    UILabel *labelStriping=[[UILabel alloc]initWithFrame:CGRectMake(0, LBVIEW_HEIGHT1*0.2-30, LBVIEW_WIDTH1*0.8, 1)];
    labelStriping.backgroundColor=[UIColor grayColor];
    [view addSubview:labelStriping];
    
    for (int i=0; i<2; i++)
    {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(i*LBVIEW_WIDTH1*0.4,LBVIEW_HEIGHT1*0.2-30, LBVIEW_WIDTH1*0.4, 30)];
        if (i==0)
        {
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
        if (i==1)
        {
            [btn setTitle:@"确认" forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(removeBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i+1;
        btn.titleLabel.font=[UIFont systemFontOfSize:18];
        [view addSubview:btn];
    }
    _shadowView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _shadowView.backgroundColor=[UIColor darkGrayColor];
    _shadowView.alpha=0.9;
    
    //找window
    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
    [window addSubview:_shadowView];
    [_shadowView addSubview:view];
}
-(void)removeBtn:(UIButton*)sender
{
    [_shadowView removeFromSuperview];
    _password=_tf.text;
    if (sender.tag==2)
    {
        [HttpEngine submitOrderAddressId:_addrId withMethod:@"huaji" withSpaypassword:_password withCouponNo:@""];
        
    }
    else
    {
        
    }
}
-(void)goWeiXin
{
    [HttpEngine WXsendPay];
    
}
//支付宝支付
-(void)goZhiFuBao
{
    
    NSString *partner = @"2088501633478038";
    NSString *seller = @"hr@ourbloom.com";
    NSString *privateKey = @"MIICXgIBAAKBgQC89o2rkejk5DqF9MZ2j/wmuhzDQdYZ8c1pitg36726la1Q4ySUy0nWmibKitlLrR61ph2ZE2pKHIEV7Wi4bPzUZVqRD+z4y7HcBFeBzq+2vBjsTFtuPOVsnc9yjaqV/ncC4GfCL9YvebILxl1mLsHJbyL3cZbgB1N+bZvBAtfwwwIDAQABAoGBAJUSlRVDWM4qVxkSz/b9BFmw/bv0lmmFXx3iUU1chyNJrZ9gcp2H+sp4dh3XiDGxc8auNC9tJ68r6ZJY5wKHyLSR5UUQ0Cze1nlooE9kltLNdADeEyAlSYN+M68MQrNSXdzoo0hLq04zpqc+XdGIA2xLDlhXRDbMlpVltldzhCxxAkEA9Ssei+mWVCB1nCMiz6qr5yV+SNif1dU02Sp9Lecs8nXrNcDlAsnYPqEjiA1l21Kj4pltUSC1hbS/V4AE+VkBTQJBAMVPvu+cruSF4bj0Sg6WA5JXCBUtgu41wYJRnAU7cg2h47anN0ILWeFFrOPnU/yKlgspnPRDHcHfiozLw0bdsk8CQQDcm/xUsdBPyxWJdiRw8YbV6+sC6cqJw9xWPeF+WLMdSfZo3DY2mCI52Q378vJgtLA7ywuPIPu2YLp8pfnT1b9RAkAn94ZKjOdUPNZDG6CgobxpeR2XBJf/3n2rAxLicG8i2ccBaY+k3h2/pthldacqgXvxGOXFCI9PhRNQf7m3chK7AkEAvtCyBgfzJ9I5wMzsRA7lKO4AjVhHe8SBYWYZWHMWPOipG7adAVm5dp+8g56BZBc3q+VeTfl+SFKn0ojcm+JPLQ==";
    
    ZhiFuBaoOrder *order = [[ZhiFuBaoOrder alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"2015368736746"; //订单ID（由商家?自?行制定）
    order.productName = @"订单详细"; //商品标题
    order.productDescription = @"10玫瑰"; //商品描述
    order.amount = @"10"; //商品价格
    order.notifyURL = @"http://www.baidu.com"; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"hjapp";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //【callback处理支付结果】
            NSLog(@"reslut = %@",resultDic);
        }];
        
    }
    
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==3||section==6)
    {
        return 3;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        return 60;
    }
    if (indexPath.section==5)
    {
        return 40;
    }
    if (indexPath.section==7)
    {
        return _dataArray.count;
    }
    return 30;
}
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    switch (indexPath.section)
    {
        case 0:
        {
            cell.textLabel.text=@"送货上门";
        }
            break;
        case 1:
        {
            
            [HttpEngine getAddress:^(NSArray *dataArray)
             {
                 _adressArray=dataArray;
                 AllAdress*adress=_adressArray[_adressArray.count-1];
                 _addrId=adress.addrId;
                 
                 UILabel*upLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 25)];
                 upLabel.text=[NSString stringWithFormat:@"%@  %@",adress.consignee,adress.phoneMob];
                 upLabel.font=[UIFont systemFontOfSize:12];
                 [cell addSubview:upLabel];
                 
                 UILabel*downLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 200, 25)];
                 downLabel.text=[NSString stringWithFormat:@"%@ %@ %@",adress.chineseProvince,adress.chineseCity,adress.chineseTown];
                 downLabel.font=[UIFont systemFontOfSize:12];
                 [cell addSubview:downLabel];
                 
             }];
            
        }
            break;
            
        case 2:
        {
            cell.textLabel.text=@"立即发送";
        }
            break;
            
        case 3:
        {
            cell.imageView.image=[UIImage imageNamed:@"Rose.png"];
            cell.textLabel.text=_payStyleArray[indexPath.row];
            UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-30, 5, 20, 20)];
            [btn setBackgroundImage:[UIImage imageNamed:@"maru.png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"Dg.png"] forState:UIControlStateSelected];
            btn.selected=NO;
            btn.tag=indexPath.row+10;
            [btn addTarget:self action:@selector(choosePayStyle:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
            break;
            
        case 4:
        {
            cell.textLabel.text=@"暂无红包";
        }
            break;
            
        case 5:
        {
            UITextField*tf=[[UITextField alloc]initWithFrame:CGRectMake(5, 5, LBVIEW_WIDTH1-10, 30)];
            //tf.backgroundColor=[UIColor grayColor];
            [cell addSubview:tf];
        }
            break;
            
        case 6:
        {
            cell.textLabel.text=_orderArray[indexPath.row];
            cell.textLabel.font=[UIFont systemFontOfSize:12];
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-50, 0, LBVIEW_WIDTH1*0.2, 30)];
            label.text=[NSString stringWithFormat:@"¥%@",_priceOrderArray[indexPath.row]];
            label.font=[UIFont systemFontOfSize:12];
            [cell addSubview:label];
            
        }
            break;
        case 7:
        {
            ShopingCar*spCa=_dataArray[indexPath.row];
            NSArray*detailArray=spCa.dataArray;
            NSMutableArray*attributeArray=[[NSMutableArray alloc]init];
            for (int i=0; i<detailArray.count; i++)
            {
                NSDictionary*dic=detailArray[i];
                NSString*str=[dic[@"visible"] stringValue];
                if ([str isEqualToString:@"1"])
                {
                    [attributeArray addObject:dic[@"prop_value"]];
                }
            }
            NSString*attributeStr=@"";
            for (int i=0; i<attributeArray.count; i++)
            {
                attributeStr=[NSString stringWithFormat:@"%@ %@",attributeStr,attributeArray[i]];
            }
            
            UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,0, LBVIEW_WIDTH1*0.5, 30)];
            nameLabel.font=[UIFont systemFontOfSize:12];
            nameLabel.text=[NSString stringWithFormat:@"%@ %@",spCa.skuName,attributeStr] ;
            [cell addSubview:nameLabel];
            
            UILabel*picLabel=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-50, 0, LBVIEW_WIDTH1*0.2, 30)];
            picLabel.text=[NSString stringWithFormat:@"¥%@",spCa.price];
            picLabel.textColor=[UIColor redColor];
            picLabel.font=[UIFont systemFontOfSize:12];
            [cell addSubview:picLabel];
            
            UILabel*numLabel=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.8, 0, 20, 30)];
            numLabel.text=[NSString stringWithFormat:@"x%@",spCa.number];
            numLabel.textAlignment=NSTextAlignmentCenter;
            numLabel.font=[UIFont systemFontOfSize:12];
            [cell addSubview:numLabel];
        }
            break;
            
        default:
            break;
    }
    return cell;
}
-(void)choosePayStyle:(UIButton*)sender
{
    if (_lastTag!=0)
    {
        UIButton*btn=[self.view viewWithTag:_lastTag];
        btn.selected=NO;
        NSLog(@"123");
    }
    sender.selected=!sender.selected;
    _lastTag=(int)sender.tag;
    
    
    
}
//区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 8;
}
//自定义区头
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]init];
    view.backgroundColor=[UIColor lightGrayColor];
    NSArray*array=[[NSArray alloc]initWithObjects:@"配送方式",@"配送地址",@"配送时间",@"支付方式",@"花集红包",@"订单备注",@"订单价格",@"商品清单", nil];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 30)];
    label.text=array[section];
    [view addSubview:label];
    
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
//自定义区尾
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]init];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-120, 5, 120, 30)];
    label.text=[NSString stringWithFormat:@"实际支付 ¥%@",_paymentPrice];
    label.textColor=[UIColor blackColor];
    [view addSubview:label];
    if (section==6)
    {
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==6)
    {
        return 40;
    }
    return 0;
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
@end;