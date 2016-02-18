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
#import "WxApi.h"
#import "OrderPageViewController.h"
#import "ChangCityViewController.h"


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
@property (nonatomic,copy)NSString *selfPickup;

//配送地址
@property(nonatomic,strong)UILabel*distributionAddrsNameLabel;
@property(nonatomic,strong)UILabel*distributionAddrsDetailLabel;
@property (nonatomic,copy) NSString *addressDetail;

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
@property(nonatomic,copy)NSString*preferNo;
@property(nonatomic,copy)NSString*priceRed;

@property(nonatomic,copy)NSString*defaultPayPrice;
@property(nonatomic,unsafe_unretained)int ttPrice;
@property(nonatomic,strong)UILabel*ttLabel;

//订单备注
@property(nonatomic,strong)UITextView *CustMessageTextV;
@end

@implementation PayViewController

NSInteger pay_type;


#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

-(void)viewWillAppear:(BOOL)animated
{
    //判断是否返回错误信息（用来防止某些时间段不能付款）
    [HttpEngine getCart:^(NSDictionary*allDic,NSArray *dataArray, NSString *totalPrice, NSString *shippingFee, NSString *paymentPrice,NSString*error)
     {
         if ([error isEqualToString:@""])
         {
             [self getdefaultAddress];
         }
         
     }];

    if (_defaultPayPrice)
    {
        _paymentPrice=_defaultPayPrice;
    }
    
    //返回配送方式
    if (_isTag==11)
    {
        _styleStr=@"上门自提";
        _selfPickup = @"1";

    } else {
        _styleStr=@"送货上门";
        _selfPickup = @"0";
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
    if(![_isTagRedPacket isEqualToString:@""])
    {
        _redStr=[NSString stringWithFormat:@"%@元红包",_isTagRedPacket];
        _priceRed=[_isTagRedPacket substringToIndex:2];
        _ttPrice=[_paymentPrice intValue]-[_priceRed intValue];
        _ttLabel.text=[NSString stringWithFormat:@"¥%d.00",_ttPrice];
        _paymentPrice=[NSString stringWithFormat:@"%d",_ttPrice];
        _preferNo=_couponNo;

    }
    
    if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:@"order_pay_notification" object:nil];//监听一个通知
    }
}

#pragma mark - 通知信息
- (void)getOrderPayResult:(NSNotification *)notification{
    if ([notification.object isEqualToString:@"success"])
    {
        [self alert:@"恭喜" msg:@"订单支付成功"];
        // to  order page
    }
    else
    {
        [self alert:@"提示" msg:@"订单支付失败"];
        // to  order page
    }
    [self tabBarVC].selectedIndex = 2;
}

//获取地址
-(void)getdefaultAddress
{
    [HttpEngine getDefaultAddress:^(NSDictionary*dataDic)
     {
         _defaultAddressDic=dataDic;
         _addrId = [NSString stringWithFormat:@"%@",_defaultAddressDic[@"addr_id"]];
         NSLog(@"_defaultAddressArray==%@",_defaultAddressDic);
         [self judgeCity];
         [_tableView reloadData];
     }];
}

