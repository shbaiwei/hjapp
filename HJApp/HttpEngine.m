//
//  HttpEngine.m
//  HJApp
//
//  Created by Bruce He on 15/10/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "HttpEngine.h"

@implementation HttpEngine
//获取城市
+(void)getCityNameBackcompletion:(void(^)(NSArray*dataArray))complete
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/location/"];
    [session GET:str parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         //NSLog(@"JSON:%@",responseObject);
         NSArray*array=responseObject[@"results"];
         complete(array);
         
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
}

//广告图
+(void)getPicture:(void(^)(NSArray*dataArray))complete
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/advertisement/"];
    [session GET:str parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"JSON:%@",responseObject);
         
         NSArray*array=responseObject[@"results"];
         NSMutableArray*dataArray=[[NSMutableArray alloc]init];
         for (int i=0; i<array.count; i++)
         {
             GetPic*getPic=[[GetPic alloc]init];
             NSDictionary*dic=array[i];
             getPic.pictureUrlStr=dic[@"image"];
             getPic.title=dic[@"title"];
             [dataArray addObject:getPic];
             
         }
         complete(dataArray);
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
}

//产品分类
+(void)getAllFlower:(void(^)(NSArray*dataArray))complete
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/goods-categories/"];
    [session GET:str parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         //NSLog(@"JSON:%@",responseObject);
         NSArray*array=responseObject[@"results"];
         NSMutableArray*dataArray=[[NSMutableArray alloc]init];
         for (int i=0; i<array.count; i++)
         {
             AllFlower*allFlower=[[AllFlower alloc]init];
             NSDictionary*dic=array[i];
             allFlower.name=[dic[@"name"]copy];
             allFlower.flowerId=[dic[@"id"]copy];
             [dataArray addObject:allFlower];
             
         }
         complete(dataArray);
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
}
//获取分类属性
+(void)getProduct:(NSString*)idStr completion:(void(^)(NSArray*dataArray))complete
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/goods-categories/%@/props/",idStr];
    
    [session GET:str parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"JSON:%@",responseObject);
         NSArray*array=responseObject;
         NSMutableArray*dataArray=[[NSMutableArray alloc]init];
         for (int i=0; i<array.count; i++)
         {
             NSDictionary*dic=array[i];
             FlowerCatalogue*flower=[FlowerCatalogue getCatalogueDictionary:dic];
             [dataArray addObject:flower];
         }
         complete(dataArray);
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
}

//获取产品
+(void)getProductDetail:(NSString*)idStr withLocation:(NSString*)location withProps:(NSArray*)props withPage:(NSString*)page withPageSize:(NSString*)pageSize completion:(void(^)(NSArray*dataArray))complete
{
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/goods/search/"];
    
    // NSDictionary*parameters=@{@"username":name,@"password":pas};
    
    NSDictionary*parameters=[[NSDictionary alloc]init];
    if (props.count==0)
    {
        NSLog(@"不刷款");
        parameters=@{@"category_id":idStr,@"location":location,@"page":page,@"page_size":pageSize};
    }
    else
    {
        NSLog(@"警告");
        // NSLog(@"props====%@",props);
       // NSArray *props=[[NSArray alloc]initWithObjects:@"10:31",@"9:26",nil];
       

        parameters=@{@"category_id":idStr,@"location":location,@"page":page,@"page_size":pageSize,@"props":props};
        
        
         NSLog(@"parameters====%@",parameters);
    }
    
    NSMutableArray*dataArray=[[NSMutableArray alloc]init];
    
    [session GET:str parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         //NSLog(@"分类产品  JSON:%@",responseObject);
         //goodsName,*image,*propValue;
         NSArray*array=responseObject[@"data"];
         for (int i=0; i<array.count; i++)
         {
             FlowerDetail*flow=[[FlowerDetail alloc]init];
             NSDictionary*dic=array[i];
             flow.goodsName=dic[@"goods_name"];
             flow.image=dic[@"image"];
             flow.propValue=dic[@"prop_value"];
             flow.dataArray=dic[@"price_list"];
             
             [dataArray addObject:flow];
         }
         complete(dataArray);
         
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
}

//购物车列表
+(void)getCart:(void(^)(NSArray*dataArray,NSString*totalPrice,NSString*shippingFee,NSString*paymentPrice))complete
{
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/cart/checkout/"];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    
    
    [session GET:str parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"JSON:%@",responseObject);
         //skuName,*price,*number
         
         NSArray*array=responseObject[@"cart_list"];
         NSMutableArray*dataArray=[[NSMutableArray alloc]init];
         for (int i=0; i<array.count; i++)
         {
             NSDictionary*dic=array[i];
             ShopingCar*shCa=[ShopingCar ConsumerDetailDictionary:dic];
             [dataArray addObject:shCa];
         }
         complete(dataArray,responseObject[@"total_price"],responseObject[@"shipping_fee"],responseObject[@"payment_price"]);
         
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
    
}
//增加商品
+(void)addGoodsLocation:(NSString*)location withSku:(NSString*)sku withSupplier:(NSString*)supplier withNumber:(NSString*)number
{
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/cart/"];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    NSDictionary*parameters=@{@"location":location,@"sku":sku,@"supplier":supplier,@"number":number};
    
    [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         //NSLog(@"JSON:%@",responseObject);
         
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
    
    
    
}

//发送短信
+(void)sendMessage
{
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    
    NSString *str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/sms/send/"];
    
    //mobile,message
    NSDictionary*parameters=@{@"mobile":@"18226986977",@"message":@"123"};
    [manager POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error: %@", error);
     }];
    
}
//查询手机号是否存在
+(void)checkUser
{
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    AFHTTPSessionManager*magager=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/auth/checkUser/"];
    [magager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    NSString*nameStr=@"18226984903";
    NSDictionary*parameters=@{@"username":nameStr};
    [magager GET:str parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"JSON:%@",responseObject);
         //         NSString*idStr=responseObject[@"id"];
         //
         //         [[NSUserDefaults standardUserDefaults]setObject:idStr forKey:@"ID"];
         
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
    
    
}

//用户注册
+(void)registerRequestUsername:(NSString*)username withPassword:(NSString*)password withMobile:(NSString*)mobile withRegIp:(NSString*)regIp
{
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/auth/register/"];
    
    //username,password,mobile,reg_ip
    NSDictionary*parameters=@{@"username":username,@"password":password,@"mobile":mobile,@"reg_ip":regIp};
    
    [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"JSON:%@",responseObject);
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         NSLog(@"Error:%@",error);
     }];
    
    
}


