//
//  HttpEngine.m
//  HJApp
//
//  Created by Bruce He on 15/10/30.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "HttpEngine.h"
#import "NSString+Encryption.h"

@implementation HttpEngine

//定位城市
+(void)convertCityName:(NSString *)lat withLng:(NSString *)lng complete:(void (^)(NSDictionary *dataDic))complete failure:(void (^)(NSError * error))failure
{
    //MBProgressHUD *hud = [BWCommon getHUD];
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/location/convert/"];
    
    [session GET:str parameters:@{@"latitude":lat,@"longitude":lng} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         //NSLog(@"JSON:%@",responseObject);
         NSDictionary *dict=responseObject;
         complete(dict);
         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        failure(error);
        NSLog(@"location Error:%@",error);
    }];
    
}
//获取城市
+(void)getCityNameBackcompletion:(void(^)(NSArray*dataArray))complete
{
    
    MBProgressHUD *hud = [BWCommon getHUD];
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/location/full/"];
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [hud removeFromSuperview];
         //NSLog(@"JSON:%@",responseObject);
         NSArray*array=responseObject;
         complete(array);
         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        [hud removeFromSuperview];
        NSLog(@"Error:%@",error);
    }];
    
}

//广告图
+(void)getPictureWithTime:(NSString*)time with:(void(^)(NSArray*dataArray))complete
{
    MBProgressHUD *hud = [BWCommon getHUD];
    NSDate *now = [NSDate date];
    NSDateFormatter *dformat = [[NSDateFormatter alloc] init];
    [dformat setDateFormat:@"YYYY-MM-dd%20HH:mm"];
    
    NSString *now_str = [dformat stringFromDate:now];
    
    NSString*code=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    NSString*str;
    if ([time isEqualToString:@"NO"])
    {
       str=@"http://hjapi.baiwei.org/advertisement/";
    }
    else
    {
       str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/advertisement/?ordering=-sort_order&start_date=%@&end_date=%@&location=%@",now_str,now_str,code];
        NSLog(@"str====%@",str);
    }
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
    {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud removeFromSuperview];
        //NSLog(@"广告的JSON:%@",responseObject);
        
        NSArray*array=responseObject[@"results"];
        NSMutableArray*dataArray=[[NSMutableArray alloc]init];
        for (int i=0; i<array.count; i++)
        {
            NSDictionary*dic=array[i];
            GetPic*getPic=[GetPic getPicWithDictionary:dic];
            [dataArray addObject:getPic];
        }
        complete(dataArray);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        [hud removeFromSuperview];
         NSLog(@"广告的Error:%@",error);
    }];
}
//花集公告
+(void)getNotifition:(void(^)(NSArray*dataArray))complete
{
    NSString*code=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/article/?ordering=-date_created&article_type=1&location=%@",code];
    
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        //NSLog(@"JSON===:%@",responseObject);
        NSArray*array=responseObject[@"results"];
        NSMutableArray*dataArray=[[NSMutableArray alloc]init];
        for (int i=0; i<array.count; i++)
        {
            NSDictionary*dic=array[i];
            HJNotifiton*hj=[HJNotifiton getPicWithDictionary:dic];
            [dataArray addObject:hj];
        }
        complete(dataArray);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
         NSLog(@"Error:%@",error);
    }];
}
//猜你喜欢
+ (void)goodsFeaturedWithLocation:(NSString *)location withPageLimit:(NSString *)pageLimit with:(void(^)(NSArray*dataArray))complete {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *strUrl = @"http://hjapi.baiwei.org/goods/featured/";
    NSDictionary *parameters = @{@"location":location,@"page_limit":pageLimit};
    [manager GET:strUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"cainixihuan===%@",responseObject);
        NSArray *dataArray = responseObject[@"data"];
        complete(dataArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"cainixihuan===%@",error);
        complete(nil);
    }];
    
}

//搜索
+ (void)goodsSearchWithLocation:(NSString *)location withGoodsName:(NSString *)goodsName with:(void(^)(NSArray*dataArray))complete {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    if (token) {
        NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
        [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    }
    
    NSString *strUrl = @"http://hjapi.baiwei.org/goods/search/";
    NSDictionary *parameters = @{@"location":location,@"goods_name":goodsName};
    [manager GET:strUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"search=====%@",responseObject);
        NSArray*array=responseObject[@"data"];
        NSMutableArray *datArray = [[NSMutableArray alloc]init];
        for (int i=0; i<array.count; i++)
        {
            NSDictionary*dic=array[i];
            FlowerDetail*flow=[FlowerDetail getAllFlowerDictionary:dic];
            [datArray addObject:flow];
        }
        complete(datArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        complete(nil);
    }];


}

