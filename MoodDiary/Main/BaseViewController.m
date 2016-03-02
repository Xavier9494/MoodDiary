//
//  BaseViewController.m
//  心情日记
//
//  Created by Xavier on 16-2-28.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property(nonatomic,strong) UIImageView * backView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)configBackgroudImage:(NSString *)imagePath  alpha:(CGFloat)alpha
{
    if (self.backView == nil) {
        UIImage * image = [UIImage imageNamed:imagePath];
        self.backView = [[UIImageView alloc]initWithImage:image];
        self.backView.frame = self.view.bounds;
        self.backView.alpha = alpha;
        [self.view insertSubview:self.backView atIndex:0];
    }else{
        self.backView.image = [UIImage imageNamed:imagePath];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
