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
#import "AdressViewController.h"


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

//送货方式
@property(nonatomic,strong)UIView*shadView;
@property(nonatomic,strong)UILabel*styleLabel;
@property(nonatomic,strong)NSDictionary*styleDic;
@property(nonatomic,copy)NSString*styleStr;

//配送地址
@property(nonatomic,strong)UILabel*distributionAddrsNameLabel;
@property(nonatomic,strong)UILabel*distributionAddrsDetailLabel;

//配送时间
@property(nonatomic,strong)UILabel*distributionLabel;
@property(nonatomic,strong)UIView*shadTimeView;

//默认地址
@property(nonatomic,strong)NSDictionary*defaultAddressDic;


//红包
@property(nonatomic,strong)NSArray*redArray;
@property(nonatomic,strong)UILabel*redLabel;
@property(nonatomic,copy)NSString*redStr;


@end

@implementation PayViewController



#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

-(void)viewWillAppear:(BOOL)animated
{
    //判断是否返回错误信息
    [HttpEngine getCart:^(NSDictionary*allDic,NSArray *dataArray, NSString *totalPrice, NSString *shippingFee, NSString *paymentPrice,NSString*error)
     {
         if ([error isEqualToString:@""])
         {
             [self getdefaultAddress];
         }
         
     }];

}
//获取地址
-(void)getdefaultAddress
{
    [HttpEngine getDefaultAddress:^(NSDictionary*dataDic)
     {
         _defaultAddressDic=dataDic;
         NSLog(@"_defaultAddressArray==%@",_defaultAddressDic);
         [self judgeCity];
         [_tableView reloadData];
     }];
}
-(void)judgeCity
{
    NSString*defaultAdressId=[NSString stringWithFormat:@"%@",_defaultAddressDic[@"province"]];
    
    
    NSString*adr=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    NSString*adressId=[NSString stringWithFormat:@"%@",adr];
    //截取默认地址前两位
    NSString*defaultTwo=[defaultAdressId substringToIndex:2];
    //截取选择地址前两位
    NSString*adressTwo=[adressId substringToIndex:2];
    
    
    if (![defaultTwo isEqualToString:adressTwo])
    {
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"收货地址不在当前选择的城市中" message:@"请选择其它地址:" preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            AdressViewController*adressVC=[[AdressViewController alloc]init];
            adressVC.payVCStr=@"payVC";
            adressVC.payVC=self;
            [self.navigationController pushViewController:adressVC animated:YES];
        }];
        UIAlertAction*cancal=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:defaultAction];
        [alert addAction:cancal];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"确认订单";
    
    
    [HttpEngine getCart:^(NSDictionary*allDic,NSArray *dataArray, NSString *totalPrice, NSString *shippingFee, NSString *paymentPrice,NSString*error)
    {
             if (![error isEqualToString:@""])
             {
                 UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:error preferredStyle: UIAlertControllerStyleAlert];
                 
                 UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                              {
                                                  [self.navigationController popViewControllerAnimated:YES];
                                              }];
                 UIAlertAction*cancal=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                     [self.navigationController popViewControllerAnimated:YES];
                 }];
                 
                 [alert addAction:defaultAction];
                 [alert addAction:cancal];
                 [self presentViewController:alert animated:YES completion:nil];
                 
                 return ;
             }

        _dataArray=dataArray;
        _styleDic=allDic;
        _totalPrice=totalPrice;
        _paymentPrice=paymentPrice;
        _shippingFee=shippingFee;
        [self showTableView];
        
    }];
    
}