//意见反馈
+(void)ideaFeedBackName:(NSString*)name withMoblie:(NSString*)moblie withContent:(NSString*)content complete:(void(^)(NSString *error))complete
{

    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/feedback/"];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    NSDictionary*parameters=@{@"name":name,@"mobile":moblie,@"feedback_type":@"1",@"content":content,@"ip":@"192.168.33.259"};
    
    [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"JSON:%@",responseObject);
        complete(nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        NSDictionary *dic = error.userInfo;
        NSString *str = [self errorArrayData:dic withKey:@"mobile"];
        complete(str);
    }];

}

//商务合作
+(void)cooperateName:(NSString*)name withMoblie:(NSString*)moblie withEmail:(NSString*)email withDanWei:(NSString*)danWei withOther:(NSString*)other withIp:(NSString *)ip complete:(void(^)(NSString *error))complete
{
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/feedback/"];
    NSDictionary*parameters=@{@"name":name,@"mobile":moblie,@"email":email,@"company":danWei,@"content":other,@"feedback_type":@"2",@"ip":ip};
    
    [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"JSON:%@",responseObject);
        complete(nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        NSDictionary *dic = error.userInfo;
        NSString *str = [self errorArrayData:dic withKey:@"mobile"];
        complete(str);
    }];

}

//产品分类
+(void)getAllFlower:(void(^)(NSArray*dataArray))complete
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/goods-categories/"];
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"产品分类JSON:%@",responseObject);
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);

    }];

    
}
//获取分类属性
+(void)getProduct:(NSString*)idStr completion:(void(^)(NSArray*dataArray))complete
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/goods-categories/%@/props/",idStr];
    
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"分类属性JSON:%@",responseObject);
        NSArray*array=responseObject;
        NSMutableArray*dataArray=[[NSMutableArray alloc]init];
        for (int i=0; i<array.count; i++)
        {
            NSDictionary*dic=array[i];
            FlowerCatalogue*flower=[FlowerCatalogue getCatalogueDictionary:dic];
            [dataArray addObject:flower];
        }
        complete(dataArray);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];

    
}

//获取产品
+(void)getProductDetail:(NSString*)idStr withLocation:(NSString*)location withProps:(NSArray*)props withPage:(NSString*)page withPageSize:(NSString*)pageSize completion:(void(^)(NSArray*dataArray))complete
{
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    NSString*login=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    if (login)
    {
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    }
    
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/goods/search/"];
    
    NSDictionary*parameters=[[NSDictionary alloc]init];
    if (props.count==0)
    {
        parameters=@{@"category_id":idStr,@"location":location,@"page":page,@"page_size":pageSize};
    }
    else
    {
        parameters=@{@"category_id":idStr,@"location":location,@"page":page,@"page_size":pageSize,@"props":props};
    }
    //NSLog(@"parameters===%@",parameters);
    NSMutableArray*datArray=[[NSMutableArray alloc]init];
    
    MBProgressHUD *hud = [BWCommon getHUD];

    [session GET:str parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud removeFromSuperview];
        //NSLog(@"分类产品  JSON:%@",responseObject);
        NSArray*array=responseObject[@"data"];
        for (int i=0; i<array.count; i++)
        {
            NSDictionary*dic=array[i];
            FlowerDetail*flow=[FlowerDetail getAllFlowerDictionary:dic];
            //NSLog(@"~~~~~%@",dic);
            [datArray addObject:flow];
        }
        complete(datArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        [hud removeFromSuperview];
    }];

    
}

//购物车列表
+(void)getCart:(void(^)(NSDictionary*allDic,NSArray*dataArray,NSString*totalPrice,NSString*shippingFee,NSString*paymentPrice,NSString*error))complete
{
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/cart/checkout/"];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    
    NSString*location=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    str = [NSString stringWithFormat:@"%@?location=%@",str,location];
    //NSLog(@"%@",str);
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"123==JSON:%@",responseObject);
        NSArray*array=responseObject[@"cart_list"];
        NSMutableArray*dataArray=[[NSMutableArray alloc]init];
        for (int i=0; i<array.count; i++)
        {
            NSDictionary*dic=array[i];
            ShopingCarDetail*shCa=[ShopingCarDetail ConsumerDetailDictionary:dic];
            [dataArray addObject:shCa];
        }
        complete(responseObject,dataArray,responseObject[@"total_price"],responseObject[@"shipping_fee"],responseObject[@"payment_price"],@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"checkout== Error:%@",error);
        
