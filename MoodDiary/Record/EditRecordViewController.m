//
//  EditRecordViewController.m
//  小心情
//
//  Created by qianfeng on 16/2/22.
//  Copyright (c) 2016年 Xavier. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "Masonry.h"
#import "ZYQAssetPickerController.h"
#import "MagicalRecord.h"
#import "MBProgressHUD.h"

#import "Dairy.h"
#import "DiaryImageModel.h"

#import "CommonDefine.h"

#import "EditRecordViewController.h"
#import "imageCollectionViewCell.h"

#define kTextViewPlaceHolderText @"在这里写日记!"

@interface EditRecordViewController ()
<UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource,
UITextFieldDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
ZYQAssetPickerControllerDelegate,
UITextViewDelegate,
CLLocationManagerDelegate>

@property(nonatomic,strong) UITextField * textField;
@property(nonatomic,strong) UICollectionView * imageCollectionView;

@property(nonatomic,strong) UITextView * textView;

@property(nonatomic,strong) UICollectionViewFlowLayout * collectionViewLayout;
@property(nonatomic,strong) NSMutableArray * imageCollectionViewDataSource;

@property(nonatomic,strong) UISwitch * locationSwitch;
@property(nonatomic,strong) UILabel * locationLabel;
@property(nonatomic,strong) CLGeocoder * geocoder;
@property(nonatomic,strong) CLLocationManager * locationManager;
@property(nonatomic,strong) CLLocation * lastLocation;

@property(nonatomic,strong) MBProgressHUD * hud;
@end

@implementation EditRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Touch

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}

#pragma mark Load Data

-(void)loadData
{
    Dairy * model = [Dairy MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"uuid = %@",self.uuid]];
    
    self.textField.text = model.title;
    self.textView.text = model.content;
    
    if (model.location.length > 0) {
        self.locationLabel.text = [NSString stringWithFormat:@"定位信息:%@",model.location];
    }else{
        self.locationLabel.text = @"您未保存定位信息";
    }
    
    NSFileManager * fmgr = [NSFileManager defaultManager];
    NSString * imageDiretotyPath = [DIARY_IMAGE_PATH stringByAppendingPathComponent:model.uuid];
    NSArray * imagesArray;

    if([fmgr fileExistsAtPath:imageDiretotyPath])
    {
        imagesArray = [fmgr contentsOfDirectoryAtPath:imageDiretotyPath error:nil];
        for (NSString * path in imagesArray) {
            NSString * imagePath = [imageDiretotyPath stringByAppendingPathComponent:path];
            DiaryImageModel * model = [NSKeyedUnarchiver unarchiveObjectWithFile:imagePath];
            [self.imageCollectionViewDataSource addObject:model];
        }
    }else{
        UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"图片文件丢失" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    
}

#pragma mark Config UI

-(void)configUI
{
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [self configTextField];
    [self configTextView];
    [self configImageCollectionView];
    [self configLocationLabel];
    
    if (self.uuid) {
        [self loadData];
    }else{
        [self configLocationSwitch];
    }
    
    //保存按钮
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = item;
}


-(void)configTextView
{
    [self.view addSubview:self.textView];
    
    WS(ws);
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.textField.mas_bottom).offset(5);
        make.left.equalTo(ws.view).offset(10);
        make.right.equalTo(ws.view).offset(-10);
        //make.height.mas_equalTo(300);
        make.bottom.equalTo(ws.view).offset(-170);
    }];
    
    self.textView.text = kTextViewPlaceHolderText;
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.backgroundColor = [UIColor whiteColor];
    
    self.textView.layer.borderWidth = 0.1;
    self.textView.layer.cornerRadius = 4;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.clipsToBounds = YES;
    
    self.textView.spellCheckingType = UITextSpellCheckingTypeNo;
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textView.delegate = self;
}

-(void)configTextField
{
    [self.view addSubview:self.textField];
    
    WS(ws);
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(ws.view).offset(-20);
        make.left.equalTo(ws.view).offset(10);
        make.height.mas_equalTo(30);
        make.top.equalTo(ws.view).offset(64 +10);
    }];
    
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.placeholder = @"请输入日记的标题";
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.delegate = self;
}

