//
//  ZQImageCheck.m
//  QSchool
//
//  Created by 李志权 on 2021/8/16.
//  Copyright © 2021 myz. All rights reserved.
//

#import "ZQImageCheck.h"
#import "DDPhotoBrowser.h"
#import "DDPhotoSDImageDownloadEngine.h"
#import "DDSDAnimatedImageView.h"
@implementation ZQImageCheck
+(void)imageCheckWithStartIndex:(NSInteger)startIndex iamgeViewSuperView:(UIView *)superView images:(id)images showFromVC:(UIViewController *)showFromVC
{
    NSMutableArray *imageDataArray = [NSMutableArray array];
    [images enumerateObjectsUsingBlock:^(id   _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {

        UIImageView * imageView = nil;
        if (superView) {
            imageView = [superView viewWithTag:1+idx];
        }
        NSURL *imageUrl = nil;
        if ([image isKindOfClass:[NSString class]]) {
            imageUrl = [NSURL URLWithString:image];
        }
        
        DDPhotoItem *item = [DDPhotoItem itemWithSourceView:imageView imageUrl:imageUrl thumbImage:nil thumbImageUrl:nil ];
        if ([image isKindOfClass:[UIImage class]]) {
            item.image = image;
        }
        
        if (idx == startIndex) {
            item.firstShowAnimation = YES;
        }
        
        [imageDataArray addObject:item];

    }];

    DDPhotoSDImageDownloadEngine * downloadEngine = [DDPhotoSDImageDownloadEngine new];
    
    /** 图片选择器展示*/
    DDPhotoBrowser * b = [DDPhotoBrowser photoBrowserWithPhotoItems:imageDataArray currentIndex:startIndex getImageViewClass:DDSDAnimatedImageView.class downloadEngine:downloadEngine];
    
    /** 设置page类型 */
    b.pageIndicateStyle = DDPhotoBrowserPageIndicateStylePageLabel;
    
    b.longPressGestureClickedBlock = ^(DDPhotoBrowser * photoBrowser ,NSInteger index, DDPhotoItem *item,NSData * imageData) {
        NSLog(@"长按手势回调：%ld", index);
    };
        
    [b showFromVC:showFromVC];
}
@end
