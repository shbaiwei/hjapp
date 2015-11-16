//
//  AssortPageViewController.m
//  HJApp
//
//  Created by Bruce He on 15/10/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "AssortPageViewController.h"
#import "AssortTableViewCell.h"
#import "RightAssortTableViewCell.h"
#import "HttpEngine.h"
#import "UIImageView+WebCache.h"
#import "MyBtn.h"
#import "ShopingPageViewController.h"


@interface AssortPageViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *leftTableV;
@property (nonatomic, strong) UITableView *rightTableV;

@property (nonatomic, strong) NSMutableArray *cateArr;
@property (nonatomic, strong) NSMutableArray *leftArr;
@property (nonatomic, strong) UICollectionView *myCollecV;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *collecArr;
@property (nonatomic, strong) NSMutableArray *firstArr;
@property (nonatomic, strong) NSMutableArray *beginArr;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableDictionary *sendDic;

@property (nonatomic, strong) UILabel *hdViewLabel;
@property (nonatomic, strong) UIScrollView *myScrollV;
@property (nonatomic, strong) NSMutableArray *BtnArr;

@property (nonatomic, strong) UIView *shopView;
@property (nonatomic, strong) UILabel *tomoniL;
@property (nonatomic, strong) UIButton *kessanBtn;
@property (nonatomic, strong) UILabel *okaneLabel;
@property (nonatomic, strong) UIImageView *shopCarIV;

////////
@property(nonatomic,strong)NSArray*floerNameArray;
@property(nonatomic,strong)NSArray*floerDetailArray;
@property(nonatomic,strong)UILabel*numLabel;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,strong)NSArray*catalogueArray;
@property(nonatomic,strong)UILabel*colorLable;
@property(nonatomic,strong)MyBtn*chooseBtn;
@property(nonatomic,strong)UIView*assortTopView;
@property(nonatomic,strong)UIScrollView*titleBtnScrollView;
@property(nonatomic,strong)NSArray*carArray;
@property(nonatomic,strong)NSMutableArray*catalogueStrArray;





@end

#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height
#define LEFTTABLE_WITH self.view.frame.size.width/3.5

@implementation AssortPageViewController


//视图将要出现  刷新数据
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    //NSLog(@"_istag===%d",_isTag);
    
    [self hidesTabBar:YES];
    [HttpEngine getCart:^(NSArray *dataArray, NSString *totalPrice, NSString *shippingFee, NSString *paymentPrice) {
        NSArray*array=dataArray;
        int num=0;
        for (int i=0; i<array.count; i++)
        {
            ShopingCar*shCar=array[i];
            num=[shCar.number intValue]+num;
        }
        
        _numLabel.text=[NSString stringWithFormat:@"%d",num];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _catalogueStrArray=[[NSMutableArray alloc]init];
    
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popself)];
    
    self.title=@"选择品种";
    [HttpEngine getAllFlower:^(NSArray *dataArray)
     {
         //左Uitableview
         _floerNameArray=dataArray;
         [self showLeftTableView];
         [self getRightData];
     }];
    
    self.collecArr = [NSMutableArray array];
    self.leftArr = [NSMutableArray array];
    self.cateArr = [NSMutableArray array];
    self.firstArr = [NSMutableArray array];
    self.navigationController.navigationBar.translucent =NO;
    
    
    [self performSelector:@selector(delayGetProduct) withObject:nil afterDelay:0.5];
    //分类
    
    
}
-(void)popself
{
    
    FlashViewController*flashVC=[[FlashViewController alloc]init];
    [self.navigationController pushViewController:flashVC animated:YES];
}