//        NSDictionary*userInfo=error.userInfo;
//        NSString*errorStr=[self errorData:userInfo];
//        complete(nil,nil,@"",@"",@"",errorStr);
    }];

    
    
}
//购物车列表
+(void)getSimpleCart:(void(^)(NSArray*array))complete
{

    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/cart/"];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    NSString*location=[[NSUserDefaults standardUserDefaults]objectForKey:@"CODE"];
    str = [NSString stringWithFormat:@"%@?location=%@",str,location];
    
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"123购物车==JSON:%@",responseObject);
        //skuName,*price,*number
        
        NSArray*array=responseObject;
        NSMutableArray*dataArray=[[NSMutableArray alloc]init];
        for (int i=0; i<array.count; i++)
        {
            NSDictionary*dic=array[i];
            ShopingCar*shCa=[ShopingCar ConsumerDetailDictionary:dic];
            [dataArray addObject:shCa];
        }
        complete(dataArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"checkout== Error:%@",error);
    }];


}
//增加商品
+(void)addGoodsLocation:(NSString*)location withSku:(NSString*)sku withSupplier:(NSString*)supplier withNumber:(NSString*)number complete:(void(^)(NSString *error,NSString *errorStr))complete
{
    MBProgressHUD *hud = [BWCommon getHUD];
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/cart/"];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
 NSDictionary*parameters=@{@"location":location,@"sku":sku,@"supplier":supplier,@"number":number};
    
    NSLog(@"parameters=====%@",parameters);
    
    [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"JSON:%@",responseObject);
        [hud removeFromSuperview];
        complete(nil,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud removeFromSuperview];
        NSDictionary *dic = error.userInfo;
        NSString *str=[HttpEngine errorData:dic withKey:@"sku"];
        complete(@"error",str);
        NSLog(@"Error:%@",str);
//        NSLog(@"dic====%@",dic);
//        NSLog(@"Error:%@",error);
    }];
}

//发送短信
+(void)sendMessageMoblie:(NSString*)mobliePhone  withKind:(int)tag
{
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    NSLog(@"mobliePhone==%@",mobliePhone);
    NSString *str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/sms/send/"];
    NSString*srt=@"";
    for (int i=0; i<6; i++)
    {
        int num=arc4random()%10;
        srt=[NSString stringWithFormat:@"%@%d",srt,num];
        NSLog(@"srtsrtsrt=====%@",srt);
    }
    NSString*message;
    if (tag==1)
    {
        [[NSUserDefaults standardUserDefaults]setObject:srt forKey:@"TEXTNUM"];
        message=[NSString stringWithFormat:@"欢迎您注册花集网会员。注册验证码：%@，三十分钟内有效。",srt];
    }
    if (tag==2)
    {
        [[NSUserDefaults standardUserDefaults]setObject:srt forKey:@"LPASSWORD"];
        message=[NSString stringWithFormat:@"亲爱的用户，您提交了找回登陆密码申请，验证码：%@，30分钟内有效。",srt];
    }
    
    
    NSString*pinjie=[NSString stringWithFormat:@"%@|%@|Zaq1Xsw2",mobliePhone,message];
    NSString*token=[pinjie MD5];
    NSDictionary*parameters=@{@"mobile":mobliePhone,@"message":message,@"token":token};
    
    [manager POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"12345Error: %@", error);
    }];

    
}
//查询手机号是否存在
+(void)checkUserPhone:(NSString*)phone with:(void(^)(NSString*existe))complete
{
    
    AFHTTPSessionManager*magager=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/auth/queryUser/"];
    NSString*nameStr=phone;
    NSDictionary*parameters=@{@"username":nameStr};

    [magager GET:str parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"JSON:%@",responseObject);
        complete(@"true");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        NSDictionary*userInfo=error.userInfo;
    NSData*data=userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString*str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"str====%@",str);
        complete(@"false");
    }];

}

+(void)queryUser:(NSString *)username with:(void (^)(NSDictionary * dict))complete failure:(void (^)(NSString *))failure{
    
    AFHTTPSessionManager*magager=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/auth/queryUser/"];

    NSDictionary*parameters=@{@"username":username};
    [magager GET:str parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"JSON:%@",responseObject);
        complete(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        NSDictionary*userInfo=error.userInfo;
        NSString *errorStr = [self errorData:userInfo withKey:@"msg"];
        failure(errorStr);
    }];

}

