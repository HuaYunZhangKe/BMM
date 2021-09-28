//
//  NSBundle+BM.h
//  BM
//
//  Created by 张科 on 2019/9/15.
//  Copyright © 2019 pingmedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (BM)
+ (NSString *)bundleName;
- (NSString*)appIconPath ;
- (UIImage*)appIcon ;
@end

NS_ASSUME_NONNULL_END
