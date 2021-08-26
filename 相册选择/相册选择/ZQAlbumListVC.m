//
//  ZQAlbumListVC.m
//  demo
//
//  Created by 李志权 on 2021/7/27.
//  Copyright © 2021 kailu. All rights reserved.
//

#import "ZQAlbumListVC.h"
#import <Photos/Photos.h>
#import "ZQAlbumNameListView.h"
#import "ZQNoJurisdictionAlbumAlertView.h"
#import "ZQAlbumShowView.h"
#import "ZQAlbumListManager.h"
static NSString *blank = @"    ";
@interface ZQAlbumListVC ()<PHPhotoLibraryChangeObserver>
@property (nonatomic,strong)UIButton *titleButton;
@property (nonatomic,strong)ZQAlbumNameListView *albumNameListView;
@property (nonatomic,copy)NSMutableArray *albumNames;
@property (nonatomic,strong)ZQAlbumShowView *albumShowView;
@property (nonatomic,strong)UIButton *authorizationLimitedBtn;
@property (nonatomic,assign)BOOL authorizationLimited;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIButton *preview;
@property (nonatomic,strong)UIButton *qualityBtn;
@property (nonatomic,strong)UIButton *doneBtn;
@property (nonatomic,strong)NSMutableArray *previewData;
@end

