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
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "OrderPayViewController.h"
#import "PayTableViewCell.h"


@interface OrderPageViewController ()

@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic,strong)NSMutableArray*arry;
@property(nonatomic,strong)UIView*chooseView;
@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSArray*payStyleArray;

@property(nonatomic,strong)MyButton*myOrderBtn;
@property(nonatomic,unsafe_unretained)int pageNum;
@property(nonatomic,strong)UIButton*stausBtn;
@property(nonatomic,strong)UIView*shadowView;
@property(nonatomic,strong)UIView*shadowV;
@property(nonatomic,unsafe_unretained)int lastTag;
@property(nonatomic,unsafe_unretained)int pay_type;

@property(nonatomic,strong)UITableView *paymentTableView;

@property(nonatomic,unsafe_unretained)BOOL isBool;
@property (nonatomic,copy)NSString *kindOrder;
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
        
    HJViewController*hj=[[HJViewController alloc]init];
    if (!_isBool)
    {
        _isBool=YES;
        if ([hj isLogin:self withTitle:@"登录后，可查看自己的订单详情"  with:1])
        {
            return;
        }
    }
    
    if ([HJViewController needShowPage])
        return;
    
    //获取上个页面所选取的种类
    _chooseValue=[[NSUserDefaults standardUserDefaults]objectForKey:@"THREETAG"];
    if (_chooseValue)
    {
        NSLog(@"_chooseValue===%@",_chooseValue);
        _kindOrder = _chooseValue;
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"THREETAG"];
        [HttpEngine myOrder:@"1" with:@"1" with:@"10" with:_chooseValue completion:^(NSArray *dataArray)
         {
             _dataArray=dataArray;
             
             [self showMyOrder];
         }];
    }
    else
    {
        _kindOrder = @"";
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
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    _pay_type = 0;
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1,64)];
    headView.backgroundColor=[UIColor colorWithRed:0.23 green:0.67 blue:0.89 alpha:1];
    [self.view addSubview:headView];
    
    //我的订单
    _myOrderBtn=[[MyButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.3, 25, LBVIEW_WIDTH1*0.4, 30)];
    [_myOrderBtn setTitle:@"我的订单" forState:UIControlStateNormal];
    [_myOrderBtn addTarget:self action:@selector(myOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _myOrderBtn.titleLabel.font=[UIFont boldSystemFontOfSize:19];
    _myOrderBtn.isOpen=NO;
    [headView addSubview:_myOrderBtn];

    _stausBtn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.5+40, 34, 15, 10)];
    [_stausBtn setBackgroundImage:[UIImage imageNamed:@"xia.png"] forState:UIControlStateNormal];
    [_stausBtn setBackgroundImage:[UIImage imageNamed:@"shang.png"] forState:UIControlStateSelected];
    _stausBtn.selected=NO;
    [headView addSubview:_stausBtn];
    
    
    self.paymentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH*0.45, 172) style:UITableViewStyleGrouped];
    self.paymentTableView.backgroundColor = [UIColor whiteColor];
    self.paymentTableView.scrollEnabled = NO;
    self.paymentTableView.delegate = self;
    [self.paymentTableView.layer setCornerRadius:8.0];
    self.paymentTableView.dataSource = self;
    
}
- (void)insertRowAtTop
{
    __weak OrderPageViewController *weakSelf = self;
    [HttpEngine myOrder:@"1" with:@"1" with:@"10" with:_kindOrder completion:^(NSArray *dataArray)
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
    [HttpEngine myOrder:@"1" with:@"1" with:pageNumStr with:_kindOrder completion:^(NSArray *dataArray)
     {
         _dataArray=dataArray;
         
         //[self showMyOrder];
         [_tableView reloadData];
     }];
    
    [weakSelf.tableView endUpdates];
    [weakSelf.tableView.infiniteScrollingView stopAnimating];

}

-(void)myOrderBtnClick
{
    NSString*login=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    if (!login)
    {
        LoginViewController*loginVC=[[LoginViewController alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navigationController animated:YES completion:nil];
        return;
    }
    _stausBtn.selected=!_stausBtn.selected;
    if (_myOrderBtn.isOpen==NO)
    {
        //选择视图
        _chooseView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, LBVIEW_WIDTH1, LBVIEW_HEIGHT1*0.25)];
        _chooseView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_chooseView];
        NSArray*btnNameArray=[[NSArray alloc]initWithObjects:@"全部", @"待付款",@"待收货",@"退款／售后",nil];
        for (int i=0; i<4; i++)
        {
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, i*LBVIEW_HEIGHT1*0.06, LBVIEW_WIDTH1-10, LBVIEW_HEIGHT1*0.06)];
            label.text=btnNameArray[i];
            label.font=[UIFont systemFontOfSize:14];
            label.textColor=NJFontColor;
            [_chooseView addSubview:label];
            
            UILabel*lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, i*LBVIEW_HEIGHT1*0.06, LBVIEW_WIDTH1, 1)];
            lineLabel.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
            [_chooseView addSubview:lineLabel];
            
            UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, i*LBVIEW_HEIGHT1*0.06, LBVIEW_WIDTH1, LBVIEW_HEIGHT1*0.06)];
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
        _kindOrder = @"";
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
            _kindOrder = @"0";
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
            _kindOrder = str;
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
    
    if (_dataArray.count==0) {
        return;
    }
    
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
    if([tableView isEqual:self.paymentTableView]){
        return 3;
    }
    
    NSDictionary*dic=_dataArray[section];
    NSArray*array=dic[@"detail"];
    
    return array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([tableView isEqual:self.paymentTableView]){
        return 1;
    }
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.paymentTableView]){
        return 42;
    }
    
    return LBVIEW_HEIGHT1*0.12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([tableView isEqual:self.paymentTableView]){
        PayTableViewCell *cell0 = [PayTableViewCell cellWithTableView:tableView];
        
        [cell0.iconImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pay1-%lu.png",indexPath.row+1]]];

        _payStyleArray = [[NSArray alloc]initWithObjects:@"花集余额",@"支付宝",@"微信支付", nil];
        cell0.textLabel.text=_payStyleArray[indexPath.row];
        
        if(_pay_type == indexPath.row){
            cell0.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell0.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell0;
    }
    
    
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
    UIView*view=[[UIView alloc]init];
    if([tableView isEqual:self.paymentTableView]){
        UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 120, 20)];
        payLabel.text = @"选择支付方式";
        payLabel.font = NJTitleFont;
        [view addSubview:payLabel];
        view.backgroundColor = [UIColor whiteColor];
        return view;
        
    }
    
    
    NSDictionary*dic=_dataArray[section];
    //view.backgroundColor=[UIColor  lightGrayColor];
    
    UIImageView*blueImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
    blueImageV.image = [UIImage imageNamed:@"my-order-ico.png"];
    [view addSubview:blueImageV];
    
    
    UILabel *dNamelable=[[UILabel alloc]initWithFrame:CGRectMake(20+LBVIEW_HEIGHT1*0.025, 15, 100,20)];
    NSString*str=dic[@"to_florist_name"];
    if (str.length>4)
    {
        str=[str substringToIndex:4];
    }
    dNamelable.text=str;
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
    
    UILabel *jyLable=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-100, 15, 90,20)];
    NSString*status=dic[@"status"];
    int intStatus=[status intValue];
    NSString*jystr;
    switch (intStatus)
    {
        case 0:
            jystr=@"等待支付";
            break;
        case 1:
            jystr=@"已支付,等待确认";
            break;
        case 2:
            jystr=@"已确认,等待配送";
            break;
        case 3:
            jystr=@"已签收,等待转账";
            break;
        case 4:
            jystr=@"已退款";
            break;
        case 5:
            jystr=@"交易关闭";
            break;
        case 6:
            jystr=@"已取消";
            break;
        case 7:
            jystr=@"已撤单";
            break;
        case 8:
            jystr=@"交易成功";
            break;
        default:
            jystr=@"订单错误";
            break;
    }
    jyLable.text=jystr;
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
    order.preferMoney=dic[@"addon_price"];
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
    if([tableView isEqual:self.paymentTableView]){
        return 0.001;
    }
    return LBVIEW_HEIGHT1*0.1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]init];
    if([tableView isEqual:self.paymentTableView]){
        return view;
    }
    NSDictionary*dic=_dataArray[section];
    NSArray*detailArray=dic[@"detail"];
    
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
    
    UILabel *freeLable=[[UILabel alloc]initWithFrame:CGRectMake(10+size.width+size1.width, 10, 100,20)];
    freeLable.text=[NSString stringWithFormat:@"(含配送费%@)",dic[@"addon_price"]];
    freeLable.textColor=[UIColor grayColor];
    freeLable.font=[UIFont systemFontOfSize:12];
    [view addSubview:freeLable];
    
    
    MyButton*btn=[MyButton buttonWithType:UIButtonTypeSystem];
    btn.layer.borderColor=[UIColor grayColor].CGColor;
    btn.layer.borderWidth=1;
    btn.layer.cornerRadius=5;
    btn.clipsToBounds=YES;
    btn.titleLabel.font=[UIFont systemFontOfSize:12];
    btn.frame=CGRectMake(LBVIEW_WIDTH1-80, LBVIEW_HEIGHT1*0.1-30, 70, 25);
    
    int status=[dic[@"status"] intValue];
    if (status==0)
    {
       [btn setTitle:@"支付" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(payorder:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    else
        if (status==5)
        {
            [btn setTitle:@"再次购买" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(reorder:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.tag=section+500;
    btn.status=status;
    
    return view;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if([tableView isEqual:self.paymentTableView]){
        _pay_type = (int)indexPath.row;
        [self.paymentTableView reloadData];
    }
}

-(void) payorder:(MyButton *)sender{
    [self gotoPayOrder:(sender.tag)];
}
//再次购买
-(void)reorder:(MyButton*)sender{

    NSDictionary*dic=_dataArray[sender.tag-500];
    NSArray*array=dic[@"detail"];
    NSDictionary*dicc=array[0];
    NSLog(@"dicc[order_no]===%@",dicc[@"order_no"]);
    [HttpEngine anginBuy:dicc[@"order_no"]];
    self.tbBarVC.selectedIndex=3;
}

-(void)gotoPayOrder:(NSInteger)tag
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController.view addSubview:self.paymentTableView];
    
    UIAlertAction*cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        
    }];
    [alertController addAction:cancelAction];
    
    UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [self toPayOrder:tag];
    }];
    [alertController addAction:defaultAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        //[indicator removeFromSuperview];
        
        CGRect frame = self.paymentTableView.frame;
        frame.size.width = alertController.view.bounds.size.width;
        self.paymentTableView.frame = frame;
    }];
    
}

