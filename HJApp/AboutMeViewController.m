//
//  AboutMeViewController.m
//  HJApp
//
//  Created by Bruce He on 15/11/2.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "AboutMeViewController.h"
#import "HttpEngine.h"
#import "MyHJViewController.h"


@interface AboutMeViewController ()
@property(nonatomic,strong)NSArray*dataArray;

@property(nonatomic,strong)UIView*btnView;
@property(nonatomic,strong)UIView*timeView;
@property(nonatomic,strong)UIView*shadowView;
@property(nonatomic,strong)UIDatePicker *datePicker;

@end

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

@implementation AboutMeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
   
    NSString*str=[[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
    [HttpEngine getConsumerDetailData:str completion:^(NSArray *dataArray)
    {
        _dataArray=dataArray;
        [self showConsumerDetail];
        
    }];
    
   
}
-(void)showConsumerDetail
{
    //*userid,*uniqueid,*realName,*gender,*birthday;

    ConsumerDetail*consumer=_dataArray[0];
    
    _memberNameLabel.text=consumer.userid;
    _memberIdLabel.text=consumer.uniqueid;
    _trueNameTF.text=consumer.realName;
    
    //[_birthdayBtn setTitle:consumer.birthday forState:UIControlStateNormal];
    [_birthdayBtn addTarget:self action:@selector(changeBirthday) forControlEvents:UIControlEventTouchUpInside];
    
    _birthdayLabel.text=consumer.birthday;
    if ([consumer.gender isEqualToString:@"0"])
    {
         _sexLabel.text=@"男";
        //[_sexBtn setTitle:@"男" forState:UIControlStateNormal];
    }
    else
    {
     _sexLabel.text=@"女";
    }
    
    [_sexBtn addTarget:self action:@selector(changeSex) forControlEvents:UIControlEventTouchUpInside];
}
-(void)changeBirthday
{

    
    _timeView=[[UIView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.1, LBVIEW_HEIGHT1*0.25, LBVIEW_WIDTH1*0.8, LBVIEW_HEIGHT1*0.5)];
    _timeView.backgroundColor=[UIColor whiteColor];
    _timeView.layer.cornerRadius=10;
    _timeView.clipsToBounds=YES;
    
    UILabel*timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, LBVIEW_WIDTH1*0.8-10, LBVIEW_HEIGHT1*0.1-1)];
    timeLabel.text=@"2015年1月3日周日";
    timeLabel.font=[UIFont systemFontOfSize:19];
    timeLabel.textColor=[UIColor blueColor];
    [_timeView addSubview:timeLabel];
    
    UILabel*lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, LBVIEW_HEIGHT1*0.1-1, LBVIEW_WIDTH1*0.8, 1)];
    lineLabel.textColor=[UIColor blueColor];
    [_timeView addSubview:lineLabel];
    
    _datePicker = [[ UIDatePicker alloc] initWithFrame:CGRectMake(0, LBVIEW_HEIGHT1*0.1, LBVIEW_WIDTH1*0.8, LBVIEW_HEIGHT1*0.3)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
      [_timeView addSubview:_datePicker];
    
    UILabel*btnLineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, LBVIEW_HEIGHT1*0.4-1, LBVIEW_WIDTH1*0.8, 1)];
    btnLineLabel.textColor=[UIColor grayColor];
    [_timeView addSubview:btnLineLabel];
    
    UIButton*timeBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, LBVIEW_HEIGHT1*0.4+1, LBVIEW_WIDTH1*0.8, LBVIEW_HEIGHT1*0.1)];
    [timeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [timeBtn setTintColor:[UIColor blackColor]];
    [timeBtn setBackgroundColor:[UIColor redColor]];
    [timeBtn addTarget:self action:@selector(chooseTime) forControlEvents:UIControlEventTouchUpInside];
    [_timeView addSubview:timeBtn];
    
    
    
    _shadowView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _shadowView.backgroundColor=[UIColor darkGrayColor];
    _shadowView.alpha=0.9;
    
    //找window
    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
    [window addSubview:_shadowView];
    [_shadowView addSubview:_timeView];
    
    
}

-(void)chooseTime
{
 
    [_shadowView removeFromSuperview];
    NSDate*date=_datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString*timeStr=[formatter stringFromDate:date];
    NSLog(@"%@",timeStr);
    _birthdayLabel.text=timeStr;
    
}

-(void)changeSex
{
    _btnView=[[UIView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.1, LBVIEW_HEIGHT1*0.45, LBVIEW_WIDTH1*0.8, LBVIEW_HEIGHT1*0.1)];
    //_view=[[UIView alloc]initWithFrame:CGSizeMake(280, 120)];
    _btnView.backgroundColor=[UIColor whiteColor];
    _btnView.layer.cornerRadius=10;
    _btnView.clipsToBounds=YES;
    
    UILabel *labelStriping=[[UILabel alloc]initWithFrame:CGRectMake(0, LBVIEW_HEIGHT1*0.05, LBVIEW_WIDTH1*0.8, 1)];
    labelStriping.backgroundColor=[UIColor grayColor];
    [_btnView addSubview:labelStriping];
    
    for (int i=0; i<2; i++)
    {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0,i* LBVIEW_HEIGHT1*0.05, LBVIEW_WIDTH1*0.8, LBVIEW_HEIGHT1*0.05)];
        if (i==0)
        {
            [btn setTitle:@"男" forState:UIControlStateNormal];
        }
        if (i==1)
        {
            [btn setTitle:@"女" forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(removeBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i+1;
        btn.titleLabel.font=[UIFont systemFontOfSize:18];
        [_btnView addSubview:btn];
    }
    _shadowView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _shadowView.backgroundColor=[UIColor darkGrayColor];
    _shadowView.alpha=0.9;
    
    //找window
    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
    [window addSubview:_shadowView];
    [_shadowView addSubview:_btnView];
   

}
-(void)removeBtn:(UIButton *)btn
{
    [_shadowView removeFromSuperview];
    if (btn.tag==1)
    {
        _sexLabel.text=@"男";
    }
    else
    {
        _sexLabel.text=@"女";
    }
    
}



- (IBAction)saveBtn:(UIButton *)sender
{
    NSString*str=@"0";
    if ([_sexLabel.text isEqualToString:@"女"])
    {
       str=@"1";
    }
    [HttpEngine updataConsumerDetailData:_trueNameTF.text with:str with:_birthdayLabel.text];
    
}

- (IBAction)backMyHJ:(UIButton *)sender
{
    MyHJViewController*myHJVC=[[MyHJViewController alloc]init];
    [self.navigationController pushViewController:myHJVC animated:YES];
    
}


@end
