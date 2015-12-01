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
#import "ChangCityViewController.h"
#import "TodayShopViewController.h"
#import "LoginViewController.h"


@interface HomePageViewController ()<UIScrollViewDelegate>

{
    int _count;
    int _countT;
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
@property(nonatomic,strong)NSArray*notifitionArray;
@property (nonatomic, strong) UIScrollView*notifitionScroll;



@end

@implementation HomePageViewController
//宏定义宽高
#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

NSInteger homePicNumber=0;
NSInteger timeGap;
NSTimer *promotionTimer;
UIButton *promotionBtn;
UILabel *hourLabel;
UILabel *minuteLabel;
UILabel *secondLabel;

-(void)viewWillAppear:(BOOL)animated
{
  
    self.navigationController.navigationBarHidden=YES;
    self.cityLabel.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"CITYNAME"];
    //NSLog(@"沙盒路径=====%@",NSHomeDirectory());
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title=@"首页";
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.manager.distanceFilter = 5.0f;
    
    if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.manager requestWhenInUseAuthorization];
        
    }
    if([CLLocationManager locationServicesEnabled]){
        [self.manager startUpdatingLocation];
    }else{
        NSLog(@"Please enable location service.");
    }
    
    
    
    /*[HttpEngine getCityNameBackcompletion:^(NSArray *dataArray)
     {
         _cityNameArray=dataArray;
         //显示顶部视图
         [self theTopView];
         
     }];
     */
    
    NSString*login=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    if (login )
    {
        [HttpEngine getSimpleCart:^(NSArray *array) {
            
            NSInteger number = 0;
            for (NSInteger i=0; i<array.count; i++) {
                ShopingCar*shCa=array[i];
                number += [shCa.number integerValue];
            }
            if(number>0){
                [self updateCartCount:[NSString stringWithFormat:@"%ld",number]];
            }
        }];
    }
    
    //主scrollView
    [self ScrollViewMain];
    
    
    
    //滑动轮播图部分
    [HttpEngine getPicture:^(NSArray *dataArray)
     {
         [self theTopView];
         _picDataArray=dataArray;
         //NSLog(@"pic  ===  %@",_picDataArray);
         [self scrollViewAndPageControl];
         
         
         [self theFlowersButtons];
         [self theTodayFlowes];
         [self theOneMoney];
         [self theIkenAndBess];
     }];
    
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *newLocation = [locations lastObject];
    CLLocation *oldLocation;
    if (locations.count > 1)
    {
        oldLocation = [locations objectAtIndex:locations.count-2];
    }
    else
    {
        oldLocation = nil;
    }
    NSLog(@"didUpdateToLocation %@ from %@", newLocation, oldLocation);
    
    NSString*cityName=[[NSUserDefaults standardUserDefaults]objectForKey:@"CITYNAME"];
    if(cityName != nil){
        [self.manager stopUpdatingLocation];
        return;
    }
    
    //获取城市定位
    NSString *lat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    [HttpEngine convertCityName:lat withLng:lng complete:^(NSDictionary *dataDic) {
        NSLog(@"%@",dataDic);

        [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"code"] forKey:@"CODE"];
        [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"name"] forKey:@"CITYNAME"];
        [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"allowed_regions"] forKey:@"ALLOWED_REGIONS"];
        [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"allowed_regions_name"] forKey:@"ALLOWED_REGIONS_NAME"];
        self.cityLabel.text = dataDic[@"name"];
    
    } failure:^(NSError *error) {
        [self changeCityBtn];
    }];
    
    
    // 停止位置更新
    [self.manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

//显示顶部视图
- (void)theTopView
{
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 11)];
    
    self.topView.backgroundColor = [UIColor colorWithRed:0.23 green:0.67 blue:0.89 alpha:1];
    [self.view addSubview:self.topView];
    
    self.mapImageView = [[UIImageView alloc] init];
    self.mapImageView.image = [UIImage imageNamed:@"Map.png"];
    self.mapImageView.frame = CGRectMake(VIEW_WIDTH * 0.035, VIEW_HEIGHT * 0.044, 15, 20);
    [self.topView addSubview:self.mapImageView];
    
    self.cityLabel = [[UILabel alloc] init];
    self.cityLabel.frame = CGRectMake(VIEW_WIDTH * 0.085, VIEW_HEIGHT * 0.042, VIEW_WIDTH * 0.21, VIEW_HEIGHT * 0.035);
    
    //[self.cityLabel setFont:NJTextFont];
    
    
    NSString*cityName=[[NSUserDefaults standardUserDefaults]objectForKey:@"CITYNAME"];
    if (cityName!=NULL)
    {
        self.cityLabel.text = cityName;
    }
    else
        self.cityLabel.text = @"获取中";
    
    self.cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    //self.cityLabel.font = [UIFont systemFontOfSize:14];
    self.cityLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.topView addSubview:self.cityLabel];
    
    self.downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.downButton.frame = CGRectMake(5, VIEW_HEIGHT * 0.053, 80, 30);
    UIImage *downImage = [UIImage imageNamed:@"swiper-market-btn-b.png"];
    downImage = [downImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.downButton setImage:downImage forState:UIControlStateNormal];
    [self.downButton setContentEdgeInsets:UIEdgeInsetsMake(0, 65, 22, 0)];
    
    [self.downButton addTarget:self action:@selector(changeCityBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.downButton];
    
}
//城市切换按钮
-(void)changeCityBtn
{
    ChangCityViewController*changVC=[[ChangCityViewController alloc]init];
    changVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changVC animated:YES];
    
}