@implementation ZQAlbumListVC
- (NSMutableArray *)previewData{
    if (!_previewData) {
        _previewData = [NSMutableArray array];
    }
    return _previewData;
}
- (ZQAlbumShowView *)albumShowView{
    if (!_albumShowView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.view.frame.size.width/4-0.05, self.view.frame.size.width/4);
        flowLayout.minimumLineSpacing = 0.01;
        flowLayout.minimumInteritemSpacing = 0.01;
        _albumShowView = [[ZQAlbumShowView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _albumShowView.translatesAutoresizingMaskIntoConstraints = NO;
        __weak typeof(self) weakSelf = self;
        [_albumShowView setMonitorSelectedAssets:^(BOOL isCount) {
            if (isCount) {
                weakSelf.preview.alpha = 1;
                weakSelf.doneBtn.alpha = 1;
            }else{
                weakSelf.preview.alpha = 0.5;
                weakSelf.doneBtn.alpha = 0.5;
            }
            weakSelf.preview.enabled = isCount;
            weakSelf.doneBtn.enabled = isCount;
        }];
        [self.view addSubview:_albumShowView];
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_albumShowView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *let = [NSLayoutConstraint constraintWithItem:_albumShowView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *rit = [NSLayoutConstraint constraintWithItem:_albumShowView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        id toItem = self.authorizationLimited ? self.authorizationLimitedBtn : self.bottomView;
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_albumShowView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:toItem attribute:NSLayoutAttributeTop multiplier:1 constant:0];

        [self.view addConstraints:@[top,let,rit,bottom]];
    }
    return _albumShowView;
}
-(UIButton *)authorizationLimitedBtn{
    if (!_authorizationLimitedBtn) {
        _authorizationLimitedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _authorizationLimitedBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _authorizationLimitedBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _authorizationLimitedBtn.titleLabel.numberOfLines = 2;
        [_authorizationLimitedBtn setTitle:@"你已设置只能访问相册部分照片，建议允许访问【所有照片】→" forState:UIControlStateNormal];
        _authorizationLimitedBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_authorizationLimitedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _authorizationLimitedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_authorizationLimitedBtn addTarget:self action:@selector(setPHAuthorization) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_authorizationLimitedBtn];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_authorizationLimitedBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *let = [NSLayoutConstraint constraintWithItem:_authorizationLimitedBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
        NSLayoutConstraint *rit = [NSLayoutConstraint constraintWithItem:_authorizationLimitedBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-20];
        NSLayoutConstraint *h = [NSLayoutConstraint constraintWithItem:_authorizationLimitedBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80];
        [self.view addConstraints:@[bottom,let,rit,h]];
    }
    return _authorizationLimitedBtn;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        [self.view addSubview:_bottomView];
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *h = [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
        NSLayoutConstraint *let = [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *rit = [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        CGFloat safeAreaInsetsBottom = 0;
        if (@available(iOS 11.0, *)) {
            safeAreaInsetsBottom = self.view.safeAreaInsets.bottom;
        }
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-safeAreaInsetsBottom];
        [self.view addConstraints:@[h,let,rit,bottom]];
        [self preview];
        [self qualityBtn];
        [self doneBtn];
    }
    return _bottomView;
}
-(UIButton *)preview{
    if (!_preview) {
        UIButton *preview = [UIButton buttonWithType:UIButtonTypeCustom];
        preview.translatesAutoresizingMaskIntoConstraints = NO;
        [preview setTitle:@"预览" forState:UIControlStateNormal];
        preview.alpha = 0.5;
        preview.enabled = NO;
        preview.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [preview setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [preview addTarget:self action:@selector(previewClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:preview];
        [_bottomView addConstraints:@[[NSLayoutConstraint constraintWithItem:preview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],[NSLayoutConstraint constraintWithItem:preview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeLeft multiplier:1 constant:20]]];
        [preview sizeToFit];
        _preview = preview;
    }
    return _preview;
}
-(UIButton *)qualityBtn{
    if (!_qualityBtn) {
        UIButton *qualityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        qualityBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [qualityBtn setTitle:@"获取原图" forState:UIControlStateNormal];
        [qualityBtn setTitle:@"标准图片" forState:UIControlStateSelected];
        qualityBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [qualityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [qualityBtn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [qualityBtn addTarget:self action:@selector(qualityBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:qualityBtn];
        [_bottomView addConstraints:@[[NSLayoutConstraint constraintWithItem:qualityBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],[NSLayoutConstraint constraintWithItem:qualityBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]]];
        [qualityBtn sizeToFit];
        _qualityBtn = qualityBtn;
    }
    return _qualityBtn;
}
-(UIButton *)doneBtn{
    if (!_doneBtn) {
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        doneBtn.alpha = 0.5;
        doneBtn.enabled = NO;
        doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:doneBtn];
        [_bottomView addConstraints:@[[NSLayoutConstraint constraintWithItem:doneBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],[NSLayoutConstraint constraintWithItem:doneBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_bottomView attribute:NSLayoutAttributeRight multiplier:1 constant:-20]]];
        [doneBtn sizeToFit];
        _doneBtn = doneBtn;
    }
    return _doneBtn;
}
- (void)qualityBtnClick{
    self.qualityBtn.selected = !self.qualityBtn.selected;
    [self.previewData removeAllObjects];
}
- (void)previewClick{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *bPreviewData = [self.previewData mutableCopy];
    [self.albumShowView.selectedAssets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull assetObj, NSUInteger idx, BOOL * _Nonnull stop) {
       __block BOOL isContains =NO;
        [weakSelf.previewData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset *asset = obj[@"asset"];
            if (![weakSelf.albumShowView.selectedAssets containsObject:asset]) {
                [bPreviewData removeObject:obj];
            }
            if (assetObj == asset) {
                isContains = YES;
            }
        }];
        if (!isContains) {
            [bPreviewData addObject:@{@"asset":assetObj,@"content":[NSNull null]}];
        }
    }];
    self.previewData = [bPreviewData mutableCopy];
    [bPreviewData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = obj[@"asset"];
        NSInteger index = [weakSelf.albumShowView.selectedAssets indexOfObject:asset];
        [weakSelf.previewData replaceObjectAtIndex:index withObject:@{@"asset":asset,@"content":obj[@"content"]}];
    }];
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    imageRequestOptions.networkAccessAllowed = YES;
    imageRequestOptions.synchronous = NO;
    imageRequestOptions.version = PHImageRequestOptionsVersionCurrent;
    imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    PHVideoRequestOptions *videoRequestOptions = [[PHVideoRequestOptions alloc] init];
    videoRequestOptions.networkAccessAllowed = YES;
    videoRequestOptions.version = PHImageRequestOptionsVersionCurrent;
    videoRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    NSMutableArray *contents = [self.previewData mutableCopy];
    __block NSInteger tag = 0;
    if ([ZQAlbumListManager manager].previewStartRequestDataBlock) {
        [ZQAlbumListManager manager].previewStartRequestDataBlock();
    }
    [self.previewData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = obj[@"asset"];
        id content = obj[@"content"];
        if ([content isKindOfClass:[NSNull class]]) {
            if (asset.mediaType == PHAssetMediaTypeImage) {
                CGSize size = !weakSelf.qualityBtn.selected ? CGSizeMake(1920, 1080) :CGSizeMake(asset.pixelWidth,asset.pixelHeight);
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    if (result) {
                        [contents replaceObjectAtIndex:idx withObject:result];
                        [weakSelf.previewData replaceObjectAtIndex:idx withObject:@{@"asset":asset,@"content":result}];
                    }
                    tag++;
                    if (tag == weakSelf.previewData.count && [ZQAlbumListManager manager].previewEndRequestDataBlock) {
                        [ZQAlbumListManager manager].previewEndRequestDataBlock(contents,weakSelf);
                    }
                }];
            }else{
                [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:videoRequestOptions resultHandler:^(AVAsset * _Nullable AVAasset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    if (AVAasset) {
                        [contents replaceObjectAtIndex:idx withObject:AVAasset];
                        [weakSelf.previewData replaceObjectAtIndex:idx withObject:@{@"asset":asset,@"content":AVAasset}];
                    }
                    tag++;
                    if (tag == weakSelf.previewData.count && [ZQAlbumListManager manager].previewEndRequestDataBlock) {
                        [ZQAlbumListManager manager].previewEndRequestDataBlock(contents,weakSelf);
                    }
                }];
            }
        }else{
            if ([content isKindOfClass:[UIImage class]]) {
                [contents replaceObjectAtIndex:idx withObject:content];
            }else{
                [contents replaceObjectAtIndex:idx withObject:content];
            }
            
            tag++;
            if (tag == weakSelf.previewData.count && [ZQAlbumListManager manager].previewEndRequestDataBlock) {
                [ZQAlbumListManager manager].previewEndRequestDataBlock(contents,weakSelf);
            }
        }
    }];

}

- (ZQAlbumNameListView *)albumNameListView{
    if (!_albumNameListView) {
        __weak typeof(self) weakSelf = self;
        _albumNameListView = [[ZQAlbumNameListView alloc] initWithFrame:self.view.bounds selectIndexPathRow:^(NSInteger row) {
            ZQAlbumNameModel *albumNameModel = weakSelf.albumNames[row];
            [weakSelf.titleButton setTitle:[NSString stringWithFormat:@"%@%@%@",blank,albumNameModel.name,blank] forState:UIControlStateNormal];
            [weakSelf.titleButton sizeToFit];
            weakSelf.albumShowView.assets =albumNameModel.assets;
        }];
        [self.view addSubview:_albumNameListView];
    }
    [self.view bringSubviewToFront:_albumNameListView];
    return _albumNameListView;
}
-(NSMutableArray *)albumNames{
    if (!_albumNames) {
        _albumNames = [NSMutableArray array];
    }
    return _albumNames;
}
- (void)dismissViewController{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
}

/// 没有权限
- (void)noJurisdiction{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}
- (void)titleButtonClick{
    [self.albumNameListView showAlbumNameListViewWithAlbumNames:self.albumNames];
}

/// 选择完成
- (void)done{
    if (self.albumShowView.selectedAssets.count) {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
        imageRequestOptions.networkAccessAllowed = YES;
        imageRequestOptions.synchronous = NO;
        imageRequestOptions.version = PHImageRequestOptionsVersionCurrent;
        imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        PHVideoRequestOptions *videoRequestOptions = [[PHVideoRequestOptions alloc] init];
        videoRequestOptions.networkAccessAllowed = YES;
        videoRequestOptions.version = PHImageRequestOptionsVersionCurrent;
        videoRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        
        NSMutableArray *data = [self.albumShowView.selectedAssets mutableCopy];
        __weak typeof(self) weakSelf = self;
        if ([ZQAlbumListManager manager].doneStartRequestDataBlock) {
            [ZQAlbumListManager manager].doneStartRequestDataBlock();
        }
        __block NSInteger tag = 0;
        [self.albumShowView.selectedAssets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id content = [weakSelf screeningIsContainsPHAsset:obj];
            if (content) {
                tag++;
                [data replaceObjectAtIndex:idx withObject:content];
                
                if (tag == weakSelf.albumShowView.selectedAssets.count) {
                    if ([ZQAlbumListManager manager].doneEndRequestDataBlock) {
                        [ZQAlbumListManager manager].doneEndRequestDataBlock(data);
                    }
                    [weakSelf dismissViewController];
                }
            }else if (obj.mediaType == PHAssetMediaTypeImage) {
                CGSize size = !weakSelf.qualityBtn.selected ? CGSizeMake(1920, 1080) :CGSizeMake(obj.pixelWidth,obj.pixelHeight);
                [[PHImageManager defaultManager] requestImageForAsset:obj targetSize:size contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    NSLog(@"索引%zi图片%@信息%@",idx,result,info);
                    tag++;
                    if (result) {
                        [data replaceObjectAtIndex:idx withObject:result];
                    }
                    if (tag == weakSelf.albumShowView.selectedAssets.count) {
                        if ([ZQAlbumListManager manager].doneEndRequestDataBlock) {
                            [ZQAlbumListManager manager].doneEndRequestDataBlock(data);
                        }
                        [weakSelf dismissViewController];
                    }
                }];
            }else{
                [[PHImageManager defaultManager] requestAVAssetForVideo:obj options:videoRequestOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    NSLog(@"索引%zi视频%@信息%@",idx,asset,info);
                    tag++;
                    if (asset) {
                        [data replaceObjectAtIndex:idx withObject:asset];
                    }
                    if (tag == weakSelf.albumShowView.selectedAssets.count) {
                        if ([ZQAlbumListManager manager].doneEndRequestDataBlock) {
                            [ZQAlbumListManager manager].doneEndRequestDataBlock(data);
                        }
                        [weakSelf dismissViewController];
                    }
                }];
            }
        }];
    }else{
        [self dismissViewController];
    }
}
-(id)screeningIsContainsPHAsset:(PHAsset *)Asset{
    __block id conten = nil;
    [self.previewData enumerateObjectsUsingBlock:^(id  _Nonnull previewDataObj, NSUInteger previewDataIdx, BOOL * _Nonnull stop) {
        PHAsset *asset = previewDataObj[@"asset"];
        if (asset==Asset) {
            conten = previewDataObj[@"content"];
        }
    }];
    return conten;
}
- (void)setNavigationBar{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleButton.backgroundColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.2];
    [self.titleButton setTitle:blank forState:UIControlStateNormal];
    self.titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.titleButton sizeToFit];
    self.titleButton.layer.cornerRadius = CGRectGetHeight(self.titleButton.frame)/2;
    self.titleButton.layer.masksToBounds = YES;
    [self.titleButton addTarget:self action:@selector(titleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    self.view.backgroundColor = [UIColor colorWithRed:19/255 green:18/255 blue:18/255 alpha:1];
    [self examineJurisdiction];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}
-(void)setPHAuthorization{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

-(void)examineJurisdiction{
    if (@available(iOS 14, *)) {
        PHAccessLevel level = PHAccessLevelReadWrite;
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:level];
          switch (status) {
              case PHAuthorizationStatusLimited:
                  self.authorizationLimited = YES;
                  [self getOriginalImages];
                  break;
              case PHAuthorizationStatusDenied:{
                  // 用户已经明确否认了这一照片数据的应用程序访问
                  [ZQNoJurisdictionAlbumAlertView showNoAlbumAlertViewCloseClick:^{
                      [self noJurisdiction];
                  } goSystemSetClick:^{
                      [self setPHAuthorization];
                  }];
                  }
                  break;
              case PHAuthorizationStatusAuthorized:
                  //  用户已经授权应用访问照片数据
                  [self getOriginalImages];
                  break;
              default:
                  break;
        }
    } else {
        //判断相册权限
        PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
        if (photoAuthorStatus ==PHAuthorizationStatusAuthorized ) {

            [self getOriginalImages];

        }else if (photoAuthorStatus ==PHAuthorizationStatusAuthorized ) {
            // 用户已经明确否认了这一照片数据的应用程序访问
            [ZQNoJurisdictionAlbumAlertView showNoAlbumAlertViewCloseClick:^{
                [self noJurisdiction];
            } goSystemSetClick:^{
                [self setPHAuthorization];
            }];
        }
    }
}
- (void)getOriginalImages
{
    [self.albumNames removeAllObjects];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获得所有的自定义相簿
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType: PHAssetCollectionTypeSmartAlbum  subtype:PHAssetCollectionSubtypeAny options:nil];
        // 遍历所有的自定义相簿
        for (PHAssetCollection *assetCollection in assetCollections) {
            [weakSelf enumerateAssetsInAssetPHAssetCollection:assetCollection];
        }
        assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum   subtype:PHAssetCollectionSubtypeAny options:nil];
        // 遍历所有的自定义相簿
        for (PHAssetCollection *assetCollection in assetCollections) {
            [weakSelf enumerateAssetsInAssetPHAssetCollection:assetCollection];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.albumNameListView showAlbumNameListViewWithAlbumNames:weakSelf.albumNames];
        });
    });
}
/**
 *  遍历相簿中的全部图片

 */
