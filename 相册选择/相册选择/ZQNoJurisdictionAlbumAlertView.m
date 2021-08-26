//
//  ZQNoJurisdictionAlbumAlertView.m
//  demo
//
//  Created by 李志权 on 2021/7/27.
//  Copyright © 2021 kailu. All rights reserved.
//

#import "ZQNoJurisdictionAlbumAlertView.h"
@interface ZQNoJurisdictionAlbumAlertView()
@property (nonatomic,copy)CloseClick closeClick;
@property (nonatomic,copy)GoSystemSetClick goSystemSetClick;
@end
@implementation ZQNoJurisdictionAlbumAlertView
+(void)showNoAlbumAlertViewCloseClick:(CloseClick)closeClick goSystemSetClick:(GoSystemSetClick)goSystemSetClick{
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    ZQNoJurisdictionAlbumAlertView *noAlbumAlertView = [[ZQNoJurisdictionAlbumAlertView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, 0)];
    noAlbumAlertView.closeClick = closeClick;
    noAlbumAlertView.goSystemSetClick = goSystemSetClick;
    noAlbumAlertView.backgroundColor = [UIColor colorWithRed:19/255 green:18/255 blue:18/255 alpha:1];
    [window addSubview:noAlbumAlertView];
    [UIView animateWithDuration:0.25 animations:^{
        noAlbumAlertView.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 64, 50, 50);
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [closeBtn addTarget:noAlbumAlertView action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [noAlbumAlertView addSubview:closeBtn];
    
    UILabel *alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 150,noAlbumAlertView.frame.size.width-100 , 100)];
    alertContentLabel.numberOfLines = 0;
    NSString *alertContent1 = @"无法访问相册中照片\n\n";
    NSString *alertContent2 = @"你已关闭照片访问权限，建议允许访问【所有照片】";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",alertContent1,alertContent2]];
    [att addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:22] range:NSMakeRange(0, alertContent1.length)];
    [att addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(alertContent1.length, alertContent2.length)];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, att.length)];
    alertContentLabel.attributedText = att;
    alertContentLabel.textAlignment = NSTextAlignmentCenter;
    [noAlbumAlertView addSubview:alertContentLabel];
    [alertContentLabel sizeToFit];
    
    UIButton *goSystemSetBtb = [UIButton buttonWithType:UIButtonTypeCustom];
    goSystemSetBtb.frame = CGRectMake(0, noAlbumAlertView.frame.size.height-80, 100, 100);
    [goSystemSetBtb setTitle:@"前往系统设置" forState:UIControlStateNormal];
    [goSystemSetBtb setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goSystemSetBtb.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [goSystemSetBtb addTarget:noAlbumAlertView action:@selector(goSystemSet) forControlEvents:UIControlEventTouchUpInside];
    [goSystemSetBtb sizeToFit];
    goSystemSetBtb.center =CGPointMake(noAlbumAlertView.center.x, alertContentLabel.center.y+300);
    [noAlbumAlertView addSubview:goSystemSetBtb];
}
- (void)goSystemSet{
    if (self.goSystemSetClick) {
        self.goSystemSetClick();
    }
}
- (void)closeBtnClick{
    if (self.closeClick) {
        self.closeClick();
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