-(void)getRightData
{
    AllFlower*flower=_floerNameArray[_isTag];
    NSString*locatioanStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    [HttpEngine getProductDetail:flower.flowerId withLocation:locatioanStr withProps:nil withPage:@"1" withPageSize:@"30" completion:^(NSArray *dataArray)
     {
         //右uitableview
         _floerDetailArray=dataArray;
         [self showRightTableView];
         
     }];
    
}
-(void)delayGetProduct
{
    AllFlower*flower=_floerNameArray[0];
    [HttpEngine getProduct:flower.flowerId completion:^(NSArray *dataArray)
     {
         _catalogueArray=dataArray;
         [self setCatalogue];
     }];
}

//分类栏设置
-(void)setCatalogue
{
    FlowerCatalogue*flower=_catalogueArray[0];
    
    _assortTopView=[[UIView alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1/3.5, 0, LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5, VIEW_HEIGHT/10)];
    _assortTopView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_assortTopView];
    
    _colorLable=[[UILabel alloc] initWithFrame:CGRectMake(5, 15,60, 20)];
    _colorLable.text=flower.name;
    _colorLable.textAlignment=NSTextAlignmentCenter;
    _colorLable.textColor=[UIColor blackColor];
    _colorLable.font=[UIFont boldSystemFontOfSize:14];
    [_assortTopView addSubview:_colorLable];
    
    _titleBtnScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(70, 10, LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5-60, 30)];
    _titleBtnScrollView.contentSize=CGSizeMake(65*flower.catalogueArray.count+40, 20);
    _titleBtnScrollView.showsHorizontalScrollIndicator=NO;
    _titleBtnScrollView.bounces=NO;
    _titleBtnScrollView.tag=100;
    [_assortTopView addSubview:_titleBtnScrollView];
    
    for (NSInteger i=0; i<flower.catalogueArray.count; i++)
    {
        NSArray*array=flower.catalogueArray;
        NSDictionary*dic=array[i];
        MyBtn *btn=[[MyBtn alloc] initWithFrame:CGRectMake(65*i+5, 5, 60, 20)];
        [btn setTitle:dic[@"aliasname"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:5];
        [btn.layer setBorderWidth:0.6];
        
        btn.section=0;
        btn.row=i;
        btn.tag=1000+i;
        
        [btn setBackgroundImage:[UIImage imageNamed:@"navi.png"] forState:UIControlStateSelected];
        
        btn.selected=NO;
        
        NSString*propStr=[NSString stringWithFormat:@"%@:%@",dic[@"props"],dic[@"id"]];
        NSLog(@"propStr===%@",propStr);
        btn.accessibilityLabel=propStr;
        
        [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleBtnScrollView addSubview:btn];
    }
    
    
    _chooseBtn=[[MyBtn alloc]initWithFrame:CGRectMake((LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5-100)/2, 40, 100, VIEW_HEIGHT/10-40)];
    [_chooseBtn setTitle:@"更多筛选" forState:UIControlStateNormal];
    _chooseBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_chooseBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_chooseBtn addTarget:self action:@selector(shouSuo) forControlEvents:UIControlEventTouchUpInside];
    _chooseBtn.isOpen=NO;
    [_assortTopView addSubview:_chooseBtn];
    
    
    
}
//分类栏收缩
-(void)shouSuo
{
    
    
    if (_chooseBtn.isOpen==NO)
    {
        [_chooseBtn setTitle:@"收起筛选" forState:UIControlStateNormal];
        _headView=[[UIView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/3.5, VIEW_HEIGHT/10, LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5, 30*_catalogueArray.count)];
        //_headView.backgroundColor=[UIColor redColor];
        
        
        for (int i=1; i<_catalogueArray.count; i++)
        {
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(5, 10+30*(i-1), 60, 20)];
            label.font=[UIFont systemFontOfSize:14];
            label.textAlignment=NSTextAlignmentCenter;
            [_headView addSubview:label];
            FlowerCatalogue*flower=_catalogueArray[i];
            label.text=flower.name;
            
            
            UIScrollView*btnScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(70, 10+30*(i-1), LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5-60, 30)];
            btnScrollView.contentSize=CGSizeMake(65*flower.catalogueArray.count+40, 20);
            btnScrollView.showsHorizontalScrollIndicator=NO;
            btnScrollView.bounces=NO;
            
            btnScrollView.tag=100+i;
            
            [_headView addSubview:btnScrollView];
            
            
            for (int j=0; j<flower.catalogueArray.count; j++)
            {
                NSDictionary*dic=flower.catalogueArray[j];
                
                MyBtn *btn=[[MyBtn alloc] initWithFrame:CGRectMake(65*j+5, 5, 60, 20)];
                [btn setTitle:dic[@"aliasname"] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font=[UIFont systemFontOfSize:14];
                [btn.layer setMasksToBounds:YES];
                [btn.layer setCornerRadius:5];
                [btn.layer setBorderWidth:0.6];
                
                btn.section=i;
                btn.row=j;
                
                btn.tag=1000+j;
                
                [btn setBackgroundImage:[UIImage imageNamed:@"navi.png"] forState:UIControlStateSelected];
                
                btn.selected=NO;
                NSString*propStr=[NSString stringWithFormat:@"%@:%@",dic[@"props"],dic[@"id"]];
                NSLog(@"propStr===%@",propStr);
                
                btn.accessibilityLabel=propStr;
                
                [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btnScrollView addSubview:btn];
                
            }
            
        }
        
        [self.view addSubview:_headView];
        
        
        _rightTableV.frame=CGRectMake(LBVIEW_WIDTH1/3.5, VIEW_HEIGHT/10+30*_catalogueArray.count, 5*LBVIEW_WIDTH1/6, 5*LBVIEW_HEIGHT1/6);
    }
    else
    {
        [_chooseBtn setTitle:@"更多筛选" forState:UIControlStateNormal];
        _rightTableV.frame=CGRectMake(LBVIEW_WIDTH1/3.5, VIEW_HEIGHT/10, 5*LBVIEW_WIDTH1/6, 5*LBVIEW_HEIGHT1/6);
        [_headView removeFromSuperview];
    }
    
    _chooseBtn.isOpen=!_chooseBtn.isOpen;
    
    
}

