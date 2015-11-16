//
//  ShopingCar.h
//  HJApp
//
//  Created by Bruce He on 15/11/5.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopingCar : NSObject

@property(nonatomic,copy)NSString *skuName,*price,*number,*skuId,*supplierId;
@property(nonatomic,strong)NSArray*dataArray;

+(id)ConsumerDetailDictionary:(NSDictionary*)dic;
-(id)initWithDictionary:(NSDictionary*)dic;

@end
