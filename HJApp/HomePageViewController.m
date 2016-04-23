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
#import "GuessV.h"
#import "IkenV.h"


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
@property (nonatomic, strong) UIView *promotionView;
@property (nonatomic, strong) UILabel *textLabel;   //上下信息滚动处  待定修改
@property (nonatomic, strong) UIImageView *oneMoneyImageView;
@property (nonatomic, strong) UIScrollView *mainScroll;
@property(nonatomic,strong)NSArray*picDataArray;
@property(nonatomic,strong)NSArray*cityNameArray;
@property(nonatomic,strong)NSArray*notifitionArray;
@property (nonatomic, strong) UIScrollView*notifitionScroll;
@property(nonatomic,unsafe_unretained)BOOL changeCity;
@property (nonatomic,strong)NSArray *guessLikeArray;
@property (nonatomic,strong) UIView *guessYouView;
@property (nonatomic,strong) UIView *ideaView;

@end

@implementation HomePageViewController
//宏定义宽高
#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height
#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height
//UI.Height
#define scrollPicHeight [UIScreen mainScreen].bounds.size.height / 4.5
#define flowerViewHeight [UIScreen mainScreen].bounds.size.width / 2
#define todayShopHeight [UIScreen mainScreen].bounds.size.height / 13
#define guessViewHeight self.guessYouView.frame.size.height

NSInteger topViewHeight = 64;
NSInteger homePicNumber=0;
NSInteger timeGap;
BOOL showPromotion=YES;
NSTimer *promotionTimer;
UIButton *promotionBtn;
UILabel *hourLabel;
UILabel *minuteLabel;
UILabel *secondLabel;
CGSize main_size;
NSString *trackViewURL;

-(void)viewWillAppear:(BOOL)animated
{
   
    self.navigationController.navigationBarHidden=YES;
    self.cityLabel.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"CITYNAME"];
    

    //滑动轮播图部分
    [HttpEngine getPictureWithTime:@"YES" with:^(NSArray *dataArray)
     {
         _picDataArray=dataArray;
         
         [self refreshAdData];
     }];
    

}

