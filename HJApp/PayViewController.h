//
//  PayViewController.h
//  HJApp
//
//  Created by Bruce He on 15/11/6.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWCommon.h"
#import "MBProgressHUD.h"

@interface PayViewController : UIViewController<
UITableViewDataSource,
UITableViewDelegate,
UIGestureRecognizerDelegate
>

@property(nonatomic,unsafe_unretained)int isTag;
@property(nonatomic,unsafe_unretained)int isTagTime;
@property(nonatomic,copy)NSString*isTagRedPacket;
@end