//页面上下滑动
-(void)ScrollViewMain
{
    //因为要让他滑动所以要把所有东西放在scrollView上
    self.mainScroll = [[UIScrollView alloc] init];
    self.mainScroll.bounces=NO;
    self.mainScroll.frame = CGRectMake(0, LBVIEW_HEIGHT1 / 11.5-20, LBVIEW_WIDTH1, LBVIEW_HEIGHT1);
    self.mainScroll.contentSize = CGSizeMake(VIEW_WIDTH, LBVIEW_HEIGHT1-30);
    [self.view addSubview:self.mainScroll];
}

//滑动轮播图部分

- (void)scrollViewAndPageControl
{
    
    homePicNumber=0;
    for (NSInteger i = 0; i < _picDataArray.count; i++)
    {
        GetPic*getpic=_picDataArray[i];
        if(![getpic.position isEqualToString: @"home"]) continue;
        homePicNumber++;
    }
    
    self.scrollPic = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 4.5)];
    self.scrollPic.contentSize = CGSizeMake(LBVIEW_WIDTH1 * (homePicNumber-1),LBVIEW_HEIGHT1/4.5);
    self.scrollPic.pagingEnabled = YES;
    self.scrollPic.delegate = self;
    self.scrollPic.bounces=NO;
    self.scrollPic.showsVerticalScrollIndicator = FALSE;
    self.scrollPic.showsHorizontalScrollIndicator = FALSE;
    [self.mainScroll addSubview:self.scrollPic];
    //使用for循环创建imageView
    NSInteger j=0;
    for (NSInteger i = 0; i < _picDataArray.count; i++)
    {
        GetPic*getpic=_picDataArray[i];
        if(![getpic.position isEqualToString: @"home"]) continue;
        
        UIImageView *scrollImage = [[UIImageView alloc] initWithFrame:CGRectMake(0+LBVIEW_WIDTH1*j, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 4.5)];
        [self.scrollPic addSubview:scrollImage];
        
        NSURL*urlStr=[NSURL URLWithString:getpic.pictureUrlStr];
        [scrollImage sd_setImageWithURL:urlStr];
        j++;

        
    }
    //pageControl
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(100,self.scrollPic.frame.size.height*0.8, VIEW_WIDTH-200, VIEW_HEIGHT * 0.03)];
    self.pageControl.numberOfPages = homePicNumber;
    self.pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor=[UIColor grayColor];
    [self.pageControl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    [self.mainScroll addSubview:self.pageControl];
    
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


- (UIButton*) createFlowerIcon:(NSString *)image category:(NSInteger) cid title:(NSString *) title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *newImage = [UIImage imageNamed: image];
    //newImage = [newImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font=NJNameFont;
    [button setTitleColor:NJFontColor forState:UIControlStateNormal];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.tag = cid;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, -20.0, 0.0)];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//鲜花按钮部分
