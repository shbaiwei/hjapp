//
//  ShopingPageViewController.m
//  HJApp
//
//  Created by Bruce He on 15/10/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "ShopingPageViewController.h"
#import "HttpEngine.h"
#import "PayViewController.h"
#import "AssortPageViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface ShopingPageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSArray*dataArray;

@property (nonatomic, strong) UILabel *okaneL;
@property (nonatomic, strong) UIButton *kessanBtn;

//

@property(nonatomic,copy)NSString*totalPrice;
@property(nonatomic,copy)NSString*shippingFee;
@property(nonatomic,strong)UILabel*shippingFeeLabel;


@end



#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

@implementation ShopingPageViewController

-(void)viewWillAppear:(BOOL)animated
{
    //[self hidesTabBar:NO];
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.translucent =NO;
    
    NSString*login=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    if (!login)
    {
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(20, LBVIEW_HEIGHT1/3-64, LBVIEW_WIDTH1-20, 20)];
        label.text=@"登录后，可查看自己的购物车列表";
        label.textColor=[UIColor grayColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:12];
        [self.view addSubview:label];
        
        NSArray*nameArray=[[NSArray alloc]initWithObjects:@"注册", @"登录",nil];
        for (int i=0; i<2; i++)
        {
            UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(40+i*(LBVIEW_WIDTH1-60)/2, LBVIEW_HEIGHT1/3+26,(LBVIEW_WIDTH1-100)/2, 40)];
            btn.layer.borderColor=[UIColor grayColor].CGColor;
            btn.layer.borderWidth=1;
            [btn setTitle:nameArray[i] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:164/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(loginRegister:) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.cornerRadius=5;
            btn.clipsToBounds=YES;
            btn.tag=332+i;
            [self.view addSubview:btn];
        }
        
        return;
    }

    
    
    
    [HttpEngine getSimpleCart:^(NSArray *array) {
        _dataArray=array;
        
        [self refreshCartCount:array];

        [self showTableView];
    }];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)showTableView
{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1-54)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    _tableView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    [self goToPayView];
    
    
}
-(void)goToPayView
{
    UIView*priceView=[[UIView alloc]initWithFrame:CGRectMake(0, LBVIEW_HEIGHT1-165, VIEW_WIDTH , LBVIEW_HEIGHT1 / 13)];
    priceView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:priceView];
    
    float sum=0;
    if (_dataArray.count==0)
    {
        _totalPrice=[NSString stringWithFormat:@"0.00"];
    }
    else
    {
    for (int i=0; i<_dataArray.count; i++)
    {
        ShopingCar*shopCar=_dataArray[i];
        NSString*numberStr=[NSString stringWithFormat:@"%@",shopCar.number];
        float num=[numberStr floatValue];
        NSString*priceStr=[NSString stringWithFormat:@"%@",shopCar.price];
        float price=[priceStr floatValue];
        sum=sum+price*num;
        _totalPrice=[NSString stringWithFormat:@"%0.2f",sum];
    }
    }
    
    NSString*allPrice=[NSString stringWithFormat:@"总计%@",_totalPrice];
    UIFont*font=[UIFont systemFontOfSize:18];
    CGSize size=[allPrice boundingRectWithSize:CGSizeMake(LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    self.okaneL = [[UILabel alloc] init];
    self.okaneL.text =allPrice;
    self.okaneL.textColor = [UIColor whiteColor];
    self.okaneL.backgroundColor=[UIColor blackColor];
    self.okaneL.font = font;
    self.okaneL.frame = CGRectMake(5, (LBVIEW_HEIGHT1/13-LBVIEW_HEIGHT1/15)/2, size.width, VIEW_HEIGHT / 15);
    [priceView addSubview:self.okaneL];
    
    
    int value=[_totalPrice intValue];
    if (value>99)
    {
        _shippingFee=@"免运费";
    }
    else
    {
        NSString*valueStr=[NSString stringWithFormat:@"%d",100-value];
        _shippingFee=[NSString stringWithFormat:@"运费10元(差%@元免配送)",valueStr];
    }
    UIFont*font1=[UIFont systemFontOfSize:12];
    CGSize size1=[_shippingFee boundingRectWithSize:CGSizeMake(LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font1} context:nil].size;
    _shippingFeeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+size.width, (LBVIEW_HEIGHT1/13-LBVIEW_HEIGHT1/15)/2, size1.width, LBVIEW_HEIGHT1/15)];
    _shippingFeeLabel.text=_shippingFee;
    _shippingFeeLabel.font=font1;
    _shippingFeeLabel.textColor=[UIColor whiteColor];
    [priceView addSubview:_shippingFeeLabel];
    
    
    self.kessanBtn=[[UIButton alloc]init];
    self.kessanBtn.frame = CGRectMake(VIEW_WIDTH * 0.665, 0, VIEW_WIDTH-VIEW_WIDTH * 0.665, priceView.frame.size.height);
    [self.kessanBtn setBackgroundColor:[UIColor colorWithRed:0/255.0 green:136/255.0 blue:215/255.0 alpha:1]];
    [self.kessanBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [self.kessanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.kessanBtn.titleLabel.font=[UIFont systemFontOfSize:21];
    [self.kessanBtn addTarget:self action:@selector(gotopayAction) forControlEvents:UIControlEventTouchUpInside];
    [priceView addSubview:self.kessanBtn];
    
}
-(void)gotopayAction
{
    if (_dataArray.count==0)
    {
        self.tabBarVC.selectedIndex=1;
    }
    else
    {
        PayViewController*payVC=[[PayViewController alloc]init];
        //[self hidesTabBar:YES];
        payVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payVC animated:YES];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //amount
    ShopingCar*spCa=_dataArray[indexPath.row];
    NSArray*detailArray=spCa.props;
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
    
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, LBVIEW_WIDTH1*0.5-10, 60)];
        nameLabel.text=[NSString stringWithFormat:@"%@ %@",spCa.skuName,attributeStr] ;
        nameLabel.numberOfLines=2;
        [nameLabel setFont:NJTitleFont];
        [nameLabel setTextColor:NJFontColor];
        [cell addSubview:nameLabel];
        
        NSString*str=[NSString stringWithFormat:@"¥%@",spCa.price];
        UIFont*font=NJTitleFont;
        CGSize size=[str boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        
        UILabel*picLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+LBVIEW_WIDTH1*0.5, 20, size.width, 30)];
        picLabel.text=[NSString stringWithFormat:@"¥%@",spCa.price];
        picLabel.textColor=[UIColor redColor];
        [picLabel setFont:font];
        [cell addSubview:picLabel];
        
