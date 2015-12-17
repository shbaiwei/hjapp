//
//  TodayShopViewController.h
//  HJApp
//
//  Created by Bruce He on 15/11/17.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWCommon.h"
#import "MBProgressHUD.h"

@interface TodayShopViewController : UIViewController
<UIWebViewDelegate>
{
}

@property(nonatomic,unsafe_unretained)int tag;

@property(nonatomic,retain) MBProgressHUD *hud;
@property(nonatomic,retain) UIWebView *webView;
@end
