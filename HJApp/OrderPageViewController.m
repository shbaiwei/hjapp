//
//  OrderPageViewController.m
//  HJApp
//
//  Created by Bruce He on 15/10/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "OrderPageViewController.h"
#import "MyHJViewController.h"
#import "HttpEngine.h"
#import "OderTableViewCell.h"
#import "OrderDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MyButton.h"
#import "SVPullToRefresh.h"
#import "LoginViewController.h"


@interface OrderPageViewController ()

@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic,strong)NSMutableArray*arry;
@property(nonatomic,strong)UIView*chooseView;
@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)MyButton*myOrderBtn;
@property(nonatomic,unsafe_unretained)int pageNum;
@end


//宏定义宽高
#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

@implementation OrderPageViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    //self.navigationController.navigationBar.translucent=NO;
    
    //获取上个页面所选取的种类
    _chooseValue=[[NSUserDefaults standardUserDefaults]objectForKey:@"THREETAG"];
    if (_chooseValue!=NULL)
    {
        NSLog(@"_chooseValue===%@",_chooseValue);
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"THREETAG"];
        [HttpEngine myOrder:@"1" with:@"1" with:@"10" with:_chooseValue completion:^(NSArray *dataArray)
         {
             _dataArray=dataArray;
             
             [self showMyOrder];
             
         }];
    }
    else
    {
    [HttpEngine myOrder:@"1" with:@"1" with:@"10" with:@"" completion:^(NSArray *dataArray)
         {
             _dataArray=dataArray;
             
             [self showMyOrder];
         }];
    }
    //订单页数
    _pageNum=10;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
  
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1,64)];
    headView.backgroundColor=[UIColor colorWithRed:0.23 green:0.67 blue:0.89 alpha:1];
    [self.view addSubview:headView];
    
