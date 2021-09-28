
//  Created by 张科 on 16/6/5.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BMLOG
#define BMLOG(fmt, ...) NSLog((@"\n\n%s [Line %d] \nBMLOG:\n\n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

typedef void(^alertClickBlock)(void);
typedef void(^actionClickBlock)(int index);
@interface BMToast : NSObject
+(void)showTotastView:(UIView *)View WithTitle:(NSString *)title;

+(void)showHudView:(UIView *)View WithTitle:(NSString *)title;

+(void)hideHud:(UIView *)view;

+(void)showAlertInWindow:(NSString *)title;

+ (void)showAlertWith:(NSString *)title AndActionTitles:(NSArray *)actionTitles AndCallBack:(actionClickBlock)alertClick;

+ (void)showAlertWith:(NSString *)title AndContent:(NSString *)content AndCallBack:(alertClickBlock)alertClick;

+ (void)showCustomAlertWith:(NSString *)title AndContent:(NSString *)content SureString:(NSString *)sure CancelString:(NSString *)cancel AndViewController:(id)vController AndCallBack:(alertClickBlock)alertClick;

+ (void)showActionSheetWithTitle:(NSString *)title Item1:(NSString *)item1 AndItem2:(NSString *)item2  AndItem3:(NSString *)item3 AndViewController:(id)vController AndCallBack:(actionClickBlock)alertClick;


@end
