//
//  ZQAlbumListManage.m
//  demo
//
//  Created by 李志权 on 2021/8/9.
//  Copyright © 2021 kailu. All rights reserved.
//

#import "ZQAlbumListManager.h"

@implementation ZQAlbumListManager
+(instancetype)manager{
    static ZQAlbumListManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
@end
