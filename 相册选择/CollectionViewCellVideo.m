//
//  CollectionViewCellVideo.m
//  相册选择
//
//  Created by 李志权 on 2021/8/10.
//

#import "CollectionViewCellVideo.h"

@implementation CollectionViewCellVideo
-(void)setAsset:(AVAsset *)asset{
    _asset = asset;
    Float64 durationSeconds = CMTimeGetSeconds([asset duration]);
    self.time.text = [self formatTimeWithTimeInterVal:durationSeconds];
    self.image.image = [self screenshot];
}
- (UIImage *)screenshot{
    
    AVAsset *myAsset = self.asset;
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:myAsset];
    CMTime midpoint = CMTimeMakeWithSeconds(1,self.asset.duration.timescale);
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
//转换时间格式的方法
- (NSString *)formatTimeWithTimeInterVal:(NSTimeInterval)timeInterVal{
    int minute = 0, hour = 0, secend = timeInterVal;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, secend];
}

@end