-(void)configImageCollectionView
{
    [self.view addSubview:self.imageCollectionView];
    
    WS(ws);
    
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(110);
        make.left.equalTo(ws.view).offset(10);
        make.right.equalTo(ws.view).offset(-10);
        make.bottom.equalTo(ws.view).offset(-60);
    }];
    
    [self.imageCollectionView registerClass:[imageCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    self.imageCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.imageCollectionView.layer.borderColor = [UIColor grayColor].CGColor;
    self.imageCollectionView.layer.borderWidth = 0.1;
    self.imageCollectionView.layer.cornerRadius = 4;
    self.imageCollectionView.clipsToBounds = YES;
    
    self.collectionViewLayout.minimumLineSpacing = 2;
    self.collectionViewLayout.minimumInteritemSpacing = 2;
    self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);

    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.delegate = self;
    
    
}

-(void)configLocationLabel
{
    UILabel * titleLabel = [[UILabel alloc]init];
    self.locationLabel = titleLabel;
    [self.view addSubview:titleLabel];
    
    titleLabel.text = @"是否开启定位";
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.numberOfLines = 0;
    
    WS(ws);
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view).offset(-10);
        make.left.equalTo(ws.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(220, 36));
    }];
}

-(void)configLocationSwitch
{
    [self.view addSubview:self.locationSwitch];

    WS(ws);
  
    [self.locationSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.locationLabel).offset(-3);
        make.right.equalTo(ws.view).offset(-10);
    }];
    
    [self.locationSwitch addTarget:self action:@selector(changeLocationSwitch:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark CLLocationManger Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.lastLocation = [locations lastObject];
    
    [self.hud show:YES];
    
    [self.geocoder reverseGeocodeLocation:self.lastLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"定位失败，请检查网络连接" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        
        if (error) {
            [self presentViewController:alertVc animated:YES completion:nil];
            self.locationLabel.text = @"定位失败，请重试";
        }else{
            alertVc.message = @"定位成功";
            CLPlacemark * mark = [placemarks lastObject];
            self.locationLabel.text = [NSString stringWithFormat:@"您当前的位置:%@\n%@",mark.country,mark.name];
        }
        
        [self.hud hide: YES];
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error) {
        NSLog(@"定位服务出现问题");
    }
}

#pragma mark TextView Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:kTextViewPlaceHolderText]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.text = kTextViewPlaceHolderText;
    }
}

#pragma mark TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField endEditing:YES];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 50) {
        UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"输入长度不能大于50个字符或25个汉字" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertVc animated:YES completion:nil];
        return NO;
    }
    return YES;
}

#pragma mark Collection View Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageCollectionViewDataSource.count +1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    imageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.imageCollectionViewDataSource.count) {
        if (self.imageCollectionViewDataSource.count >= 9) {
            UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"最多选择九张图片" preferredStyle:UIAlertControllerStyleAlert];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertVc animated:YES completion:nil];
        }else{
            [self selectImage];
        }
    }else{
        [self.imageCollectionViewDataSource removeObjectAtIndex:indexPath.item];
        [self.imageCollectionView reloadData];
    }
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    imageCollectionViewCell * tCell = (imageCollectionViewCell *)cell;
    if (indexPath.item == self.imageCollectionViewDataSource.count) {
        tCell.cellImageView.image = [UIImage imageNamed:@"addImageIcon"];
    }else{
        DiaryImageModel * model = self.imageCollectionViewDataSource[indexPath.item];
        tCell.cellImageView.image = model.thumbnail;
    }

}

#pragma mark CollectionFlowLayout Delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.item == self.imageCollectionViewDataSource.count) {
//        return CGSizeMake(25, 25);
//    }
    return CGSizeMake(50, 50);
}

#pragma mark Image Picker Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
}



#pragma mark ZYQAssetPickerControlle Delegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (int i = 0;i < assets.count;i++) {
        DiaryImageModel * model = [[DiaryImageModel alloc]init];
        ALAsset * asset = assets[i];
        ALAssetRepresentation * rep = asset.defaultRepresentation;
        NSString * fileType = rep.filename.pathExtension;
        model.imageName = [NSString stringWithFormat:@"%d.%@",i,fileType];
        model.thumbnail = [UIImage imageWithCGImage:asset.thumbnail];
        model.image = [UIImage imageWithCGImage:rep.fullResolutionImage];
        [self.imageCollectionViewDataSource addObject:model];
    }
    [self.imageCollectionView reloadData];
}

#pragma mark action

