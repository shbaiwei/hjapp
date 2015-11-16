//
//  HomePageViewController.m
//  HJApp
//
//  Created by Bruce He on 15/10/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "HomePageViewController.h"
#import "HttpEngine.h"
#import "UIImageView+WebCache.h"
#import "IdeaBackViewController.h"
#import "CooperateViewController.h"
#import "AssortPageViewController.h"
#import "ChangCityViewController.h"

@interface HomePageViewController ()<UIScrollViewDelegate>

{
    int _count;
    
}
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIImageView *mapImageView;

@property (nonatomic, strong) UIButton *downButton;
@property (nonatomic, strong) UIButton *twoNButton;


@property (nonatomic, strong) UIScrollView *scrollPic;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIView *flowerView;
@property (nonatomic, strong) UIButton *roseButton;
@property (nonatomic, strong) UIButton *baiheButton;
@property (nonatomic, strong) UIButton *KNXButton;
@property (nonatomic, strong) UIButton *DTJButton;
@property (nonatomic, strong) UIButton *huacaoButton;
@property (nonatomic, strong) UIButton *baoButton;
@property (nonatomic, strong) UIButton *yshButton;
@property (nonatomic, strong) UIButton *jkhButton;

@property (nonatomic, strong) UILabel *roseLabel;
@property (nonatomic, strong) UILabel *baiheLbael;
@property (nonatomic, strong) UILabel *knxLabel;
@property (nonatomic, strong) UILabel *dtjLabel;
@property (nonatomic, strong) UILabel *huacaoLabel;
@property (nonatomic, strong) UILabel *baoLabel;
@property (nonatomic, strong) UILabel *yshLabel;
@property (nonatomic, strong) UILabel *jkhLabel;


@property (nonatomic, strong) UIView *oneMoneyView;
@property (nonatomic, strong) UIImageView *todayMoneyImageView;
@property (nonatomic, strong) UILabel *textLabel;   //上下信息滚动处  待定修改
@property (nonatomic, strong) UIImageView *oneMoneyImageView;
@property (nonatomic, strong) UIButton *ikenButton;
@property (nonatomic, strong) UIButton *bessButton;
@property (nonatomic, strong) UIScrollView *mainScroll;

//////////////
@property(nonatomic,strong)NSArray*picDataArray;
@property(nonatomic,strong)NSArray*cityNameArray;




@end

@implementation HomePageViewController
//宏定义宽高
#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    [self hidesTabBar:NO];
    self.cityLabel.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"CITYNAME"];
    //NSLog(@"沙河路径=====%@",NSHomeDirectory());
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"首页";
    
    [HttpEngine getCityNameBackcompletion:^(NSArray *dataArray)
     {
         
         _cityNameArray=dataArray;
         //显示顶部视图
         [self theTopView];
         
         
     }];
    
    //主scrollView
    [self ScrollViewMain];
    
    //滑动轮播图部分
    [HttpEngine getPicture:^(NSArray *dataArray)
     {
         
         
         _picDataArray=dataArray;
         [self scrollViewAndPageControl];
         
         
         [self theFlowersButtons];
         [self theTodayFlowes];
         [self theOneMoney];
         [self theIkenAndBess];
     }];
    
    
}