-(void)judgeCity
{
    NSString*provinceCode=[NSString stringWithFormat:@"%@",_defaultAddressDic[@"province"]];
    NSString*cityCode=[NSString stringWithFormat:@"%@",_defaultAddressDic[@"city"]];
    NSString*townCode=[NSString stringWithFormat:@"%@",_defaultAddressDic[@"town"]];
    
    NSArray *allowed_regions = [[[NSUserDefaults standardUserDefaults]objectForKey:@"ALLOWED_REGIONS"] componentsSeparatedByString:@","];
    
    NSString*location=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"]];
    //判断有没有选择城市
    NSString*code=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    if (!code)
    {
        [self alert];
        return;
    }
    NSString *errorMessage = @"";
    if (![provinceCode isEqualToString:location]&&![cityCode isEqualToString:location])
    {
        errorMessage = [NSString stringWithFormat:@"收货地址不在当前选中的城市中。\n可配送区域\n%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ALLOWED_REGIONS_NAME"]];
    }
    else if(![allowed_regions containsObject:townCode] && ![allowed_regions containsObject:cityCode])
    {
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

//选择默认城市
-(void)alert
{
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未选择城市" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction*action)
                          {
                              
                          }];
    UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action)
                                 {
                                     ChangCityViewController*changVC=[[ChangCityViewController alloc]init];
                                     changVC.hidesBottomBarWhenPushed=YES;
                                     [self.navigationController pushViewController:changVC animated:YES];
                                 }];
    [alert addAction:cancel];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"确认订单";
    
    pay_type = 0;
    _isTagRedPacket = @"";
    
    if (!_priceRed)
    {
        _priceRed=@"0";
    }
    _selfPickup = @"0";
    
    MBProgressHUD *hud = [BWCommon getHUD];
    //获取错误信息  防止时间段不供应
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
        if (_show_deadline) {
            NSArray*array=_styleDic[@"deadline"];
            _distributionTimeStr=array[0];
        }
        float tprice = [totalPrice floatValue];
        totalPrice = [NSString stringWithFormat:@"%.2f",tprice];
        _totalPrice=totalPrice;
        float fprice = [paymentPrice floatValue];
        paymentPrice = [NSString stringWithFormat:@"%.2f",fprice];
        _paymentPrice=paymentPrice;
        _defaultPayPrice=paymentPrice;
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
    
    [HttpEngine getBalance:^(NSDictionary *dic)
     {
         if (dic) {
             NSString *huaJiMeny = [NSString stringWithFormat:@"花集余额(%@)",dic[@"nmoney"]];
             _payStyleArray=[[NSArray alloc]initWithObjects:huaJiMeny,@"支付宝",@"微信支付",nil];
         }
     }];
    _orderArray=[[NSArray alloc]initWithObjects:@"总价",@"配送费",@"花集红包", nil];
    _priceOrderArray=[[NSArray alloc]initWithObjects:_totalPrice,_shippingFee,_priceRed, nil];
    
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
                 if (price>termPrice)
                 {
                     _redStr=@"请选择红包";
                     break;
                 }
                 else
                 {
                     if (i==_redArray.count-1)
                     {
                         _redStr=@"红包不可用";
                     }
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
    
    _ttLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1-LBVIEW_WIDTH1/2.95, LBVIEW_HEIGHT1/13)];
   // label.backgroundColor=[UIColor blackColor];
    _ttLabel.textColor=[UIColor whiteColor];
    _ttLabel.textAlignment=NSTextAlignmentCenter;
    _ttLabel.text=[NSString stringWithFormat:@"实付款:  ¥%@",_paymentPrice];
    [payView addSubview:_ttLabel];
    
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
    else
    {
        [self createOrder];
    }

}
#pragma mark----------创建订单
-(void)createOrder
{
    NSString *province = _defaultAddressDic[@"province"];
    NSString *city = _defaultAddressDic[@"city"];
    NSString *town = _defaultAddressDic[@"town"];
    NSString *phoneMob = _defaultAddressDic[@"phone_mob"];
    NSString *consignee = _defaultAddressDic[@"consignee"];
    if (_isTag!=11) {
        NSString *address = _defaultAddressDic[@"address"];
        _addressDetail = address;
    }
    if (!_preferNo) {
        _preferNo = @"0";
    }
    if (!_CustMessageTextV.text) {
        _CustMessageTextV.text = @" ";
    }
    if (!_distributionLabel.text) {
        _distributionLabel.text = @" ";
    }
    if (!_password) {
        _password = @" ";
    }
    NSArray *pay_method = [[NSArray alloc] initWithObjects:@"huaji",@"alipay",@"weixin", nil];
    
    [HttpEngine submitOrderMethod:[pay_method objectAtIndex:pay_type] withSpaypassword:_password withDeadline:_distributionLabel.text withCouponNo:_preferNo withCustMessage:_CustMessageTextV.text withSelfPickup:_selfPickup withAddressId:_addrId withConsignee:consignee withProvince:province withCity:city withTown:town withPhoneMob:phoneMob withAddress:_addressDetail completion:^(NSDictionary *dict) {
        
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提醒" message:dict[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
         
         NSString *actionTitle = pay_type == 0 ? @"查看我的订单" : @"去支付";
 
         UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
             if(pay_type == 0)
             {
                 // order page
                 
             }
             else if (pay_type==1)
             {
                 [self alipay:dict[@"out_trade_no"] amount:dict[@"payment_price"] completion:^(BOOL success)
                  {
                      //order page
                  }];
             }
             else if (pay_type==2)
             {
                 [self WeiXinPay:dict[@"out_trade_no"]];
             }
             [self.navigationController popViewControllerAnimated:YES];
         }];
         if (pay_type!=0)
         {
            UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
             {
                 [self.navigationController popViewControllerAnimated:YES];
            }];
             [alertController addAction:cancel];
             
         }
         [alertController addAction:defaultAction];
 
         [self presentViewController:alertController animated:YES completion:nil];
         
     }];
}

