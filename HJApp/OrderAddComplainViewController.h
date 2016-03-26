//
//  OrderAddComplainViewController.h
//  HJApp
//
//  Created by Bruce on 16/3/23.
//  Copyright © 2016年 shanghai baiwei network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpEngine.h"
#import "MBProgressHUD.h"

@interface OrderAddComplainViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
UITextFieldDelegate,
UIGestureRecognizerDelegate,
UIPickerViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIPickerViewDelegate,
MBProgressHUDDelegate
>
{
    MBProgressHUD *hud;
}

@property (nonatomic,assign) NSString *order_no;

@property (nonatomic,strong) UITableView *tableView;

- (void) snapImage;//拍照
- (void) pickImage;//从相册里找

@end
