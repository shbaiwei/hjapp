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
#import "MyPropBtn.h"
#import "ShopingPageViewController.h"
#import "LoginViewController.h"


@interface AssortPageViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *leftTableV;
@property (nonatomic, strong) UITableView *rightTableV;

@property (nonatomic, strong) UICollectionView *myCollecV;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *beginArr;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableDictionary *sendDic;

@property (nonatomic, strong) UILabel *hdViewLabel;
@property (nonatomic, strong) UIScrollView *myScrollV;
@property (nonatomic, strong) NSMutableArray *BtnArr;
@property(nonatomic,strong)UILabel*numLabel;

@property (nonatomic, strong) UIView *shopView;
@property (nonatomic, strong) UILabel *tomoniL;
@property (nonatomic, strong) UIButton *kessanBtn;
@property (nonatomic, strong) UILabel *okaneLabel;
@property (nonatomic, strong) UIImageView *shopCarIV;

////////
@property(nonatomic,strong)NSArray*floerNameArray;
@property(nonatomic,strong)NSArray*floerDetailArray;
//@property(nonatomic,strong)UILabel*numLabel;
@property(nonatomic,strong)UIView*headView;
@property(nonatomic,strong)NSArray*catalogueArray;
@property(nonatomic,strong)UILabel*colorLable;
@property(nonatomic,strong)MyBtn*chooseBtn;
@property(nonatomic,strong)UIView*assortTopView;
@property(nonatomic,strong)UIScrollView*titleBtnScrollView;
@property(nonatomic,strong)NSArray*carArray;
@property(nonatomic,strong)NSMutableArray*catalogueStrArray;

//添加减少按钮对应的购物车数组
@property(nonatomic,strong)NSArray*btnCarArray;
@property(nonatomic,unsafe_unretained)int addNum;


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
    self.navigationController.navigationBar.translucent =NO;
    self.navigationItem.hidesBackButton=YES;
    self.title=@"选择品类";
    [self hidesTabBar:NO];
    
    //判断是否需要登陆
//    NSString*str=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
//    if (str==NULL)
//    {
//        LoginViewController*loginVC=[[LoginViewController alloc]init];
//        
//        //[self.navigationController popToViewController:loginVC animated:YES];
//        
//        //__weak AssortPageViewController *weakSelf = self;
//        
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        
//        [self presentViewController:navigationController animated:YES completion:^{
//            
//        }];
//        return;
//    }

    
    [HttpEngine getAllFlower:^(NSArray *dataArray)
     {
         //左Uitableview
         _floerNameArray=dataArray;
         [self judgeIsTag];
     }];
    
    
    //获取购物车物品总数量
//    [HttpEngine getSimpleCart:^(NSArray *array) {
//        int num=0;
//                for (int i=0; i<array.count; i++)
//               {
//                    ShopingCar*shCar=array[i];
//                    num=[shCar.number intValue]+num;
//               }
//                _numLabel.text=[NSString stringWithFormat:@"%d",num];
//    }];

    if(!_leftTableV)
    {
        //获取所有的花
        [HttpEngine getAllFlower:^(NSArray *dataArray)
         {
             //左Uitableview
             _floerNameArray=dataArray;
             [self showLeftTableView];
            // [self getRightData];
         }];

    }
    if(!_rightTableV)
    {
      [self performSelector:@selector(getRightData) withObject:nil afterDelay:0.5];
    }
    if (!_assortTopView)
    {
      [self performSelector:@selector(delayGetProduct) withObject:nil afterDelay:0.3];
    }
}

-(void)judgeIsTag
{
    //获取上个页面所选取的种类
    NSString*isTagStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"TWOTAG"];
    if (isTagStr!=NULL)
    {
        _isTag=[isTagStr intValue];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"TWOTAG"];
        NSLog(@"_isTag===%d",_isTag);
        
        AllFlower*flower=_floerNameArray[_isTag];
        NSString*locatioanStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
        NSLog(@"locatioanStr===%@",locatioanStr);
        [HttpEngine getProductDetail:flower.flowerId withLocation:locatioanStr withProps:nil withPage:@"1" withPageSize:@"30" completion:^(NSArray *dataArray)
         {
             //右uitableview
             _floerDetailArray=dataArray;
             [_rightTableV reloadData];
         }];
        
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _catalogueStrArray=[[NSMutableArray alloc]init];
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    _addNum=0;
    
}

