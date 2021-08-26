//
//  ZQImageCheck.h
//  QSchool
//
//  Created by 李志权 on 2021/8/16.
//  Copyright © 2021 myz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ZQImageCheck : NSObject
+(void)imageCheckWithStartIndex:(NSInteger)startIndex iamgeViewSuperView:(UIView *)superView images:(id)images showFromVC:(UIViewController *)showFromVC;
@end

