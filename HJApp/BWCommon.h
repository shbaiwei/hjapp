//
//  BWCommon.h
//  HJApp
//
//  Created by Bruce on 15/11/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface BWCommon : NSObject
+ (void)verificationCode:(void(^)())blockYes blockNo:(void(^)(id time))blockNo;
+ (UIViewController *)getCurrentVC;
@end