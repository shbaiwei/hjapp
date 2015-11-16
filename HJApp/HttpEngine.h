//
//  HttpEngine.h
//  HJApp
//
//  Created by Bruce He on 15/10/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "GetPic.h"
#import "AllFlower.h"
#import "FlowerCatalogue.h"
#import "ConsumerDetail.h"
#import "orderDetail.h"
#import "FlowerDetail.h"
#import "ShopingCar.h"
#import "AllAdress.h"

@interface HttpEngine : NSObject



//获取城市
+(void)getCityNameBackcompletion:(void(^)(NSArray*dataArray))complete;

//广告图
+(void)getPicture:(void(^)(NSArray*dataArray))complete;



//发送短信
+(void)sendMessage;

//查询手机号是否存在
+(void)checkUser;

//用户注册
+(void)registerRequestUsername:(NSString*)username withPassword:(NSString*)password withMobile:(NSString*)mobile withRegIp:(NSString*)regIp;

//登陆请求
+(void)loginRequest:(NSString*)name with:(NSString*)pas complete:(void(^)(NSString*fail))complete;



//产品分类
+(void)getAllFlower:(void(^)(NSArray*dataArray))complete;

//获取分类属性
+(void)getProduct:(NSString*)idStr completion:(void(^)(NSArray*dataArray))complete;

//获取产品
+(void)getProductDetail:(NSString*)idStr withLocation:(NSString*)location withProps:(NSArray*)props withPage:(NSString*)page withPageSize:(NSString*)pageSize completion:(void(^)(NSArray*dataArray))complete;


//购物车列表
+(void)getCart:(void(^)(NSArray*dataArray,NSString*totalPrice,NSString*shippingFee,NSString*paymentPrice))complete;

//增加商品
+(void)addGoodsLocation:(NSString*)location withSku:(NSString*)sku withSupplier:(NSString*)supplier withNumber:(NSString*)number;





//获取用户详细信息
+(void)getConsumerData:(void(^)(NSArray*dataArray))complete;

//获取用户资料
+(void)getConsumerDetailData:(NSString*)idStr completion:(void(^)(NSArray*dataArray))complete;

//编辑个人资料
+(void)updataConsumerDetailData:(NSString*)realNameStr with:(NSString*)genderStr with:(NSString*)birthdayStr;


//我的订单
+(void)myOrder:(NSString*)full with:(NSString*)page with:(NSString*)pageSize with:(NSString*)status completion:(void(^)(NSArray*dataArray))complete;
//订单详细
+(void)detailOrder:(NSString*)idStr completion:(void(^)(NSDictionary*dataDic))complete;

//订单提交
+(void)submitOrderAddressId:(NSString*)addressId withMethod:(NSString*)method withSpaypassword:(NSString*)spaypassword withCouponNo:(NSString*)couponNo;

//微信支付
+(void)WXsendPay;



//地址列表
+(void)getAddress:(void(^)(NSArray*dataArray))complete;
//地址编辑
+(void)changeAddress:(NSString*)addressId Consignee:(NSString*)consignee withPhoneMob:(NSString*)phoneMob withProvince:(NSString*)province withCity:(NSString*)city withTown:(NSString*)town withAddress:(NSString*)address;
//增加地址
+(void)addAdressConsignee:(NSString*)consignee withPhoneMob:(NSString*)phoneMob withProvince:(NSString*)province withCity:(NSString*)city withTown:(NSString*)town withAddress:(NSString*)address;
//地址删除
+(void)deleteAddress:(NSString*)addrId;
//设置默认收货地址
+(void)defaultAddress:(NSString*)addrId;



//我的红包
+(void)getRedBagStatus:(NSString*)status completion:(void(^)(NSArray*dataArray))complete;

//花集余额
+(void)getBalance:(void(^)(NSDictionary*dic))complete;

//amount,method
//花集余额充值
+(void)topUpAmount:(NSString*)amount withMethod:(NSString*)method;


@end