-(void)showTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1-64-LBVIEW_HEIGHT1 / 13) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];

    [self.view addSubview:_tableView];
    _payStyleArray=[[NSArray alloc]initWithObjects:@"花集余额",@"支付宝",@"微信支付",nil];
    _orderArray=[[NSArray alloc]initWithObjects:@"总价",@"配送费",@"花集红包", nil];
    _priceOrderArray=[[NSArray alloc]initWithObjects:_totalPrice,_shippingFee,@"0", nil];
    
    //配送方式字符串
    NSString*selfPickup=[NSString stringWithFormat:@"%@",_styleDic[@"self_pickup"]];
    if ([selfPickup isEqualToString:@"0"])
    {
        _styleStr=@"送货上门";
    }
    else
    {
        _styleStr=@"上门提货";
        
    }
    //红宝状态
    NSString*priceStr=[NSString stringWithFormat:@"%@",_paymentPrice];
    int price=[priceStr intValue];
    [HttpEngine getRedBagStatus:@"1" completion:^(NSArray *dataArray)
     {
         _redArray=dataArray;
         
         if (_redArray.count==0)
         {
             _redStr=@"暂无红包";
         }
         else
         {
             for (int i=0; i<_redArray.count; i++)
             {
                 NSDictionary*dic=_redArray[i];
                 NSString*termPriceStr=[NSString stringWithFormat:@"%@",dic[@"term_price"]];
                 int termPrice=[termPriceStr intValue];
                 if (price<termPrice)
                 {
                     _redStr=@"未达到使用额度";
                 }
                 else
                 {
                     _redStr=@"请选择红包";
                 }
             }
             
         }
         [_tableView reloadData];
     }];
    
    [self showBtn];
}
-(void)showBtn
{
    UIView*payView=[[UIView alloc]initWithFrame:CGRectMake(0, 12*LBVIEW_HEIGHT1/13-64, LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 13)];
    payView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:payView];
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1-LBVIEW_WIDTH1/2.95, LBVIEW_HEIGHT1/13)];
   // label.backgroundColor=[UIColor blackColor];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=[NSString stringWithFormat:@"实付款:  ¥%@",_paymentPrice];
    [payView addSubview:label];
    
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-LBVIEW_WIDTH1/2.95, 0, LBVIEW_WIDTH1/2.95,payView.frame.size.height)];
//    [btn setBackgroundImage:[UIImage imageNamed:@"kessan.png"] forState:UIControlStateNormal];
    [btn setTitle:@"去结算" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(gotopayAction) forControlEvents:UIControlEventTouchUpInside];
    [payView addSubview:btn];
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
       [self goZhiFuBao];
        
    }
    if (_lastTag==12)
    {
       [self goWeiXin];
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
    _tf.secureTextEntry=YES;
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
    order.amount = @"10.00"; //商品价格
    order.notifyURL = @""; //回调URL
    
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"2015111300787957";
    
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
    if (section==7)
    {
        return _dataArray.count;
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
        return 70;
    }
    if (indexPath.section==6)
    {
        return 30;
    }
    if (indexPath.section==7)
    {
        return 30;
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
   
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    switch (indexPath.section)
    {
        case 0:
        {
            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 120,30)];
            view.layer.borderWidth=1;
            view.layer.borderColor=[UIColor grayColor].CGColor;
            [cell addSubview:view];
            
            _styleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
            _styleLabel.text=_styleStr;
            _styleLabel.textColor=[UIColor blackColor];
            _styleLabel.font=[UIFont systemFontOfSize:12];
            [view addSubview:_styleLabel];
            
            UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(90, 10, 20, 10)];
            image.image=[UIImage imageNamed:@"swiper-market-btn-b.png"];
            [view addSubview:image];
            
            UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
            [btn addTarget:self action:@selector(cutAddress) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
            break;
        case 1:
        {
        _distributionAddrsNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 25)];
        _distributionAddrsNameLabel.text=[NSString stringWithFormat:@"%@  %@",_defaultAddressDic[@"consignee"],_defaultAddressDic[@"phone_mob"]];
        _distributionAddrsNameLabel.font=[UIFont systemFontOfSize:12];
        [cell addSubview:_distributionAddrsNameLabel];
            
        _distributionAddrsDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 200, 25)];
        _distributionAddrsDetailLabel.text=[NSString stringWithFormat:@"%@ %@ %@",_defaultAddressDic[@"chinese_province"],_defaultAddressDic[@"chinese_city"],_defaultAddressDic[@"chinese_town"]];
        _distributionAddrsDetailLabel.font=[UIFont systemFontOfSize:12];
        [cell addSubview:_distributionAddrsDetailLabel];
            
        }
            break;
            
        case 2:
        {
            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 200,30)];
            view.layer.borderWidth=1;
            view.layer.borderColor=[UIColor grayColor].CGColor;
            [cell addSubview:view];
            
            _distributionLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
