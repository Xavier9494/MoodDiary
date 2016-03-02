//
//  NSDate+toDateString.h
//  心情日记
//
//  Created by qianfeng on 16/2/25.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (toDateString)

-(NSString *)toDateString;
-(NSString *)toDateStringWithFormat:(NSString *)format;

@end