-(void)toPayOrder:(NSInteger )tag{
    
    NSDictionary*dic=_dataArray[tag-500];
    NSArray*array=dic[@"detail"];
    NSDictionary*dicc=array[0];
    if (_pay_type == 0)
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
            [HttpEngine payOrderNum:dicc[@"order_no"] withSpaypassword:pay_password.text withMethod:@"huaji" withCoupon:@"" Completion:^(NSString *orderNo,NSString*price)
                                             {
                                                 
                                             }];
                       
                                        }];
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    if (_pay_type==1)
    {
        [HttpEngine payOrderNum:dicc[@"order_no"] withSpaypassword:@"" withMethod:@"weixin" withCoupon:@"" Completion:^(NSString *orderNo,NSString*price)
         {
             [self alipay:orderNo amount:price completion:^(BOOL success)
              {
                  //order page
                  
              }];
         }];
    }
    if (_pay_type==2)
    {
        [HttpEngine payOrderNum:dicc[@"order_no"] withSpaypassword:@"" withMethod:@"alipay" withCoupon:@"" Completion:^(NSString *orderNo,NSString*price)
        {
             [self WeiXinPay:orderNo];
        }];
    }
}
-(void)ay:(UIButton*)sender
{
    sender.selected=!sender.selected;
    if (_lastTag!=0)
    {
        UIButton*btn=[_shadowV viewWithTag:_lastTag];
        btn.selected=NO;
    }
    _lastTag=(int)sender.tag;
}
@end
