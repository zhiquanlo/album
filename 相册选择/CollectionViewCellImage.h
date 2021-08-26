//
//  CollectionViewCellImage.h
//  相册选择
//
//  Created by 李志权 on 2021/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCellImage : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *cancel;

@end

NS_ASSUME_NONNULL_END
