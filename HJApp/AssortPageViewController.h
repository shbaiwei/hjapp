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
    BOOL _isOpen[100];
    int _lastTag[100];
}
@property(nonatomic,unsafe_unretained)int isTag;
@end
