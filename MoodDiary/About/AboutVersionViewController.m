//
//  AboutVersionViewController.m
//  心情日记
//
//  Created by qianfeng on 16/2/29.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import "AboutVersionViewController.h"

@interface AboutVersionViewController ()
@property(nonatomic,strong) UITextView * textView;
@end

@implementation AboutVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView = [[UITextView alloc]init];
    self.textView.frame = self.view.bounds;
    self.textView.editable = NO;
    self.textView.font = [UIFont systemFontOfSize:13];
    self.textView.textColor = [UIColor darkGrayColor];
    
    self.textView.text = @"2016年2月29号 发布Verson 1.0\n\
    功能:图文排布，模糊搜索，位置定位，登陆备份暂未实现\n";
    
    [self.view addSubview:self.textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
