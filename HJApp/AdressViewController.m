//
//  AdressViewController.m
//  HJApp
//
//  Created by Bruce He on 15/11/6.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "AdressViewController.h"
#import "AdressTableViewCell.h"
#import "NewAdViewController.h"
#import "HttpEngine.h"


@interface AdressViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *adressTV;
@property (nonatomic, strong) NSMutableArray *adressArr;
@property (nonatomic, strong) NSMutableDictionary *adressDic;

@property (nonatomic, strong) UIButton *newadBtn;

////
@property(nonatomic,strong)NSArray*dataArray;


@end

@implementation AdressViewController

#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height


-(void)viewWillAppear:(BOOL)animated
{

    self.navigationController.navigationBarHidden=NO;
    [HttpEngine getAddress:^(NSArray *dataArray)
     {
         _dataArray=dataArray;
         [self creatTableview];
     }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1,64)];
    headView.backgroundColor=[UIColor colorWithRed:0.23 green:0.67 blue:0.89 alpha:1];
    [self.view addSubview:headView];
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, LBVIEW_WIDTH1, 30)];
    titleLabel.text=@"管理收货地址";
    titleLabel.font=[UIFont systemFontOfSize:18];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headView addSubview:titleLabel];
    
    UIButton*backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 30, 50, 20)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    
    
}

-(void)backBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//表的创建
-(void)creatTableview
{
    self.adressTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, LBVIEW_WIDTH1, LBVIEW_HEIGHT1-118) style:UITableViewStyleGrouped];
    self.adressTV.delegate = self;
    self.adressTV.dataSource = self;
    [self.view addSubview:self.adressTV];
}

//区数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

//区高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 120;
    
}
//自定义cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"reuse";
    AllAdress*adress=_dataArray[indexPath.row];
    
    AdressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[AdressTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        
        cell.numAddressLabel.text=[NSString stringWithFormat:@"%lu",indexPath.row];
        cell.nameL.text=adress.consignee;
        cell.numberL.text=adress.phoneMob;
        cell.adressL.text=adress.chineseCity;
        
        [cell.deleBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleBtn.tag=indexPath.row;
        
        [cell.bjBtn addTarget:self action:@selector(bianJiBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.bjBtn.tag=indexPath.row+1000;
        
        
        
    }
    return cell;
}

//设置区尾
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]init];
    
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(20,LBVIEW_HEIGHT1 / 10-LBVIEW_HEIGHT1 / 17, LBVIEW_WIDTH1-40, LBVIEW_HEIGHT1 / 17)];
    [btn setImage:[UIImage imageNamed:@"newadress.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(newadBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return view;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return LBVIEW_HEIGHT1 / 10;
}

//添加新地址
- (void)newadBtnAction:(UIButton *)sender
{
    
    NewAdViewController *newAdVC = [[NewAdViewController alloc] init];
    [self.navigationController pushViewController:newAdVC animated:YES];
    
}

//删除操作
-(void)deleteBtn:(UIButton*)sender
{

    AllAdress*adress=_dataArray[sender.tag];
    NSString*adr_id=adress.addrId;
    [HttpEngine deleteAddress:adr_id];
    
    [self performSelector:@selector(shuaiXin) withObject:nil afterDelay:0.1];
    
}

//编辑操作
-(void)bianJiBtn:(UIButton*)sender
{
    AllAdress*adress=_dataArray[sender.tag-1000];
    
    //*addrId,*consignee,*phoneMob,*chineseCity,*chineseProvince;
    NewAdViewController*newVC=[[NewAdViewController alloc]init];
    newVC.userName=adress.consignee;
    newVC.phone=adress.phoneMob;
    newVC.procon=adress.chineseCity;
    newVC.bj=1;
    newVC.addrId=adress.addrId;
    [self.navigationController pushViewController:newVC animated:YES];

}

//刷新表
-(void)shuaiXin
{
    [HttpEngine getAddress:^(NSArray *dataArray) {
        _dataArray=dataArray;
        [_adressTV reloadData];
    }];
}

@end