//        UILabel*xlabel=[[UILabel alloc]initWithFrame:CGRectMake((3*LBVIEW_WIDTH1*0.5-70+size.width)/2, 25, 20, 20)];
//        xlabel.text=@"X";
//        xlabel.textColor=[UIColor grayColor];
//        [cell addSubview:xlabel];
        
        UILabel*numLabel=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-60, 25, 20, 20)];
        numLabel.text=[NSString stringWithFormat:@"%@",spCa.number];
        numLabel.textAlignment=NSTextAlignmentCenter;
        numLabel.font=NJTitleFont;
        [cell addSubview:numLabel];
        
        UIButton*addBtn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-40, 20, 30, 30)];
        [addBtn setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.tag=indexPath.row;
        [cell addSubview:addBtn];
        
        
        UIButton*subBtn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-90, 20, 30, 30)];
        [subBtn setImage:[UIImage imageNamed:@"jian.png"] forState:UIControlStateNormal];
        subBtn.tag=indexPath.row+1000;
        [subBtn addTarget:self action:@selector(subBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:subBtn];
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}
//增加按钮
-(void)addBtn:(UIButton*)sender
{
    [HttpEngine getSimpleCart:^(NSArray *array)
     {
         _dataArray=array;
         
         NSInteger number = 0;
         for (NSInteger i=0; i<array.count; i++) {
             ShopingCar*shCa=array[i];
             number += [shCa.number integerValue];
         }
         if(number>0){
             [self updateCartCount:[NSString stringWithFormat:@"%ld",number]];
         }

         [self add:(sender.tag)];
    }];
    
}
//添加
-(void)add:(NSInteger)tag
{
    ShopingCar*spCa=_dataArray[tag];
    NSString*numer=spCa.number;
    numer=[NSString stringWithFormat:@"%lu",[numer integerValue]+1];
    NSLog(@"----%@",numer);
    //添加
    NSLog(@"===%@,===%@",spCa.skuId,spCa.supplierId);
    
    NSString*str=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    [HttpEngine addGoodsLocation:str withSku:spCa.skuId withSupplier:spCa.supplierId withNumber:numer];
    [self performSelector:@selector(shuaiXin) withObject:numer afterDelay:0.1];
    
    
}


