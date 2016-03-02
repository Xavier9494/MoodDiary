//
//  CommonDefine.h
//  小心情
//
//  Created by Xavier on 16-2-22.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#ifndef ____CommonDefine_h
#define ____CommonDefine_h

#define kScreenRect [UIScreen mainScreen].bounds
#define kScreenSize kScreenRect.size
#define kScreenWidth kScreenSize.width
#define kScreenHeight kScreenSize.height

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define DOCUMENT_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject
#define DBPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"db.sqlite"]
#define DIARY_IMAGE_PATH [DOCUMENT_PATH stringByAppendingPathComponent:@"diaryImage"]

#endif