//登陆请求
+(void)loginRequest:(NSString*)name with:(NSString*)pas complete:(void(^)(NSString*fail))complete
{
    NSLog(@"登陆请求");
    NSLog(@"账户--%@,密码---%@",name,pas);
    
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    
    NSString *str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/api-token-auth/"];
    
    NSDictionary*parameters=@{@"username":name,@"password":pas};
    [manager POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSString*str=responseObject[@"token"];
         
         [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"TOKEN_KEY"];
         complete(@"succese");
         
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         complete(@"fail");
         NSLog(@"Error: %@", error);
     }];
    
}

//获取用户详细信息
+(void)getConsumerData:(void(^)(NSArray*dataArray))complete
{
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    AFHTTPSessionManager*magager=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/users/userinfo/"];
    [magager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    [magager GET:str parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         //NSLog(@"JSON:%@",responseObject);
         NSString*idStr=responseObject[@"id"];
         
         [[NSUserDefaults standardUserDefaults]setObject:idStr forKey:@"ID"];
         
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
    
}

//获取用户资料
+(void)getConsumerDetailData:(NSString*)idStr completion:(void(^)(NSArray*dataArray))complete
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-info/%@/",idStr];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    NSMutableArray*dataArray=[[NSMutableArray alloc]init];
    [session GET:str parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"JSON:%@",responseObject);
         ConsumerDetail*consumer=[[ConsumerDetail alloc]init];
         consumer.userid=responseObject[@"userid"];
         consumer.uniqueid=responseObject[@"uniqueid"];
         //将uniqueid存入本地
         // [[NSUserDefaults standardUserDefaults]setObject:consumer.userid forKey:@"UNIQUEID"];
         consumer.realName=responseObject[@"real_name"];
         consumer.gender=responseObject[@"gender"];
         consumer.birthday=responseObject[@"birthday"];
         [dataArray addObject:consumer];
         complete(dataArray);
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
    
}
//我的订单
+(void)myOrder:(NSString*)full with:(NSString*)page with:(NSString*)pageSize with:(NSString*)status completion:(void(^)(NSArray*dataArray))complete
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
   // NSLog(@"pageSize==%@",pageSize);
    
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    NSString*uniqueidStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
    
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/orders/"];
    
    NSDictionary*parameters=[[NSDictionary alloc]init];
    
    if ([status isEqualToString:@""])
    {
        parameters=@{@"uniqueid":uniqueidStr,@"full":full,@"page":page,@"page_size":pageSize};
    }
    else
    {
        parameters=@{@"uniqueid":uniqueidStr,@"full":full,@"page":page,@"page_size":pageSize,@"status":status};
    }
    
    [session GET:str parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         
         NSArray*array=responseObject[@"data"];
         //NSLog(@"array====%@",array);
         
         
         complete(array);
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
    
    
}

//订单详细
+(void)detailOrder:(NSString*)idStr completion:(void(^)(NSDictionary*dataDic))complete
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/orders/%@/",idStr];
    
    
    [session GET:str parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSDictionary*dic=responseObject;
         NSLog(@"dic====%@",dic);
         complete(dic);
         
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
    
    
}

//订单提交
+(void)submitOrderAddressId:(NSString*)addressId withMethod:(NSString*)method withSpaypassword:(NSString*)spaypassword withCouponNo:(NSString*)couponNo
{
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/orders/"];
    
    NSLog(@"spaypassword==%@",spaypassword);
    NSDictionary*parameters=@{@"address_id":addressId,@"method":method,@"spaypassword":spaypassword,@"coupon_no":couponNo};
    
    [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         // NSLog(@"JSON:%@",responseObject);
         NSString*str=responseObject;
         NSLog(@"str==%@",str);
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         NSLog(@"Error:%@",error);
     }];
}