- (void)theFlowersButtons
{
    self.flowerView = [[UIView alloc] init];
    self.flowerView.frame = CGRectMake(0,LBVIEW_HEIGHT1/4.5, LBVIEW_WIDTH1, LBVIEW_WIDTH1 / 2-2);
    self.flowerView.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.flowerView];
    
    CGFloat iconW = VIEW_WIDTH/15 * 2;
    CGFloat firstColumnsY = VIEW_HEIGHT * 0.02;
    CGFloat secondColumnsY = iconW + 25 + firstColumnsY * 2;
    
    self.roseButton = [self createFlowerIcon:@"index_meigui" category:1 title:@"玫瑰"];
    self.roseButton.frame = CGRectMake(VIEW_WIDTH/13, firstColumnsY, iconW, iconW);
    [self.flowerView addSubview:self.roseButton];
    
    self.baiheButton = [self createFlowerIcon:@"index_baihe" category:5 title:@"百合"];
    self.baiheButton.frame = CGRectMake(4*VIEW_WIDTH/13, firstColumnsY, iconW, iconW);
    [self.flowerView addSubview:self.baiheButton];
    
    
    self.KNXButton = [self createFlowerIcon:@"index_kangnaixing" category:6 title:@"康乃馨"];
    self.KNXButton.frame = CGRectMake(7*LBVIEW_WIDTH1/13, firstColumnsY,  iconW,iconW);
    [self.flowerView addSubview:self.KNXButton];
    
    
    self.DTJButton = [self createFlowerIcon:@"index_duotouju" category:7 title:@"多头菊"];
    self.DTJButton.frame = CGRectMake(10*LBVIEW_WIDTH1/13, firstColumnsY,  iconW, iconW);
    [self.flowerView addSubview:self.DTJButton];
    
    
    self.huacaoButton = [self createFlowerIcon:@"index_peihuapeicao" category:8 title:@"配花配草"];
    self.huacaoButton.frame = CGRectMake(VIEW_WIDTH/13, secondColumnsY, iconW,iconW);
    [self.flowerView addSubview:self.huacaoButton];
    
    
    self.baoButton = [self createFlowerIcon:@"index_baozhuangzicai" category:9 title:@"包装资材"];
    self.baoButton.frame = CGRectMake(4*VIEW_WIDTH/13, secondColumnsY, iconW,  iconW);
    [self.flowerView addSubview:self.baoButton];
    
    self.yshButton = [self createFlowerIcon:@"index_yongshenghua" category:10 title:@"永生花"];
    self.yshButton.frame = CGRectMake(7*VIEW_WIDTH/13, secondColumnsY,  iconW,iconW);
    [self.flowerView addSubview:self.yshButton];
    
    self.jkhButton = [self createFlowerIcon:@"index_jinkouhua" category:11 title:@"进口花"];
    
    self.jkhButton.frame = CGRectMake(10*VIEW_WIDTH/13, secondColumnsY, iconW,iconW);
    [self.flowerView addSubview:self.jkhButton];

    
}
-(void)btnClick:(UIButton*)sender
{
    
    //判断是否需要登陆
    NSString*str=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    if (str==NULL )
    {
        LoginViewController*loginVC=[[LoginViewController alloc]init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:navigationController animated:YES completion:^{
            
        }];
        return;
    }
    
     NSString*isTag=[NSString stringWithFormat:@"%lu",sender.tag];
    
    [[NSUserDefaults standardUserDefaults]setObject:isTag forKey:@"TWOTAG"];
    
     self.tabBarVC.selectedIndex=1;
}


