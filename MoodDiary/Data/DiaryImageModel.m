//
//  DiaryImageModel.m
//  心情日记
//
//  Created by qianfeng on 16/2/26.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import "DiaryImageModel.h"

@implementation DiaryImageModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.imageName forKey:@"imageName"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    [aCoder encodeObject:self.image forKey:@"image"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
        self.imageName = [aDecoder decodeObjectForKey:@"imageName"];
        self.thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
    }
    return self;
}

@end