//获取右边tableview数据
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

//获取分类栏属性
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
    
    _assortTopView=[[UIView alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1/3.5, 0, LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5, 70+20)];
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
        MyPropBtn *btn=[[MyPropBtn alloc] initWithFrame:CGRectMake(65*i+5, 5, 60, 20)];
        [btn setTitle:dic[@"aliasname"] forState:UIControlStateNormal];
        [btn.layer setBorderColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1].CGColor];
        btn.section=0;
        btn.row=i;
        btn.tag=1000+i;
        
        //[btn setBackgroundImage:[UIImage imageNamed:@"navi.png"] forState:UIControlStateSelected];
        btn.selected=NO;
        
        
        NSString*propStr=[NSString stringWithFormat:@"%@:%@",dic[@"props"],dic[@"id"]];
        NSLog(@"propStr===%@",propStr);
        btn.accessibilityLabel=propStr;
        
        [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_titleBtnScrollView addSubview:btn];
    }
    
    
    _chooseBtn=[[MyBtn alloc]initWithFrame:CGRectMake((LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5-100)/2, 35, 100, 70-20)];
    [_chooseBtn setTitle:@"更多筛选" forState:UIControlStateNormal];
    _chooseBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [_chooseBtn setTitleColor:[UIColor colorWithRed:37/255.0 green:119/255.0 blue:188/255.0 alpha:1] forState:UIControlStateNormal];
    [_chooseBtn addTarget:self action:@selector(shouSuo) forControlEvents:UIControlEventTouchUpInside];
    _chooseBtn.isOpen=NO;
    [_assortTopView addSubview:_chooseBtn];
    

    for (int i=0; i<2; i++)
    {
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(5+((LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5)/2+45)*i, 60, (LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5-110)/2, 2)];
        label.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        [_assortTopView addSubview:label];
    }
    
}
//分类栏收缩
-(void)shouSuo
{
    
    
    if (_chooseBtn.isOpen==NO)
    {
        [_chooseBtn setTitle:@"收起筛选" forState:UIControlStateNormal];
        _headView=[[UIView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/3.5, 70, LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5, 30*_catalogueArray.count)];
        _headView.backgroundColor=[UIColor whiteColor];
        
        
        for (int i=1; i<_catalogueArray.count; i++)
        {
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(5, 10+30*(i-1), 60, 20)];
            label.font=[UIFont systemFontOfSize:14];
            label.textAlignment=NSTextAlignmentCenter;
            [_headView addSubview:label];
            FlowerCatalogue*flower=_catalogueArray[i];
            label.text=flower.name;
            
            
            UIScrollView*btnScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(70, 5+30*(i-1), LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5-60, 30)];
            btnScrollView.contentSize=CGSizeMake(65*flower.catalogueArray.count+40, 20);
            btnScrollView.showsHorizontalScrollIndicator=NO;
            btnScrollView.bounces=NO;
            
            btnScrollView.tag=100+i;
            
            [_headView addSubview:btnScrollView];
            
            
            for (int j=0; j<flower.catalogueArray.count; j++)
            {
                NSDictionary*dic=flower.catalogueArray[j];
                
                MyPropBtn *btn=[[MyPropBtn alloc] initWithFrame:CGRectMake(65*j+5, 5, 60, 20)];
                [btn setTitle:dic[@"aliasname"] forState:UIControlStateNormal];
                [btn.layer setBorderColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1].CGColor];
                btn.section=i;
                btn.row=j;
                
                btn.tag=1000+j;
                
                btn.selected=NO;
                NSString*propStr=[NSString stringWithFormat:@"%@:%@",dic[@"props"],dic[@"id"]];
                NSLog(@"propStr===%@",propStr);
                
                btn.accessibilityLabel=propStr;
                
                [btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [btnScrollView addSubview:btn];
                
                
                
            }
            
        }
        
        [self.view addSubview:_headView];
        
        
        _rightTableV.frame=CGRectMake(LBVIEW_WIDTH1/3.5, 70+30*_catalogueArray.count, 5*LBVIEW_WIDTH1/6,LBVIEW_HEIGHT1-70-113-30*_catalogueArray.count);
    }
    else
    {
        [_chooseBtn setTitle:@"更多筛选" forState:UIControlStateNormal];
        _rightTableV.frame=CGRectMake(LBVIEW_WIDTH1/3.5, 90, 5*LBVIEW_WIDTH1/6, LBVIEW_HEIGHT1-90-113);
        [_headView removeFromSuperview];
    }
    
    _chooseBtn.isOpen=!_chooseBtn.isOpen;
    
    
}

