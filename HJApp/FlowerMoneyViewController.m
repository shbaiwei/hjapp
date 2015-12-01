//
//  FlowerMoneyViewController.m
//  HJApp
//
//  Created by Bruce He on 15/11/6.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "FlowerMoneyViewController.h"
#import "FlowerTableViewCell.h"
#import "HttpEngine.h"

@interface FlowerMoneyViewController ()

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIButton *madaBtn;
@property (nonatomic, strong) UIButton *dattaBtn;
@property (nonatomic, strong) UIButton *mouBtn;

@property (nonatomic, strong) UITableView *flowerTV;
@property (nonatomic, strong) NSMutableArray *flowerArr;
@property (nonatomic, strong) NSMutableDictionary *flowerDic;
@property(nonatomic,copy)NSString*muYou;

/////
@property(nonatomic,strong)NSArray*dataArray;

@end

@implementation FlowerMoneyViewController

//宏定义宽高
#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

-(void)viewWillAppear:(BOOL)animated
{
     self.navigationController.navigationBarHidden=NO;
     self.navigationController.navigationBar.translucent =NO;
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.title = @"花集红包";
    
    [HttpEngine getRedBagStatus:@"1" completion:^(NSArray *dataArray)
     {
         _dataArray=dataArray;
         [self.flowerTV reloadData];
         
     }];
    
    [self performSelector:@selector(showRedPage) withObject:nil afterDelay:0.5];
    
}
-(void)showRedPage
{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 15)];
    [self.view addSubview:self.topView];
    
    
    self.madaBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.madaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.madaBtn.backgroundColor = [UIColor whiteColor];
    self.madaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.madaBtn.frame = CGRectMake(0, 0, LBVIEW_WIDTH1 / 3-1, LBVIEW_HEIGHT1 / 15);
    [self.madaBtn addTarget:self action:@selector(lookRedBagBtn:) forControlEvents:UIControlEventTouchUpInside];
    if (_dataArray.count!=0)
    {
        _muYou=[NSString stringWithFormat:@"待使用(%lu)",_dataArray.count];
    }
    else
    {
        _muYou=@"待使用";
    }
    [self.madaBtn setTitle:_muYou forState:UIControlStateNormal];
    self.madaBtn.tag=1;
    [self.topView addSubview:self.madaBtn];
    
    self.dattaBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.dattaBtn setTitle:@"已使用" forState:UIControlStateNormal];
    [self.dattaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.dattaBtn.backgroundColor = [UIColor whiteColor];
    self.dattaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.dattaBtn.frame = CGRectMake(LBVIEW_WIDTH1 / 3+2, 0, LBVIEW_WIDTH1/3-1, LBVIEW_HEIGHT1 / 15);
    self.dattaBtn.tag=2;
    [self.dattaBtn addTarget:self action:@selector(lookRedBagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.dattaBtn];
    
    self.mouBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.mouBtn setTitle:@"已过期" forState:UIControlStateNormal];
    [self.mouBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.mouBtn.backgroundColor = [UIColor whiteColor];
    self.mouBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.mouBtn.frame = CGRectMake(2*LBVIEW_WIDTH1/3+3, 0, LBVIEW_WIDTH1 / 3-1, LBVIEW_HEIGHT1 / 15);
    self.mouBtn.tag=3;
    [self.mouBtn addTarget:self action:@selector(lookRedBagBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.mouBtn];
    
    
    self.flowerTV = [[UITableView alloc] initWithFrame:CGRectMake(0,self.topView.frame.size.height, LBVIEW_WIDTH1, LBVIEW_HEIGHT1-self.topView.frame.size.height-64) style:UITableViewStylePlain];
    self.flowerTV.delegate = self;
    self.flowerTV.dataSource = self;
    self.flowerTV.backgroundColor =[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    _flowerTV.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.flowerTV];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (LBVIEW_WIDTH1-40)/5.6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*dic=_dataArray[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
   // cell.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIImageView*redPageImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 3, LBVIEW_WIDTH1-40, (LBVIEW_WIDTH1-40)/5.6-6)];
        redPageImage.image=[UIImage imageNamed:@"hongbao_bg.png"];
        [cell addSubview:redPageImage];
        
        
        UILabel*timeEndLabel=[[UILabel alloc]initWithFrame:CGRectMake(redPageImage.frame.size.width/11, redPageImage.frame.size.height-25, redPageImage.frame.size.width/3, 20)];
        NSString*strTime=dic[@"end_time"];
        NSInteger intTime=[strTime integerValue];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:intTime];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString*strtt=[formatter stringFromDate:confromTimesp];
     
        timeEndLabel.text=[NSString stringWithFormat:@"有效期到:%@",strtt];
        timeEndLabel.font=[UIFont systemFontOfSize:12];
        timeEndLabel.textColor=[UIColor grayColor];
        [cell addSubview:timeEndLabel];
        
        UILabel*valueLabel=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-20-redPageImage.frame.size.width/3, redPageImage.frame.size.height-25-30, redPageImage.frame.size.width/3, 30)];
        valueLabel.text=[NSString stringWithFormat:@"¥ %@",dic[@"price"]];
        valueLabel.textColor=[UIColor whiteColor];
        valueLabel.textAlignment=NSTextAlignmentCenter;
        valueLabel.font=[UIFont systemFontOfSize:19];
        [cell addSubview:valueLabel];
        
        UILabel*fullLabel=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1-20-redPageImage.frame.size.width/3, redPageImage.frame.size.height-25, redPageImage.frame.size.width/3, 20)];
        fullLabel.text=[NSString stringWithFormat:@"满%@元使用",dic[@"term_price"]];
        fullLabel.textColor=[UIColor whiteColor];
        fullLabel.textAlignment=NSTextAlignmentCenter;
        fullLabel.font=[UIFont systemFontOfSize:12];
        [cell addSubview:fullLabel];
        
    }
    
    return cell;
}

//查看红包
-(void)lookRedBagBtn:(UIButton*)sender
{
    NSString*str=[NSString stringWithFormat:@"%ld",sender.tag];
    [HttpEngine getRedBagStatus:str completion:^(NSArray *dataArray)
     {
         _dataArray=dataArray;
         [self.flowerTV reloadData];
     }];

}


@end
