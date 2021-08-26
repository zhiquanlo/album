//
//  ZQAlbumShowView.m
//  demo
//
//  Created by 李志权 on 2021/7/28.
//  Copyright © 2021 kailu. All rights reserved.
//

#import "ZQAlbumShowView.h"
#import "ZQAlbumListManager.h"
@interface ZQAlbumShowViewCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *tagLabel;
@property (nonatomic,strong)UILabel *duration;
@end

@implementation ZQAlbumShowViewCell
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}
- (UILabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-35, 5, 30, 30)];
        _tagLabel.font = [UIFont boldSystemFontOfSize:20];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.layer.cornerRadius = 15;
        _tagLabel.layer.masksToBounds = YES;
        _tagLabel.layer.borderWidth = 1;
        _tagLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.imageView addSubview:_tagLabel];
    }
    return _tagLabel;
}
- (UILabel *)duration{
    if (!_duration) {
        _duration = [[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height-30, self.frame.size.width-20, 30)];
        _duration.textColor = [UIColor whiteColor];
        _duration.font = [UIFont systemFontOfSize:10];
        _duration.textAlignment = NSTextAlignmentRight;
        [self.imageView addSubview:_duration];
    }
    return _duration;
}
@end

@interface ZQAlbumShowView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)PHImageRequestOptions *options;
@property (nonatomic,strong)NSMutableArray <UIImage *>*backupImages;
@end

@implementation ZQAlbumShowView
-(NSMutableArray<UIImage *> *)backupImages{
    if (!_backupImages) {
        _backupImages = [NSMutableArray array];
    }
    return _backupImages;
}
- (PHImageRequestOptions *)options{
    if (!_options) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        _options = options;
    }
    return _options;
}
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        self.allowsSelection = YES;
        [self registerClass:[ZQAlbumShowViewCell class] forCellWithReuseIdentifier:@"ZQAlbumShowViewCell"];
    }
    return self;
}
- (void)setAssets:(NSArray<PHAsset *> *)assets{
    _assets = assets;
    [self reloadData];
}
#pragma mark --- UICollectionViewDelegate && UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZQAlbumShowViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZQAlbumShowViewCell" forIndexPath:indexPath];
    PHAsset *asset = self.assets[indexPath.row];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        cell.duration.text = [self formatTimeWithTimeInterVal:asset.duration];
    }else{
        cell.duration.text = @"";
    }
    if ([_selectedAssets containsObject:self.assets[indexPath.row]]) {
        cell.tagLabel.text = [NSString stringWithFormat:@"%zi",[_selectedAssets indexOfObject:asset]+1];
        cell.tagLabel.backgroundColor = [UIColor colorWithRed:0/255 green:255/255 blue:255/255 alpha:1];
    }else{
        cell.tagLabel.text = @"";
        cell.tagLabel.backgroundColor = [UIColor colorWithRed:232/255 green:227/255 blue:227/255 alpha:0.5];
    }
    if (indexPath.row<self.backupImages.count) {
        cell.imageView.image = self.backupImages[indexPath.row];
    }else{
        __weak typeof(self) weakSelf = self;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake((self.frame.size.width/4-0.05)*2, (self.frame.size.width/4)*2) contentMode:PHImageContentModeDefault options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.imageView.image = result;
            if (![weakSelf.backupImages containsObject:result]) {
                [weakSelf.backupImages addObject:result];
            }
        }];
    }
   
    return cell;
}
//转换时间格式的方法
- (NSString *)formatTimeWithTimeInterVal:(NSTimeInterval)timeInterVal{
    int minute = 0, hour = 0, secend = timeInterVal;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, secend];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    PHAsset *asset = self.assets[indexPath.row];
    if (![_selectedAssets containsObject:asset]) {
       __block NSInteger videoCount = 0 , imageCount = 0;
        [_selectedAssets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.mediaType == PHAssetMediaTypeVideo) {
                videoCount++;
            }else{
                imageCount++;
            }
        }];
        if ([ZQAlbumListManager manager].isImageVideoCount && [ZQAlbumListManager manager].imageMaxNumber+[ZQAlbumListManager manager].videoMaxNumber>0 && self.selectedAssets.count>=[ZQAlbumListManager manager].imageMaxNumber+[ZQAlbumListManager manager].videoMaxNumber) {
            if ([ZQAlbumListManager manager].maximumBlock) {
                [ZQAlbumListManager manager].maximumBlock(ZQAlbumSelectedTypeAll);
            }
            return;
        }
        if (![ZQAlbumListManager manager].isImageVideoCount && [ZQAlbumListManager manager].imageMaxNumber>0 && imageCount>=[ZQAlbumListManager manager].imageMaxNumber && asset.mediaType == PHAssetMediaTypeImage) {
            if ([ZQAlbumListManager manager].maximumBlock) {
                [ZQAlbumListManager manager].maximumBlock(ZQAlbumSelectedTypeImage);
            }
            return;
        }
        if (![ZQAlbumListManager manager].isImageVideoCount && [ZQAlbumListManager manager].videoMaxNumber>0 && videoCount>=[ZQAlbumListManager manager].videoMaxNumber && asset.mediaType == PHAssetMediaTypeVideo) {
            if ([ZQAlbumListManager manager].maximumBlock) {
                [ZQAlbumListManager manager].maximumBlock(ZQAlbumSelectedTypeVideo);
            }
            return;
        }
        [_selectedAssets addObject:asset];
    }else{
        [_selectedAssets removeObject:asset];
    }
    if (self.monitorSelectedAssets) {
        self.monitorSelectedAssets(self.selectedAssets.count>0);
    }
    [self reloadData];
}
@end