//            NSString*selfPickup=[NSString stringWithFormat:@"%@",_styleDic[@"self_pickup"]];
 
            NSArray*array=_styleDic[@"deadline"];
            _distributionLabel.text=array[0];
            _distributionLabel.textColor=[UIColor blackColor];
            _distributionLabel.font=[UIFont systemFontOfSize:12];
            [view addSubview:_distributionLabel];
            
            UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(170, 10, 20, 10)];
            image.image=[UIImage imageNamed:@"swiper-market-btn-b.png"];
            [view addSubview:image];
            
            UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
            [btn addTarget:self action:@selector(distributionTime) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
            break;
            
        case 3:
        {

            cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"pay1-%lu.png",indexPath.row+1]];

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
    
                _redLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 30)];
                _redLabel.text=_redStr;
                _redLabel.textColor=[UIColor blackColor];
                [cell addSubview:_redLabel];
            
                UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
                [btn addTarget:self action:@selector(chooseRedPage) forControlEvents:UIControlEventTouchUpInside];
                btn.layer.borderColor=[UIColor grayColor].CGColor;
                btn.layer.borderWidth=1;
                [cell addSubview:btn];
            
        }
            break;
            
        case 5:
        {
            UITextView*tView=[[UITextView alloc]initWithFrame:CGRectMake(10, 5, LBVIEW_WIDTH1-20,60)];
            tView.layer.borderColor =[UIColor grayColor].CGColor;
            tView.layer.borderWidth =1.0;
            tView.layer.cornerRadius =5.0;
            tView.tag=3;
            [cell addSubview:tView];
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
            ShopingCarDetail*spCa=_dataArray[indexPath.row];
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
    }
    return cell;
}

