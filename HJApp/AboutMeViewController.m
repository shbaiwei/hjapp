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
#import "ChangeSexViewController.h"


@interface AboutMeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray*dataArray;

@property(nonatomic,strong)UIView*btnView;
@property(nonatomic,strong)UIView*timeView;
@property(nonatomic,strong)UIView*shadowView;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,strong)NSArray*titleArray;

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIButton*sexBtn;
@property(nonatomic,strong)UIButton*birthdayBtn;
@property(nonatomic,strong)UITextField*trueNameTF;
@property(nonatomic,strong)UILabel*sexLabel;
@property(nonatomic,strong)UILabel*birthdayLabel;


@property(nonatomic,strong)UILabel*timeLabel;

@end

#define LBVIEW_WIDTH1 [UIScreen mainScreen].bounds.size.width
#define LBVIEW_HEIGHT1 [UIScreen mainScreen].bounds.size.height

@implementation AboutMeViewController


-(void)viewWillAppear:(BOOL)animated
{
    if (_isTag==10)
    {
        _sexLabel.text=@"男";
    }
    if (_isTag==11)
    {
        _sexLabel.text=@"女";
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.title=@"个人资料";
    self.navigationController.navigationBar.translucent =NO;
    _titleArray=[[NSArray alloc]initWithObjects:@"会员",@"会员UID",@"真实姓名",@"性别",@"生日", nil];
    NSString*str=[[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
    [HttpEngine getConsumerDetailData:str completion:^(NSArray *dataArray)
    {
        _dataArray=dataArray;
        [self showConsumerDetail];
        
    }];
    

}
-(void)showConsumerDetail
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, LBVIEW_WIDTH1, LBVIEW_HEIGHT1) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.view addSubview:_tableView];
}

//区头
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]init];
    
    UIImageView*headImage=[[UIImageView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1 * 0.05, (80-LBVIEW_HEIGHT1*0.09)/2, LBVIEW_HEIGHT1*0.09, LBVIEW_HEIGHT1* 0.09)];
    headImage.image=[UIImage imageNamed:@"head.png"];
    [view addSubview:headImage];
    
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(3*LBVIEW_WIDTH1/4-10, 20, LBVIEW_WIDTH1/4, 40)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"更换头像" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:17];
    btn.layer.borderColor=[UIColor grayColor].CGColor;
    btn.layer.borderWidth=1;
    btn.layer.cornerRadius=10;
    btn.clipsToBounds=YES;
    [view addSubview:btn];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

//区尾
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]init];
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(10, 30, LBVIEW_WIDTH1-20, 30)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius=7;
    btn.clipsToBounds=YES;
    [btn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70;
}

