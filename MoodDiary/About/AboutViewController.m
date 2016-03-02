//
//  AboutViewController.m
//  心情日记
//
//  Created by qianfeng on 16/2/29.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutFunctionViewController.h"
#import "AboutVersionViewController.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray * dataSource;
@end

@implementation AboutViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    self.dataSource = [[NSMutableArray alloc]initWithObjects:
                       @"功能介绍",
                       @"版本详情",nil];
}

-(void)configTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        AboutFunctionViewController * funcVc = [[AboutFunctionViewController alloc]init];
        [self.navigationController pushViewController:funcVc animated:YES];
    }else if(indexPath.item == 1){
        AboutVersionViewController * versionVc = [[AboutVersionViewController alloc]init];
        [self.navigationController pushViewController:versionVc animated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.dataSource[indexPath.item];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
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