//输入密码
-(void)inputPassword
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入支付密码" message:@"请输入您花集账户的支付密码" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
     {
        textField.secureTextEntry = YES;
        textField.placeholder = @"支付密码";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        UITextField *pay_password = alertController.textFields.firstObject;
        _password = pay_password.text;
        [self createOrder];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
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
            _styleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 90, 30)];
            _styleLabel.text=_styleStr;
            _styleLabel.textColor=[UIColor blackColor];
            _styleLabel.font=[UIFont systemFontOfSize:14];
            [cell addSubview:_styleLabel];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
        {
           
        _distributionAddrsNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 25)];
        _distributionAddrsNameLabel.text=[NSString stringWithFormat:@"%@  %@",_defaultAddressDic[@"consignee"],_defaultAddressDic[@"phone_mob"]];
        _distributionAddrsNameLabel.font=[UIFont systemFontOfSize:14];
        [cell addSubview:_distributionAddrsNameLabel];
            
        _distributionAddrsDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 30, 280, 25)];
        _distributionAddrsDetailLabel.text=[NSString stringWithFormat:@"%@ %@ %@",_defaultAddressDic[@"chinese_province"],_defaultAddressDic[@"chinese_city"],_defaultAddressDic[@"chinese_town"]];
        _distributionAddrsDetailLabel.font=[UIFont systemFontOfSize:14];
        [cell addSubview:_distributionAddrsDetailLabel];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        if (_isTag==11)
        {
            NSArray *pickupAddressArray = _styleDic[@"pickup_address"];
            NSDictionary *pickupAddressDic = pickupAddressArray[0];
            _distributionAddrsNameLabel.text=[NSString stringWithFormat:@"%@  %@",pickupAddressDic[@"consignee"],pickupAddressDic[@"phone_mob"]];
            NSString *str = pickupAddressDic[@"address"];
            NSString *pickAddrss = [str substringToIndex:(str.length-6)];
            _distributionAddrsDetailLabel.text=pickAddrss;
            _addressDetail = pickAddrss;
        }
            
        }
            break;
            
        case 2:
        {
            _distributionLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 30)];
            _distributionLabel.text=_distributionTimeStr;
            _distributionLabel.textColor=[UIColor blackColor];
            _distributionLabel.font=[UIFont systemFontOfSize:14];
            [cell addSubview:_distributionLabel];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case 3:
        {
            PayTableViewCell *cell0 = [PayTableViewCell cellWithTableView:tableView];
            [cell0.iconImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pay1-%lu.png",indexPath.row+1]]];
            cell0.textLabel.text=_payStyleArray[indexPath.row];
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

            if (![_redStr isEqualToString:@"红包不可用"]&&![_redStr isEqualToString:@"暂无红包"])
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
            _CustMessageTextV=[[UITextView alloc]initWithFrame:CGRectMake(10, 5, LBVIEW_WIDTH1-20,60)];
            _CustMessageTextV.layer.borderColor =[UIColor grayColor].CGColor;
            _CustMessageTextV.layer.borderWidth =1.0;
            _CustMessageTextV.layer.cornerRadius =5.0;
            _CustMessageTextV.tag=3;
            self.cust_message = _CustMessageTextV;
            [cell addSubview:_CustMessageTextV];
        }
            break;
            
        case 6:
        {
            cell.textLabel.text=_orderArray[indexPath.row];
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-50, 0, LBVIEW_WIDTH1*0.2, 30)];
            if (indexPath.row==2)
            {
                label.text=[NSString stringWithFormat:@"¥-%@",_priceRed];
            }
            else
            {
            label.text=[NSString stringWithFormat:@"¥%@",_priceOrderArray[indexPath.row]];
            }
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
            nameLabel.text=[NSString stringWithFormat:@"%@ %@",spCa.skuName,attributeStr];
            [cell addSubview:nameLabel];
            
            UILabel*picLabel=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-65, 0, LBVIEW_WIDTH1*0.2+10, 30)];
            picLabel.text=[NSString stringWithFormat:@"¥%@",spCa.price];
            picLabel.textColor=[UIColor redColor];
            picLabel.font=[UIFont systemFontOfSize:14];
            [cell addSubview:picLabel];
            
            UILabel*numLabel=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.8-38, 0, 30, 30)];
            numLabel.text=[NSString stringWithFormat:@"x%@",spCa.number];
            numLabel.textAlignment=NSTextAlignmentRight;
            numLabel.font=[UIFont systemFontOfSize:14];
            [cell addSubview:numLabel];
        }
            break;
            
        default:
            break;
    }
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0)
    {
        int selfPickup = [_styleDic[@"self_pickup"] intValue];
        if (selfPickup==1) {
            [self cutAddress];
        }
    }else
        if(indexPath.section ==1){
            if (_isTag!=11) {
              [self changeAddress];
            }
        }else
            if(indexPath.section == 2)
            {
                int showDeadline = [_styleDic[@"show_deadline"] intValue];
                if (showDeadline) {
                    [self distributionTime];
                }
            }
            else
                if (indexPath.section==3)
                {
                    pay_type = indexPath.row;
                    [tableView reloadData];
                }
}
//切换配送方式
-(void)cutAddress
{
    DistributionStyleViewController*distribuVC=[[DistributionStyleViewController alloc]init];
    distribuVC.payVC=self;
    [self.navigationController pushViewController:distribuVC animated:YES];
}
//更换地址
-(void)changeAddress
{
    AdressViewController*adressVC=[[AdressViewController alloc]init];
    adressVC.payVCStr=@"payVC";
    adressVC.payVC=self;
    [self.navigationController pushViewController:adressVC animated:YES];
    
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
    redPacketVC.payPrice=_paymentPrice;
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

//自定义区尾
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]init];
    view.backgroundColor=[UIColor whiteColor];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-130, 5, 110, 30)];
    label.text=@"实际支付";
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[UIColor blackColor];
    [view addSubview:label];
    
    UIFont*font=[UIFont systemFontOfSize:14];
    CGSize size=[label.text boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    UILabel*labelp=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-120+size.width, 5, 65, 30)];
    labelp.text=[NSString stringWithFormat:@"¥%@",_paymentPrice];
    labelp.textColor=[UIColor redColor];
    labelp.font=[UIFont systemFontOfSize:14];
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