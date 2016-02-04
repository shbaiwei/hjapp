//
//  HomePageViewController.h
//  HJApp
//
//  Created by Bruce He on 15/10/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HJViewController.h"
#import "AssortPageViewController.h"
#import "BWCommon.h"

@interface HomePageViewController : HJViewController
<CLLocationManagerDelegate,
UIAlertViewDelegate
>

@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic,strong) CLLocationManager *manager;
@end
