//
//  ViewController.m
//  相册选择
//
//  Created by 李志权 on 2021/8/10.
//

#import "ViewController.h"
#import "CollectionViewCellVideo.h"
#import "CollectionViewCellImage.h"
#import "ZQAlbum.h"
#import "ZQImageCheck.h"
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *data;
@end

@implementation ViewController
-(NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [ZQAlbum setImageMaxNumber:0 videoMaxNumber:0 isImageVideoCount:YES];
    [ZQAlbum doneStartRequestDataBlock:^{
        NSLog(@"请等待");
    }];
    [ZQAlbum doneEndRequestDataBlock:^(NSMutableArray *data) {
        NSLog(@"完成");
        [self.data addObjectsFromArray:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    [ZQAlbum maximumBlock:^(ZQAlbumSelectedType albumSelectedType) {
        NSLog(@"已上限%zi",albumSelectedType);
    }];
    [ZQAlbum previewStartRequestDataBlock:^{
        NSLog(@"预览开始");
    }];
    [ZQAlbum previewEndRequestDataBlock:^(NSMutableArray *data,UIViewController *showFromVC) {
        NSLog(@"预览结束");
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[AVAsset class]]) {
                [data replaceObjectAtIndex:idx withObject:[self screenshotMyAsset:obj]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZQImageCheck imageCheckWithStartIndex:0 iamgeViewSuperView:nil images:data showFromVC:showFromVC];
            });
            
        }];
    }];
    // Do any additional setup after loading the view.
}
- (UIImage *)screenshotMyAsset:(AVAsset *)myAsset{
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:myAsset];
    CMTime midpoint = CMTimeMakeWithSeconds(1,myAsset.duration.timescale);
    NSError *error;
    CMTime actualTime;
     
    CGImageRef halfWayImage = [imageGenerator copyCGImageAtTime:midpoint actualTime:&actualTime error:&error];
    UIImage *iamge = [UIImage imageWithCGImage:halfWayImage];
    if (halfWayImage != NULL) {
        // Do something interesting with the image.
        CGImageRelease(halfWayImage);
    }
    return iamge;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count+1;
}
-( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.data.count>indexPath.row) {
        id data = self.data[indexPath.row];
        if ([data isKindOfClass:[UIImage class]]) {
            CollectionViewCellImage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellImage" forIndexPath:indexPath];
            cell.image.image  = data;
            return cell;
        }else{
            CollectionViewCellVideo *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellVideo" forIndexPath:indexPath];
            cell.asset = data;
            return cell;
        }
        
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellAdd" forIndexPath:indexPath];
        return cell;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.view.frame.size.width-20)/3-0.05, (self.view.frame.size.width-20)/3);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (self.data.count>indexPath.row) {
        NSLog(@"%@",self.data[indexPath.row]);
    }else{
        [ZQAlbum showAlbumListFromViewController:self modalPresentationStyle:UIModalPresentationPageSheet albumSelectedType:ZQAlbumSelectedTypeAll];
    }
}
@end
