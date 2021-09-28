//
//  UIApplication+BM.m
//  Component
//
//  Created by Zack Zhang on 2021/8/5.
//

#import "UIApplication+BM.h"

@implementation UIApplication (BM)
+ (UIWindow *)getTopWindow {
    
    UIWindow *window = nil;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            UIWindow *firstWindow = ((UIWindowScene *) scene).windows.firstObject;
            if (firstWindow) {
                window = firstWindow;
            }
        }
    }
    return  window;

}


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
   ///下文中有分析
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }

    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

@end
