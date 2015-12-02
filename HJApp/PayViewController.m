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
#import "DistributionStyleViewController.h"
#import "DistributionTimeViewController.h"
#import "redPacketViewController.h"
#import "PayTableViewCell.h"


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
@property(nonatomic,retain) UITextView *cust_message;

@property(nonatomic,unsafe_unretained)BOOL show_deadline;
@property(nonatomic,unsafe_unretained)BOOL self_pickup;



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
@property(nonatomic,copy)NSString*distributionTimeStr;
@property(nonatomic,strong)UIView*shadTimeView;

//默认地址
@property(nonatomic,strong)NSDictionary*defaultAddressDic;


//红包
@property(nonatomic,strong)NSArray*redArray;
@property(nonatomic,strong)UILabel*redLabel;
@property(nonatomic,copy)NSString*redStr;


@end

@implementation PayViewController

NSInteger pay_type;


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
    
    //返回配送方式
    if (_isTag==10)
    {
        _styleStr=@"送货上门";
    }
    if (_isTag==11)
    {
        _styleStr=@"上门自提";
    }
    //返回配送时间
    if (_styleDic.count!=0)
    {
        if (_isTagTime!=0)
        {
            NSArray*array=_styleDic[@"deadline"];
            _distributionTimeStr=array[_isTagTime-10];
        }
    }
    //返回配送红包
    if(_isTagRedPacket!=nil)
    {
        _redStr=_isTagRedPacket;
    }

}
//获取地址
-(void)getdefaultAddress
{
    [HttpEngine getDefaultAddress:^(NSDictionary*dataDic)
     {
         _defaultAddressDic=dataDic;
         
         _addrId = [NSString stringWithFormat:@"%@",_defaultAddressDic[@"addr_id"]];
         NSLog(@"_defaultAddressArray==%@",_defaultAddressDic);
         //[self judgeIsNull];
         [self judgeCity];
         [_tableView reloadData];
     }];
}

//-(void)judgeIsNull
//{
//    if (_defaultAddressDic.count==0)
//    {
//        [HttpEngine getAddress:^(NSArray *dataArray)
//         {
//             NSArray*array=dataArray;
//             _defaultAddressDic=array[array.count-1];
//             [_tableView reloadData];
//        }];
//    }
//}