//    UIButton*backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 30, 50, 20)];
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
//    [headView addSubview:backBtn];
    
    //我的订单
    _myOrderBtn=[[MyButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.3, 25, LBVIEW_WIDTH1*0.4, 30)];
    [_myOrderBtn setTitle:@"我的订单" forState:UIControlStateNormal];
    [_myOrderBtn addTarget:self action:@selector(myOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _myOrderBtn.titleLabel.font=[UIFont boldSystemFontOfSize:19];
    _myOrderBtn.isOpen=NO;
    [headView addSubview:_myOrderBtn];
    
    UIImageView*downImage=[[UIImageView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.5+40, 34, 15, 10)];
    downImage.image=[UIImage imageNamed:@"city-arr.png"];
    [headView addSubview:downImage];

    
}
- (void)insertRowAtTop
{
    if (_dataArray.count==0)
    {
        return;
    }
    
    __weak OrderPageViewController *weakSelf = self;
    
    [HttpEngine myOrder:@"1" with:@"1" with:@"10" with:@"" completion:^(NSArray *dataArray)
     {
         _dataArray=dataArray;
         
         [_tableView reloadData];
     }];
    
    [weakSelf.tableView.pullToRefreshView stopAnimating];

}
- (void)insertRowAtBottom
{
    if (_dataArray.count==0)
    {
        return;
    }
    __weak OrderPageViewController *weakSelf = self;
    [weakSelf.tableView beginUpdates];
    
    _pageNum+=10;
    NSString*pageNumStr=[NSString stringWithFormat:@"%d",_pageNum];
    [HttpEngine myOrder:@"1" with:@"1" with:pageNumStr with:@"" completion:^(NSArray *dataArray)
     {
         _dataArray=dataArray;
         
         //[self showMyOrder];
         [_tableView reloadData];
     }];
    
    [weakSelf.tableView endUpdates];
    [weakSelf.tableView.infiniteScrollingView stopAnimating];

}

//-(void)backBtn
//{
//    MyHJViewController*myHJVC=[[MyHJViewController alloc]init];
//    [self.navigationController pushViewController:myHJVC animated:YES];
//}

-(void)myOrderBtnClick
{
    if (_myOrderBtn.isOpen==NO)
    {
        //选择视图
        _chooseView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, LBVIEW_WIDTH1, LBVIEW_HEIGHT1*0.2)];
        _chooseView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_chooseView];
        NSArray*btnNameArray=[[NSArray alloc]initWithObjects:@"全部", @"待付款",@"待收货",@"退款／售后",nil];
        for (int i=0; i<4; i++)
        {
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, i*LBVIEW_HEIGHT1*0.05, LBVIEW_WIDTH1-10, LBVIEW_HEIGHT1*0.05)];
            label.text=btnNameArray[i];
            label.font=[UIFont systemFontOfSize:14];
            label.textColor=[UIColor blackColor];
            [_chooseView addSubview:label];
            
            UILabel*lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, i*LBVIEW_HEIGHT1*0.05, LBVIEW_WIDTH1, 1)];
            lineLabel.backgroundColor=[UIColor grayColor];
            [_chooseView addSubview:lineLabel];
            
            UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, i*LBVIEW_HEIGHT1*0.05, LBVIEW_WIDTH1, LBVIEW_HEIGHT1*0.05)];
            btn.tag=i+1;
            [btn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_chooseView addSubview:btn];
            
        }
    }
    else
    {
        [_chooseView removeFromSuperview];
    }
    _myOrderBtn.isOpen=!_myOrderBtn.isOpen;
}
//选择按钮
-(void)chooseBtn:(UIButton*)sender
{
    
    _myOrderBtn.isOpen=!_myOrderBtn.isOpen;
    [_chooseView removeFromSuperview];
    //订单布局
    if (sender.tag==1)
    {
        [HttpEngine myOrder:@"1" with:@"1" with:@"10" with:@"" completion:^(NSArray *dataArray)
         {
             _dataArray=dataArray;
             //订单布局
             [self showMyOrder];
         }];
    }
    else
    {
        if (sender.tag==2)
        {
            [HttpEngine myOrder:@"true" with:@"1" with:@"10" with:@"0" completion:^(NSArray *dataArray)
             {
                 _dataArray=dataArray;
                 //订单布局
                 [self showMyOrder];
             }];
        }
        else
        {
            NSString*str=[NSString stringWithFormat:@"%ld",sender.tag-1];
            [HttpEngine myOrder:@"true" with:@"1" with:@"10" with:str completion:^(NSArray *dataArray)
             {
                 _dataArray=dataArray;
                 //订单布局
                 [self showMyOrder];
             }];
        }
        
    }
    
}
-(void)showMyOrder
{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, LBVIEW_WIDTH1, LBVIEW_HEIGHT1-104) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    //下拉刷新 上拉加载更多
    __weak OrderPageViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary*dic=_dataArray[section];
    NSArray*array=dic[@"detail"];
    
    return array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LBVIEW_HEIGHT1*0.12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*dic=_dataArray[indexPath.section];
    NSArray*array=dic[@"detail"];
    NSDictionary*dataDic=array[indexPath.row];
    
    static NSString *cellId = @"reuse";
    
    
    OderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        
        cell = [[OderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.moneyLabel.text=[NSString stringWithFormat:@"x%@",dataDic[@"curr_price"]];
        
        NSURL*urlStr=[NSURL URLWithString:dataDic[@"merch_image"]];
        [cell.leftImageV sd_setImageWithURL:urlStr];
        cell.nameLabel.text=dataDic[@"merch_name"];
        cell.suryouLabel.text=dataDic[@"merch_desc"];
        cell.X2Label.text=[NSString stringWithFormat:@"x%@",dataDic[@"merch_qty"]];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//设置区头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary*dic=_dataArray[section];
    
    UIView*view=[[UIView alloc]init];
    //view.backgroundColor=[UIColor  lightGrayColor];
    
    UIImageView*blueImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    blueImageV.image = [UIImage imageNamed:@"my-order-ico.png"];
    [view addSubview:blueImageV];
    
    
    UILabel *dNamelable=[[UILabel alloc]initWithFrame:CGRectMake(20+LBVIEW_HEIGHT1*0.025, 15, 100,20)];
    dNamelable.text=dic[@"to_florist_name"];
    dNamelable.font=[UIFont systemFontOfSize:14];
    //dNamelable.textAlignment=NSTextAlignmentCenter;
    dNamelable.backgroundColor=[UIColor clearColor];
    [view addSubview:dNamelable];
    
    
    UILabel *timeLable=[[UILabel alloc]initWithFrame:CGRectMake(120+LBVIEW_HEIGHT1*0.025, 15, 140,20)];
    timeLable.text=dic[@"datetime"];
    timeLable.font=[UIFont systemFontOfSize:12];
    timeLable.textColor=[UIColor grayColor];
    //dNamelable.textAlignment=NSTextAlignmentCenter;
    timeLable.backgroundColor=[UIColor clearColor];
    [view addSubview:timeLable];
    
    UILabel *jyLable=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-90, 15, 80,20)];
    jyLable.text=@"交易关闭";
    jyLable.textColor=[UIColor colorWithRed:43/255.0 green:152/255.0 blue:225/255.0 alpha:1];
    jyLable.font=[UIFont systemFontOfSize:12];
    jyLable.textAlignment=NSTextAlignmentRight;
    //dNamelable.textAlignment=NSTextAlignmentCenter;
    jyLable.backgroundColor=[UIColor clearColor];
    [view addSubview:jyLable];
    
    
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1*0.05)];
    [btn addTarget:self action:@selector(orderDetail:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag=section;
    //[btn setBackgroundColor:[UIColor redColor]];
    [view addSubview:btn];
    
    
    return view;
}
-(void)orderDetail:(UIButton*)sender
{
    NSMutableArray*array=[[NSMutableArray alloc]init];
    NSDictionary*dic=_dataArray[sender.tag];
    orderDetail*order=[[orderDetail alloc]init];
    order.orderNo=dic[@"order_no"];
    order.recvName=dic[@"recv_name"];
    order.recvMobile=dic[@"recv_mobile"];
    order.recvAddress=dic[@"recv_address"];
    order.orderPrice=dic[@"order_price"];
    order.preferMoney=dic[@"prefer_money"];
    order.discountPrice=dic[@"discount_price"];
    order.paymentPrice=dic[@"payment_price"];
    order.dataArray=dic[@"detail"];
    [array addObject:order];
    
    OrderDetailViewController*orderVC=[[OrderDetailViewController alloc]init];
    orderVC.dataArray=array;
    orderVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}



//设置区尾
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return LBVIEW_HEIGHT1*0.1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary*dic=_dataArray[section];
    // NSLog(@"_dataArray[5]==%@",_dataArray[0]);
    NSArray*detailArray=dic[@"detail"];
    
    UIView*view=[[UIView alloc]init];
    view.backgroundColor=[UIColor whiteColor];
    
    UIFont*font=[UIFont systemFontOfSize:12];
    NSString*numStr=[NSString stringWithFormat:@"%lu",detailArray.count];
    NSString*labelStr=[NSString stringWithFormat:@"共%@件商品 实际支付",numStr];
    CGSize size=[labelStr boundingRectWithSize:CGSizeMake(LBVIEW_WIDTH1, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, size.width,20)];
    lable.text=labelStr;
    lable.font=font;
    [view addSubview:lable];
    
    
    UIFont*font1=[UIFont systemFontOfSize:14];
    NSString*picStr=[NSString stringWithFormat:@"¥%@",dic[@"order_price"]];
    CGSize size1=[picStr boundingRectWithSize:CGSizeMake(LBVIEW_WIDTH1, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font1} context:nil].size;
    UILabel *priceLable=[[UILabel alloc]initWithFrame:CGRectMake(10+size.width, 10, size1.width,20)];
    priceLable.text=picStr;
    priceLable.textColor=[UIColor redColor];
    priceLable.font=font1;
    [view addSubview:priceLable];
    
    UILabel *freeLable=[[UILabel alloc]initWithFrame:CGRectMake(10+size.width+size1.width, 10, 80,20)];
    freeLable.text=@"(含运费¥0.00)";
    freeLable.textColor=[UIColor grayColor];
    freeLable.font=[UIFont systemFontOfSize:12];
    [view addSubview:freeLable];
    
    
    UIButton*btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.layer.borderColor=[UIColor grayColor].CGColor;
    btn.layer.borderWidth=1;
    btn.layer.cornerRadius=5;
    btn.clipsToBounds=YES;
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    btn.frame=CGRectMake(LBVIEW_WIDTH1-80, LBVIEW_HEIGHT1*0.1-25, 70, 20);
    [btn setTitle:@"再次购买" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.tag=section+500;
    [btn addTarget:self action:@selector(againBuy:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return view;
}

//再次购买
-(void)againBuy:(UIButton*)sender
{
    NSDictionary*dic=_dataArray[sender.tag-500];
    NSArray*array=dic[@"detail"];
    
    NSDictionary*dicc=array[0];
    NSLog(@"dicc[order_no]===%@",dicc[@"order_no"]);
    [HttpEngine anginBuy:dicc[@"order_no"]];


}

@end