//显示顶部视图
- (void)theTopView
{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 11.5)];
    
    self.topView.backgroundColor = [UIColor colorWithRed:0.23 green:0.67 blue:0.89 alpha:1];
    [self.view addSubview:self.topView];
    
    self.mapImageView = [[UIImageView alloc] init];
    self.mapImageView.image = [UIImage imageNamed:@"spqd_1.png"];
    self.mapImageView.frame = CGRectMake(VIEW_WIDTH * 0.035, VIEW_HEIGHT * 0.043, VIEW_WIDTH * 0.042, VIEW_HEIGHT * 0.035);
    [self.topView addSubview:self.mapImageView];
    
    self.cityLabel = [[UILabel alloc] init];
    self.cityLabel.frame = CGRectMake(VIEW_WIDTH * 0.085, VIEW_HEIGHT * 0.042, VIEW_WIDTH * 0.21, VIEW_HEIGHT * 0.035);
    
    NSDictionary*dic=_cityNameArray[0];
    
    NSString*cityName=[[NSUserDefaults standardUserDefaults]objectForKey:@"CITYNAME"];
    if (cityName==NULL)
    {
       //NSLog(@"上海笑");
       [[NSUserDefaults standardUserDefaults]setObject:dic[@"name"] forKey:@"CITYNAME"];
        self.cityLabel.text = dic[@"name"];
    }
    
    else
    {
    self.cityLabel.text = cityName;
    }
    self.cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    self.cityLabel.font = [UIFont systemFontOfSize:18];
    self.cityLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.topView addSubview:self.cityLabel];
    
    self.downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.downButton.frame = CGRectMake(self.cityLabel.frame.size.width + 2, VIEW_HEIGHT * 0.053, VIEW_WIDTH * 0.052, VIEW_HEIGHT * 0.015);
    UIImage *downImage = [UIImage imageNamed:@"swiper-market-btn-b.png"];
    downImage = [downImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.downButton setImage:downImage forState:UIControlStateNormal];
    [self.downButton addTarget:self action:@selector(changeCityBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.downButton];
    
    //    self.twoNButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    self.twoNButton.frame = CGRectMake(VIEW_WIDTH * 0.87, VIEW_HEIGHT * 0.037, VIEW_WIDTH * 0.086, VIEW_HEIGHT * 0.043);
    //    UIImage *twoNum = [UIImage imageNamed:@"twoN.png"];
    //    twoNum = [twoNum imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    [self.twoNButton setImage:twoNum forState:UIControlStateNormal];
    //    [self.topView addSubview:self.twoNButton];
    
}
//城市切换按钮
-(void)changeCityBtn
{
    ChangCityViewController*changVC=[[ChangCityViewController alloc]init];
    [self.navigationController pushViewController:changVC animated:YES];
    
}

//页面上下滑动
-(void)ScrollViewMain
{
    //因为要让他滑动所以要把所有东西放在scrollView上
    self.mainScroll = [[UIScrollView alloc] init];
    self.mainScroll.bounces=NO;
    self.mainScroll.frame = CGRectMake(0, LBVIEW_HEIGHT1 / 11.5-20, LBVIEW_WIDTH1, LBVIEW_HEIGHT1);
    self.mainScroll.contentSize = CGSizeMake(VIEW_WIDTH, LBVIEW_HEIGHT1-LBVIEW_HEIGHT1 / 11.5+LBVIEW_HEIGHT1*0.15);
    [self.view addSubview:self.mainScroll];
}

//滑动轮播图部分