//左视图
-(void)showLeftTableView
{
    self.leftTableV=[[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width/3.5,  self.view.bounds.size.height-LBVIEW_HEIGHT1/11.5) style:UITableViewStylePlain];
    self.leftTableV.delegate=self;
    self.leftTableV.dataSource=self;
    self.leftTableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:self.leftTableV];
    
    //购物车
    self.shopCarIV = [[UIImageView alloc] init];
    self.shopCarIV.image = [UIImage imageNamed:@"shopcarr.png"];
    self.shopCarIV.frame = CGRectMake(VIEW_WIDTH * 0.05, LBVIEW_HEIGHT1 / 1.36, VIEW_WIDTH * 0.142, VIEW_HEIGHT * 0.08);
    [self.view addSubview:self.shopCarIV];
    
    UIButton*shopBtn=[[UIButton alloc]initWithFrame:CGRectMake(VIEW_WIDTH * 0.05, LBVIEW_HEIGHT1 / 1.36, VIEW_WIDTH * 0.142, VIEW_HEIGHT * 0.08)];
    [shopBtn addTarget:self action:@selector(goShopCar) forControlEvents:UIControlEventTouchUpInside];
    //[shopBtn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:shopBtn];
    
    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(VIEW_WIDTH * 0.05+VIEW_WIDTH * 0.142-VIEW_HEIGHT*0.02, LBVIEW_HEIGHT1 / 1.36, VIEW_HEIGHT * 0.02, VIEW_HEIGHT * 0.02)];
    _numLabel.backgroundColor=[UIColor redColor];
    _numLabel.layer.cornerRadius=VIEW_HEIGHT*0.01;
    _numLabel.clipsToBounds=YES;
    _numLabel.font=[UIFont systemFontOfSize:10];
    _numLabel.textAlignment=NSTextAlignmentCenter;
    _numLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:_numLabel];
    
}
//去购物车
-(void)goShopCar
{
    
    ShopingPageViewController*shopVC=[[ShopingPageViewController alloc]init];
    [self.navigationController pushViewController:shopVC animated:YES];
    
}


