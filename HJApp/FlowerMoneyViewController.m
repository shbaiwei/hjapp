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
    [HttpEngine getRedBagStatus:@"1" completion:^(NSArray *dataArray)
     {
         _dataArray=dataArray;
         [self.flowerTV reloadData];
     }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"花券";
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, + self.navigationController.navigationBar.frame.size.height + 20, LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 15)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    
    self.madaBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.madaBtn setTitle:@"未使用↓" forState:UIControlStateNormal];
    [self.madaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //  self.madaBtn.backgroundColor = [UIColor grayColor];
    self.madaBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.madaBtn.alpha = 0.6;
    self.madaBtn.frame = CGRectMake(0, 0, LBVIEW_WIDTH1 / 3, LBVIEW_HEIGHT1 / 15);
    [self.madaBtn addTarget:self action:@selector(lookRedBagBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.madaBtn];
    
    self.dattaBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.dattaBtn setTitle:@"已使用↓" forState:UIControlStateNormal];
    [self.dattaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //  self.dattaBtn.backgroundColor = [UIColor greenColor];
    self.dattaBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.dattaBtn.alpha = 0.6;
    self.dattaBtn.frame = CGRectMake(+ self.madaBtn.frame.size.width, 0, LBVIEW_HEIGHT1 / 5, LBVIEW_HEIGHT1 / 15);
    [self.topView addSubview:self.dattaBtn];
    
    self.mouBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.mouBtn setTitle:@"已过期↓" forState:UIControlStateNormal];
    [self.mouBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // self.mouBtn.backgroundColor = [UIColor blueColor];
    self.mouBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.mouBtn.alpha = 0.6;
    self.mouBtn.frame = CGRectMake(+ self.madaBtn.frame.size.width + self.dattaBtn.frame.size.width, 0, LBVIEW_WIDTH1 / 3, LBVIEW_HEIGHT1 / 15);
    [self.topView addSubview:self.mouBtn];
    
    
    self.flowerTV = [[UITableView alloc] initWithFrame:CGRectMake(0, + self.navigationController.navigationBar.frame.size.height + self.topView.frame.size.height + 20, LBVIEW_WIDTH1, LBVIEW_HEIGHT1) style:UITableViewStylePlain];
    self.flowerTV.delegate = self;
    self.flowerTV.dataSource = self;
    self.flowerTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.flowerTV];
    
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"reuse";
    
    FlowerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[FlowerTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        
    }
    
    return cell;
}

-(void)lookRedBagBtn
{
    

}


@end
