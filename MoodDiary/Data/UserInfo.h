//
//  UserInfo.h
//  心情日记
//
//  Created by Xavier on 16-2-28.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UserStateNotLogin,
    UserStateAlreadyLogin,
} UserState;

@interface UserInfo : NSObject<NSCoding>

@property(nonatomic,assign) UserState state;
@property(nonatomic,strong) NSString * userName;
@property(nonatomic,strong) NSString * password;
@property(nonatomic,assign) BOOL isAutoLogin;

+(id)sharedUserInfo;

@end
