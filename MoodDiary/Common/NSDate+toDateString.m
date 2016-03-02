//
//  NSDate+toDateString.m
//  心情日记
//
//  Created by qianfeng on 16/2/25.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import "NSDate+toDateString.h"

@implementation NSDate (toDateString)

-(NSString *)toDateString
{
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    return [fmt stringFromDate:self];
}

-(NSString *)toDateStringWithFormat:(NSString *)format
{
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = format;
    return [fmt stringFromDate:self];
}

@end
