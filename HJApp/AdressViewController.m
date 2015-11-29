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
@property(nonatomic,strong)UILabel*chooseLable;
@property(nonatomic,unsafe_unretained)int lastTag;
@property(nonatomic,strong)NSDictionary*defaultAdDic;

@property(nonatomic,unsafe_unretained)int defaultIndex;
@end

@implementation AdressViewController

#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.translucent =NO;
    [HttpEngine getAddress:^(NSArray *dataArray)
     {
         _dataArray=dataArray;
         [self refreshData];
         [_adressTV reloadData];
     }];
    
    //获取默认地址
    [HttpEngine getDefaultAddress:^(NSDictionary*dataDic)
     {
         _defaultAdDic=dataDic;
    }];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"管理收货地址";
    [self creatTableview];
}

//刷新默认的索引值
-(void)refreshData
{
    for (int i=0; i<_dataArray.count; i++)
    {
        AllAdress*adress=_dataArray[i];
        NSString*str1=adress.addrId;
        NSString*str2=_defaultAdDic[@"addr_id"];
        if ([str2 isEqualToString:str1])
        {
            _defaultIndex=i;
        }
    }
}
//表的创建
-(void)creatTableview
{
    self.adressTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1-64) style:UITableViewStyleGrouped];
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
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        cell = [[AdressTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        
        cell.numAddressLabel.text=[NSString stringWithFormat:@"%lu",indexPath.row+1];
        cell.numAddressLabel.textColor=[UIColor whiteColor];
        cell.numAddressLabel.font=[UIFont boldSystemFontOfSize:12];
        
        cell.nameL.text=adress.consignee;
        cell.numberL.text=adress.phoneMob;
        cell.adressL.text=[NSString stringWithFormat:@"%@ %@ %@ %@",adress.chineseProvince,adress.chineseCity,adress.chineseTown,adress.address];
        
       
       
        
        _chooseLable=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/5/1.1, 95, 2*LBVIEW_WIDTH1/5, 20)];
       
        _chooseLable.tag=indexPath.row+500;
        _chooseLable.font = [UIFont systemFontOfSize:14];
        [cell addSubview:_chooseLable];
        
        
        [cell.deleBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleBtn.tag=indexPath.row;
        
        [cell.bjBtn addTarget:self action:@selector(bianJiBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.bjBtn.tag=indexPath.row+1000;
        cell.morenBtn.tag=indexPath.row+100;
        
        
        [cell.morenBtn addTarget:self action:@selector(defaultAddre:) forControlEvents:UIControlEventTouchUpInside];
        
        if (indexPath.row==_defaultIndex)
        {
            _chooseLable.text=@"默认地址";
            [cell.morenBtn setImage:[UIImage imageNamed:@"Dg.png"] forState:UIControlStateNormal];
            
        }
        else
        {
            _chooseLable.text= @"设为默认地址";
            [cell.morenBtn setImage:[UIImage imageNamed:@"maru.png"] forState:UIControlStateNormal];
        }
        
        
    }
    return cell;
}

-(void)defaultAddre:(UIButton*)sender
{
    //设置默认地址
    AllAdress*alldress=_dataArray[sender.tag-100];
   [HttpEngine setDefaultAddress:alldress.addrId];

    [self performSelector:@selector(goBackPage) withObject:nil afterDelay:0.2]; 
}
-(void)goBackPage
{
    if ([_payVCStr isEqualToString:@"payVC"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    //获取默认地址
    [HttpEngine getDefaultAddress:^(NSDictionary*dataDic)
     {
         _defaultAdDic=dataDic;
         [self refreshData];
         [_adressTV reloadData];
         
     }];
   
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
    newVC.procon=[NSString stringWithFormat:@"%@ %@ %@",adress.chineseProvince,adress.chineseCity,adress.chineseTown];
    newVC.adre=adress.address;
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