//今日花市部分
- (void)theTodayFlowes{
    
    self.oneMoneyView = [[UIView alloc] initWithFrame:CGRectMake(0, LBVIEW_WIDTH1 / 2+ LBVIEW_HEIGHT1 / 4.5, LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 13)];
    
    self.oneMoneyView.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.oneMoneyView];
    
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, (LBVIEW_HEIGHT1 / 13- LBVIEW_HEIGHT1 / 15)/2, VIEW_WIDTH / 4, LBVIEW_HEIGHT1 / 15)];
    label.text=@"花集公告";
    label.textColor=[UIColor colorWithRed:37/255.0 green:119/255.0 blue:188/255.0 alpha:1];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:14];
    
    [self.oneMoneyView addSubview:label];
    
    UILabel*lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+VIEW_WIDTH / 4-1,(LBVIEW_HEIGHT1 / 13- LBVIEW_HEIGHT1 / 20)/2, 1, LBVIEW_HEIGHT1 / 20)];
    lineLabel.backgroundColor=[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    [self.oneMoneyView addSubview:lineLabel];
    
    [HttpEngine getNotifition:^(NSArray *dataArray)
    {
        _notifitionArray=dataArray;
        [self todayShop];
    }];
    
}
//今日花市
-(void)todayShop
{
    _notifitionScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(VIEW_WIDTH / 4 + 10, (LBVIEW_HEIGHT1 / 13- LBVIEW_HEIGHT1 / 15)/2, 3*VIEW_WIDTH/4-20, LBVIEW_HEIGHT1 / 15)];
    _notifitionScroll.contentSize=CGSizeMake(3*VIEW_WIDTH/4-10, LBVIEW_HEIGHT1 / 15*_notifitionArray.count);
    _notifitionScroll.showsHorizontalScrollIndicator=NO;
    _notifitionScroll.showsVerticalScrollIndicator=NO;
    _notifitionScroll.delegate=self;
    _notifitionScroll.bounces=NO;
    _notifitionScroll.pagingEnabled=YES;
    [self.oneMoneyView addSubview:_notifitionScroll];
    for (int i=0; i<_notifitionArray.count; i++)
    {
        HJNotifiton*hjn=_notifitionArray[i];
        UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0,i*LBVIEW_HEIGHT1 / 15, 3*VIEW_WIDTH/4-20,LBVIEW_HEIGHT1/15)];
        [btn setTitle:hjn.title forState:UIControlStateNormal];
        [btn setTitleColor:NJFontColor forState:UIControlStateNormal];
        [btn.titleLabel setFont:NJTitleFont];
        //[btn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        btn.tag=hjn.article_id.integerValue;
        [btn addTarget:self action:@selector(gotoNotifition:) forControlEvents:UIControlEventTouchUpInside];
        [_notifitionScroll addSubview:btn];
        
    }
    //定时器
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(animotion) userInfo:nil repeats:YES];
}

-(void)gotoNotifition:(UIButton*)sender
{
    TodayShopViewController*todayVC=[[TodayShopViewController alloc]init];
    todayVC.tag=(int)sender.tag;
    [self.navigationController pushViewController:todayVC animated:YES];
    
}


-(void)animotion
{
    //上面
    _count++;
    if (_count>homePicNumber-1)
    {
        _count=0;
    }
    [self.scrollPic setContentOffset:CGPointMake(_count*LBVIEW_WIDTH1, 0)  animated:YES];
    
    //下面
    _countT++;
    
    if (_countT>_notifitionArray.count-1)
    {
        _countT=0;
    }
    [self.notifitionScroll setContentOffset:CGPointMake(0,_countT*LBVIEW_HEIGHT1 / 15)  animated:YES];
}