-(void)judgeCity
{
    NSString*provinceCode=[NSString stringWithFormat:@"%@",_defaultAddressDic[@"province"]];
    NSString*cityCode=[NSString stringWithFormat:@"%@",_defaultAddressDic[@"city"]];
    NSString*townCode=[NSString stringWithFormat:@"%@",_defaultAddressDic[@"town"]];
    
    NSArray *allowed_regions = [[[NSUserDefaults standardUserDefaults]objectForKey:@"ALLOWED_REGIONS"] componentsSeparatedByString:@","];
    
    
    NSString*location=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"]];
    

    NSString *errorMessage = @"";
    if (provinceCode != location && cityCode != location)
    {
        errorMessage = [NSString stringWithFormat:@"收货地址不在当前选中的城市中。\n可配送区域\n%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ALLOWED_REGIONS_NAME"]];
    }
    else if(![allowed_regions containsObject:townCode] && ![allowed_regions containsObject:cityCode])
    {
        //errorMessage = @"收货地址所在区域暂未开通配送服务。\n 可配送区域\n";
        errorMessage = [NSString stringWithFormat:@"收货地址所在区域暂未开通配送服务。\n可配送区域\n%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ALLOWED_REGIONS_NAME"]];
    }
    
    if(![errorMessage isEqualToString:@""])
    {
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"系统提示" message:errorMessage preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            AdressViewController*adressVC=[[AdressViewController alloc]init];
            adressVC.payVCStr=@"payVC";
            adressVC.payVC=self;
            [self.navigationController pushViewController:adressVC animated:NO];
        }];
        UIAlertAction*cancal=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
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
    
    pay_type = 0;
    _isTagRedPacket = @"";
    _password = @"";
    
    MBProgressHUD *hud = [BWCommon getHUD];
    [HttpEngine getCart:^(NSDictionary*allDic,NSArray *dataArray, NSString *totalPrice, NSString *shippingFee, NSString *paymentPrice,NSString*error)
    {
        [hud removeFromSuperview];
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
        _show_deadline = allDic[@"show_deadline"];
        _self_pickup = allDic[@"self_pickup"];
        //_self_pickup = 0;
        //NSLog(@"self_pickup  %@",_styleDic);
        //NSLog(@"self_pickup  %d",_self_pickup);
        NSArray*array=_styleDic[@"deadline"];
        _distributionTimeStr=array[0];
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
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [_tableView addGestureRecognizer:gestureRecognizer];

    [self.view addSubview:_tableView];
    _payStyleArray=[[NSArray alloc]initWithObjects:@"花集余额",@"支付宝",@"微信支付",nil];
    _orderArray=[[NSArray alloc]initWithObjects:@"总价",@"配送费",@"花集红包", nil];
    _priceOrderArray=[[NSArray alloc]initWithObjects:_totalPrice,_shippingFee,@"0", nil];
    
    //配送方式字符串
    _styleStr=@"送货上门";
    
    //红包状态
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
                     _redStr=@"暂无可用红包";
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
    if(pay_type == 0)
    {
       [self inputPassword];
    }
    if (pay_type == 1)
    {
       [self goZhiFuBao];
        
    }
    if (pay_type == 2)
    {
       [self goWeiXin];
    }
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        [self changeAddress];
    }else if(indexPath.section == 3){
        //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        pay_type = indexPath.row;
        [tableView reloadData];
    }
}
//输入密码
-(void)inputPassword
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入支付密码" message:@"请输入您花集账户的支付密码" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = YES;
        textField.placeholder = @"支付密码";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *pay_password = alertController.textFields.firstObject;
        _password = pay_password.text;
        NSLog(@"支付密码：%@",_password);
        
        [self createOrder];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void) createOrder{
    
    NSArray *pay_method = [[NSArray alloc] initWithObjects:@"huaji",@"alipay",@"weixin", nil];
    
    
    [HttpEngine submitOrderAddressId:_addrId withMethod:[pay_method objectAtIndex:pay_type] withSpaypassword:_password withCouponNo:_isTagRedPacket];
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
    if((section == 0 && !_self_pickup) || (section == 2 && !_show_deadline))
        return 0;

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
    if((indexPath.section == 0 && !_self_pickup) || (indexPath.section == 2 && !_show_deadline))
        return 0;
    
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
        return 40;
    }
    if (indexPath.section==7)
    {
        return 40;
    }
    return 40;
}
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    
    switch (indexPath.section)
    {
        case 0:
        {
//            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 120,40)];
//            [cell addSubview:view];
            
            _styleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
            _styleLabel.text=_styleStr;
            _styleLabel.textColor=[UIColor blackColor];
            _styleLabel.font=[UIFont systemFontOfSize:14];
            [cell addSubview:_styleLabel];
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            //UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-30, 5, 10, 20)];
            //image.image=[UIImage imageNamed:@"item-r.png"];
            //[view addSubview:image];
            
            UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, 40)];
            [btn addTarget:self action:@selector(cutAddress) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
            break;
        case 1:
        {
        _distributionAddrsNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 25)];
        _distributionAddrsNameLabel.text=[NSString stringWithFormat:@"%@  %@",_defaultAddressDic[@"consignee"],_defaultAddressDic[@"phone_mob"]];
        _distributionAddrsNameLabel.font=[UIFont systemFontOfSize:14];
        [cell addSubview:_distributionAddrsNameLabel];
            
        _distributionAddrsDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 30, 200, 25)];
        _distributionAddrsDetailLabel.text=[NSString stringWithFormat:@"%@ %@ %@",_defaultAddressDic[@"chinese_province"],_defaultAddressDic[@"chinese_city"],_defaultAddressDic[@"chinese_town"]];
        _distributionAddrsDetailLabel.font=[UIFont systemFontOfSize:14];
        [cell addSubview:_distributionAddrsDetailLabel];
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }
            break;
            
        case 2:
        {
//            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(10, 0, 200,30)];
//            [cell addSubview:view];
            
            _distributionLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 30)];
            _distributionLabel.text=_distributionTimeStr;
            _distributionLabel.textColor=[UIColor blackColor];
            _distributionLabel.font=[UIFont systemFontOfSize:14];
            [cell addSubview:_distributionLabel];
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            //UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-30, 5, 10, 20)];
            //image.image=[UIImage imageNamed:@"item-r.png"];
            //[view addSubview:image];
            
            UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, 40)];
            [btn addTarget:self action:@selector(distributionTime) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
            break;
            
        case 3:
        {
            PayTableViewCell *cell0 = [PayTableViewCell cellWithTableView:tableView];
            
            //UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 24, 24)];
            [cell0.iconImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pay1-%lu.png",indexPath.row+1]]];
            //cell0.iconImage = iconImage;
            //cell.imageView.frame = CGRectMake(0, 0, 24, 24);
            cell0.textLabel.text=_payStyleArray[indexPath.row];
            //cell0.selected = YES;
            /*UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-30, 5, 20, 20)];
            [btn setBackgroundImage:[UIImage imageNamed:@"maru.png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"Dg.png"] forState:UIControlStateSelected];
            btn.selected=NO;
            btn.tag=indexPath.row+10;
            [btn addTarget:self action:@selector(choosePayStyle:) forControlEvents:UIControlEventTouchUpInside];
            [cell0 addSubview:btn];*/
            
            if(pay_type == indexPath.row){
                cell0.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell0.accessoryType = UITableViewCellAccessoryNone;
            }
            
            return cell0;
        }
            break;
            
        case 4:
        {
    
                _redLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 120, 30)];
                _redLabel.text=_redStr;
                _redLabel.font=[UIFont systemFontOfSize:14];
                _redLabel.textColor=[UIColor blackColor];
                [cell addSubview:_redLabel];
            
            
            //UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-20, 5, 10, 20)];
            //image.image=[UIImage imageNamed:@"item-r.png"];
            //[cell addSubview:image];
            
            if (![_redStr isEqualToString:@"暂无可用红包"]&&![_redStr isEqualToString:@"暂无红包"])
            {
                UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, 40)];
                [btn addTarget:self action:@selector(chooseRedPage) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            else{
                
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
        }
            break;
            
        case 5:
        {
            UITextView*tView=[[UITextView alloc]initWithFrame:CGRectMake(10, 5, LBVIEW_WIDTH1-20,60)];
            tView.layer.borderColor =[UIColor grayColor].CGColor;
            tView.layer.borderWidth =1.0;
            tView.layer.cornerRadius =5.0;
            tView.tag=3;
            
            self.cust_message = tView;
            [cell addSubview:tView];
        }
            break;
            
        case 6:
        {
            cell.textLabel.text=_orderArray[indexPath.row];
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-50, 0, LBVIEW_WIDTH1*0.2, 30)];
            label.text=[NSString stringWithFormat:@"¥%@",_priceOrderArray[indexPath.row]];
            label.font=[UIFont systemFontOfSize:14];
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
            
            UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,0, LBVIEW_WIDTH1*0.5, 30)];
            nameLabel.font=[UIFont systemFontOfSize:14];
            nameLabel.text=[NSString stringWithFormat:@"%@ %@",spCa.skuName,attributeStr] ;
            [cell addSubview:nameLabel];
            
            UILabel*picLabel=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-50, 0, LBVIEW_WIDTH1*0.2, 30)];
            picLabel.text=[NSString stringWithFormat:@"¥%@",spCa.price];
            picLabel.textColor=[UIColor redColor];
            picLabel.font=[UIFont systemFontOfSize:14];
            [cell addSubview:picLabel];
            
            UILabel*numLabel=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.8, 0, 20, 30)];
            numLabel.text=[NSString stringWithFormat:@"x%@",spCa.number];
            numLabel.textAlignment=NSTextAlignmentCenter;
            numLabel.font=[UIFont systemFontOfSize:14];
            [cell addSubview:numLabel];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