-(void)checkVersion:(NSString* )appurl
{
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    [session POST:appurl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary* resultDic=responseObject;
        NSArray* infoArray = [resultDic objectForKey:@"results"];
        if (infoArray.count>0) {
            NSDictionary* releaseInfo =[infoArray objectAtIndex:0];
            NSString* appStoreVersion = [releaseInfo objectForKey:@"version"];
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            if ([appStoreVersion floatValue] > [currentVersion floatValue] )
            {
                trackViewURL = [[NSString alloc] initWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                NSString* msg =[releaseInfo objectForKey:@"releaseNotes"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"版本升级" message:[NSString stringWithFormat:@"%@%@%@", @"新版本特性:",msg, @"\n是否升级？"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"稍后升级" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *defaul = [UIAlertAction actionWithTitle:@"马上升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    UIApplication *application = [UIApplication sharedApplication];
                    [application openURL:[NSURL URLWithString:trackViewURL]];
                }];
                [alert addAction:cancel];
                [alert addAction:defaul];
                [self presentViewController:alert animated:YES completion:nil];
                
                //                UIAlertView* alertview =[[UIAlertView alloc] initWithTitle:@"版本升级" message:[NSString stringWithFormat:@"%@%@%@", @"新版本特性:",msg, @"\n是否升级？"] delegate:self cancelButtonTitle:@"稍后升级" otherButtonTitles:@"马上升级", nil];
                //                [alertview show];
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    main_size = rect.size;
    _count = 1;
    
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
    
    [HttpEngine getAdvertisement:^(NSArray *dataArray) {
        
    }];
    
    
    NSString*login=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    if (login )
    {
        [HttpEngine getSimpleCart:^(NSArray *array) {
            
            NSInteger number = 0;
            for (NSInteger i=0; i<array.count; i++) {
                ShopingCar*shCa=array[i];
                number += [shCa.number integerValue];
            }
            if(number>0)
            {
                [self updateCartCount:[NSString stringWithFormat:@"%ld",number]];
            }
        }];
    }
    

    NSString *strLocation = [[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    if (strLocation) {
        [self guessYouLikeData:strLocation];
    } else {
        [_guessYouView removeFromSuperview];
        _guessYouView.bounds =CGRectMake(0, 0, LBVIEW_WIDTH1, 0);
        _mainScroll.contentSize = CGSizeMake( LBVIEW_WIDTH1, scrollPicHeight+flowerViewHeight+todayShopHeight+LBVIEW_HEIGHT1/6+6+50+118);
        [self theIkenAndBess];
    }
    
    //主scrollView
    [self theTopView];
    [self ScrollViewMain];
    [self scrollViewAndPageControl];
    [self theFlowersButtons];
    [self theTodayFlowes];
    [self theOneMoney];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self checkVersion:@"http://itunes.apple.com/lookup?id=1063993741"];
    });
    
//    [HttpEngine getPictureWithTime:@"TIME" with:^(NSArray *dataArray)
//     {
//         _picTimeDataArray=dataArray;
//         
//     }];
    
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        //获取城市定位
        NSString *lat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
        NSString *lng = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
        [HttpEngine convertCityName:lat withLng:lng complete:^(NSDictionary *dataDic) {
            NSLog(@"%@",dataDic);
            
            [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"code"] forKey:@"CODE"];
            [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"name"] forKey:@"CITYNAME"];
            [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"allowed_regions"] forKey:@"ALLOWED_REGIONS"];
            [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"allowed_regions_name"] forKey:@"ALLOWED_REGIONS_NAME"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.cityLabel.text = dataDic[@"name"];
            });
            
            
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^
            {
                if (_changeCity==NO)
                {
                    [self changeCityBtn];
                    _changeCity=YES;
                }
                
                
            });
            
        }];

        
    });

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
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, main_size.width, topViewHeight)];
    
    self.topView.backgroundColor = [UIColor colorWithRed:0 green:171/255.0f blue:238/255.0f alpha:1];
    [self.view addSubview:self.topView];
    
    self.mapImageView = [[UIImageView alloc] init];
    self.mapImageView.image = [UIImage imageNamed:@"Map.png"];
    self.mapImageView.frame = CGRectMake(main_size.width * 0.035, 34, 15, 20);
    [self.topView addSubview:self.mapImageView];
    
    self.cityLabel = [[UILabel alloc] init];
    self.cityLabel.frame = CGRectMake(main_size.width * 0.085, 32, main_size.width * 0.21, 20);
    
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
    self.downButton.frame = CGRectMake(0, 38, 80, 30);
    UIImage *downImage = [UIImage imageNamed:@"swiper-market-btn-b.png"];
    downImage = [downImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.downButton setImage:downImage forState:UIControlStateNormal];
    [self.downButton setContentEdgeInsets:UIEdgeInsetsMake(0, 65, 22, 0)];
    //[self.downButton setBackgroundColor:[UIColor redColor]];
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
    self.mainScroll = [[UIScrollView alloc] init];
    self.mainScroll.bounces=NO;
    self.mainScroll.showsVerticalScrollIndicator = NO;
    self.mainScroll.frame = CGRectMake(0, topViewHeight, LBVIEW_WIDTH1, LBVIEW_HEIGHT1);
    self.mainScroll.contentSize = CGSizeMake(VIEW_WIDTH, scrollPicHeight+flowerViewHeight+todayShopHeight+LBVIEW_HEIGHT1/6+292+50+118);
    [self.view addSubview:self.mainScroll];
}

//滑动轮播图部分

- (void)scrollViewAndPageControl
{
    self.scrollPic = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, scrollPicHeight)];
    //self.scrollPic.contentSize = CGSizeMake(LBVIEW_WIDTH1 * (homePicNumber-1),LBVIEW_HEIGHT1/4.5);
    self.scrollPic.pagingEnabled = YES;
    self.scrollPic.delegate = self;
    self.scrollPic.bounces = NO;
    self.scrollPic.showsVerticalScrollIndicator = FALSE;
    self.scrollPic.showsHorizontalScrollIndicator = FALSE;
    [self.mainScroll addSubview:self.scrollPic];
    //使用for循环创建imageView
    /*NSInteger j=0;
    for (NSInteger i = 0; i < _picDataArray.count; i++)
    {
        GetPic*getpic=_picDataArray[i];
        if(![getpic.position isEqualToString: @"home"]) continue;
        
        UIImageView *scrollImage = [[UIImageView alloc] initWithFrame:CGRectMake(0+LBVIEW_WIDTH1*j, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 4.5)];
        [self.scrollPic addSubview:scrollImage];
        
        NSURL*urlStr=[NSURL URLWithString:getpic.pictureUrlStr];
        [scrollImage sd_setImageWithURL:urlStr];
        j++;

        
    }*/
    //pageControl
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(100,scrollPicHeight*0.8, main_size.width-200, main_size.height * 0.03)];
    //self.pageControl.numberOfPages = homePicNumber;
    self.pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor=[UIColor grayColor];
    [self.pageControl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
    [self.mainScroll addSubview:self.pageControl];
}

