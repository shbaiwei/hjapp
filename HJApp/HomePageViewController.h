//
//  HomePageViewController.h
//  HJApp
//
//  Created by Bruce He on 15/10/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssortPageViewController.h"

@interface HomePageViewController : UIViewController

@property (nonatomic, strong) UILabel *cityLabel;

//@property(nonatomic,strong)AssortPageViewController*assortPageVC;
@property(nonatomic,strong)UITabBarController*tabBarVC;
@end
