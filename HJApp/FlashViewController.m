//
//  FlashViewController.m
//  HJApp
//
//  Created by Bruce He on 15/10/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "FlashViewController.h"
#import "HomePageViewController.h"
#import "AssortPageViewController.h"
#import "OrderPageViewController.h"
#import "ShopingPageViewController.h"
#import "MyHJViewController.h"

@interface FlashViewController ()

@property(nonatomic,strong)UITabBarController*tabBar;


@end

@implementation FlashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor redColor];
    [self goToPage];
    
}
-(void)goToPage
{
    //TabBar
    _tabBar = [[UITabBarController alloc] init];
    //tabBar.tabBar.opaque = YES;
    
    UIWindow*window=[[UIApplication sharedApplication]keyWindow];
    window.rootViewController=_tabBar;
    
    HomePageViewController *homeVC = [[HomePageViewController alloc] init];
    AssortPageViewController *assortVC= [[AssortPageViewController alloc] init];
    OrderPageViewController *oderVC = [[OrderPageViewController alloc] init];
    ShopingPageViewController*shopVC = [[ShopingPageViewController alloc] init];
    MyHJViewController *myHuaJiVC = [[MyHJViewController alloc] init];
    
    //设置首页tabbar   选中前和选中后
    UIImage *HomeImage = [UIImage imageNamed:@"home2.png"];
    HomeImage = [HomeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    homeVC.tabBarItem.image = HomeImage;
    homeVC.title = @"首页";
    homeVC.tabBarItem.selectedImage = HomeImage;
    
    UIImage *homeImage2 = [UIImage imageNamed:@"Home.png"];
    homeImage2 = [homeImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = homeImage2;
    
    UIImage *AssortImage = [UIImage imageNamed:@"assort2.png"];
    AssortImage = [AssortImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    assortVC.tabBarItem.image = AssortImage;
    assortVC.title = @"分类";
    assortVC.tabBarItem.selectedImage = AssortImage;
    
    UIImage *assortImage2 = [UIImage imageNamed:@"Assort.png"];
    assortImage2 = [assortImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    assortVC.tabBarItem.selectedImage = assortImage2;
    
    UIImage *OderImage = [UIImage imageNamed:@"oder2.png"];
    OderImage = [OderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    oderVC.tabBarItem.image = OderImage;
    oderVC.title = @"订单";
    oderVC.tabBarItem.selectedImage = OderImage;
    
    UIImage *oderImage2 = [UIImage imageNamed:@"Oder.png"];
    oderImage2 = [oderImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    oderVC.tabBarItem.selectedImage = oderImage2;
    
    
    UIImage *ShopImage = [UIImage imageNamed:@"shop2.png"];
    ShopImage = [ShopImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    shopVC.tabBarItem.image = ShopImage;
    shopVC.title = @"购物车";
    shopVC.tabBarItem.selectedImage = ShopImage;
    
    UIImage *shopImage2 = [UIImage imageNamed:@"shop.png"];
    shopImage2 = [shopImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    shopVC.tabBarItem.selectedImage = shopImage2;
    
    
    UIImage *MyHuaJiImage = [UIImage imageNamed:@"myhuaji2.png"];
    MyHuaJiImage = [MyHuaJiImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    myHuaJiVC.tabBarItem.image = MyHuaJiImage;
    myHuaJiVC.title = @"我的花集";
    myHuaJiVC.tabBarItem.selectedImage = MyHuaJiImage;
    
    UIImage *MyhuajiImage2 = [UIImage imageNamed:@"MyHuaJi.PNG"];
    MyhuajiImage2 = [MyhuajiImage2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myHuaJiVC.tabBarItem.selectedImage = MyhuajiImage2;
    //TabBar字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil] forState: UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.23 green:0.5 blue:0.84 alpha:0.9], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    
    UINavigationController *naviHome = [[UINavigationController alloc] initWithRootViewController: homeVC];
    UINavigationController *naviAssprt = [[UINavigationController alloc] initWithRootViewController: assortVC];
    UINavigationController *naviOder = [[UINavigationController alloc] initWithRootViewController:oderVC];
    UINavigationController *naviShop = [[UINavigationController alloc] initWithRootViewController:shopVC];
    UINavigationController *naviMyHuaJi = [[UINavigationController alloc] initWithRootViewController:myHuaJiVC];
    
    homeVC.tabBarVC=_tabBar;
    myHuaJiVC.tabBarVC=_tabBar;
    shopVC.tabBarVC=_tabBar;
    assortVC.tabBarVC=_tabBar;
    _tabBar.viewControllers = @[naviHome, naviAssprt, naviOder, naviShop, naviMyHuaJi];
    
    //设置导航栏背景色
    naviHome.navigationBar.barTintColor = [UIColor colorWithRed:0.23 green:0.67 blue:0.89 alpha:1];
    naviMyHuaJi.navigationBar.barTintColor = [UIColor colorWithRed:0.23 green:0.67 blue:0.89 alpha:1];
    naviOder.navigationBar.barTintColor = [UIColor colorWithRed:0.23 green:0.67 blue:0.89 alpha:1];
    naviShop.navigationBar.barTintColor = [UIColor colorWithRed:0.23 green:0.67 blue:0.89 alpha:1];
    naviAssprt.navigationBar.barTintColor = [UIColor colorWithRed:0.23 green:0.67 blue:0.89 alpha:1];
    
    
    [naviHome setNavigationBarHidden:YES animated:YES];
    
    
    //设置导航栏字体和颜色
    [naviMyHuaJi.navigationBar setTitleTextAttributes: @{NSFontAttributeName:
                                                             [UIFont boldSystemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [naviOder.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:19], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [naviShop.navigationBar setTitleTextAttributes:@{NSFontAttributeName :[UIFont boldSystemFontOfSize:19], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [naviAssprt.navigationBar setTitleTextAttributes:@{NSFontAttributeName :[UIFont boldSystemFontOfSize:19], NSForegroundColorAttributeName: [UIColor whiteColor]}];
   
    
}


//-(void)nextPageHomePageViewController:(HomePageViewController *)homeVC didFinish:(NSInteger)tag
//{
//    NSLog(@"12345678");
//    _tabBar.selectedIndex=1;
//
//}

@end