//右视图
-(void)showRightTableView
{
    self.rightTableV=[[UITableView alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1/3.5, VIEW_HEIGHT/10, 5*LBVIEW_WIDTH1/6, 5*LBVIEW_HEIGHT1/6) style:UITableViewStyleGrouped];
    
    self.rightTableV.delegate=self;
    self.rightTableV.dataSource=self;
    [self.view addSubview:self.rightTableV];
    
    
}

//条件按钮
-(void)selectBtnClick:(MyBtn *)sender
{
    AllFlower*flower=_floerNameArray[_isTag];
    NSString*locatioanStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    
    NSString*str=sender.accessibilityLabel;
    
    //移除前后两次点击相同的
    for (int i=0; i<_catalogueStrArray.count; i++)
    {
        if ([str isEqualToString:_catalogueStrArray[i]])
        {
//            NSLog(@"_catalogueStrArray===%@",_catalogueStrArray[i]);
//            NSLog(@"qwer");
            [_catalogueStrArray removeObjectAtIndex:i];
            
            sender.selected=!sender.selected;
            
            [HttpEngine getProductDetail:flower.flowerId withLocation:locatioanStr withProps:_catalogueStrArray withPage:@"1" withPageSize:@"30" completion:^(NSArray *dataArray)
             {
                 //右uitableview
                 _floerDetailArray=dataArray;
                 [_rightTableV reloadData];
                 
             }];
            
            return;
        }
    }
    
    //NSLog(@"sender.tag===%lu",sender.tag);
    NSLog(@"str=====%@",str);
    //将点击的不同行加到数组中
    if (_catalogueStrArray.count==0)
    {
        [_catalogueStrArray addObject:str];
    }
    else
    {
        for (int i=0; i<_catalogueStrArray.count; i++)
        {
            
            NSString*str1=[str substringToIndex:1];
            NSLog(@"str1===%@",str1);
            NSString*str2=[_catalogueStrArray[i] substringToIndex:1];
 
            if ([str1 isEqualToString:str2])
            {
                [_catalogueStrArray removeObjectAtIndex:i];
                [_catalogueStrArray addObject:str];
            }
            else
            {
                if (i==_catalogueStrArray.count-1)
                {
                    [_catalogueStrArray addObject:str];
                }
                
            }
        }
        
    }
    NSLog(@"_catalogueStrArray===%@",_catalogueStrArray);
    
    
    
//    NSString*propsStr=_catalogueStrArray[0];
//    for (int i=1; i<_catalogueStrArray.count; i++)
//    {
//        propsStr=[NSString stringWithFormat:@"props=%@&props=%@",propsStr,_catalogueStrArray[i]];
//    }
    
//    NSLog(@"propsStr==%@",propsStr);
    
    [HttpEngine getProductDetail:flower.flowerId withLocation:locatioanStr withProps:_catalogueStrArray withPage:@"1" withPageSize:@"30" completion:^(NSArray *dataArray)
     {
         //右uitableview
         _floerDetailArray=dataArray;
         [_rightTableV reloadData];
         
     }];
    
    
    //选中状态与非选中的区别
    if (sender.tag==_lastTag[sender.section])
    {
        sender.selected=!sender.selected;
        return;
    }
    if (sender.section==0)
    {
        if (_lastTag[0]!=0)
        {
            UIScrollView*scrollView=[_assortTopView viewWithTag:sender.section+100];
            UIButton*btn=[scrollView viewWithTag:_lastTag[0]];
            btn.selected=NO;
            
        }
        _lastTag[0]=(int)sender.tag;
    }
    else
    {
        if (_lastTag[sender.section]!=0)
        {
            UIScrollView*scrollView=[_headView viewWithTag:sender.section+100];
            UIButton*btn=[scrollView viewWithTag:_lastTag[sender.section]];
            btn.selected=NO;
        }
        _lastTag[sender.section]=(int)sender.tag;
    }
    sender.selected=!sender.selected;
}