//限时秒杀部分
-(void)theOneMoney
{
    
    UIView *oneMoneyView = [[UIView alloc] initWithFrame:CGRectMake(0,LBVIEW_WIDTH1 / 2+ LBVIEW_HEIGHT1 / 4.5+LBVIEW_HEIGHT1/13, VIEW_WIDTH, VIEW_HEIGHT / 6)];

    self.oneMoneyImageView = [[UIImageView alloc] initWithFrame:oneMoneyView.bounds];
    NSString *deadline = @"";
    for(NSInteger i=0;i<[_picDataArray count];i++){
        GetPic*getpic=_picDataArray[i];
        if([getpic.position isEqualToString:@"promotion"]){
            NSURL*urlStr=[NSURL URLWithString:getpic.pictureUrlStr];
            [self.oneMoneyImageView sd_setImageWithURL:urlStr];
            deadline=[getpic.deadline stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            break;
        }
    }
    [oneMoneyView addSubview:self.oneMoneyImageView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [formatter dateFromString:deadline];
    NSInteger timestamp = [datenow timeIntervalSince1970];
    timeGap = timestamp - [[NSDate date] timeIntervalSince1970];
    
    //timeGap = 9999;
    
    CGFloat hourX = VIEW_WIDTH * 0.6;
    CGFloat hourY = oneMoneyView.bounds.size.height / 2 - 20;
    CGFloat hourW = VIEW_WIDTH * 0.1;
    
    UIImageView *hourView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number-bg"]];
    hourView.frame = CGRectMake(hourX, hourY, hourW, hourW);
    [oneMoneyView addSubview:hourView];
    hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, hourW, hourW)];
    [hourLabel setTextAlignment:NSTextAlignmentCenter];
    [hourLabel setFont:[UIFont systemFontOfSize:14]];
    [hourView addSubview:hourLabel];
    
    CGFloat minuteX = hourX+hourW+15;
    CGFloat minuteY = hourY;
    CGFloat minuteW = hourW;
    
    UILabel *dotLabel = [[UILabel alloc] initWithFrame:CGRectMake(hourX+hourW, hourY+2, 15, 30)];
    [oneMoneyView addSubview:dotLabel];
    [dotLabel setTextAlignment:NSTextAlignmentCenter];
    [dotLabel setText:@":"];
    
    UIImageView *minuteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number-bg"]];
    minuteView.frame = CGRectMake(minuteX, minuteY, minuteW, minuteW);
    [oneMoneyView addSubview:minuteView];
    minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, minuteW, minuteW)];
    [minuteLabel setTextAlignment:NSTextAlignmentCenter];
    [minuteLabel setFont:[UIFont systemFontOfSize:14]];
    [minuteView addSubview:minuteLabel];
    
    CGFloat secondX = minuteX+minuteW+15;
    CGFloat secondY = minuteY;
    CGFloat secondW = hourW;
    
    UILabel *dot2Label = [[UILabel alloc] initWithFrame:CGRectMake(minuteX+minuteW, minuteY+2, 15, 30)];
    [oneMoneyView addSubview:dot2Label];
    [dot2Label setTextAlignment:NSTextAlignmentCenter];
    [dot2Label setText:@":"];
    
    UIImageView *secondView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number-bg"]];
    secondView.frame = CGRectMake(secondX, secondY, secondW, secondW);
    [oneMoneyView addSubview:secondView];
    secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, secondW, secondW)];
    [secondLabel setTextAlignment:NSTextAlignmentCenter];
    [secondLabel setFont:[UIFont systemFontOfSize:14]];
    [secondView addSubview:secondLabel];
    
    CGFloat promotionW = VIEW_WIDTH * 0.4;
    CGFloat promotionH = promotionW * 117/387;
    promotionBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - promotionW - 10, (oneMoneyView.bounds.size.height - promotionH)/2, promotionW, promotionH)];
    [promotionBtn setImage:[UIImage imageNamed:@"buy_btn"] forState:UIControlStateNormal];
    [oneMoneyView addSubview:promotionBtn];
    promotionBtn.tag = 19;
    [promotionBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [promotionBtn setHidden:YES];

    //加入倒计时
    promotionTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(promotionAnimation) userInfo:nil repeats:YES];
        

    
    [self.mainScroll addSubview:oneMoneyView];
    
}


