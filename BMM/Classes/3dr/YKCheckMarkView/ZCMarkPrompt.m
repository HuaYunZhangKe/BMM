//
//  ZCMarkPrompt.m
//  ZcJiGuangDemo
//
//  Created by 郑超 on 2017/9/20.
//  Copyright © 2017年 jiuhe. All rights reserved.
//

#import "ZCMarkPrompt.h"


@interface ZCMarkPrompt ()

@property (nonatomic, strong) YKMarkToastViewController *toastViewController;

@end

static ZCMarkPrompt *markToastView = nil;
@implementation ZCMarkPrompt

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        markToastView = [[ZCMarkPrompt alloc] init];
    });
    return markToastView;
}

#pragma mark - successMarkToast

+ (void)showMarkToastInViewController:(UIViewController *)viewController message:(NSString *)message completionBlock:(YKAnimationFinishedBlock)complectionBlock {
    [self showToastInViewController:viewController message:message isSuccess:YES completionBlock:complectionBlock];
}

#pragma mark - failedToast

+ (void)showFailedToastInViewController:(UIViewController *)viewController message:(NSString *)message completionBlock:(YKAnimationFinishedBlock)complectionBlock {
    [self showToastInViewController:viewController message:message isSuccess:NO completionBlock: complectionBlock];
}

+ (void)showToastInViewController:(UIViewController *)viewController message:(NSString *)message isSuccess:(BOOL)isSuccess completionBlock:(YKAnimationFinishedBlock)complectionBlock {
    
    if ([ZCMarkPrompt sharedInstance].toastViewController) {
        [[ZCMarkPrompt sharedInstance].toastViewController removeFromParentViewController];
        [[ZCMarkPrompt sharedInstance].toastViewController.view removeFromSuperview];
        [ZCMarkPrompt sharedInstance].toastViewController = nil;
    }
    
    YKMarkToastViewController * toastViewController = [[YKMarkToastViewController alloc] initWithNibName:@"YKMarkToastViewController" bundle:nil];
    toastViewController.message = message;
    toastViewController.isSuccess = isSuccess;
    [ZCMarkPrompt sharedInstance].toastViewController = toastViewController;
    [self performSelector:@selector(remove:) withObject:complectionBlock afterDelay:1.5];
    [toastViewController showInViewController:viewController];
}

+ (void)remove:(YKAnimationFinishedBlock)finishedBlock {
    [UIView animateWithDuration:0.5 animations:^{
        [ZCMarkPrompt sharedInstance].toastViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [[ZCMarkPrompt sharedInstance].toastViewController removeFromParentViewController];
        [[ZCMarkPrompt sharedInstance].toastViewController.view removeFromSuperview];
        [ZCMarkPrompt sharedInstance].toastViewController = nil;
        if (finishedBlock) {
            finishedBlock();
        }
    }];
}



@end