-(void) setBottomBorder:(UIView *)view color:(UIColor *)color{
    
    [view sizeToFit];
    
    CALayer* layer = [view layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height, layer.frame.size.width, 1);
    [bottomBorder setBorderColor:color.CGColor];
    [layer addSublayer:bottomBorder];
}

//左视图
-(void)showLeftTableView
{
    NSLog(@"_floerNameArray==%@",_floerNameArray);
    self.leftTableV=[[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width/3.5,  self.view.bounds.size.height * 0.75) style:UITableViewStylePlain];
    self.leftTableV.delegate=self;
    self.leftTableV.dataSource=self;
    //self.leftTableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.leftTableV];
    
    UIImageView*downImage=[[UIImageView alloc]initWithFrame:CGRectMake(30, self.view.bounds.size.height * 0.75 + 20, LBVIEW_WIDTH1/6-20, 20)];
    downImage.image=[UIImage imageNamed:@"swiper-market-btn-b.png"];
    [self.view addSubview:downImage];
    
//    //购物车
//    self.shopCarIV = [[UIImageView alloc] init];
//    self.shopCarIV.image = [UIImage imageNamed:@"shopcarr.png"];
//    self.shopCarIV.frame = CGRectMake(VIEW_WIDTH * 0.05, LBVIEW_HEIGHT1 / 1.36, VIEW_WIDTH * 0.142, VIEW_HEIGHT * 0.08);
//    [self.view addSubview:self.shopCarIV];
//    
//    UIButton*shopBtn=[[UIButton alloc]initWithFrame:CGRectMake(VIEW_WIDTH * 0.05, LBVIEW_HEIGHT1 / 1.36, VIEW_WIDTH * 0.142, VIEW_HEIGHT * 0.08)];
//    [shopBtn addTarget:self action:@selector(goShopCar) forControlEvents:UIControlEventTouchUpInside];
//    //[shopBtn setBackgroundColor:[UIColor redColor]];
//    [self.view addSubview:shopBtn];
//    
//    _numLabel=[[UILabel alloc]initWithFrame:CGRectMake(VIEW_WIDTH * 0.05+VIEW_WIDTH * 0.142-VIEW_HEIGHT*0.02, LBVIEW_HEIGHT1 / 1.36, VIEW_HEIGHT * 0.02, VIEW_HEIGHT * 0.02)];
//    _numLabel.backgroundColor=[UIColor redColor];
//    _numLabel.layer.cornerRadius=VIEW_HEIGHT*0.01;
//    _numLabel.clipsToBounds=YES;
//    _numLabel.font=[UIFont systemFontOfSize:10];
//    _numLabel.textAlignment=NSTextAlignmentCenter;
//    _numLabel.textColor=[UIColor whiteColor];
//    [self.view addSubview:_numLabel];
//    
}
//////去购物车
//-(void)goShopCar
//{
//    _tabBarVC.selectedIndex=3;
//}


//右视图
-(void)showRightTableView
{
    self.rightTableV=[[UITableView alloc] initWithFrame:CGRectMake(LBVIEW_WIDTH1/3.5, 20+70, 5*LBVIEW_WIDTH1/6, LBVIEW_HEIGHT1-90-113) style:UITableViewStylePlain];
    self.rightTableV.delegate=self;
    self.rightTableV.dataSource=self;
    [self.view addSubview:self.rightTableV];
    
    
}

