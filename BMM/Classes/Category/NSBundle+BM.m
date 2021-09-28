//
//  NSBundle+BM.m
//  BM
//
//  Created by 张科 on 2019/9/15.
//  Copyright © 2019 pingmedia. All rights reserved.
//

#import "NSBundle+BM.h"

@implementation NSBundle (BM)
+ (NSString *)bundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (NSString*)appIconPath {
    NSString* iconFilename = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"] ;
    NSString* iconBasename = [iconFilename stringByDeletingPathExtension] ;
    NSString* iconExtension = [iconFilename pathExtension] ;
    return [[NSBundle mainBundle] pathForResource:iconBasename
                                           ofType:iconExtension] ;
}

- (UIImage*)appIcon {
    UIImage*appIcon = [[UIImage alloc] initWithContentsOfFile:[self appIconPath]] ;
    return appIcon;
}
@end
