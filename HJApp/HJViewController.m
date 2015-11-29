//
//  HJViewController.m
//  HJApp
//
//  Created by Bruce on 15/11/29.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "HJViewController.h"
#import "LoginViewController.h"

@interface HJViewController ()

@end

@implementation HJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tabBarVC setDelegate:self];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    //NSLog(@"~~~~~ %ld",viewController.tabBarItem.tag );
    //判断是否需要登陆
    NSString*str=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    if (str==NULL && viewController.tabBarItem.tag >1)
    {
        LoginViewController*loginVC=[[LoginViewController alloc]init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:navigationController animated:YES completion:^{
            
        }];
        
        return NO;
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end