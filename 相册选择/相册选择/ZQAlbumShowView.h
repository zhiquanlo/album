//
//  ZQAlbumShowView.h
//  demo
//
//  Created by 李志权 on 2021/7/28.
//  Copyright © 2021 kailu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZQAlbumShowView : UICollectionView
@property (nonatomic, strong)NSArray<PHAsset *> *assets;
/// 选择的Asset
@property (nonatomic,strong,readonly)NSMutableArray <PHAsset *>*selectedAssets;
/// 选择Asset监听
@property (nonatomic,copy)void (^monitorSelectedAssets)(BOOL isCount);
@end


NS_ASSUME_NONNULL_END
