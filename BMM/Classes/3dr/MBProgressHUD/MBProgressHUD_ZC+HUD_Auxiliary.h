//
//  MBProgressHUD_ZC+HUD_Auxiliary.h
//  ZcOneselfDemo
//
//  Created by 郑超 on 2017/9/6.
//  Copyright © 2017年 郑超. All rights reserved.
//

#import "MBProgressHUD_ZC.h"

@interface MBProgressHUD_ZC (HUD_Auxiliary)

+ (MBProgressHUD_ZC *)createHUD:(UIView *)view;
+ (MBProgressHUD_ZC *)defaultMBProgress:(UIView *)view;
+ (MBProgressHUD_ZC *)defaultMBProgressWithText:(NSString *)text view:(UIView *)view;


+ (void)showSuccess:(NSString *)success view:(UIView *)view;
+ (void)showError:(NSString *)error view:(UIView *)view;
+ (MBProgressHUD_ZC *)showNotice:(NSString *)notice view:(UIView *)view;

/*****帧动画*****/
+ (MBProgressHUD_ZC *)showCustomAnimate:(NSString *)text imageName:(NSString *)imageName imageCounts:(NSInteger)imageCounts view:(UIView *)view;
+ (void)drawErrorViewWithText:(NSString *)text view:(UIView *)view;
+ (void)drawRightViewWithText:(NSString *)text view:(UIView *)view;
+ (MBProgressHUD_ZC *)drawRoundLoadingView:(NSString *)tex view:(UIView *)viewt;

@end