//用户注册
+(void)registerRequestPassword:(NSString*)password withMobile:(NSString*)mobile withRegIp:(NSString*)regIp withFlorist:(NSString*)isFlorist complete:(void(^)(NSString*fail))complete;
{
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];

    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/auth/register/"];
    NSString*username=[NSString stringWithFormat:@"hj_%@",mobile];
    
    //username,password,mobile,reg_ip
    NSDictionary*parameters=@{@"username":username,@"password":password,@"mobile":mobile};
    
    NSLog(@"parameters ==  %@",parameters);
    
    [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"JSON:%@",responseObject);
        complete(@"true");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        NSDictionary*dic=error.userInfo;
        NSData*data=dic[@"com.alamofire.serialization.response.error.data"];
        NSString*strr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"strr====%@",strr);
        complete(@"flase");
    }];

    
}


//登陆请求
+(void)loginRequest:(NSString*)name with:(NSString*)pas complete:(void(^)(NSString*fail))complete
{
//    NSLog(@"登陆请求");
//    NSLog(@"账户--%@,密码---%@",name,pas);
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    NSString *str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/api-token-auth/"];
    NSDictionary*parameters=@{@"username":name,@"password":pas};
    
    [manager POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"登录JSON: %@", responseObject);
        NSString*str=responseObject[@"token"];
        [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"TOKEN_KEY"];
        [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"NAME"];
        complete(nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"Error: %@", error);
        NSDictionary *dic = error.userInfo;
        NSString *str = [self errorArrayData:dic withKey:@"non_field_errors"];
        complete(str);
    }];
}

//修改密码
+(void)momodifyPasswordUser:(NSString*)user withPassword:(NSString*)password complete:(void(^)(NSString*fail))complete;
{

    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/auth/password/"];
    NSString*username=user;
    
    NSDate *localDate = [NSDate date]; //获取当前时间
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]];
    NSString*pinjie=[NSString stringWithFormat:@"%@|%@|Zaq1Xsw2",username,timeSp];
    NSString*token=[pinjie MD5];
    //username,password,mobile,reg_ip
    NSDictionary*parameters=@{@"username":username,@"password":password,@"time":timeSp,@"token":token};
    NSLog(@"parameters ==  %@",parameters);
    
    [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"JSON:%@",responseObject);
        complete(@"true");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        NSDictionary*dic=error.userInfo;
        NSData*data=dic[@"com.alamofire.serialization.response.error.data"];
        NSString*strr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"strr====%@",strr);
        complete(@"flase");
    }];

}

//获取用户详细信息
+(void)getConsumerData:(void(^)(NSDictionary*dataDic))complete
{
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    AFHTTPSessionManager *magager=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/users/userinfo/"];
    [magager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    [magager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"个人信息＝＝JSON:%@",responseObject);
        NSString* idStr =responseObject[@"id"];
        [[NSUserDefaults standardUserDefaults]setObject:idStr forKey:@"ID"];
        complete(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"Error:%@",error);
        complete(nil);
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
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"JSON:%@",responseObject);
        ConsumerDetail*consumer=[[ConsumerDetail alloc]init];
        consumer.userid=responseObject[@"userid"];
        consumer.uniqueid=responseObject[@"uniqueid"];
        //将uniqueid存入本地
        // [[NSUserDefaults standardUserDefaults]setObject:consumer.userid forKey:@"UNIQUEID"];
        consumer.realName=responseObject[@"real_name"];
        consumer.gender=responseObject[@"gender"];
        consumer.birthday=responseObject[@"birthday"];
        consumer.mobile=responseObject[@"mobile"];
        consumer.portrait=responseObject[@"portrait"];
        [dataArray addObject:consumer];
        complete(dataArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error:%@",error);
    }];

    
}
//我的订单
+(void)myOrder:(NSString*)full with:(NSString*)page with:(NSString*)pageSize with:(NSString*)status completion:(void(^)(NSArray*dataArray))complete
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
   // NSLog(@"pageSize==%@",pageSize);
    
    MBProgressHUD *hud = [BWCommon getHUD];
    
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
    
    [session GET:str parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray*array=responseObject[@"data"];
        //NSLog(@"array====%@",array);
        
        [hud removeFromSuperview];
        complete(array);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud removeFromSuperview];
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
    
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary*dic=responseObject;
        //NSLog(@"dic====%@",dic);
        complete(dic);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error:%@",error);
    }];
    
    
}
//再次购买
+(void)anginBuy:(NSString*)order
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/orders/%@/reorder/",order];
    
    [session POST:str parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
        //NSLog(@"Agin==JSON:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Agin==Error:%@",error);
    }];
    
}