//条件按钮
-(void)selectBtnClick:(MyPropBtn *)sender
{
    AllFlower*flower=_floerNameArray[_isTag];
    NSString*locatioanStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    
    NSString*str=sender.accessibilityLabel;
    
    //移除前后两次点击相同的
    for (int i=0; i<_catalogueStrArray.count; i++)
    {
        if ([str isEqualToString:_catalogueStrArray[i]])
        {
            [_catalogueStrArray removeObjectAtIndex:i];
            
            sender.selected=!sender.selected;
            
            [sender changeStyle];
            
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
//NSLog(@"str=====%@",str);
    
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
        [sender changeStyle];
        return;
    }
    if (sender.section==0)
    {
        if (_lastTag[0]!=0)
        {
            UIScrollView*scrollView=[_assortTopView viewWithTag:sender.section+100];
            MyPropBtn*btn=[scrollView viewWithTag:_lastTag[0]];
            btn.selected=NO;
            [btn removeSelectedStyle];
            
        }
        _lastTag[0]=(int)sender.tag;
    }
    else
    {
        if (_lastTag[sender.section]!=0)
        {
            UIScrollView*scrollView=[_headView viewWithTag:sender.section+100];
            MyPropBtn*btn=[scrollView viewWithTag:_lastTag[sender.section]];
            btn.selected=NO;
            [btn removeSelectedStyle];
            
        }
        _lastTag[sender.section]=(int)sender.tag;
    }
    sender.selected=!sender.selected;
    [sender changeStyle];
}

//左按钮
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.leftTableV]) {
        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        UIColor *color = [[UIColor alloc] init];//通过RGB来定义自己的颜色
        color = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        
         [cell.textLabel setHighlightedTextColor:[UIColor colorWithRed:37/255.0 green:119/255.0 blue:188/255.0 alpha:1]];
        
    } else if ([tableView isEqual:self.rightTableV]) {
        cell.backgroundColor = [UIColor whiteColor];
        UIColor *color = [[UIColor alloc] init];//通过RGB来定义自己的颜色
        color = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }
}


//cell的行数
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
        FlowerDetail*dFlower=_floerDetailArray[section];
        
        return dFlower.dataArray.count;
    }
    return 0;
}

//行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.leftTableV]) {
        return 60;
    }
    
    else if ([tableView isEqual:self.rightTableV]) {
        
        return 45;
    }
    return 0;
}

