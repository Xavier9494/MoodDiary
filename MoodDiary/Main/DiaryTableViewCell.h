//
//  DiaryTableViewCell.h
//  心情日记
//
//  Created by qianfeng on 16/2/26.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iImageView;
@property (weak, nonatomic) IBOutlet UILabel *iTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *iTimeLabel;

@end
