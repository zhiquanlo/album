//
//  ZQAlbumNameListView.h
//  demo
//
//  Created by 李志权 on 2021/7/27.
//  Copyright © 2021 kailu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class ZQAlbumNameModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectIndexPathRow)(NSInteger row);
@interface ZQAlbumNameListView : UITableView

/// 初始化相册名称列表
/// @param selectIndexPathRow 选择的索引
-(instancetype)initWithFrame:(CGRect)frame selectIndexPathRow:(SelectIndexPathRow)selectIndexPathRow;

/// 显示相册名称列表
/// @param albumNames 相册名称数组
- (void)showAlbumNameListViewWithAlbumNames:(NSArray <ZQAlbumNameModel *>*)albumNames;

/// 隐藏相册名称列表
-(void)hiddenAlbumNameListView;
@end

@interface ZQAlbumNameModel : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic, strong)NSArray<PHAsset *> *assets;
@property (nonatomic,assign)NSInteger count;
@end

NS_ASSUME_NONNULL_END