- (void)scrollViewAndPageControl
{
    self.scrollPic = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 4.5)];
    self.scrollPic.contentSize = CGSizeMake(LBVIEW_WIDTH1 * (_picDataArray.count-2),LBVIEW_HEIGHT1/4.5);
    self.scrollPic.pagingEnabled = YES;
    self.scrollPic.delegate = self;
    self.scrollPic.bounces=NO;
    self.scrollPic.showsVerticalScrollIndicator = FALSE;
    self.scrollPic.showsHorizontalScrollIndicator = FALSE;
    [self.mainScroll addSubview:self.scrollPic];
    //使用for循环创建imageView
    for (NSInteger i = 2; i < _picDataArray.count; i++)
    {
        UIImageView *scrollImage = [[UIImageView alloc] initWithFrame:CGRectMake(0+LBVIEW_WIDTH1*(i-2), 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 4.5)];
        [self.scrollPic addSubview:scrollImage];
        GetPic*getpic=_picDataArray[i];
        NSURL*urlStr=[NSURL URLWithString:getpic.pictureUrlStr];
        [scrollImage sd_setImageWithURL:urlStr];
        
    }
    //pageControl
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.scrollPic.frame.size.width / 2.1,self.scrollPic.frame.size.height*0.8, VIEW_WIDTH * 0.05, VIEW_HEIGHT * 0.03)];
    self.pageControl.numberOfPages = _picDataArray.count-2;
    self.pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor=[UIColor grayColor];
    [self.pageControl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    [self.mainScroll addSubview:self.pageControl];
    
    //修改
    //定时器
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(animotion) userInfo:nil repeats:YES];
}
-(void)animotion
{
    _count++;
    
    if (_count>_picDataArray.count-3)
    {
        _count=0;
    }
    [self.scrollPic setContentOffset:CGPointMake(_count*LBVIEW_WIDTH1, 0)  animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger number =scrollView.contentOffset.x  / LBVIEW_WIDTH1;
    self.pageControl.currentPage = number;
}

- (void)pageAction:(UIPageControl *)pageCon
{
    [self.scrollPic setContentOffset:CGPointMake(LBVIEW_WIDTH1 * pageCon.currentPage, 0) animated:YES];
}


//鲜花按钮部分
- (void)theFlowersButtons
{
    self.flowerView = [[UIView alloc] init];
    self.flowerView.frame = CGRectMake(0,LBVIEW_HEIGHT1/4.5, LBVIEW_WIDTH1, LBVIEW_WIDTH1 / 2);
    self.flowerView.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.flowerView];
    
    self.roseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *roseImage = [UIImage imageNamed:@"index_meigui.png"];
    roseImage = [roseImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.roseButton.contentMode = UIViewContentModeScaleAspectFill;
    self.roseButton.frame = CGRectMake(VIEW_WIDTH * 0.05, VIEW_HEIGHT * 0.02, VIEW_HEIGHT * 0.085, VIEW_HEIGHT * 0.085);
    [self.roseButton setImage:roseImage forState:UIControlStateNormal];
    self.roseButton.layer.cornerRadius = 10;
    self.roseButton.clipsToBounds = YES;
    self.roseButton.tag=1;
    [_roseButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.flowerView addSubview:self.roseButton];
    
    self.baiheButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *baiheImage = [UIImage imageNamed:@"index_baihe.png"];
    baiheImage = [baiheImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.baiheButton.contentMode = UIViewContentModeScaleAspectFill;
    self.baiheButton.frame = CGRectMake(self.roseButton.frame.size.width * 1.9, VIEW_HEIGHT * 0.02, VIEW_HEIGHT * 0.085, VIEW_HEIGHT * 0.085);
    //    self.baiheButton.frame = CGRectMake(VIEW_WIDTH * 0.3, VIEW_HEIGHT * 0.02, VIEW_HEIGHT * 0.085, VIEW_HEIGHT * 0.085);
    [self.baiheButton setImage:baiheImage forState:UIControlStateNormal];
    self.baiheButton.layer.cornerRadius = 20;
    self.baiheButton.clipsToBounds = YES;
    self.baiheButton.tag=2;
    [_baiheButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.flowerView addSubview:self.baiheButton];
    
    
    self.KNXButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *knxImage = [UIImage imageNamed:@"index_kangnaixing.png"];
    knxImage = [knxImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.KNXButton.contentMode = UIViewContentModeScaleAspectFill;
    self.KNXButton.frame = CGRectMake(self.roseButton.frame.size.width * 3.6, VIEW_HEIGHT * 0.02, VIEW_HEIGHT * 0.085, VIEW_HEIGHT * 0.085);
    //    self.KNXButton.frame = CGRectMake(VIEW_WIDTH * 0.55, VIEW_HEIGHT * 0.02, VIEW_HEIGHT * 0.085, VIEW_HEIGHT * 0.085);
    [self.KNXButton setImage:knxImage forState:UIControlStateNormal];
    self.KNXButton.layer.cornerRadius = 20;
    self.KNXButton.clipsToBounds = YES;
    self.KNXButton.tag=3;
    [_KNXButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.flowerView addSubview:self.KNXButton];
    
    
    self.DTJButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *dtjImage = [UIImage imageNamed:@"index_duotouju.png"];
    dtjImage = [dtjImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.DTJButton.contentMode = UIViewContentModeScaleAspectFill;
    self.DTJButton.frame = CGRectMake(self.roseButton.frame.size.width * 5.3, VIEW_HEIGHT * 0.02, VIEW_HEIGHT * 0.085, VIEW_HEIGHT * 0.085);
    //    self.DTJButton.frame = CGRectMake(VIEW_WIDTH * 0.81, VIEW_HEIGHT * 0.02, VIEW_HEIGHT * 0.085, VIEW_HEIGHT * 0.085);
    [self.DTJButton setImage:dtjImage forState:UIControlStateNormal];
    self.DTJButton.layer.cornerRadius = 20;
    self.DTJButton.clipsToBounds = YES;
    self.DTJButton.tag=4;
    [_DTJButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.flowerView addSubview:self.DTJButton];
    
    
    self.huacaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *huacaoImage = [UIImage imageNamed:@"index_peihuapeicao.png"];
    huacaoImage = [huacaoImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.huacaoButton.contentMode = UIViewContentModeScaleAspectFill;
    self.huacaoButton.frame = CGRectMake(VIEW_WIDTH * 0.05, self.roseButton.frame.size.height * 1.75, VIEW_HEIGHT * 0.085, VIEW_HEIGHT * 0.085);
    [self.huacaoButton setImage:huacaoImage forState:UIControlStateNormal];
    self.huacaoButton.layer.cornerRadius = 20;
    self.huacaoButton.clipsToBounds = YES;
    self.huacaoButton.tag=5;
    [_huacaoButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.flowerView addSubview:self.huacaoButton];
    
    
    self.baoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *baoImage = [UIImage imageNamed:@"index_baozhuangzicai.png"];
    baoImage = [baoImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.baoButton.contentMode = UIViewContentModeScaleAspectFill;
    self.baoButton.frame = CGRectMake(self.huacaoButton.frame.size.width * 1.9, self.roseButton.frame.size.height * 1.75, VIEW_HEIGHT * 0.085, VIEW_HEIGHT * 0.085);
    //    self.baoButton.frame = CGRectMake(VIEW_WIDTH * 0.3, self.roseButton.frame.size.height * 1.75, VIEW_HEIGHT * 0.085, VIEW_HEIGHT * 0.085);
    [self.baoButton setImage:baoImage forState:UIControlStateNormal];
    self.baoButton.layer.cornerRadius = 20;
    self.baoButton.clipsToBounds = YES;
    self.baoButton.tag=6;
    [_baoButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.flowerView addSubview:self.baoButton];
    
    
    self.yshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *yshImage = [UIImage imageNamed:@"index_yongshenghua.png"];
    yshImage = [yshImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.yshButton.contentMode = UIViewContentModeScaleAspectFill;
    self.yshButton.frame = CGRectMake(self.huacaoButton.frame.size.width * 3.6, self.roseButton.frame.size.height * 1.75, VIEW_HEIGHT * 0.085, VIEW_HEIGHT * 0.085);
    //    self.yshButton.frame = CGRectMake(VIEW_WIDTH * 0.55, self.roseButton.frame.size.height * 1.75, VIEW_HEIGHT * 0.085, VIEW_HEIGHT * 0.085);
    [self.yshButton setImage:yshImage forState:UIControlStateNormal];
    self.yshButton.layer.cornerRadius = 20;
    self.yshButton.clipsToBounds = YES;
    self.yshButton.tag=7;
    [_yshButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.flowerView addSubview:self.yshButton];
    
    self.jkhButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *jkhImage = [UIImage imageNamed:@"index_jinkouhua.png"];
    jkhImage = [jkhImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.jkhButton.contentMode = UIViewContentModeScaleAspectFill;
    self.jkhButton.frame = CGRectMake(self.huacaoButton.frame.size.width * 5.3, self.roseButton.frame.size.height * 1.75, VIEW_HEIGHT * 0.085, VIEW_HEIGHT * 0.085);
    //    self.jkhButton.frame = CGRectMake(VIEW_WIDTH * 0.81, self.roseButton.frame.size.height * 1.75, VIEW_HEIGHT * 0.085, VIEW_HEIGHT * 0.085);
    [self.jkhButton setImage:jkhImage forState:UIControlStateNormal];
    self.jkhButton.layer.cornerRadius = 20;
    self.jkhButton.clipsToBounds = YES;
    self.jkhButton.tag=8;
    [_jkhButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.flowerView addSubview:self.jkhButton];
    //花名
    self.roseLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_WIDTH * 0.05, VIEW_HEIGHT * 0.105, VIEW_WIDTH * 0.15, VIEW_HEIGHT * 0.03)];
    self.roseLabel.text = @"玫瑰";
    self.roseLabel.textColor = [UIColor blackColor];
    self.roseLabel.font = [UIFont systemFontOfSize:14];
    self.roseLabel.textAlignment=NSTextAlignmentCenter;
    [self.flowerView addSubview:self.roseLabel];
    
    self.baiheLbael = [[UILabel alloc] initWithFrame:CGRectMake(self.roseLabel.frame.size.width * 1.9, VIEW_HEIGHT * 0.105, VIEW_WIDTH * 0.15, VIEW_HEIGHT * 0.03)];
    self.baiheLbael.text = @"百合";
    self.baiheLbael.textColor = [UIColor blackColor];
    self.baiheLbael.font = [UIFont systemFontOfSize:14];
    self.baiheLbael.textAlignment=NSTextAlignmentCenter;
    [self.flowerView addSubview:self.baiheLbael];
    
    self.knxLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.roseLabel.frame.size.width * 3.6, VIEW_HEIGHT * 0.105, VIEW_WIDTH * 0.15, VIEW_HEIGHT * 0.03)];
    self.knxLabel.text = @"康乃馨";
    self.knxLabel.textColor = [UIColor blackColor];
    self.knxLabel.font = [UIFont systemFontOfSize:14];
    self.knxLabel.textAlignment=NSTextAlignmentCenter;
    [self.flowerView addSubview:self.knxLabel];
    
    self.dtjLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.roseLabel.frame.size.width * 5.35, VIEW_HEIGHT * 0.105, VIEW_WIDTH * 0.15, VIEW_HEIGHT * 0.03)];
    self.dtjLabel.text = @"多头菊";
    self.dtjLabel.textColor = [UIColor blackColor];
    self.dtjLabel.font = [UIFont systemFontOfSize:14];
    self.dtjLabel.textAlignment=NSTextAlignmentCenter;
    [self.flowerView addSubview:self.dtjLabel];
    
    
    self.huacaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_WIDTH * 0.04, VIEW_HEIGHT * 0.235, VIEW_WIDTH * 0.19, VIEW_HEIGHT * 0.03)];
    self.huacaoLabel.text = @"配花配草";
    self.huacaoLabel.textColor = [UIColor blackColor];
    self.huacaoLabel.textAlignment=NSTextAlignmentCenter;
    self.huacaoLabel.font = [UIFont systemFontOfSize:14];
    [self.flowerView addSubview:self.huacaoLabel];
    
    self.baoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.roseLabel.frame.size.width * 1.8, VIEW_HEIGHT * 0.235, VIEW_WIDTH * 0.19, VIEW_HEIGHT * 0.03)];
    self.baoLabel.text = @"包装资材";
    self.baoLabel.textColor = [UIColor blackColor];
    self.baoLabel.textAlignment=NSTextAlignmentCenter;
    self.baoLabel.font = [UIFont systemFontOfSize:14];
    [self.flowerView addSubview:self.baoLabel];
    
    self.yshLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.roseLabel.frame.size.width * 3.5, VIEW_HEIGHT * 0.235, VIEW_WIDTH * 0.19, VIEW_HEIGHT * 0.03)];
    self.yshLabel.text = @"永生花";
    self.yshLabel.textColor = [UIColor blackColor];
    self.yshLabel.textAlignment=NSTextAlignmentCenter;
    self.yshLabel.font = [UIFont systemFontOfSize:14];
    [self.flowerView addSubview:self.yshLabel];
    
    self.jkhLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.roseLabel.frame.size.width * 5.2, VIEW_HEIGHT * 0.235, VIEW_WIDTH * 0.19, VIEW_HEIGHT * 0.03)];
    self.jkhLabel.text = @"进口花";
    self.jkhLabel.textColor = [UIColor blackColor];
    self.jkhLabel.textAlignment=NSTextAlignmentCenter;
    self.jkhLabel.font = [UIFont systemFontOfSize:14];
    [self.flowerView addSubview:self.jkhLabel];
    
}
-(void)btnClick:(UIButton*)sender
{
    AssortPageViewController*assortVC=[[AssortPageViewController alloc]init];
    assortVC.isTag=(int)sender.tag-1;
    [self.navigationController pushViewController:assortVC animated:YES];
    
}