-(void)refreshAdData{
    
    homePicNumber=0;
    for (NSInteger i = 0; i < _picDataArray.count; i++)
    {
        GetPic*getpic=_picDataArray[i];
        if(![getpic.position isEqualToString: @"home"]) continue;
        homePicNumber++;
    }
    
    self.scrollPic.contentSize = CGSizeMake(LBVIEW_WIDTH1 * (homePicNumber-1),LBVIEW_HEIGHT1/4.5);
    
    NSInteger j=0;
    for (NSInteger i = 0; i < _picDataArray.count; i++)
    {
        GetPic*getpic=_picDataArray[i];
        if(![getpic.position isEqualToString: @"home"]) continue;
        
        UIImageView *scrollImage = [[UIImageView alloc] initWithFrame:CGRectMake(0+LBVIEW_WIDTH1*j, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1 / 4.5)];
        [self.scrollPic addSubview:scrollImage];
        
        NSURL*urlStr=[NSURL URLWithString:getpic.pictureUrlStr];
        [scrollImage sd_setImageWithURL:urlStr];
        
        scrollImage.userInteractionEnabled = YES;
        scrollImage.tag = 1;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adClick:)];
        [scrollImage addGestureRecognizer:singleTap];
        j++;
    }
    
    self.pageControl.numberOfPages = homePicNumber;
    
    
    NSString *deadline = @"";
    for(int i=0;i<_picDataArray.count;i++){
        GetPic*getpic=_picDataArray[i];
        if([getpic.position isEqualToString:@"promotion"]){
            NSURL*urlStr=[NSURL URLWithString:getpic.pictureUrlStr];
            [self.oneMoneyImageView sd_setImageWithURL:urlStr];
            deadline=[getpic.deadline stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            break;
        }
    }
    
    if([deadline isEqualToString:@""]){
        showPromotion=NO;
        
        //若没有秒杀 则隐藏
        [self.promotionView setHidden:YES];
        //上移猜你喜欢等VIEW
        [self guessYouLike];
        [self theIkenAndBess];
        promotionTimer = nil;
    }
    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [formatter dateFromString:deadline];
    NSInteger timestamp = [datenow timeIntervalSince1970];
    timeGap = timestamp - [[NSDate date] timeIntervalSince1970];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger number =scrollView.contentOffset.x  / main_size.width;
    self.pageControl.currentPage = number;
}
- (void)pageAction:(UIPageControl *)pageCon
{
    [self.scrollPic setContentOffset:CGPointMake(main_size.width * pageCon.currentPage, 0) animated:YES];
}


- (UIButton*) createFlowerIcon:(NSString *)image category:(NSInteger) cid title:(NSString *) title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    //image url = http://jinhuo.huaji.com/static/images/index-{image}.png
    
    //NSLog(@"nav icon: %@",[NSString stringWithFormat:@"http://jinhuo.huaji.com/static/images/index-%@.png",image]);
    NSURL*urlStr=[NSURL URLWithString:[NSString stringWithFormat:@"http://jinhuo.huaji.com/static/images/index-%@.png",image]];
    //[cell.leftImageV sd_setImageWithURL:urlStr];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:urlStr];
    UIImage *newImage = [UIImage imageWithData:imageData];
    //newImage = [newImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = NJNameFont;
    [button setTitleColor:NJFontColor forState:UIControlStateNormal];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.tag = cid;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -5.0, -20.0, -5.0)];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//鲜花按钮部分
- (void)theFlowersButtons
{
    self.flowerView = [[UIView alloc] init];
    self.flowerView.frame = CGRectMake(0,scrollPicHeight, LBVIEW_WIDTH1, flowerViewHeight);
    self.flowerView.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.flowerView];

    CGFloat iconW = main_size.width/15 * 2;
    CGFloat firstColumnsY = main_size.height * 0.02;
    CGFloat secondColumnsY = iconW + 20 + firstColumnsY * 2;
    
    [HttpEngine getHomeNav:^(NSArray *dataArray) {
        for (int i=0; i<[dataArray count]; i++) {
            NSString *icon = [dataArray[i] objectForKey:@"alias"];
            NSInteger category = [[dataArray[i] objectForKey:@"id"] integerValue];
            NSString *title = [dataArray[i] objectForKey:@"name"];
            UIButton *navButton = [self createFlowerIcon:icon category:category title:title];
            
            if(i < 4){
                NSInteger pos = i * 3 + 1 ;
                navButton.frame = CGRectMake(pos * main_size.width/13, firstColumnsY, iconW, iconW);
            }else{
                NSInteger pos = (i-4) * 3 + 1 ;
                navButton.frame = CGRectMake(pos * main_size.width/13, secondColumnsY, iconW, iconW);
            }
            [self.flowerView addSubview:navButton];
        }
    }];


    
}
-(void)btnClick:(UIButton*)sender
{
     NSString*isTag=[NSString stringWithFormat:@"%lu",sender.tag];
    [[NSUserDefaults standardUserDefaults]setObject:isTag forKey:@"TWOTAG"];
     self.tabBarVC.selectedIndex=1;
}

