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
    [self hidesTabBar:NO];
    self.navigationController.navigationBarHidden=YES;

    if (_chooseValue!=NULL)
    {
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
    
    UIButton*backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 30, 50, 20)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    
    //我的订单
    _myOrderBtn=[[MyButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.3, 20, LBVIEW_WIDTH1*0.4, 30)];
    [_myOrderBtn setTitle:@"我的订单" forState:UIControlStateNormal];
    [_myOrderBtn addTarget:self action:@selector(myOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _myOrderBtn.isOpen=NO;
    [headView addSubview:_myOrderBtn];
    
}
- (void)insertRowAtTop
{
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

-(void)backBtn
{
    MyHJViewController*myHJVC=[[MyHJViewController alloc]init];
    [self.navigationController pushViewController:myHJVC animated:YES];
}

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
            label.font=[UIFont systemFontOfSize:13];
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
    
//    if (_dataArray.count==0)
//    {
//        
//    }
//    else
//    {
//        //表尾部
//        UIView*footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, 60)];
//        footView.backgroundColor=[UIColor lightGrayColor];
//        self.tableView.tableFooterView=footView;
//        
//        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, LBVIEW_WIDTH1, 30)];
//        [btn setBackgroundColor:[UIColor whiteColor]];
//        [btn setTitle:@"加载更多..." forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(loadMoreOrder) forControlEvents:UIControlEventTouchUpInside];
//        [footView addSubview:btn];
//    }
    
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
//加载更多
//-(void)loadMoreOrder
//{
//    _pageNum+=10;
//    NSString*pageNumStr=[NSString stringWithFormat:@"%d",_pageNum];
//    [HttpEngine myOrder:@"1" with:@"1" with:pageNumStr with:@"" completion:^(NSArray *dataArray)
//     {
//         _dataArray=dataArray;
//         
//         //[self showMyOrder];
//         [_tableView reloadData];
//     }];
//}

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
    return LBVIEW_HEIGHT1*0.05;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary*dic=_dataArray[section];
    
    UIView*view=[[UIView alloc]init];
    //view.backgroundColor=[UIColor  lightGrayColor];
    
    UIImageView*blueImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, LBVIEW_HEIGHT1*0.05-20, LBVIEW_HEIGHT1*0.025, LBVIEW_HEIGHT1*0.025)];
    blueImageV.image = [UIImage imageNamed:@"bluehouse.png"];
    [view addSubview:blueImageV];
    
    
    UILabel *dNamelable=[[UILabel alloc]initWithFrame:CGRectMake(20+LBVIEW_HEIGHT1*0.025, LBVIEW_HEIGHT1*0.05-20, 100,20)];
    dNamelable.text=dic[@"to_florist_id"];
    //dNamelable.textAlignment=NSTextAlignmentCenter;
    dNamelable.backgroundColor=[UIColor clearColor];
    [view addSubview:dNamelable];
    
    
    UILabel *timeLable=[[UILabel alloc]initWithFrame:CGRectMake(120+LBVIEW_HEIGHT1*0.025, LBVIEW_HEIGHT1*0.05-20, 140,20)];
    timeLable.text=dic[@"datetime"];
    timeLable.font=[UIFont systemFontOfSize:13];
    timeLable.textColor=[UIColor grayColor];
    //dNamelable.textAlignment=NSTextAlignmentCenter;
    timeLable.backgroundColor=[UIColor clearColor];
    [view addSubview:timeLable];
    
    UILabel *jyLable=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-90, LBVIEW_HEIGHT1*0.05-20, 80,20)];
    jyLable.text=@"交易关闭";
    jyLable.textColor=[UIColor blueColor];
    jyLable.font=[UIFont systemFontOfSize:14];
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
    order.preferMoney=dic[@"prefer_money"];
    order.paymentPrice=dic[@"payment_price"];
    order.dataArray=dic[@"detail"];
    [array addObject:order];
    
    OrderDetailViewController*orderVC=[[OrderDetailViewController alloc]init];
    orderVC.dataArray=array;
    [self.navigationController pushViewController:orderVC animated:YES];
}



//设置区尾
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return LBVIEW_HEIGHT1*0.12;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary*dic=_dataArray[section];
    // NSLog(@"_dataArray[5]==%@",_dataArray[0]);
    NSArray*detailArray=dic[@"detail"];
    
    UIView*view=[[UIView alloc]init];
    view.backgroundColor=[UIColor whiteColor];
    
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, LBVIEW_WIDTH1-10,20)];
    NSString*numStr=[NSString stringWithFormat:@"%lu",detailArray.count];
    NSString*picStr=[NSString stringWithFormat:@"¥%@",dic[@"order_price"]];
    lable.text=[NSString stringWithFormat:@"共%@件商品 实际支付%@（含运费¥10.0）",numStr,picStr];
    lable.backgroundColor=[UIColor clearColor];
    [view addSubview:lable];
    
    UIButton*btn=[UIButton buttonWithType:UIButtonTypeSystem];
    
    //边框颜色
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,0,0,1});
//    [btn.layer setBorderColor:color];
//    btn.layer.borderColor=[UIColor grayColor].CGColor;
    
    btn.frame=CGRectMake(LBVIEW_WIDTH1-110, LBVIEW_HEIGHT1*0.12-30, 100, 20);
    [btn setTitle:@"再次购买" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(againBuy) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return view;
}

-(void)againBuy
{
    
    
    
    
    
    
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
