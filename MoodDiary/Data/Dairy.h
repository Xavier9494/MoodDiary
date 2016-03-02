//
//  Dairy.h
//  心情日记
//
//  Created by qianfeng on 16/2/25.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dairy : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * location;

@end