-(void)adClick:(id*)sender{
    NSString*isTag=@"1";
    [[NSUserDefaults standardUserDefaults]setObject:isTag forKey:@"TWOTAG"];
    self.tabBarVC.selectedIndex=1;
}

// VIEW_WIDTH/15 * 2+10+ 20 + VIEW_HEIGHT * 0.02 * 2;
//今日花市部分
- (void)theTodayFlowes{
    
    self.oneMoneyView = [[UIView alloc] initWithFrame:CGRectMake(0, scrollPicHeight+ flowerViewHeight+2, LBVIEW_WIDTH1, todayShopHeight)];
    self.oneMoneyView.backgroundColor = [UIColor whiteColor];
    [self.mainScroll addSubview:self.oneMoneyView];
    
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(10, (todayShopHeight- LBVIEW_HEIGHT1 / 15)/2, VIEW_WIDTH / 4, LBVIEW_HEIGHT1 / 15)];
    label.text=@"花集公告";
    label.textColor=[UIColor colorWithRed:37/255.0 green:119/255.0 blue:188/255.0 alpha:1];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:14];
    
    [self.oneMoneyView addSubview:label];
    UILabel*lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(16+VIEW_WIDTH / 4-1,(todayShopHeight- LBVIEW_HEIGHT1 / 20)/2, 1, LBVIEW_HEIGHT1 / 20)];
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
    _notifitionScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(VIEW_WIDTH / 4 + 20, (todayShopHeight- LBVIEW_HEIGHT1 / 15)/2, 3*VIEW_WIDTH/4-20, LBVIEW_HEIGHT1 / 15)];
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
        btn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        btn.tag=hjn.article_id.integerValue;
        [btn addTarget:self action:@selector(gotoNotifition:) forControlEvents:UIControlEventTouchUpInside];
        [_notifitionScroll addSubview:btn];
        
    }
    //定时器
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(animotion) userInfo:nil repeats:YES];
}

-(void)gotoNotifition:(UIButton*)sender
{
    TodayShopViewController*todayVC=[[TodayShopViewController alloc]init];
    todayVC.tag=(int)sender.tag;
    todayVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:todayVC animated:YES];
    
}

