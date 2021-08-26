//
//  ZQAlbum.m
//  相册选择
//
//  Created by 李志权 on 2021/8/25.
//

#import "ZQAlbum.h"
#import "ZQAlbumListVC.h"
@implementation ZQAlbum
/// 显示选择相册
/// @param hostvc 操作控制器
/// @param modalPresentationStyle 模态显示样式
/// @param albumSelectedType 相册选择类型
+(void)showAlbumListFromViewController:(UIViewController *)hostvc  modalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle albumSelectedType:(ZQAlbumSelectedType)albumSelectedType{
    
    [ZQAlbumListManager manager].albumSelectedType = albumSelectedType;
    ZQAlbumListVC *VC = [[ZQAlbumListVC alloc] init];
    UINavigationController *NVC = [[UINavigationController alloc] initWithRootViewController:VC];
    NVC.modalPresentationStyle = modalPresentationStyle;
    [hostvc presentViewController:NVC animated:YES completion:nil];
    NVC.navigationBar.barTintColor = [UIColor colorWithRed:19/255 green:18/255 blue:18/255 alpha:0.8];
}
/// @param imageMaxNumber 图片最大的选择数量 0为无限制
/// @param videoMaxNumber 图片最大的选择数量 0为无限制
/// @param isImageVideoCount 最大的选择数据图片视频是否混合计算  isImageVideoCount为YES视为混合计算 imageMaxNumber+videoMaxNumber的总和
+(void)setImageMaxNumber:(NSInteger)imageMaxNumber videoMaxNumber:(NSInteger)videoMaxNumber isImageVideoCount:(BOOL)isImageVideoCount{
    [ZQAlbumListManager manager].imageMaxNumber = imageMaxNumber;
    [ZQAlbumListManager manager].videoMaxNumber = videoMaxNumber;
    [ZQAlbumListManager manager].isImageVideoCount = isImageVideoCount;
}
/// @param doneStartRequestDataBlock 完成开始请数据片可以在这里做加载框 开始加载回调
+(void)doneStartRequestDataBlock:(DoneStartRequestDataBlock)doneStartRequestDataBlock{
    [ZQAlbumListManager manager].doneStartRequestDataBlock = doneStartRequestDataBlock;
}
/// @param doneEndRequestDataBlock 完成结束请求数据可以在这里关闭加载框 结束加载回调
+(void)doneEndRequestDataBlock:(DoneEndRequestDataBlock)doneEndRequestDataBlock{
    [ZQAlbumListManager manager].doneEndRequestDataBlock = doneEndRequestDataBlock;
}
/// @param previewStartRequestDataBlock 预览开始请数据片可以在这里做加载框 开始加载回调
+(void)previewStartRequestDataBlock:(PreviewStartRequestDataBlock)previewStartRequestDataBlock{
    [ZQAlbumListManager manager].previewStartRequestDataBlock = previewStartRequestDataBlock;
}
/// @param previewEndRequestDataBlock 预览结束请求数据可以在这里关闭加载框 结束加载回调
+(void)previewEndRequestDataBlock:(PreviewEndRequestDataBlock)previewEndRequestDataBlock{
    [ZQAlbumListManager manager].previewEndRequestDataBlock = previewEndRequestDataBlock;
}
/// @param maximumBlock 最大的选择数量限制回调
+(void)maximumBlock:(MaximumBlock)maximumBlock{
    [ZQAlbumListManager manager].maximumBlock  = maximumBlock;
}
@end
