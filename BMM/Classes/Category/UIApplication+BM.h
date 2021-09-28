//
//  UIApplication+BM.h
//  Component
//
//  Created by Zack Zhang on 2021/8/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (BM)
+ (UIWindow *)getTopWindow;
+ (UIViewController *)getCurrentVC;
@end

NS_ASSUME_NONNULL_END
