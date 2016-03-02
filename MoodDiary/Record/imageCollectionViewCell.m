//
//  imageCollectionViewCell.m
//  小心情
//
//  Created by qianfeng on 16/2/23.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import "imageCollectionViewCell.h"

@implementation imageCollectionViewCell

-(void)layoutSubviews
{
    [self.contentView addSubview:self.cellImageView];
    CGRect tRect = CGRectZero;
    tRect.size = self.contentView.bounds.size;
    self.cellImageView.frame = tRect;
    self.cellImageView.contentMode = UIViewContentModeScaleToFill;
}

-(UIImageView *)cellImageView
{
    if (_cellImageView == nil) {
        _cellImageView = [[UIImageView alloc]init];
    }
    return _cellImageView;
}

@end