//今日花市部分
- (void)theTodayFlowes{
    
    self.oneMoneyView = [[UIView alloc] initWithFrame:CGRectMake(0, LBVIEW_WIDTH1 / 2+ LBVIEW_HEIGHT1 / 4.5, LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 13)];
    
    self.oneMoneyView.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.oneMoneyView];
    
    self.todayMoneyImageView = [[UIImageView alloc] init];
    self.todayMoneyImageView.image = [UIImage imageNamed:@"toady-market.png"];
    self.todayMoneyImageView.frame = CGRectMake(10, VIEW_HEIGHT * 0.01, VIEW_WIDTH / 4, VIEW_HEIGHT * 0.042);
    [self.oneMoneyView addSubview:self.todayMoneyImageView];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.todayMoneyImageView.frame.size.width + 10, 7, LBVIEW_WIDTH1 / 1.6, VIEW_HEIGHT * 0.05)];
    self.textLabel.text = @"上海批发市场均价最近七天环比上升9.68%";
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.font = [UIFont systemFontOfSize:12];
    [self.oneMoneyView addSubview:self.textLabel];
    
}




//一元疯抢部分
-(void)theOneMoney {
    
    self.oneMoneyImageView = [[UIImageView alloc] init];
    GetPic*getpic=_picDataArray[1];
    NSURL*urlStr=[NSURL URLWithString:getpic.pictureUrlStr];
    [self.oneMoneyImageView sd_setImageWithURL:urlStr];
    self.oneMoneyImageView.frame = CGRectMake(0,LBVIEW_WIDTH1 / 2+ LBVIEW_HEIGHT1 / 4.5+LBVIEW_HEIGHT1/13, VIEW_WIDTH, VIEW_HEIGHT / 6);
    [self.mainScroll addSubview:self.oneMoneyImageView];
    
    
}



