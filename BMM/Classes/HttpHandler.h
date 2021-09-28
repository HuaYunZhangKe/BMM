//
//  HttpHandler.h
//  Component
//
//  Created by Zack Zhang on 2021/8/6.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef void (^NetworkResult)(BOOL, NSData *);
static BOOL Enable_Log = NO;

@interface HttpHandler : NSObject

#pragma - mark Base
+(void)httpRequestWithAPI:(NSString *)api
                   method:(NSString *)methond
                parameter:(NSDictionary *)paras
                    topic:(NSString *)topic
                 jsonData:(BOOL)isJsonBody
        shouldAlertResult:(BOOL)isAlertResult shouldShowPrecess:(BOOL)shouldShowPrecess isUrlEncode:(BOOL)isUrlEncode
                   result: (NetworkResult) networkResult;

+ (void)httpRequestWithRequest:(NSURLRequest *)request
                     parameter:(NSDictionary *)paras
                     httpTopic:(NSString *)topic
             shouldAlertResult:(BOOL)isAlertResult
             shouldShowPrecess:(BOOL)shouldShowPrecess
                        result: (NetworkResult) networkResult;


@end




NS_ASSUME_NONNULL_END