-(void)changeLocationSwitch:(UISwitch *)sender
{
    if(sender == self.locationSwitch)
    {
        if (self.locationSwitch.on == YES) {
            self.locationLabel.text = @"正在定位";
            [self.locationManager startUpdatingLocation];
        }else{
            self.locationLabel.text = @"当前定位未打开";
            [self.locationManager stopUpdatingLocation];
        }
    }
}

-(void)submit
{
    __block UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    
    if (self.textField.text.length == 0 || [self.textView.text isEqualToString:kTextViewPlaceHolderText]) {
        [self presentViewController:alertVc animated:YES completion:^{
            
        }];
        return;
    }

    if (!self.uuid) {
        Dairy * model = [Dairy MR_createEntity];
        model.title = self.textField.text;
        model.content = self.textView.text;
        model.uuid = [[NSUUID UUID] UUIDString];
        model.time = [NSDate date];
        
        self.uuid = model.uuid;
        
        if ([self.locationLabel.text hasPrefix:@"您当前的位置:"]) {
            model.location = [[[[self.locationLabel.text componentsSeparatedByString:@":"] lastObject] componentsSeparatedByString:@"\n"] componentsJoinedByString:@" "];
        }
    }else{
        //修改数据库模型
        Dairy * model = [[Dairy MR_findByAttribute:@"uuid" withValue:self.uuid] lastObject];
        model.title = self.textField.text;
        model.content = self.textView.text;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
        //保存图片
        
        NSFileManager * fmgr = [NSFileManager defaultManager];
        
        NSString * dirPath = [DIARY_IMAGE_PATH stringByAppendingPathComponent:self.uuid];
        NSError * error;
    
        if(![fmgr fileExistsAtPath:dirPath])
        {
            [fmgr createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        }else{
            NSArray * modelsPath = [fmgr subpathsAtPath:dirPath];
            for (NSString * path in modelsPath) {
                [fmgr removeItemAtPath:[dirPath stringByAppendingPathComponent:path] error:&error];
            }
        }
    
        if (error) {
            NSLog(@"%@",error);
            alertVc.message = @"保存图片出现错误";
            [self presentViewController:alertVc animated:YES completion:nil];
            return;
        }else{
            for (int i = 0; i < self.imageCollectionViewDataSource.count ; i++) {
                DiaryImageModel * model = self.imageCollectionViewDataSource[i];
                NSString * filePath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.%@",i,@"model"]];
                if (![NSKeyedArchiver archiveRootObject:model toFile:filePath]) {
                    NSLog(@"存储图像模型出现错误");
                }
            }
        }
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
            if (!error) {
                alertVc.message = @"保存成功";
            }else{
                alertVc.message = @"保存失败，请重试";
                NSLog(@"%@",error);
            }
            [self presentViewController:alertVc animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
}

-(void)selectImage
{
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self LocalPhoto];
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"用相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takePhoto];
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVc animated:YES completion:^{
        
    }];
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 9 -self.imageCollectionViewDataSource.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
//    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
//            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
//            return duration >= 5;
//        } else {
//            return YES;
//        }
//    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark lazy load

-(UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc]init];
    }
    return _textField;
}

-(UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc]init];
    }
    return _textView;
}

-(UICollectionView *)imageCollectionView
{
    if (_imageCollectionView == nil) {
        _imageCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
    }
    return _imageCollectionView;
}

-(UICollectionViewFlowLayout *)collectionViewLayout
{
    if (_collectionViewLayout == nil) {
        _collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    }
    return _collectionViewLayout;
}

-(NSMutableArray *)imageCollectionViewDataSource
{
    if (_imageCollectionViewDataSource == nil) {
        _imageCollectionViewDataSource = [[NSMutableArray alloc]init];
    }
    return _imageCollectionViewDataSource;
}

-(UISwitch *)locationSwitch
{
    if (_locationSwitch == nil) {
        _locationSwitch = [[UISwitch alloc]init];
    }
    return _locationSwitch;
}

-(UILabel *)locationLabel
{
    if (_locationLabel == nil) {
        _locationLabel = [[UILabel alloc]init];
    }
    return _locationLabel;
}

-(CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

-(CLLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];
            [_locationManager requestAlwaysAuthorization];
        }
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

-(MBProgressHUD *)hud
{
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc]init];
        [self.view addSubview:_hud];
    }
    return _hud;
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