//意见反馈以及商务合作部分
- (void)theIkenAndBess {
    
    self.ikenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    UIImage *ikenImage = [UIImage imageNamed:@"other_service_1.png"];
//    ikenImage = [ikenImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [self.ikenButton setImage:ikenImage forState:UIControlStateNormal];
    [self.ikenButton setTitle:@"意见反馈" forState:UIControlStateNormal];
    self.ikenButton.frame = CGRectMake(0, LBVIEW_WIDTH1 / 2+ LBVIEW_HEIGHT1 / 4.5+LBVIEW_HEIGHT1/13+VIEW_HEIGHT / 6, VIEW_WIDTH / 2, VIEW_HEIGHT * 0.07);
    self.ikenButton.backgroundColor = [UIColor whiteColor];
    [self.ikenButton addTarget:self action:@selector(ikenButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScroll addSubview:self.ikenButton];
    
    self.bessButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    UIImage *bessImage = [UIImage imageNamed:@"other_service_2.png"];
//    bessImage = [bessImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [self.bessButton setImage:bessImage forState:UIControlStateNormal];
    [self.bessButton setTitle:@"商务合作" forState:UIControlStateNormal];
    self.bessButton.frame = CGRectMake(self.ikenButton.frame.size.width + 1,  LBVIEW_WIDTH1 / 2+ LBVIEW_HEIGHT1 / 4.5+LBVIEW_HEIGHT1/13+VIEW_HEIGHT / 6, VIEW_WIDTH / 2, VIEW_HEIGHT * 0.07);
    self.bessButton.backgroundColor = [UIColor whiteColor];
    [self.bessButton addTarget:self action:@selector(bessButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScroll addSubview:self.bessButton];
    
    
}
-(void)ikenButton:(UIButton*)sender
{
    
    IdeaBackViewController*ideaVC=[[IdeaBackViewController alloc]init];
    [self.navigationController pushViewController:ideaVC animated:YES];
    
}
-(void)bessButton:(UIButton*)sender
{
    CooperateViewController*cooperateVC=[[CooperateViewController alloc]init];
    [self.navigationController pushViewController:cooperateVC animated:YES];
    
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