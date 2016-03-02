//
//  MainTableViewController.m
//  小心情
//
//  Created by Xavier on 16-2-22.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import "DCPathButton.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "MagicalRecord.h"
#import "NSDate+toDateString.h"
#import "Masonry.h"

#import "CommonDefine.h"
#import "Dairy.h"
#import "DiaryTableViewCell.h"
#import "DiaryImageModel.h"
#import "MainTableViewController.h"
#import "EditRecordViewController.h"


@interface MainTableViewController ()<DCPathButtonDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,strong) DCPathButton * dcpb;
@property(nonatomic,strong) UISearchBar * searchBar;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];

}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithTitle:@"结束编辑" style:UIBarButtonItemStylePlain target:self action:@selector(endEdit)];
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithTitle:@"确认删除" style:UIBarButtonItemStylePlain target:self action:@selector(submitDelete)];
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Load Data

-(Dairy *)loadDataWithOffset:(NSInteger)offset
{
    NSFetchRequest * request = [Dairy MR_createFetchRequest];
    NSSortDescriptor * sortor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    request.sortDescriptors = @[sortor];
    request.fetchOffset = offset;
    return [Dairy MR_executeFetchRequestAndReturnFirstObject:request];
    
}

-(NSArray *)searchDataByKey:(NSString *)key
{
    NSFetchRequest * request = [Dairy MR_createFetchRequest];
    NSSortDescriptor * sortor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
    request.sortDescriptors = @[sortor];
    request.predicate = [NSPredicate predicateWithFormat:@"title like %@",[NSString stringWithFormat:@"*%@*",key]];
    return [Dairy MR_executeFetchRequest:request];
}

#pragma mark - Config UI

-(void)configUI
{
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.tableView registerNib:[UINib nibWithNibName:@"DiaryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
    self.tableView.backgroundColor = [UIColor clearColor];
    //[self configBackgroudImage:@"MainBack" alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    self.searchBar.frame = CGRectMake(0, 0, kScreenWidth, 32);
    self.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.contentOffset = CGPointMake(0, 32);
    
    [self configDcpb];
}

-(void)configDcpb
{
    
    DCPathButton *dcPathButton = [[DCPathButton alloc] initWithButtonFrame:CGRectMake(0, 0, 50, 50) centerImage:[UIImage imageNamed:@"menu"] highlightedImage:[UIImage imageNamed:@"menu"]];
    self.dcpb = dcPathButton;
    
    dcPathButton.delegate = self;
    
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"plusSign"]
                                                           highlightedImage:[UIImage imageNamed:@"plusSign"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"lockIcon"]
                                                           highlightedImage:[UIImage imageNamed:@"lockIcon"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    

    
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-sleep"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-sleep-highlighted"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    [dcPathButton addPathItems:@[itemButton_1,
                                 itemButton_2,
                                 itemButton_3
                                 ]];
    
    dcPathButton.bloomRadius = 80.0f;
    dcPathButton.dcButtonCenter = CGPointMake(dcPathButton.bounds.size.width /2 +10, self.view.bounds.size.height - dcPathButton.bounds.size.height/2 -10);
    dcPathButton.bottomViewColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    dcPathButton.allowSounds = YES;
    dcPathButton.allowCenterButtonRotation = YES;
    dcPathButton.bloomDirection = kDCPathButtonBloomDirectionTopRight;
    
    [self.view addSubview:dcPathButton];

}

#pragma mark SearchBar Delegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    UIView * maskView = [[UIView alloc]initWithFrame:kScreenRect];
    maskView.tag = 9999;
    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignSearchBar:)]];
    [self.view insertSubview:maskView belowSubview:searchBar];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [[self.view viewWithTag:9999]removeFromSuperview];
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSArray * result = [self searchDataByKey:searchText];
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:result];
    [self.tableView reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
}



#pragma mark Table view Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        return;
    }
    
    EditRecordViewController * editVc = [[EditRecordViewController alloc]init];
    Dairy * model = [self loadDataWithOffset:indexPath.item];
    editVc.uuid = model.uuid;
    [self.navigationController pushViewController:editVc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Dairy * model = [self loadDataWithOffset:indexPath.item];
        [model MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource.count != 0) {
        return self.dataSource.count;
    }
    else{
        return [[Dairy MR_numberOfEntities] longValue];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(entryEditMode:)]];
    Dairy * model;
    if (self.dataSource.count != 0) {
        model = self.dataSource[indexPath.item];
    }else{
        model = [self loadDataWithOffset:indexPath.item];
    }
    cell.iTitleLabel.text = model.title;
    cell.iTitleLabel.textColor = [UIColor darkGrayColor];
    cell.iTimeLabel.text = [model.time toDateString];
    cell.iTimeLabel.textColor = [UIColor darkGrayColor];

    return cell;
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark DCPathButton delegate

-(void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex
{
    if (itemButtonIndex == 0) {
        EditRecordViewController * erVc = [[EditRecordViewController alloc]init];
        [self.navigationController pushViewController:erVc animated:YES];
    }else if(itemButtonIndex == 1){
        
    }else if(itemButtonIndex == 2){
        
    }
}

#pragma mark action

-(void)endEdit
{
    self.navigationController.navigationBar.hidden = YES;
    [self.tableView setEditing:NO animated:YES];
    
    CGRect tRect = self.tableView.frame;
    tRect.origin.y = 0;
    self.tableView.frame = tRect;
}

-(void)submitDelete
{
    NSArray * targetArray = self.tableView.indexPathsForSelectedRows;

    for (int i = 0; i < targetArray.count; i++) {
        NSIndexPath * indexPath = targetArray[i];
        Dairy * model = [self loadDataWithOffset:indexPath.item];
        [model MR_deleteEntity];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:targetArray withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [self endEdit];
}

-(void)entryEditMode:(UILongPressGestureRecognizer *)ges
{
    self.navigationController.navigationBar.hidden = NO;
    [self.tableView setEditing:YES animated:YES];
    
    CGRect tRect = self.tableView.frame;
    tRect.origin.y = 44;
    self.tableView.frame = tRect;
}

-(void)resignSearchBar:(UITapGestureRecognizer *)ges
{

    [self.searchBar resignFirstResponder];
}

#pragma mark lazy load

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
    }
    return _tableView;
}

-(UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]init];
    }
    return _searchBar;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
