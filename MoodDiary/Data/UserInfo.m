//
//  UserInfo.m
//  心情日记
//
//  Created by Xavier on 16-2-28.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+(id)sharedUserInfo
{
    static UserInfo * userInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[self alloc]init];
    });
    return userInfo;
}

#pragma mark NSCoding Protocol

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.state = [aDecoder decodeIntegerForKey:@"state"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.isAutoLogin = [aDecoder decodeBoolForKey:@"isAutoLogin"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.state forKey:@"state"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeBool:self.isAutoLogin forKey:@"isAutoLogin"];
}

@end
