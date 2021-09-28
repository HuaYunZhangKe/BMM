//
//  NSData+BM.h
//  BM
//
//  Created by 张科 on 2017/6/8.
//  Copyright © 2017年 bm. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef BMLOG
#define BMLOG(fmt, ...) NSLog((@"\n\n\nBMLOG:\n%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

@interface NSData (BM)
- (NSString *)toString;
- (NSDictionary *)toDictionary;
- (NSArray *)toArray;
- (NSArray *)toArrayWithModelName:(NSString *)name;
@end
