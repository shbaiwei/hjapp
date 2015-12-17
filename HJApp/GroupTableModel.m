//
//  GroupTableModel.m
//  HJApp
//
//  Created by Bruce He on 15/11/25.
//  Copyright © 2015年 shanghai baiwei network technology. All rights reserved.
//

#import "GroupTableModel.h"
#import "DataBaseUtil.h"

@implementation GroupTableModel

//获取对应编号
+(NSMutableArray*)getAllFromMenuTable:(NSString *)str
{

    FMDatabase*db=[DataBaseUtil getDataBase];
    NSLog(@"db====%@",db);
    if (![db open])
    {
        [db close];
        NSLog(@"打开数据库失败");
        return nil;
    }
    NSLog(@"str===%@",str);
    FMResultSet*set=[db executeQuery:@"select * from region where region_name=?",str];
    NSMutableArray*array=[[NSMutableArray alloc]initWithCapacity:0];
    while ([set next])
    {
        AreaModel*area=[[AreaModel alloc]init];
        area.regionId=[set stringForColumn:@"region_id"];
        area.parentId=[set stringForColumn:@"parent_id"];
        [array addObject:area];
        NSLog(@"array===%@==%@===%@",array,area.regionId,area.parentId);
    }
    [set close];
    [db close];
    return array;
    
}

@end