//微信支付
+(void)WXsendPay
{
    
    
    
    //调起微信支付
    //                PayReq* req             = [[PayReq alloc] init];
    //                req.openID              = @"oUpF8uMuAJO_M2pxb1Q9zNjWeS6o";
    //                req.partnerId           = @"wxf454e1c4757a9d2b";
    //                req.prepayId            = @"201514926";
    //                req.nonceStr            = @"5K8264ILTKCH16CQ2502SI8ZNMTM67VS";
    //                req.timeStamp
    //                req.package
    //                req.sign
    //                [WXApi sendReq:req];
    //  "_OBJC_CLASS_$_CMMotionManager", referenced from:
    
    
    
}




//编辑个人资料
+(void)updataConsumerDetailData:(NSString*)realNameStr with:(NSString*)genderStr with:(NSString*)birthdayStr
{
    //    NSLog(@"realNameStr=%@,genderStr=%@,birthdayStr=%@",realNameStr,genderStr,birthdayStr);
    
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    
    NSString*idStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-info/%@/",idStr];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    NSDictionary*parameters=@{@"real_name":realNameStr,@"gender":genderStr,@"birthday":birthdayStr};
    
    [manager PUT:str parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"JSON:%@",responseObject);
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
    
}

//地址列表
+(void)getAddress:(void(^)(NSArray*dataArray))complete
{
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-address/"];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    [session GET:str parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"JSON:%@",responseObject);
         NSMutableArray*dataArray=[[NSMutableArray alloc]init];
         NSArray*array=responseObject;
         for (int i=0; i<array.count; i++)
         {
             NSDictionary*dic=array[i];
             AllAdress*adress=[AllAdress ConsumerDetailDictionary:dic];
             [dataArray addObject:adress];
         }
         complete(dataArray);
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         NSLog(@"Error:%@",error);
     }];
    
    
}
//地址编辑
+(void)changeAddress:(NSString*)addressId Consignee:(NSString*)consignee withPhoneMob:(NSString*)phoneMob withProvince:(NSString*)province withCity:(NSString*)city withTown:(NSString*)town withAddress:(NSString*)address
{
    
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-address/%@/",addressId];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    //consignee，phone_mob，province，city，town，address
    
    NSDictionary*parameters=@{@"consignee":consignee,@"phone_mob":phoneMob,@"province":province,@"city":city,@"town":town,@"address":address};
    
    [manager PUT:str parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"JSON:%@",responseObject);
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
    
}
//增加地址
+(void)addAdressConsignee:(NSString*)consignee withPhoneMob:(NSString*)phoneMob withProvince:(NSString*)province withCity:(NSString*)city withTown:(NSString*)town withAddress:(NSString*)address
{
    
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-address/"];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    NSDictionary*parameters=@{@"consignee":consignee,@"phone_mob":phoneMob,@"province":province,@"city":city,@"town":town,@"address":address};
    
    [manager POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"JSON:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
}
//地址删除
+(void)deleteAddress:(NSString*)addrId
{
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-address/%@/",addrId];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    [session DELETE:str parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         
         
         NSLog(@"购物车 JSON:%@",responseObject);
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
}
//设置默认收货地址
+(void)defaultAddress:(NSString*)addrId
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-address/%@/",addrId];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    [session PUT:str parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         
     }];
    
    
}

//我的红包
+(void)getRedBagStatus:(NSString*)status completion:(void(^)(NSArray*dataArray))complete;
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    NSString*str=@"http://hjapi.baiwei.org/member-coupon/";
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    NSDictionary*parameters=@{@"status":status};
    
    [session GET:str parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"购物车 JSON:%@",responseObject);
         NSArray*array=responseObject;
         complete(array);
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
    
    
}

//花集余额
+(void)getBalance:(void(^)(NSDictionary*dic))complete
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    NSString*idStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-bill/%@/",idStr];
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    [session GET:str parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"购物车 JSON:%@",responseObject);
         NSDictionary*dic=responseObject;
         NSLog(@"dic===%@",dic);
         complete(dic);
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
}
//amount,method
//花集余额充值
+(void)topUpAmount:(NSString*)amount withMethod:(NSString*)method
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    NSString*idStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-bill/%@/wireIn/",idStr];
    
    NSDictionary*parameters=@{@"amount":amount,@"method":method};
    
    [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         NSLog(@"JSON:%@",responseObject);
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         NSLog(@"Error:%@",error);
     }];
}
@end
