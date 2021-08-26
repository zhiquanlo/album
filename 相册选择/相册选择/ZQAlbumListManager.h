//
//  ZQAlbumListManage.h
//  demo
//
//  Created by 李志权 on 2021/7/29.
//  Copyright © 2021 kailu. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 ZQAlbumSelectedTypeAll 相片、视频
 ZQAlbumSelectedTypeImage 相片
 ZQAlbumSelectedTypeVideo 视频
 */
typedef NS_ENUM(NSInteger, ZQAlbumSelectedType){
    ZQAlbumSelectedTypeAll = 0,
    ZQAlbumSelectedTypeImage = 1,
    ZQAlbumSelectedTypeVideo = 2
};
//完成开始请求数据
typedef void(^DoneStartRequestDataBlock)(void);
//完成结束请求数据
typedef void(^DoneEndRequestDataBlock)(NSMutableArray *data);
//预览开始请求数据
typedef void(^PreviewStartRequestDataBlock)(void);
//预览结束请求数据
typedef void(^PreviewEndRequestDataBlock)(NSMutableArray *data,UIViewController *showFromVC);
//最大限制回调
typedef void (^MaximumBlock)(ZQAlbumSelectedType albumSelectedType);
@interface ZQAlbumListManager : NSObject
+(instancetype)manager;

/// 点击完成的开始回调
@property (nonatomic,copy)DoneStartRequestDataBlock doneStartRequestDataBlock;
/// 点击完成的结束回调
@property (nonatomic,copy)DoneEndRequestDataBlock doneEndRequestDataBlock;
/// 点击预览的开始回调
@property (nonatomic,copy)PreviewStartRequestDataBlock previewStartRequestDataBlock;
/// 点击预览的结束回调
@property (nonatomic,copy)PreviewEndRequestDataBlock previewEndRequestDataBlock;

/// 最大限制回调
@property (nonatomic,copy)MaximumBlock maximumBlock;

/// 设置图片最大数
@property (nonatomic,assign)NSInteger imageMaxNumber;

/// 设置视频最大数
@property (nonatomic,assign)NSInteger videoMaxNumber;

/// 是否图片视频数量合并
@property (nonatomic,assign)BOOL isImageVideoCount;

/// 选择的类型
@property (nonatomic,assign)ZQAlbumSelectedType albumSelectedType;
@end

