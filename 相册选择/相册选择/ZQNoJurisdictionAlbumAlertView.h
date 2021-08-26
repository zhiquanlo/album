//
//  ZQNoJurisdictionAlbumAlertView.h
//  demo
//
//  Created by 李志权 on 2021/7/27.
//  Copyright © 2021 kailu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CloseClick) (void);
typedef void(^GoSystemSetClick) (void);
@interface ZQNoJurisdictionAlbumAlertView : UIView

/// 显示没有权限提示
+(void)showNoAlbumAlertViewCloseClick:(CloseClick)closeClick goSystemSetClick:(GoSystemSetClick)goSystemSetClick;
@end

NS_ASSUME_NONNULL_END