//左按钮
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.leftTableV]) {
        cell.backgroundColor = [UIColor colorWithRed:0.97 green:0.973 blue:0.98 alpha:1];
        UIColor *color = [[UIColor alloc] init];//通过RGB来定义自己的颜色
        color = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    } else if ([tableView isEqual:self.rightTableV]) {
        cell.backgroundColor = [UIColor whiteColor];
        UIColor *color = [[UIColor alloc] init];//通过RGB来定义自己的颜色
        color = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }
}


//cell的区数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([tableView isEqual:self.leftTableV])
    {
        return _floerNameArray.count;
    }
    
    else if ([tableView isEqual:self.rightTableV])
    {
        if (_isOpen[section]==NO)
        {
            return 0;
        }
        
        return 1;
    }
    
    return 0;
}

//行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.leftTableV]) {
        return 45;
    }
    
    else if ([tableView isEqual:self.rightTableV]) {
        
        return 45;
    }
    
    return 0;
}

//cell的行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.leftTableV])
    {
        return 1;
    }
    
    else if ([tableView isEqual:self.rightTableV]) {
        
        return _floerDetailArray.count;
    }
    return 0;
}

//cell的详细
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllFlower*flower=_floerNameArray[indexPath.row];
    FlowerDetail*dFlower=_floerDetailArray[indexPath.section];
    
    if ([tableView isEqual:self.leftTableV]) {
        
        AssortTableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            cell=[[AssortTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.textLabel.text=flower.name;
        cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        return cell;
    }
    else if ([tableView isEqual:self.rightTableV]){
        RightAssortTableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            cell=[[RightAssortTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
            NSDictionary*dic=dFlower.dataArray[0];
            nameLabel.text=dic[@"supplier_name"];
            nameLabel.font=[UIFont systemFontOfSize:14];
            [cell addSubview:nameLabel];
            
            UILabel*detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 200, 20)];
            detailLabel.font=[UIFont systemFontOfSize:12];
            detailLabel.text=[NSString stringWithFormat:@"¥%@ 库存:%@",dic[@"price"],dic[@"stocks"]];
            [cell addSubview:detailLabel];
            
            //添加按钮
            UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(cell.frame.size.width-50, 15, 20, 20)];
            [btn setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=indexPath.section+100;
            [cell addSubview:btn];
            
        }
        
        return cell;
    }
    return nil;
}
//添加按钮
-(void)addBtnClick:(UIButton*)sender
{
    
    FlowerDetail*dFlower=_floerDetailArray[sender.tag-100];
    NSDictionary*dic=dFlower.dataArray[0];
    //添加
    [HttpEngine addGoodsLocation:@"330100" withSku:dic[@"sku"] withSupplier:dic[@"supplier"] withNumber:@"1"];
    
    
    [HttpEngine getCart:^(NSArray *dataArray, NSString *totalPrice, NSString *shippingFee, NSString *paymentPrice) {
        NSArray*array=dataArray;
        _numLabel.text=[NSString stringWithFormat:@"%lu",array.count];
    }];
    
    
    //UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[sender convertRect: sender.bounds toView:self.view];
    //动画
    UIImageView*anImage=[[UIImageView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1, rect.origin.y, 40, 40)];
    [anImage sd_setImageWithURL:[NSURL URLWithString:dFlower.image]];
    anImage.layer.cornerRadius=20;
    anImage.clipsToBounds=YES;
    [self.view addSubview:anImage];
    
//    [UIView beginAnimations:@"123" context:nil];
//    [UIView setAnimationDuration:2];
    
    [UIView animateWithDuration:0.5 animations:^
    {
        anImage.frame=CGRectMake(LBVIEW_WIDTH1-LBVIEW_WIDTH1/3, rect.origin.y-LBVIEW_HEIGHT1/10, 40, 40);
        
    } completion:^(BOOL finished)
    {
       [UIView animateWithDuration:1 animations:^
        {
        anImage.frame=CGRectMake(VIEW_WIDTH * 0.05+7, LBVIEW_HEIGHT1 / 1.36+7, 40, 40);
           
       } completion:^(BOOL finished)
        {
           [anImage removeFromSuperview];
       }];
        
    }];
//    [UIView commitAnimations];
    

}