-(void)promotionAnimation{
    
    if(timeGap>0){
        //NSLog(@"%ld",timeGap);
        
        int hour = (int)floor(timeGap / 3600);
        int minute = (int)floor((timeGap - hour * 3600) / 60);
        int second = (int)(timeGap - hour * 3600 - minute * 60);
        hour = MIN(hour, 99);
        [hourLabel setText:[NSString stringWithFormat:@"%@%d",hour>=10?@"":@"0",hour]];
        [minuteLabel setText:[NSString stringWithFormat:@"%@%d",minute>=10?@"":@"0",minute]];
        [secondLabel setText:[NSString stringWithFormat:@"%@%d",second>=10?@"":@"0",second]];
        timeGap--;
        return;
    }
    
    [promotionBtn setHidden:NO];
    promotionTimer = nil;
}


//意见反馈以及商务合作部分
- (void)theIkenAndBess
{
    
    NSArray*array=[[NSArray alloc]initWithObjects:@"意见反馈",@"商务合作", nil];
    for (int i=0; i<2;i++)
    {
        UIView*view=[[UIView alloc]initWithFrame:CGRectMake(i*(VIEW_WIDTH / 2+1), LBVIEW_WIDTH1 / 2+ LBVIEW_HEIGHT1 / 4.5+LBVIEW_HEIGHT1/13+VIEW_HEIGHT / 6+3, VIEW_WIDTH / 2-1, VIEW_HEIGHT * 0.08)];
        view.backgroundColor=[UIColor whiteColor];
        [self.mainScroll addSubview:view];

        
        UIImageView*image=[[UIImageView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/10, (view.frame.size.height-10)/2, 16, 16)];
        image.image=[UIImage imageNamed:[NSString stringWithFormat:@"other_service_%d.png",i+1]];
        [view addSubview:image];
        
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/10+i*LBVIEW_WIDTH1/2+30, LBVIEW_WIDTH1 / 2+ LBVIEW_HEIGHT1 / 4.5+LBVIEW_HEIGHT1/13+VIEW_HEIGHT / 6+10, VIEW_WIDTH / 4,VIEW_HEIGHT * 0.07)];
        label.text=array[i];
        [label setFont:NJTitleFont];
        [label setTextColor:NJFontColor];
        [self.mainScroll addSubview:label];
        
    }
    
    
    self.ikenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.ikenButton.frame = CGRectMake(0, LBVIEW_WIDTH1 / 2+ LBVIEW_HEIGHT1 / 4.5+LBVIEW_HEIGHT1/13+VIEW_HEIGHT / 6, VIEW_WIDTH / 2, VIEW_HEIGHT * 0.07);
    [self.ikenButton addTarget:self action:@selector(ikenButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScroll addSubview:self.ikenButton];
    
    self.bessButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.bessButton.frame = CGRectMake(self.ikenButton.frame.size.width + 1,  LBVIEW_WIDTH1 / 2+ LBVIEW_HEIGHT1 / 4.5+LBVIEW_HEIGHT1/13+VIEW_HEIGHT / 6, VIEW_WIDTH / 2, VIEW_HEIGHT * 0.07);
    [self.bessButton addTarget:self action:@selector(bessButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScroll addSubview:self.bessButton];
    
    
}
-(void)ikenButton:(UIButton*)sender
{
    IdeaBackViewController*ideaVC=[[IdeaBackViewController alloc]init];
    ideaVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ideaVC animated:YES];
    
}
-(void)bessButton:(UIButton*)sender
{
    CooperateViewController*cooperateVC=[[CooperateViewController alloc]init];
    cooperateVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cooperateVC animated:YES];
    
}

@end