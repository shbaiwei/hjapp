//
//  AboutMeViewController.h
//  HJApp
//
//  Created by Bruce He on 15/11/2.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutMeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *memberIdLabel;

@property (weak, nonatomic) IBOutlet UITextField *trueNameTF;

@property (weak, nonatomic) IBOutlet UIButton *birthdayBtn;

@property (weak, nonatomic) IBOutlet UIButton *sexBtn;

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;

- (IBAction)saveBtn:(UIButton *)sender;
- (IBAction)backMyHJ:(UIButton *)sender;

@end
