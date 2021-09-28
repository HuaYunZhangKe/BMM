//
//  NSData+BM.m
//  BM
//
//  Created by 张科 on 2017/6/8.
//  Copyright © 2017年 bm. All rights reserved.
//

#import "NSData+BM.h"

@implementation NSData (BM)
- (NSString *)toString
{
   return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)toDictionary {
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
}

- (NSArray *)toArray {
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
}








@end
