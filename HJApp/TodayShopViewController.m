//
//  TodayShopViewController.m
//  HJApp
//
//  Created by Bruce He on 15/11/17.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "TodayShopViewController.h"
#import "HttpEngine.h"

@interface TodayShopViewController ()
@property(nonatomic,strong)NSArray*dataArray;
@end

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

@implementation TodayShopViewController

CGSize size;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.translucent =NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, size.width,size.height)];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://jinhuo.huaji.com/index.php/article/%d.html?from=app",self.tag]]];
    
    [self.webView loadRequest:request];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title=@"花集公告";
    [self hidesTabBar:YES];
    /*[HttpEngine getNotifition:^(NSArray *dataArray)
     {
         _dataArray=dataArray;
         [self showPage];
    }];*/
    
    
}

-(void) webViewDidStartLoad:(UIWebView *)webView{
    self.hud = [BWCommon getHUD];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [self.hud removeFromSuperview];
}
-(void)showPage
{
    HJNotifiton*hjn=_dataArray[_tag];
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1/15)];
    titleLabel.text=hjn.title;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont boldSystemFontOfSize:20];
    [self.view addSubview:titleLabel];
    
    UILabel*detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,LBVIEW_HEIGHT1/15, LBVIEW_WIDTH1-20, LBVIEW_HEIGHT1/20)];
    detailLabel.text=[NSString stringWithFormat:@"作者: %@   发布日期: %@",hjn.author,hjn.dateCreated];
    detailLabel.font=[UIFont systemFontOfSize:15];
    detailLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:detailLabel];
    
    
    UILabel*lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, LBVIEW_HEIGHT1/15+LBVIEW_HEIGHT1/20,  LBVIEW_WIDTH1-20, 1)];
    lineLabel.backgroundColor=[UIColor grayColor];
    [self.view addSubview:lineLabel];

    UIFont*font=[UIFont systemFontOfSize:15];
    CGSize size = [hjn.content boundingRectWithSize:CGSizeMake(LBVIEW_WIDTH1-40, LONG_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    
    UILabel*contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, LBVIEW_HEIGHT1/15+6+LBVIEW_HEIGHT1/20, LBVIEW_WIDTH1-40, size.height+30)];
    contentLabel.text=hjn.content;
    contentLabel.font=font;
    contentLabel.numberOfLines=0;
    [self.view addSubview:contentLabel];
    
    

}

//自定义隐藏tarbtn
-(void)hidesTabBar:(BOOL)hidden
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    for (UIView *view in self.tabBarController.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            if (hidden)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height, view.frame.size.width , view.frame.size.height)];
            }
            else{
                [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height - 49, view.frame.size.width, view.frame.size.height)];
                
            }
        }
        else{
            if([view isKindOfClass:NSClassFromString(@"UITransitionView")]){
                if (hidden) {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
                }
                else{
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 49 )];
                }
            }
        }
    }
    [UIView commitAnimations];
}
@end