//订单提交
+(void)submitOrderMethod:(NSString*)method withSpaypassword:(NSString*)spaypassword withDeadline:(NSString *)deadline withCouponNo:(NSString*)couponNo withCustMessage:(NSString *)CustMessage withSelfPickup:(NSString *)selfPickup withAddressId:(NSString*)addressId withConsignee:(NSString *)consignee withProvince:(NSString *)province withCity:(NSString *)city withTown:(NSString *)town withPhoneMob:(NSString *)phoneMob withAddress:(NSString *)address completion:(void(^)(NSDictionary*dict))complete
{
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/orders/"];
    NSDictionary*parameters;
    parameters = @{@"method":method,@"spaypassword":spaypassword,@"deadline":deadline,@"coupon_no":couponNo,@"cust_message":CustMessage,@"self_pickup":selfPickup,@"address_id":addressId,@"consignee":consignee,@"province":province,@"city":city,@"town":town,@"phone_mob":phoneMob,@"address":address};
    
    NSLog(@"parameters==%@",parameters);
    
    [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSLog(@"responseObject===%@",responseObject);
        NSDictionary*dic=responseObject;
        complete(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
}
//订单支付
+(void)payOrderNum:(NSString*)num withSpaypassword:(NSString*)spaypassword withMethod:(NSString*)method withCoupon:(NSString*)couponNo Completion:(void(^)(NSString*orderNo,NSString*price))complete
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/orders/%@/pay/",num];
    NSDictionary*parameter=[[NSDictionary alloc]init];
    if ([method isEqualToString:@"huaji"])
    {
        parameter=@{@"method":method,@"spaypassword":spaypassword,@"coupon_no":couponNo};
    }
    else
    {
        parameter=@{@"method":method,@"spaypassword":@"",@"coupon_no":couponNo};
    }

    [session POST:str parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSLog(@"JSON:%@",responseObject);
        complete(responseObject[@"out_trade_no"],responseObject[@"payment_price"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"Error:%@",error);
    }];
}

//编辑个人资料
+(void)updataConsumerDetailData:(NSString*)realNameStr with:(NSString*)genderStr with:(NSString*)birthdayStr completion:(void (^)(NSString *))completion
{
        NSLog(@"realNameStr=%@,genderStr=%@,birthdayStr=%@",realNameStr,genderStr,birthdayStr);
    
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    
    NSString*idStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-info/%@/",idStr];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    NSDictionary*parameters=@{@"real_name":realNameStr,@"gender":genderStr,@"birthday":birthdayStr};
    
    NSLog(@"parameters===%@",parameters);
    
    [manager PUT:str parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         //NSLog(@"JSON:%@",responseObject);
         completion(@"succe");
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
         completion(@"error");
     }];
    
}