-(void)animotion
{
    //上面
    int num = _scrollPic.contentOffset.x/main_size.width;
    if (num>=homePicNumber-1)
    {
        num=-1;
    }
    num = num + _count;
    [self.scrollPic setContentOffset:CGPointMake(num*main_size.width, 0)  animated:YES];
    
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
    UIView *promotionView = [[UIView alloc] initWithFrame:CGRectMake(0,scrollPicHeight+ flowerViewHeight+todayShopHeight+4, main_size.width, main_size.height / 6)];
    self.oneMoneyImageView = [[UIImageView alloc] initWithFrame:promotionView.bounds];
    /*NSString *deadline = @"";
    for(int i=0;i<_picDataArray.count;i++){
        GetPic*getpic=_picDataArray[i];
        if([getpic.position isEqualToString:@"promotion"]){
            NSURL*urlStr=[NSURL URLWithString:getpic.pictureUrlStr];
            [self.oneMoneyImageView sd_setImageWithURL:urlStr];
            deadline=[getpic.deadline stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            break;
        }
    }*/
    [promotionView addSubview:self.oneMoneyImageView];
    
    self.promotionView = promotionView;
    
    /*NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [formatter dateFromString:deadline];
    NSInteger timestamp = [datenow timeIntervalSince1970];
    timeGap = timestamp - [[NSDate date] timeIntervalSince1970];
    */
    //timeGap = 9999;
    
    CGFloat hourX = main_size.width * 0.6;
    CGFloat hourY = promotionView.bounds.size.height / 2 - 20;
    CGFloat hourW = main_size.width * 0.1;
    
    UIImageView *hourView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number-bg"]];
    hourView.frame = CGRectMake(hourX, hourY, hourW, hourW);
    [promotionView addSubview:hourView];
    hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, hourW, hourW)];
    [hourLabel setTextAlignment:NSTextAlignmentCenter];
    [hourLabel setFont:[UIFont systemFontOfSize:14]];
    [hourView addSubview:hourLabel];
    
    CGFloat minuteX = hourX+hourW+15;
    CGFloat minuteY = hourY;
    CGFloat minuteW = hourW;
    
    UILabel *dotLabel = [[UILabel alloc] initWithFrame:CGRectMake(hourX+hourW, hourY+2, 15, 30)];
    [promotionView addSubview:dotLabel];
    [dotLabel setTextAlignment:NSTextAlignmentCenter];
    [dotLabel setText:@":"];
    
    UIImageView *minuteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number-bg"]];
    minuteView.frame = CGRectMake(minuteX, minuteY, minuteW, minuteW);
    [promotionView addSubview:minuteView];
    minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, minuteW, minuteW)];
    [minuteLabel setTextAlignment:NSTextAlignmentCenter];
    [minuteLabel setFont:[UIFont systemFontOfSize:14]];
    [minuteView addSubview:minuteLabel];
    
    CGFloat secondX = minuteX+minuteW+15;
    CGFloat secondY = minuteY;
    CGFloat secondW = hourW;
    
    UILabel *dot2Label = [[UILabel alloc] initWithFrame:CGRectMake(minuteX+minuteW, minuteY+2, 15, 30)];
    [promotionView addSubview:dot2Label];
    [dot2Label setTextAlignment:NSTextAlignmentCenter];
    [dot2Label setText:@":"];
    
    UIImageView *secondView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number-bg"]];
    secondView.frame = CGRectMake(secondX, secondY, secondW, secondW);
    [promotionView addSubview:secondView];
    secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, secondW, secondW)];
    [secondLabel setTextAlignment:NSTextAlignmentCenter];
    [secondLabel setFont:[UIFont systemFontOfSize:14]];
    [secondView addSubview:secondLabel];
    
    CGFloat promotionW = main_size.width * 0.4;
    CGFloat promotionH = promotionW * 117/387;
    promotionBtn = [[UIButton alloc] initWithFrame:CGRectMake(main_size.width - promotionW, (promotionView.bounds.size.height-10 - promotionH)/2, promotionW, promotionH)];
    [promotionBtn setImage:[UIImage imageNamed:@"buy_btn"] forState:UIControlStateNormal];
    [promotionView addSubview:promotionBtn];
    promotionBtn.tag = 19;
    [promotionBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [promotionBtn setHidden:YES];

    //加入倒计时
    promotionTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(promotionAnimation) userInfo:nil repeats:YES];
    [self.mainScroll addSubview:promotionView];
}

-(void)promotionAnimation{
    

    
    if(timeGap>0){
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
#pragma mark -----猜你喜欢
- (void)guessYouLikeData:(NSString *)strLocation {
    

//    NSString *strLocation = [[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    [HttpEngine goodsFeaturedWithLocation:strLocation withPageLimit:@"6" with:^(NSArray *dataArray) {
        _guessLikeArray = dataArray;
        [self guessYouLike];
        int guessV = ceilf(_guessLikeArray.count/2.0);
        _mainScroll.contentSize = CGSizeMake( LBVIEW_WIDTH1, scrollPicHeight+flowerViewHeight+todayShopHeight+LBVIEW_HEIGHT1/6+40+82*guessV+6+50+118);
        [self theIkenAndBess];
    }];
}
- (void)guessYouLike {

    [_guessYouView removeFromSuperview];
    int guessV = ceilf(_guessLikeArray.count/2.0);
    CGFloat height =scrollPicHeight+flowerViewHeight+todayShopHeight+4;
    
    if(showPromotion){
        height+=LBVIEW_HEIGHT1/6;
    }
    
    GuessV *gusv = [[GuessV alloc]initWithFrame:CGRectMake(0, height, LBVIEW_WIDTH1, 40+82*guessV)];
    gusv.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [gusv superWidth:LBVIEW_WIDTH1 withArray:_guessLikeArray withTabVC:self.tabBarVC];
    _guessYouView = gusv;
    [_mainScroll addSubview:_guessYouView];
}
#pragma mark 意见、合作
- (void)theIkenAndBess
{
    [self.ideaView removeFromSuperview];
    IkenV *ikenv = [[IkenV alloc]init];
    
    CGFloat height = scrollPicHeight+flowerViewHeight+todayShopHeight+guessViewHeight+6;
    
    if(showPromotion){
        height+=LBVIEW_HEIGHT1/6;
    }
    
    ikenv.frame = CGRectMake(0, height, LBVIEW_WIDTH1, 50);
    ikenv.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [ikenv viewWithSuperWidth:main_size.width withVC:self];
    self.ideaView = ikenv;
    [_mainScroll addSubview:self.ideaView];
}
@end