//区
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsumerDetail*consumer=_dataArray[0];
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text=_titleArray[indexPath.row];
        switch (indexPath.row)
        {
            case 0:
            {
                UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/3, 20, 2*LBVIEW_WIDTH1/3, 20)];
                label.textColor=[UIColor blackColor];
                label.text=consumer.userid;
                [cell addSubview:label];
            }
                break;
            case 1:
            {
                UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/3, 20, 2*LBVIEW_WIDTH1/3, 20)];
                label.textColor=[UIColor blackColor];
                label.text=consumer.uniqueid;
                [cell addSubview:label];
                
            }
                break;
            case 2:
            {
                _trueNameTF=[[UITextField alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/3, 15,LBVIEW_WIDTH1/2, 40)];
                _trueNameTF.layer.borderColor=[UIColor grayColor].CGColor;
                _trueNameTF.layer.borderWidth=1;
                _trueNameTF.layer.cornerRadius=10;
                _trueNameTF.clipsToBounds=YES;
                _trueNameTF.text=[NSString stringWithFormat:@"%@",consumer.realName];
                _trueNameTF.textColor=[UIColor blackColor];
                [cell addSubview:_trueNameTF];
                
            }
                break;
            case 3:
            {
                
                _sexLabel=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/3+10, 10,LBVIEW_WIDTH1/2-10, 40)];
                _sexLabel.textColor=[UIColor blackColor];
                [cell addSubview:_sexLabel];
                
                _sexBtn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/3, 10,LBVIEW_WIDTH1/2, 40)];
                _sexBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                _sexBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                _sexBtn.layer.borderWidth=1;
                _sexBtn.layer.borderColor=[UIColor grayColor].CGColor;
                _sexBtn.layer.cornerRadius=10;
                _sexBtn.clipsToBounds=YES;
                [_sexBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                if ([consumer.gender isEqualToString:@"0"])
                {
                    _sexLabel.text=@"男";
                }
                else
                {
                    _sexLabel.text=@"女";
                }
                [_sexBtn addTarget:self action:@selector(changeSex) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:_sexBtn];
            }
                break;
            case 4:
            {
                _birthdayLabel=[[UILabel alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/3+10, 10,LBVIEW_WIDTH1/2-10, 40)];
                _birthdayLabel.textColor=[UIColor blackColor];
                _birthdayLabel.text=consumer.birthday;
                [cell addSubview:_birthdayLabel];
                
                _birthdayBtn=[[UIButton alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1/3, 10,LBVIEW_WIDTH1/2, 40)];
                _birthdayBtn.layer.borderWidth=1;
                _birthdayBtn.layer.borderColor=[UIColor grayColor].CGColor;
                _birthdayBtn.layer.cornerRadius=10;
                _birthdayBtn.clipsToBounds=YES;
                [_birthdayBtn addTarget:self action:@selector(changeBirthday) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:_birthdayBtn];
            }
                break;
            default:
                break;
        }
        
    }
    
    return cell;
}

-(void)changeBirthday
{
    _timeView=[[UIView alloc]initWithFrame:CGRectMake(LBVIEW_WIDTH1*0.1, LBVIEW_HEIGHT1*0.25, LBVIEW_WIDTH1*0.8, LBVIEW_HEIGHT1*0.5)];
    _timeView.backgroundColor=[UIColor whiteColor];
    _timeView.layer.cornerRadius=10;
    _timeView.clipsToBounds=YES;
    
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, LBVIEW_WIDTH1*0.8-10, LBVIEW_HEIGHT1*0.1-1)];
    //_timeLabel.text=@"2015年1月3日周日";
    
    _timeLabel.font=[UIFont systemFontOfSize:19];
    _timeLabel.textColor=[UIColor blueColor];
    [_timeView addSubview:_timeLabel];
    
    UILabel*lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, LBVIEW_HEIGHT1*0.1-1, LBVIEW_WIDTH1*0.8, 1)];
    lineLabel.textColor=[UIColor blueColor];
    [_timeView addSubview:lineLabel];
    
    _datePicker = [[ UIDatePicker alloc] initWithFrame:CGRectMake(0, LBVIEW_HEIGHT1*0.1, LBVIEW_WIDTH1*0.8, LBVIEW_HEIGHT1*0.3)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker addTarget:self action:@selector(showTime) forControlEvents:UIControlEventValueChanged];
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
//时间显示
-(void)showTime
{
    NSDate*date=_datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString*timeStr=[formatter stringFromDate:date];
    _timeLabel.text=timeStr;
}


-(void)chooseTime
{
    [_shadowView removeFromSuperview];
    NSDate*date=_datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString*timeStr=[formatter stringFromDate:date];
    _birthdayLabel.text=timeStr;
    
}

-(void)changeSex
{
    ChangeSexViewController*changeSex=[[ChangeSexViewController alloc]init];
    changeSex.aboutMeVC=self;
    [self.navigationController pushViewController:changeSex animated:NO];

}

- (IBAction)saveBtn:(UIButton *)sender
{
    NSString*str=@"0";
    if ([_sexLabel.text isEqualToString:@"女"])
    {
       str=@"1";
    }
    [HttpEngine updataConsumerDetailData:_trueNameTF.text with:str with:_birthdayLabel.text];
    
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"更新成功" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction*defaultAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action)
                                 {
                                    
                                 }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
