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

@interface ShopingPageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)NSArray*dataArray;

@property (nonatomic, strong) UILabel *okaneL;
@property (nonatomic, strong) UIButton *kessanBtn;

//

@property(nonatomic,copy)NSString*totalPrice;
@property(nonatomic,copy)NSString*shippingFee;


@end

#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

@implementation ShopingPageViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    [self hidesTabBar:NO];
    [HttpEngine getCart:^(NSArray *dataArray, NSString *totalPrice, NSString *shippingFee, NSString *paymentPrice)
     {
         _dataArray=dataArray;
         _totalPrice=totalPrice;
         _shippingFee=shippingFee;
         //页面展示
         [self showTableView];
     }];
    
    //self.navigationController.navigationBarHidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)showTableView
{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, LBVIEW_WIDTH1, LBVIEW_HEIGHT1-118)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    
    _tableView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    [self goToPayView];
    
    
}
-(void)goToPayView
{
    UIView *grayblueV = [[UIView alloc] init];
    //grayblueV.backgroundColor = [UIColor yellowColor];
    grayblueV.frame = CGRectMake(0, LBVIEW_HEIGHT1 * 0.849, LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 13);
    [self.view addSubview:grayblueV];
    
    self.okaneL = [[UILabel alloc] init];
    
    NSLog(@"_shippingFee==%@",_shippingFee);
//    NSString*str=@"0";
//    if ([_shippingFee isEqualToString:str])
//    {
//        _shippingFee=@"免运费";
//    }
    
    self.okaneL.text = [NSString stringWithFormat:@"总计%@运费%@元",_totalPrice, _shippingFee];
    self.okaneL.textColor = [UIColor whiteColor];
    self.okaneL.backgroundColor=[UIColor blackColor];
    self.okaneL.font = [UIFont systemFontOfSize:23];
    self.okaneL.textAlignment=NSTextAlignmentCenter;
    self.okaneL.frame = CGRectMake(0, 0, LBVIEW_WIDTH1-VIEW_WIDTH / 2.95+1, VIEW_HEIGHT / 13);
    [grayblueV addSubview:self.okaneL];
    
    
    self.kessanBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *kessan = [UIImage imageNamed:@"kessan.png"];
    kessan = [kessan imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.kessanBtn.frame = CGRectMake(VIEW_WIDTH * 0.665, 0, VIEW_WIDTH / 2.95, VIEW_HEIGHT/13+1);
    [self.kessanBtn setImage:kessan forState:UIControlStateNormal];
    [self.kessanBtn addTarget:self action:@selector(gotopayAction) forControlEvents:UIControlEventTouchUpInside];
    [grayblueV addSubview:self.kessanBtn];
    
}
-(void)gotopayAction
{
    if (_dataArray.count==0)
    {
        AssortPageViewController*assortVC=[[AssortPageViewController alloc]init];
        [self.navigationController pushViewController:assortVC animated:YES];
        
    }
    
    else
    {
        PayViewController*payVC=[[PayViewController alloc]init];
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
    
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, LBVIEW_HEIGHT1*0.01, LBVIEW_WIDTH1*0.5, LBVIEW_HEIGHT1*0.06)];
        nameLabel.text=[NSString stringWithFormat:@"%@ %@",spCa.skuName,attributeStr] ;
        nameLabel.numberOfLines=0;
        [cell addSubview:nameLabel];
        
        UILabel*picLabel=[[UILabel alloc]initWithFrame:CGRectMake(30+LBVIEW_WIDTH1*0.5, LBVIEW_HEIGHT1*0.01, LBVIEW_WIDTH1*0.2, LBVIEW_HEIGHT1*0.06)];
        picLabel.text=[NSString stringWithFormat:@"¥%@",spCa.price];
        picLabel.textColor=[UIColor redColor];
        [cell addSubview:picLabel];
        
        UILabel*numLabel=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-50, LBVIEW_HEIGHT1*0.01, 20, LBVIEW_HEIGHT1*0.06)];
        numLabel.text=[NSString stringWithFormat:@"%@",spCa.number];
        numLabel.textAlignment=NSTextAlignmentCenter;
        numLabel.font=[UIFont systemFontOfSize:14];
        [cell addSubview:numLabel];
        
        UIButton*addBtn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-30, LBVIEW_HEIGHT1*0.025, 20, 20)];
        [addBtn setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBtn:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.tag=indexPath.row;
        [cell addSubview:addBtn];
        
        
        UIButton*subBtn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-70, LBVIEW_HEIGHT1*0.025, 20, 20)];
        [subBtn setImage:[UIImage imageNamed:@"jian.png"] forState:UIControlStateNormal];
        subBtn.tag=indexPath.row+1000;
        [subBtn addTarget:self action:@selector(subBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:subBtn];
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return LBVIEW_HEIGHT1*0.08;
    
}
//增加按钮
-(void)addBtn:(UIButton*)sender
{
    [HttpEngine getCart:^(NSArray *dataArray, NSString *totalPrice, NSString *shippingFee, NSString *paymentPrice) {
        _dataArray=dataArray;
        _totalPrice=totalPrice;
        _shippingFee=shippingFee;
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
    
    [HttpEngine addGoodsLocation:@"330100" withSku:spCa.skuId withSupplier:spCa.supplierId withNumber:numer];
    [self performSelector:@selector(shuaiXin) withObject:numer afterDelay:0.1];
    
    
}

//删除按钮
-(void)subBtn:(UIButton*)sender
{
    
    [HttpEngine getCart:^(NSArray *dataArray, NSString *totalPrice, NSString *shippingFee, NSString *paymentPrice) {
        _dataArray=dataArray;
        _totalPrice=totalPrice;
        _shippingFee=shippingFee;
        [self sub:(sender.tag-1000)];
    }];
    
}
//删除
-(void)sub:(NSInteger)tag
{
    
    ShopingCar*spCa=_dataArray[tag];
    NSString*numer=spCa.number;
    numer=[NSString stringWithFormat:@"%lu",[numer integerValue]-1];
    NSLog(@"----%@",numer);
    //添加
    NSLog(@"===%@,===%@",spCa.skuId,spCa.supplierId);
    [HttpEngine addGoodsLocation:@"330100" withSku:spCa.skuId withSupplier:spCa.supplierId withNumber:numer];
    [self performSelector:@selector(shuaiXin) withObject:numer afterDelay:0.1];
}

//刷新表
-(void)shuaiXin
{
    [HttpEngine getCart:^(NSArray *dataArray, NSString *totalPrice, NSString *shippingFee, NSString *paymentPrice) {
        _dataArray=dataArray;
        _totalPrice=totalPrice;
        _shippingFee=shippingFee;
//        if ([_shippingFee isEqualToString:@"0"])
//        {
//            _shippingFee=@"免运费";
//        }
        self.okaneL.text = [NSString stringWithFormat:@"总计%@运费%@元",_totalPrice, _shippingFee];
        [_tableView reloadData];
    }];
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