//
//  HttpHandler.m
//  Component
//
//  Created by Zack Zhang on 2021/8/6.
//

#import "HttpHandler.h"
#import "NSDictionary+BM.h"
#import "UIApplication+BM.h"
#import "BMToast.h"
#import "ZCMarkPrompt.h"

@implementation HttpHandler

+(void)httpRequestWithAPI:(NSString *)api
                   method:(NSString *)methond
                parameter:(NSDictionary *)paras
                    topic:(NSString *)topic
                 jsonData:(BOOL)isJsonBody
        shouldAlertResult:(BOOL)isAlertResult shouldShowPrecess:(BOOL)shouldShowPrecess isUrlEncode:(BOOL)isUrlEncode
                   result: (NetworkResult) networkResult {
    if ([methond isEqualToString:@"GET"]) {
        NSString *bodyString = @"";
        if ([paras toHttpParamsStringEncode:isUrlEncode]) {
            bodyString = [paras toHttpParamsStringEncode:isUrlEncode];
        }
        NSString *requestString = @"";
        if (paras) {
            requestString = [NSString stringWithFormat:@"HTTP Request Start:\nMethod:%@\nApi:%@?%@", methond, api,bodyString];
        }

        if (Enable_Log) {
            NSLog(@"%@", requestString);
        }
        
        
        NSString *host = [NSString stringWithFormat:@"%@?%@", api, bodyString];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:host]];
        request.HTTPMethod = methond;
        [HttpHandler httpRequestWithRequest:request parameter:paras httpTopic:topic shouldAlertResult:isAlertResult shouldShowPrecess:shouldShowPrecess result:networkResult];


    }
    
    
    if ([methond isEqualToString:@"POST"] ) {
        NSString *bodyString = [paras toHttpParamsStringEncode:isUrlEncode];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:api]];
        request.HTTPMethod = methond;
        if (isJsonBody) {
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            request.HTTPBody = [NSJSONSerialization dataWithJSONObject:paras options:NSJSONWritingFragmentsAllowed error:nil];

        } else {
            NSData *postData = [bodyString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            request.HTTPBody = postData;
        }

        NSString *requestString = [NSString stringWithFormat:@"HTTP Request Start:\nMethod:%@\nApi:%@\nBody:%@", @"POST", api, bodyString];
        if (Enable_Log) {
            NSLog(@"%@", requestString);
        }
        [HttpHandler httpRequestWithRequest:request parameter:paras httpTopic:topic shouldAlertResult:isAlertResult shouldShowPrecess:shouldShowPrecess result:networkResult];
    }
    
    if ([methond isEqualToString:@"PUT"] ) {
        NSString *bodyString = [paras toHttpParamsStringEncode:isUrlEncode];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:api]];
        request.HTTPMethod = methond;
        if (isJsonBody) {
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            if (paras) {
                request.HTTPBody = [NSJSONSerialization dataWithJSONObject:paras options:NSJSONWritingFragmentsAllowed error:nil];
            }


        } else {
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            NSData *postData = [bodyString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            request.HTTPBody = postData;
        }

        NSString *requestString = [NSString stringWithFormat:@"HTTP Request Start:\nMethod:%@\nApi:%@\nBody:%@", @"PUT", api, bodyString];
        if (Enable_Log) {
            NSLog(@"%@", requestString);
        }
        
        [HttpHandler httpRequestWithRequest:request parameter:paras httpTopic:topic shouldAlertResult:isAlertResult shouldShowPrecess:shouldShowPrecess result:networkResult];
    }
    
    if ([methond isEqualToString:@"DELETE"] ) {
        NSString *bodyString = [paras toHttpParamsStringEncode:isUrlEncode];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:api]];
        request.HTTPMethod = methond;
        if (isJsonBody) {
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            if (paras) {
                request.HTTPBody = [NSJSONSerialization dataWithJSONObject:paras options:NSJSONWritingFragmentsAllowed error:nil];
            }


        } else {
            NSData *postData = [bodyString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            request.HTTPBody = postData;
        }

        NSString *requestString = [NSString stringWithFormat:@"HTTP Request Start:\nMethod:%@\nApi:%@\nBody:%@", @"DELETE", api, bodyString];
        if (Enable_Log) {
            NSLog(@"%@", requestString);
        }
        
        [HttpHandler httpRequestWithRequest:request parameter:paras httpTopic:topic shouldAlertResult:isAlertResult shouldShowPrecess:shouldShowPrecess result:networkResult];
    }
}

+ (void)httpRequestWithRequest:(NSURLRequest *)request
                     parameter:(NSDictionary *)paras
                     httpTopic:(NSString *)topic
             shouldAlertResult:(BOOL)isAlertResult
             shouldShowPrecess:(BOOL)shouldShowPrecess
                        result: (NetworkResult) networkResult{
    NSString *requestString = [NSString stringWithFormat:@"\nHTTP Request:\nMethod:%@\nApi:%@", request.HTTPMethod, request.URL.absoluteString];
    
    if (shouldShowPrecess) {
        [BMToast showHudView:[UIApplication getTopWindow] WithTitle:@"请求提交中..."];
    }
    __block NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (shouldShowPrecess) {
                [BMToast hideHud:[UIApplication getTopWindow]];
            }
        });
        if (data) {
            

            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (Enable_Log) {
                NSLog(@"%@", requestString);
                NSLog(@"\nResponse:Success!\n%@",responseString);
            }
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (dataDictionary) {
                NSInteger code = [dataDictionary[@"code"] integerValue];
                if (code == 200) {
                    if (isAlertResult) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [ZCMarkPrompt showMarkToastInViewController:[UIApplication getCurrentVC] message:[NSString stringWithFormat:@"%@成功!", topic] completionBlock:^ {
                                return networkResult(YES, data);
                            }];
                        });
                    } else {
                        return networkResult(YES, data);

                    }
                } else {
                    if (isAlertResult) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [ZCMarkPrompt showFailedToastInViewController:[UIApplication getCurrentVC] message:[NSString stringWithFormat:@"%@失败!", topic] completionBlock:^{
                                return networkResult(NO, data);
                            }];
                        });
                    } else {
                        return networkResult(NO, data);
                    }
                }
                
            } else {
                if (isAlertResult) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ZCMarkPrompt showFailedToastInViewController:[UIApplication getCurrentVC] message:[NSString stringWithFormat:@"%@失败!", topic] completionBlock:^{
                            return networkResult(NO, data);
                        }];
                    });
                } else {
                    return networkResult(NO, data);

                }

            }

        } else {
            if (isAlertResult) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ZCMarkPrompt showFailedToastInViewController:[UIApplication getCurrentVC] message:[NSString stringWithFormat:@"%@失败!", topic] completionBlock:^{
                        return networkResult(NO, nil);

                    }];
                });
            } else {
                return networkResult(NO, nil);

            }

            if (Enable_Log) {
                NSLog(@"\nResponse:Fail!");

            }

        }
    }];
    [dataTask resume];
}
@end