-(void) refreshCartCount:(NSArray *)array {
    
    NSInteger number = 0;
    for (NSInteger i=0; i<array.count; i++) {
        ShopingCar*shCa=array[i];
        number += [shCa.number integerValue];
    }
    if(number>0){
        [self updateCartCount:[NSString stringWithFormat:@"%ld",number]];
    }else{
        [self updateCartCount:nil];
    }

}

//删除按钮
-(void)subBtn:(UIButton*)sender
{

[HttpEngine getSimpleCart:^(NSArray *array)
 {
    _dataArray=array;
     [self refreshCartCount:array];
    [self sub:(sender.tag-1000)];
    
 }];
    
}
//删除
-(void)sub:(NSInteger)tag
{
    if (_dataArray.count==0)
    {
        return;
    }
    

    ShopingCar*spCa=_dataArray[tag];
    NSString*numer=spCa.number;
    numer=[NSString stringWithFormat:@"%lu",[numer integerValue]-1];
    //添加
    NSLog(@"===%@,===%@",spCa.skuId,spCa.supplierId);
    NSString*str=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    [HttpEngine addGoodsLocation:str withSku:spCa.skuId withSupplier:spCa.supplierId withNumber:numer];
    [self performSelector:@selector(shuaiXin) withObject:numer afterDelay:0.1];
}

//刷新表
-(void)shuaiXin
{
    [HttpEngine getSimpleCart:^(NSArray *array)
     {
         _dataArray=array;
         
         [self refreshCartCount:array];
         
         
         float sum=0;
         if (_dataArray.count==0)
         {
             _totalPrice=[NSString stringWithFormat:@"0.00"];
         }
         else
         {
             for (int i=0; i<_dataArray.count; i++)
             {
                 ShopingCar*shopCar=_dataArray[i];
                 NSString*numberStr=[NSString stringWithFormat:@"%@",shopCar.number];
                 float num=[numberStr floatValue];
                 NSString*priceStr=[NSString stringWithFormat:@"%@",shopCar.price];
                 float price=[priceStr floatValue];
                 sum=sum+price*num;
                 _totalPrice=[NSString stringWithFormat:@"%0.2f",sum];
             }
         }
         //总价格刷新
         NSString*allPrice=[NSString stringWithFormat:@"总计%@",_totalPrice];
         UIFont*font=[UIFont systemFontOfSize:18];
         CGSize size=[allPrice boundingRectWithSize:CGSizeMake(LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
         self.okaneL.text =allPrice;
         self.okaneL.frame = CGRectMake(5, (LBVIEW_HEIGHT1/13-LBVIEW_HEIGHT1/15)/2, size.width, VIEW_HEIGHT / 15);
         
         //运费刷新
         int price=[_totalPrice intValue];
         if (price>99)
         {
             _shippingFee=@"免运费";
         }
         else
         {
             NSString*valueStr=[NSString stringWithFormat:@"%d",100-price];
             _shippingFee=[NSString stringWithFormat:@"运费10元(差%@元免配送)",valueStr];
         }
         UIFont*font1=[UIFont systemFontOfSize:12];
         CGSize size1=[_shippingFee boundingRectWithSize:CGSizeMake(LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font1} context:nil].size;
         self.shippingFeeLabel.text=_shippingFee;
         NSLog(@"_shippingFeeLabel===%@",_shippingFeeLabel.text);
         self.shippingFeeLabel.frame=CGRectMake(10+size.width, (LBVIEW_HEIGHT1/13-LBVIEW_HEIGHT1/15)/2, size1.width, LBVIEW_HEIGHT1/15);
         
         [_tableView reloadData];
     }];
    
}

@end