//上传图片
+(void)uploadPicData:(UIImage*)image
{
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    NSString*idStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-info/%@/avatar/",idStr];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"image====%@",image);
    
    //NSData *data = UIImagePNGRepresentation(image);
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *strr = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", strr];

    [manager POST:str parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
      [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
      
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       //NSLog(@"pic===JSON:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
    
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"JSON:%@",responseObject);
        NSMutableArray*dataArray=[[NSMutableArray alloc]init];
        NSArray*array=responseObject;
        for (int i=0; i<array.count; i++)
        {
            NSDictionary*dic=array[i];
            AllAdress*adress=[AllAdress ConsumerDetailDictionary:dic];
            [dataArray addObject:adress];
        }
        complete(dataArray);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
         //NSLog(@"bijiJSON:%@",responseObject);
         
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"bijiError:%@",error);
     }];
    
}
//增加地址
+(void)addAdressConsignee:(NSString*)consignee withPhoneMob:(NSString*)phoneMob withProvince:(NSString*)province withCity:(NSString*)city withTown:(NSString*)town withAddress:(NSString*)address completion:(void(^)(NSString *str))completion
{
    
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-address/"];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    [manager.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    NSDictionary*parameters=@{@"consignee":consignee,@"phone_mob":phoneMob,@"province":province,@"city":city,@"town":town,@"address":address};
    NSLog(@"parameters====%@",parameters);
    [manager POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"新增JSON:%@",responseObject);
        completion(@"succe");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        completion(@"error");
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
         
         
         //NSLog(@"购物车 JSON:%@",responseObject);
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
     {
         NSLog(@"Error:%@",error);
     }];
}
//设置默认收货地址
+(void)setDefaultAddress:(NSString*)addrId
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-address/%@/",addrId];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    NSDictionary*parameters=@{@"default_flag":@"1"};
    
    NSLog(@"parameters====%@",parameters);
    NSLog(@"strstrstr====%@",str);
    [session PUT:str parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject)
     {
         //NSLog(@"设置默认地址＝＝JSON:%@",responseObject);
     } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
         NSLog(@"设置默认地址===Error:%@",error);
     }];
}
//获取默认收货地址
+(void)getDefaultAddress:(void(^)(NSDictionary*dataDic))complete
{

    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-address/default/"];
    
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"默认地址－－JSON:%@",responseObject);
        complete(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error:%@",error);
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
    
    [session GET:str parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"购物车 JSON:%@",responseObject);
        NSArray*array=responseObject;
        complete(array);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        complete(nil);
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
    
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"JSON:%@",responseObject);
        NSDictionary*dic=responseObject;
        //NSLog(@"dic===%@",dic);
        complete(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error:%@",error);
        complete(nil);
    }];
}
//amount,method
//花集余额充值
+(void)topUpAmount:(NSString*)amount withMethod:(NSString*)method completion:(void(^)(NSDictionary *dict))complete
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    
    NSString*idStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"ID"];
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/member-bill/%@/wireIn/",idStr];
    
    NSDictionary*parameters=@{@"amount":amount,@"method":method};
    
    [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"JSON:%@",responseObject);
        
        complete(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error:%@",error);
    }];
}

+(void)wxPayRequest:(NSString *)out_trade_no completion:(void (^)(NSDictionary *))complete{
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://weixin.huaji.com/app_payment/handle/app.php?out_trade_no=%@",out_trade_no];

    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complete(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error:%@",error);
    }];
    
}

//我的售后
+(void)complainServerPage:(NSString*)page withPageSize:(NSString*)pageSize completion:(void(^)(NSArray*dataArray))complete
{
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/complain/"];
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"售后 JSON:%@",responseObject);
        
        NSMutableArray*dataArray=[[NSMutableArray alloc]init];
        NSArray*resultArray=responseObject[@"results"];
        for (int i=0; i<resultArray.count; i++)
        {
            NSDictionary*dic=resultArray[i];
            ComplainServe*com=[ComplainServe ConsumerDetailDictionary:dic];
            [dataArray addObject:com];
        }
        complete(dataArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
    }];
    
    
}
//消息中心
+(void)messageCentercompletion:(void(^)(NSArray*dataArray))complete
{
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/message/"];
    NSString*token=[[NSUserDefaults standardUserDefaults]objectForKey:@"TOKEN_KEY"];
    NSString*tokenStr=[NSString stringWithFormat:@"JWT %@",token];
    [session.requestSerializer setValue:tokenStr forHTTPHeaderField:@"Authorization"];
    
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"消息 JSON:%@",responseObject);
        complete(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error:%@",error);
    }];

}

//错误数据
+(NSString*)errorData:(NSDictionary*)userInfo withKey:(NSString *)key
{
    NSData*data=userInfo[@"com.alamofire.serialization.response.error.data"];
    //  NSString *errorStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary*dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"Errordic====%@",dic);
    NSString*errorStr=[dic objectForKey:key];
    if (!errorStr) {
        errorStr = dic[@"msg"];
    }
    return errorStr;
}
+(NSString *)errorArrayData:(NSDictionary*)userInfo withKey:(NSString *)key {
    
    NSData*data=userInfo[@"com.alamofire.serialization.response.error.data"];
    NSDictionary*dataDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray*errorArray=dataDic[key];
    NSString *str = errorArray[0];
    return str;
}
//产地来源
+ (void)getAreaDataLocation:(NSString *)location completion:(void(^)(NSArray*dataArray))complete {
    
    AFHTTPSessionManager*session=[AFHTTPSessionManager manager];
    NSString*str=[NSString stringWithFormat:@"http://hjapi.baiwei.org/goods/suppliers/"];
    NSDictionary *parameters= @{@"location":location};
    [session GET:str parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"产地 JSON:%@",responseObject);
        complete(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"Error:%@",error);
        complete(nil);
    }];
}
@end