- (void)enumerateAssetsInAssetPHAssetCollection:(PHAssetCollection*)assetCollection
{
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    NSMutableArray *assetsArr = [NSMutableArray array];
    [assets enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([ZQAlbumListManager manager].albumSelectedType == ZQAlbumSelectedTypeAll) {
            [assetsArr addObject:obj];
        }else if([ZQAlbumListManager manager].albumSelectedType == ZQAlbumSelectedTypeImage){
            if (obj.mediaType == PHAssetMediaTypeImage) {
                [assetsArr addObject:obj];
            }
        } else if([ZQAlbumListManager manager].albumSelectedType == ZQAlbumSelectedTypeVideo){
            if (obj.mediaType == PHAssetMediaTypeVideo) {
                [assetsArr addObject:obj];
            }
        }

    }];
    if (assetsArr.count) {
        ZQAlbumNameModel *albumNameModel = [ZQAlbumNameModel alloc];
        albumNameModel.name = assetCollection.localizedTitle;
        albumNameModel.assets = assetsArr;
        albumNameModel.count = assetsArr.count;
        [self.albumNames addObject:albumNameModel];
    }
}
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    ///一定要在主线程刷新：这里是异步监听
    dispatch_async (dispatch_get_main_queue (), ^{
        [self getOriginalImages];
    });
}
- (void)dealloc{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}
@end
