//
//  BWCommon.m
//  HJApp
//
//  Created by Bruce on 15/11/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "BWCommon.h"

@implementation BWCommon

+ (void)verificationCode:(void(^)())blockYes blockNo:(void(^)(id time))blockNo {
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                blockYes();
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                blockNo(strTime);
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+(MBProgressHUD *) getHUD{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[BWCommon getCurrentVC].view animated:YES];
    
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 62)];
    UIImageView *loadingLogo =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_logo.png"]];
    loadingLogo.frame = CGRectMake(0, 0, 59, 62);
    [loadingView addSubview:loadingLogo];
    //loadingLogo.frame = CGRectMake(10, 0, 40, 40);
    /*UILabel *loadingText = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 60, 20)];
    [loadingText setTextAlignment:NSTextAlignmentCenter];
    [loadingText setTextColor:[UIColor whiteColor]];
    [loadingText setText:@"加载中.."];
    [loadingText setFont:[UIFont systemFontOfSize:12]];
    [loadingView addSubview:loadingText];*/
    hud.customView = loadingView;
    hud.mode = MBProgressHUDModeCustomView;
    
    return hud;
}

@end