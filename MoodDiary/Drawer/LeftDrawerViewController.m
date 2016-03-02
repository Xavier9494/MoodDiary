//
//  LeftDrawerViewController.m
//  心情日记
//
//  Created by Xavier on 16-2-28.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import "CommonDefine.h"

#import "TextWithImageModel.h"
#import "LeftDrawerViewController.h"
#import "LeftDrawerTableViewCell.h"
#import "AboutViewController.h"
#import "MMDrawerController.h"

@interface LeftDrawerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation LeftDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //[self configBackgroudImage:@"left_drawer_back_mode_night"];
    [self configBackgroudImage:@"left_drawer_back_mode_sun" alpha:0.3];
    
    [self loadData];
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMDrawerController * drawerVc =  (MMDrawerController *)self.parentViewController;
    UINavigationController * navVc = (UINavigationController *)drawerVc.centerViewController;
    
    if (indexPath.item == 0) {
        
    }else if(indexPath.item == 1){
        
    }else if(indexPath.item == 2){
        
    }else if(indexPath.item == 3){
        AboutViewController * aboutVc = [[AboutViewController alloc]init];
        [navVc pushViewController:aboutVc animated:NO];
    }
    
    [drawerVc closeDrawerAnimated:YES completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftDrawerTableViewCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    TextWithImageModel * model = self.dataSource[indexPath.item];
    cell.cellImageView.image = [UIImage imageNamed:model.image];
    cell.cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.cellTextLabel.text = model.text;
    cell.cellTextLabel.textColor = [UIColor whiteColor];
    UIView * tView = [[UIView alloc]initWithFrame:cell.bounds];
    tView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    cell.selectedBackgroundView = tView;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

#pragma mark Config UI

-(void)configTableView
{
    [self.view addSubview:self.tableView];
    self.tableView.frame = kScreenRect;
    [self.tableView registerNib:[UINib nibWithNibName:@"LeftDrawerTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

#pragma mark Load Data

-(void)loadData
{
    NSArray * textArray = @[@"应用设置",@"信息备份",@"外观",@"关于我们"];
    NSArray * imageArray = @[@"option",@"cloudy",@"night2",@"about"];
    for (int i =0; i<4; i++) {
        TextWithImageModel * model = [[TextWithImageModel alloc]init];
        model.text = textArray[i];
        model.image = imageArray[i];
        [self.dataSource addObject:model];
    }
}

#pragma mark lazy load

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
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