//区数
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
    
    
    if ([tableView isEqual:self.leftTableV]) {
        
        AllFlower*flower=_floerNameArray[indexPath.row];
        
        AssortTableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            cell=[[AssortTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.textLabel.text=flower.name;
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.adjustsFontSizeToFitWidth=YES;
        cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        return cell;
    }
    else if ([tableView isEqual:self.rightTableV]){
        
        FlowerDetail*dFlower=_floerDetailArray[indexPath.section];
        
        RightAssortTableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            cell=[[RightAssortTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
            NSDictionary*dic=dFlower.dataArray[indexPath.row];
            nameLabel.text=dic[@"supplier_name"];
            nameLabel.font=[UIFont systemFontOfSize:14];
            [cell addSubview:nameLabel];
            
            UILabel*priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 50, 20)];
            priceLabel.font=[UIFont systemFontOfSize:12];
            priceLabel.text=[NSString stringWithFormat:@"¥%@",dic[@"price"]];
            priceLabel.textColor=[UIColor redColor];
            [cell addSubview:priceLabel];
            
            UILabel*detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 25, 100, 20)];
            detailLabel.font=[UIFont systemFontOfSize:12];
            detailLabel.text=[NSString stringWithFormat:@"库存:%@",dic[@"stocks"]];
            detailLabel.textColor=[UIColor grayColor];
            [cell addSubview:detailLabel];
            
            //添加按钮
            UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5-40, 5, 44, 44)];
            [btn setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
            [btn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
            [btn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=indexPath.section+100;
            [cell addSubview:btn];
            
            
            //获取购物车信息
            NSString*flowerStr=[NSString stringWithFormat:@"%@",dFlower.Id];
            
            [HttpEngine getSimpleCart:^(NSArray *array)
             {
                 for (int i=0; i<array.count; i++)
                 {
                     ShopingCar*shopCar=array[i];
                     NSString*shopCarStr=[NSString stringWithFormat:@"%@",shopCar.skuId];
                     if ([flowerStr isEqualToString:shopCarStr])
                     {
                         //减少按钮
                         UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5-90, 5, 44, 44)];
                         [btn setImage:[UIImage imageNamed:@"jian.png"] forState:UIControlStateNormal];
                         [btn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
                         
                         [btn addTarget:self action:@selector(subBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                         btn.tag=indexPath.section+500;
                         [cell addSubview:btn];
                         
                         UILabel*numLabel=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5-60, 15, 30, 20)];
                         numLabel.text=[NSString stringWithFormat:@"%@",shopCar.number];
                         numLabel.textColor=[UIColor blackColor];
                         numLabel.font=[UIFont systemFontOfSize:15];
                         numLabel.textAlignment=NSTextAlignmentCenter;
                         [cell addSubview:numLabel];
                         
                     }
                     
                 }

            }];
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
    NSString*locatioanStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    NSString*flowerStr=[NSString stringWithFormat:@"%@",dic[@"sku"]];
    //获取商品在购物车里面的数量
    [HttpEngine getSimpleCart:^(NSArray *array) {
        if (array.count==0)
        {
            [HttpEngine addGoodsLocation:locatioanStr withSku:dic[@"sku"] withSupplier:dic[@"supplier"] withNumber:@"1"];
        }
        else
        {
            for (int i=0; i<array.count; i++)
            {
                ShopingCar*shopCar=array[i];
                NSString*shopCarStr=[NSString stringWithFormat:@"%@",shopCar.skuId];
                
                if ([flowerStr isEqualToString:shopCarStr])
                {
                    NSLog(@"shopCar===%@",shopCar.number);
                    _addNum=[shopCar.number intValue]+1;
                    NSString*addStr=[NSString stringWithFormat:@"%d",_addNum];
                    [HttpEngine addGoodsLocation:locatioanStr withSku:dic[@"sku"] withSupplier:dic[@"supplier"] withNumber:addStr];
                    return ;
                }
                else
                {
                    if (i==array.count-1)
                    {
                        [HttpEngine addGoodsLocation:locatioanStr withSku:dic[@"sku"] withSupplier:dic[@"supplier"] withNumber:@"1"];
                    }
                }
            }
        }

    }];
    //找到当前点击的位置
    CGRect rect=[sender convertRect: sender.bounds toView:self.view];
    UIImageView*anImage=[[UIImageView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-50, rect.origin.y, 20, 20)];
    [anImage sd_setImageWithURL:[NSURL URLWithString:dFlower.image]];
    //anImage.backgroundColor=[UIColor redColor];
    anImage.layer.cornerRadius=10;
    anImage.clipsToBounds=YES;
    [self.view addSubview:anImage];
    
     //动画
    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced animations:^
    {
        //anImage.frame=CGRectMake(4*LBVIEW_WIDTH1/5, 6*rect.origin.y/5, 10, 10);
        anImage.frame=CGRectMake(3.5*LBVIEW_WIDTH1/5, LBVIEW_HEIGHT1-54, 20, 20);
        anImage.transform=CGAffineTransformMakeRotation((90.0f*M_PI) / 180.0f);
    } completion:^(BOOL finished)
     {
         
     [anImage removeFromSuperview];
      
    }];
    
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.5];
    
}
//减少按钮
-(void)subBtnClick:(UIButton*)sender
{
    FlowerDetail*dFlower=_floerDetailArray[sender.tag-500];
    NSDictionary*dic=dFlower.dataArray[0];
    NSString*flowerStr=[NSString stringWithFormat:@"%@",dFlower.Id];
    
    NSString*locatioanStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    //获取商品在购物车里面的数量
    [HttpEngine getSimpleCart:^(NSArray *array) {
        for (int i=0; i<array.count; i++)
        {
            ShopingCar*shopCar=array[i];
            NSString*shopCarStr=[NSString stringWithFormat:@"%@",shopCar.skuId];
            if ([flowerStr isEqualToString:shopCarStr])
            {
                _addNum=[shopCar.number intValue]-1;
                NSString*addStr=[NSString stringWithFormat:@"%d",_addNum];
                [HttpEngine addGoodsLocation:locatioanStr withSku:dic[@"sku"] withSupplier:dic[@"supplier"] withNumber:addStr];
            }
        }
    }];
    
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:0.5];
}

