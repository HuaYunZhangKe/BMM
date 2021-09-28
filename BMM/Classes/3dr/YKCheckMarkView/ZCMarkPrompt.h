//
//  ZCMarkPrompt.h
//  ZcJiGuangDemo
//
//  Created by 郑超 on 2017/9/20.
//  Copyright © 2017年 jiuhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKMarkToastViewController.h"

@interface ZCMarkPrompt : NSObject

+ (instancetype)sharedInstance;

+ (void)showMarkToastInViewController:(UIViewController *)viewController message:(NSString *)message completionBlock:(YKAnimationFinishedBlock)complectionBlock;

+ (void)showFailedToastInViewController:(UIViewController *)viewController message:(NSString *)message completionBlock:(YKAnimationFinishedBlock)complectionBlock;

@end