//切换地址按钮
-(void)cutAddress
{
    DistributionStyleViewController*distribuVC=[[DistributionStyleViewController alloc]init];
    distribuVC.payVC=self;
    [self.navigationController pushViewController:distribuVC animated:YES];

}

//配送时间
-(void)distributionTime
{
    DistributionTimeViewController*disTimeVC=[[DistributionTimeViewController alloc]init];
    disTimeVC.payVC=self;
    disTimeVC.dataArray=_styleDic[@"deadline"];
    [self.navigationController pushViewController:disTimeVC animated:NO];
}
//选择红包
-(void)chooseRedPage
{
    redPacketViewController*redPacketVC=[[redPacketViewController alloc]init];
    redPacketVC.payVC=self;
    redPacketVC.dataArray=_redArray;
    [self.navigationController pushViewController:redPacketVC animated:YES];
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

//区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 8;
}
//自定义区头
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]init];
    
    if((section == 0 && !_self_pickup) || (section == 2 && !_show_deadline))
        return view;
    
    NSArray*array=[[NSArray alloc]initWithObjects:@"配送方式",@"配送地址",@"配送时间",@"支付方式",@"花集红包",@"订单备注",@"订单价格",@"商品清单", nil];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 20)];
    label.text=array[section];
    [label setFont:NJTitleFont];
    [view addSubview:label];
    
  /*  if (section==1)
    {
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-140, 10, 120, 20)];
        [btn setTitle:@"选择其它收货地址" forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeAddress) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-20, 10, 10, 12)];
        image.image=[UIImage imageNamed:@"item-r.png"];
        [view addSubview:image];
    }
   */
    
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //if(section == 0)
    //    return 50;
    
    if((section == 0 && !_self_pickup) || (section == 2 && !_show_deadline))
        return 0.001;

    return 30;
}


-(void) hideKeyboard{
    [self.cust_message resignFirstResponder];
}
// 点击隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    [self.tableView endEditing:YES];
}

// tap dismiss keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.tableView endEditing:YES];
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
    label.text=@"实际支付";
    label.textColor=[UIColor blackColor];
    [view addSubview:label];
    
    UIFont*font=[UIFont systemFontOfSize:17];
    CGSize size=[label.text boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    UILabel*labelp=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-115+size.width, 5, 50, 30)];
    labelp.text=[NSString stringWithFormat:@"¥%@",_paymentPrice];
    labelp.textColor=[UIColor redColor];
    [view addSubview:labelp];
    
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
    return 0.001;
}
@end;