//刷新表
-(void)refreshData
{
    [_rightTableV reloadData];
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
        
        //重置row状态
        for (int i=0; i<_floerDetailArray.count; i++)
        {
            _isOpen[i]=NO;
        }
       
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

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if([tableView isEqual:self.rightTableV])
    {
       return 4;
    }
    
    return 0;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerBorder=[[UIView alloc] init];
    
    [footerBorder setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    //[self setBottomBorder:footerBorder color:[UIColor grayColor]];
    return footerBorder;
}

//自定义区头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.leftTableV])
    {
        return 0;
    }
    return 80;
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
        
        //NSLog(@"%@",flow.propValue);
        
        UIView*view=[[UIView alloc]init];
        view.backgroundColor=[UIColor whiteColor];
        
        //图片
        UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(10, LBVIEW_HEIGHT1*0.01,LBVIEW_WIDTH1/6, LBVIEW_WIDTH1/6)];
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@@!l60",flow.image]]];
        [view addSubview:image];
        
        //名字
        UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(15+LBVIEW_WIDTH1/6, 0,LBVIEW_WIDTH1/2+10, 30)];
        nameLabel.text=flow.goodsName;
        nameLabel.numberOfLines=0;
        nameLabel.font=[UIFont systemFontOfSize:16];
        nameLabel.textColor=[UIColor blackColor];
        [view addSubview:nameLabel];
        
        //属性
        UILabel*unitLabel=[[UILabel alloc]initWithFrame:CGRectMake(15+LBVIEW_WIDTH1/6, 30,45, 20)];
        unitLabel.text=[NSString stringWithFormat:@"%@/扎",flow.standardNumber];
        unitLabel.font=[UIFont systemFontOfSize:12];
        unitLabel.textColor=[UIColor grayColor];
        [view addSubview:unitLabel];
        
        NSArray*attributeArray=[flow.propValue componentsSeparatedByString:@","];
        if (attributeArray.count>=3)
        {
            for (int i=0; i<3; i++)
            {
                UILabel*detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(15+LBVIEW_WIDTH1/6+50+35*i,30, 30, 20)];
                detailLabel.text=attributeArray[i];
                detailLabel.textAlignment=NSTextAlignmentCenter;
                detailLabel.layer.cornerRadius=5;
                detailLabel.clipsToBounds=YES;
                detailLabel.adjustsFontSizeToFitWidth=YES;
                detailLabel.font=[UIFont systemFontOfSize:12];
                detailLabel.textColor=[UIColor whiteColor];
                if (i==0)
                {
                    detailLabel.backgroundColor=[UIColor colorWithRed:244/255.0 green:100/255.0 blue:108/255.0 alpha:1];
                }
                if (i==1)
                {
                     detailLabel.backgroundColor=[UIColor colorWithRed:104/255.0 green:179/255.0 blue:255/255.0 alpha:1];
                }
                if (i==2)
                {
                    detailLabel.backgroundColor=[UIColor colorWithRed:255/255.0 green:45/255.0 blue:75/255.0 alpha:1];
                }
                [view addSubview:detailLabel];
            }
        }
        else
        {
        for (int i=0; i<attributeArray.count; i++)
        {
            UILabel*detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(15+LBVIEW_WIDTH1/6+50+35*i, 30, 30, 20)];
            detailLabel.text=attributeArray[i];
            detailLabel.textAlignment=NSTextAlignmentCenter;
            detailLabel.layer.cornerRadius=5;
            detailLabel.clipsToBounds=YES;
            detailLabel.font=[UIFont systemFontOfSize:12];
            detailLabel.textColor=[UIColor whiteColor];
            detailLabel.adjustsFontSizeToFitWidth=YES;
            detailLabel.backgroundColor=[UIColor colorWithRed:245/255.0 green:i*87/255.0 blue:105/255.0 alpha:1];
            [view addSubview:detailLabel];
        }
        }

        //价格
        UILabel*picLabel=[[UILabel alloc]initWithFrame:CGRectMake(15+LBVIEW_WIDTH1/6, 50, 100, 20)];
        NSDictionary*dic=flow.dataArray[0];
        if (flow.dataArray.count>1)
        {
           picLabel.text=[NSString stringWithFormat:@"¥%@ 起",dic[@"price"]];
        }
        else
        {
           picLabel.text=[NSString stringWithFormat:@"¥%@",dic[@"price"]];
        }
        picLabel.textColor=[UIColor redColor];
        picLabel.font=[UIFont systemFontOfSize:13];
        [view addSubview:picLabel];
        //展开按钮
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-LBVIEW_WIDTH1/3.5-90,40, 94, 34)];
        //[btn setBackgroundImage:[UIImage imageNamed:@"category-arrow2.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"category-arrow2.png"] forState:UIControlStateNormal];
        [btn setContentMode:UIViewContentModeCenter];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(10, 60, 0, 10)];
        
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
    [_rightTableV reloadData];
//    NSIndexSet*set=[NSIndexSet indexSetWithIndex:sender.tag];
//    [_rightTableV reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
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
