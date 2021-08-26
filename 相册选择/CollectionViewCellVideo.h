//
//  CollectionViewCellVideo.h
//  相册选择
//
//  Created by 李志权 on 2021/8/10.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCellVideo : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic,strong)AVAsset *asset;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end

NS_ASSUME_NONNULL_END
