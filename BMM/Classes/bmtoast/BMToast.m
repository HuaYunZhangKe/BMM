//
//  MBUtil.m
//  youzhitou
//
//  Created by 张科 on 16/6/5.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "BMToast.h"
#import "UIApplication+BM.h"
#import "MBProgressHUD_ZC.h"
@implementation BMToast
static MBProgressHUD_ZC *hud;
static MBProgressHUD_ZC *hudR;


+(void)showTotastView:(UIView *)View WithTitle:(NSString *)title;
{
    if (hud)
    {
        hud = nil;
        hud = [MBProgressHUD_ZC showHUDAddedTo:View animated:YES];
        hud.labelText = title;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.0];

    }
    else
    {
        hud = [MBProgressHUD_ZC showHUDAddedTo:View animated:YES];
        hud.labelText = title;
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.0];

    }
    hud.userInteractionEnabled = NO;

}
+(void)showHudView:(UIView *)View WithTitle:(NSString *)title;
{
    if (hudR)
    {
        hudR = nil;
        hudR = [MBProgressHUD_ZC showHUDAddedTo:View animated:YES];
        hudR.labelText = title;
        hudR.mode = MBProgressHUDModeIndeterminate;
        
    }
    else
    {
        hudR = [MBProgressHUD_ZC showHUDAddedTo:View animated:YES];
        hudR.labelText = title;
        hudR.mode = MBProgressHUDModeIndeterminate;
        
    }
    hudR.userInteractionEnabled = NO;

}
+(void)hideHud:(UIView *)view
{
    [MBProgressHUD_ZC hideHUDForView:view animated:YES];
}

+(void)showAlertInWindow:(NSString *)title
{
    [BMToast showTotastView:[UIApplication sharedApplication].keyWindow WithTitle:title];
}

+(void)showAlertWith:(NSString *)title AndContent:(NSString *)content AndCallBack:(alertClickBlock)alertClick
{
    UIAlertController  *alertVC = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *acionCon = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        alertClick();
    }];
    UIAlertAction *acionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //模态取消alertview
        [alertVC dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alertVC addAction:acionCon];
    [alertVC addAction:acionCancle];
    
    
    [[UIApplication getCurrentVC]  presentViewController:alertVC animated:YES completion:^{
        
    }];
}

+ (void)showCustomAlertWith:(NSString *)title AndContent:(NSString *)content SureString:(NSString *)sure CancelString:(NSString *)cancel AndViewController:(id)vController AndCallBack:(alertClickBlock)alertClick
{
    UIAlertController  *alertVC = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *acionCon = [UIAlertAction actionWithTitle:sure style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        alertClick();
    }];
    UIAlertAction *acionCancle = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //模态取消alertview
        [alertVC dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alertVC addAction:acionCon];
    [alertVC addAction:acionCancle];
    [vController presentViewController:alertVC animated:YES completion:^{
        
    }];

}

+ (void)showActionSheetWithTitle:(NSString *)title Item1:(NSString *)item1 AndItem2:(NSString *)item2  AndItem3:(NSString *)item3 AndViewController:(id)vController AndCallBack:(actionClickBlock)alertClick
{
    UIAlertController  *alertVC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *acionCon1 = [UIAlertAction actionWithTitle:item1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        alertClick(1);
    }];
    UIAlertAction *acionCon2 = [UIAlertAction actionWithTitle:item2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        alertClick(2);
    }];
    
    UIAlertAction *acionCancle = [UIAlertAction actionWithTitle:item3 style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //模态取消alertview
        [alertVC dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [alertVC addAction:acionCon1];
    [alertVC addAction:acionCon2];
    [alertVC addAction:acionCancle];
    
    [vController presentViewController:alertVC animated:YES completion:^{
        
    }];
    
}

+ (void)showAlertWith:(NSString *)title AndActionTitles:(NSArray *)actionTitles AndCallBack:(actionClickBlock)alertClick {
    UIAlertController  *alertVC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    
    for (int i = 0; i < actionTitles.count; i ++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            alertClick(i);
            [alertVC dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        [alertVC addAction:action];
    }
    
    UIAlertAction *acionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //模态取消alertview
        [alertVC dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    

    [alertVC addAction:acionCancle];
    
    [[UIApplication getCurrentVC] presentViewController:alertVC animated:YES completion:^{
        
    }];
}




@end
