
#import <Foundation/Foundation.h>


@interface NSDictionary (BM)

- (NSString*_Nullable)toJson;
// @param isEncode  如果为YES则进行url encode
- (NSString *_Nullable)toHttpParamsStringEncode:(BOOL) isEncode;
- (NSData *_Nonnull)toHttpBodyWithSeparator:(NSString *_Nullable)separator;

- (void)bmSetValue:(nullable id)value forKey:(NSString * _Nonnull)key;
- (nullable id)bmValueForKey:(NSString *_Nonnull)key;
@end
