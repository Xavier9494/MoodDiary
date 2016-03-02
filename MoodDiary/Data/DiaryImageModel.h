//
//  DiaryImageModel.h
//  心情日记
//
//  Created by qianfeng on 16/2/26.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DiaryImageModel : NSObject<NSCoding>

@property(nonatomic,strong) NSString * imageName;
@property(nonatomic,strong) UIImage * image;
@property(nonatomic,strong) UIImage * thumbnail;

@end
