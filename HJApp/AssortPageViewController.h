//
//  AssortPageViewController.h
//  HJApp
//
//  Created by Bruce He on 15/10/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlashViewController.h"


@interface AssortPageViewController : UIViewController

{
    BOOL _isOpen[666];
    int _lastTag[666];
}
@property(nonatomic,unsafe_unretained)int isTag;
@property(nonatomic,strong)UITabBarController*tabBarVC;
@end