//切换地址按钮
-(void)cutAddress
{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/6, 9*LBVIEW_HEIGHT1/20, 2*LBVIEW_WIDTH1/3, LBVIEW_HEIGHT1/10)];
    NSArray*array=[[NSArray alloc]initWithObjects:@"送货上门",@"上门自提", nil];
    for (int i=0; i<2; i++)
    {
        
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, i*view.frame.size.height/2, view.frame.size.width, view.frame.size.height/2)];
        label.text=array[i];
        label.textColor=[UIColor blackColor];
        label.tag=110+i;
        label.backgroundColor=[UIColor whiteColor];
        [view addSubview:label];
        
        UILabel*lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height/2, view.frame.size.width, 1)];
        lineLabel.backgroundColor=[UIColor grayColor];
        [view addSubview:lineLabel];
        
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, i*view.frame.size.height/2, view.frame.size.width, view.frame.size.height/2)];
        [btn addTarget:self action:@selector(chooseStyle:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=100+i;
        [view addSubview:btn];
    }
    
    
    _shadView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _shadView.backgroundColor=[UIColor darkGrayColor];
    _shadView.alpha=0.8;
    
    //找window
    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
    [window addSubview:_shadView];
    [_shadView addSubview:view];
    
}
-(void)chooseStyle:(UIButton*)sender
{
    UILabel*label=[_shadView viewWithTag:sender.tag+10];
    _styleStr=label.text;
    _styleLabel.text=_styleStr;
    
    [_shadView removeFromSuperview];
}
//配送时间
-(void)distributionTime
{
   NSArray*timeArray=_styleDic[@"deadline"];
    
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/6,(LBVIEW_HEIGHT1-timeArray.count*LBVIEW_HEIGHT1/10)/2, 2*LBVIEW_WIDTH1/3,timeArray.count*LBVIEW_HEIGHT1/10)];
    for (int i=0; i<timeArray.count; i++)
    {
        
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, i*view.frame.size.height/(timeArray.count+1), view.frame.size.width, view.frame.size.height/(timeArray.count+1))];
        label.text=timeArray[i];
        label.textColor=[UIColor blackColor];
        label.tag=300+i;
        label.backgroundColor=[UIColor whiteColor];
        [view addSubview:label];
        
        UILabel*lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, i*view.frame.size.height/(timeArray.count+1), view.frame.size.width, 1)];
        lineLabel.backgroundColor=[UIColor grayColor];
        [view addSubview:lineLabel];
        
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, i*view.frame.size.height/(timeArray.count+1), view.frame.size.width, view.frame.size.height/(timeArray.count+1))];
        [btn addTarget:self action:@selector(chooseTime:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=200+i;
        [view addSubview:btn];
    }
    
    
    _shadTimeView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _shadTimeView.backgroundColor=[UIColor darkGrayColor];
    _shadTimeView.alpha=0.8;
    
    //找window
    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
    [window addSubview:_shadTimeView];
    [_shadTimeView addSubview:view];
}
//选择红包
-(void)chooseRedPage
{
    
    
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/6,(LBVIEW_HEIGHT1-_redArray.count*LBVIEW_HEIGHT1/10)/2, 2*LBVIEW_WIDTH1/3,_redArray.count*LBVIEW_HEIGHT1/10)];
    for (int i=0; i<_redArray.count; i++)
    {
        
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, i*view.frame.size.height/(_redArray.count+1), view.frame.size.width, view.frame.size.height/(_redArray.count+1))];
        NSDictionary*dic=_redArray[i];
        label.text=[NSString stringWithFormat:@"%@元红包",dic[@"price"]];
        label.textColor=[UIColor blackColor];
        label.tag=900+i;
        label.backgroundColor=[UIColor whiteColor];
        [view addSubview:label];
        
        UILabel*lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, i*view.frame.size.height/(_redArray.count+1), view.frame.size.width, 1)];
        lineLabel.backgroundColor=[UIColor grayColor];
        [view addSubview:lineLabel];
        
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, i*view.frame.size.height/(_redArray.count+1), view.frame.size.width, view.frame.size.height/(_redArray.count+1))];
        [btn addTarget:self action:@selector(chooseRed:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=800+i;
        [view addSubview:btn];
    }
    
    
    _shadTimeView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _shadTimeView.backgroundColor=[UIColor darkGrayColor];
    _shadTimeView.alpha=0.8;
    
    //找window
    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
    [window addSubview:_shadTimeView];
    [_shadTimeView addSubview:view];
}
//选择时间
-(void)chooseTime:(UIButton*)sender
{
    UILabel*label=[_shadTimeView viewWithTag:sender.tag+100];
    _distributionLabel.text=label.text;
    [_shadTimeView removeFromSuperview];

}

//选择支付方式
-(void)choosePayStyle:(UIButton*)sender
{
    if (_lastTag!=0)
    {
        UIButton*btn=[self.view viewWithTag:_lastTag];
        btn.selected=NO;
    }
    sender.selected=!sender.selected;
    _lastTag=(int)sender.tag;
}

//选择红包
-(void)chooseRed:(UIButton*)sender
{
    UILabel*label=[_shadTimeView viewWithTag:sender.tag+100];
    _redStr=label.text;
    _redLabel.text=_redStr;
    [_shadTimeView removeFromSuperview];
    
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
    NSArray*array=[[NSArray alloc]initWithObjects:@"配送方式",@"配送地址",@"配送时间",@"支付方式",@"花集红包",@"订单备注",@"订单价格",@"商品清单", nil];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 30)];
    label.text=array[section];
    [view addSubview:label];
    
    if (section==1)
    {
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-140, 10, 120, 20)];
        [btn setTitle:@"选择其它收货地址" forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeAddress) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-20, 10, 10, 20)];
        image.image=[UIImage imageNamed:@"item-r.png"];
        [view addSubview:image];
    }
    
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
//更换地址
-(void)changeAddress
{
    AdressViewController*adressVC=[[AdressViewController alloc]init];
    adressVC.payVCStr=@"payVC";
    adressVC.payVC=self;
    [self.navigationController pushViewController:adressVC animated:YES];
    
}
//自定义区尾
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]init];
    view.backgroundColor=[UIColor whiteColor];
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

@end;