//选中cell调用
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.leftTableV])
    {
        //隐藏分类栏
        [_catalogueStrArray removeAllObjects];
        _chooseBtn.isOpen=YES;
        [self shouSuo];
        
        _isTag=(int)indexPath.row;
        
        AllFlower*flower=_floerNameArray[indexPath.row];
        
        //获取产品
        NSString*locatioanStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
        [HttpEngine getProductDetail:flower.flowerId withLocation:locatioanStr withProps:nil withPage:@"1" withPageSize:@"30" completion:^(NSArray *dataArray)
         {
             _floerDetailArray=dataArray;
             
             [_rightTableV reloadData];
             
         }];
        
        //获取产品分类
        [HttpEngine getProduct:flower.flowerId completion:^(NSArray *dataArray)
         {
             _catalogueArray=dataArray;
             [self setCatalogue];
             
             
         }];

    }
    
    else if ([tableView isEqual:self.rightTableV])
    {
        
        
    }
    
}

//自定义区头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.leftTableV])
    {
        return 0;
    }
    return LBVIEW_HEIGHT1*0.12;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:self.leftTableV])
    {
        return nil;
    }
    if ([tableView isEqual:self.rightTableV])
    {
        FlowerDetail*flow=_floerDetailArray[section];
        
        UIView*view=[[UIView alloc]init];
        //view.backgroundColor=[UIColor lightGrayColor];
        
        
        //图片
        UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(10, LBVIEW_HEIGHT1*0.01,LBVIEW_WIDTH1/6, LBVIEW_HEIGHT1*0.1)];
        [image sd_setImageWithURL:[NSURL URLWithString:flow.image]];
        [view addSubview:image];
        
        //名字
        UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+LBVIEW_WIDTH1/6, LBVIEW_HEIGHT1*0.01, 120, 20)];
        nameLabel.text=flow.goodsName;
        nameLabel.textColor=[UIColor blackColor];
        [view addSubview:nameLabel];
        //属性
        UILabel*detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+LBVIEW_WIDTH1/6, LBVIEW_HEIGHT1*0.01+20, 200, 20)];
        detailLabel.text=flow.propValue;
        detailLabel.font=[UIFont systemFontOfSize:12];
        detailLabel.textColor=[UIColor blackColor];
        [view addSubview:detailLabel];
        //价格
        UILabel*picLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+LBVIEW_WIDTH1/6, LBVIEW_HEIGHT1*0.01+40, 100, 20)];
        NSDictionary*dic=flow.dataArray[0];
        picLabel.text=[NSString stringWithFormat:@"¥%@",dic[@"price"]];
        picLabel.textColor=[UIColor blackColor];
        [view addSubview:picLabel];
        //展开按钮
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5-40,LBVIEW_HEIGHT1*0.05, 30, 30)];
        [btn setBackgroundImage:[UIImage imageNamed:@"jt.png"] forState:UIControlStateNormal];
        btn.tag=section;
        [btn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        return view;
        
    }
    return nil;
    
}
//区间开合按钮
-(void)showDetail:(UIButton*)sender
{
    _isOpen[sender.tag]=!_isOpen[sender.tag];
    NSIndexSet*set=[NSIndexSet indexSetWithIndex:sender.tag];
    [_rightTableV reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    
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
