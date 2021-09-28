

#import "NSDictionary+BM.h"
#import "NSString+BM.h"
@implementation NSDictionary (BM)

- (NSString*)toJson
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (NSString *)toHttpParamsStringEncode:(BOOL)isEncode
{
    NSString *urlString = @"";
    
    for (int i = 0; i < self.count; i ++)
    {
        NSArray *keyArr = [self allKeys];
        if (i == 0)
        {
            NSString *key =  keyArr[i];
            NSString *value = [self objectForKey:key];
            NSString *tempStr = [NSString stringWithFormat:@"%@=%@",key,value];
            urlString = [urlString stringByAppendingString:tempStr];
        }
        else
        {
            NSString *key =  keyArr[i];
            NSString *value = [self objectForKey:key];
            NSString *tempStr = [NSString stringWithFormat:@"&%@=%@",key,value];
            urlString = [urlString stringByAppendingString:tempStr];
        }
    }
    return isEncode ? [urlString URLEncodedString] : urlString;
}


- (NSData *)toHttpBodyWithSeparator:(NSString *)separator
{

    //分界线 --BM
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",separator];
    // 结束符 --BM--
    NSString *lastStr = [[NSString alloc]initWithFormat:@"--%@--",separator];
    NSArray *picArr = @[@"cover",@"card_reverse",@"card_reverse"];
    NSMutableString *bodyNoPic=[[NSMutableString alloc]init];
    NSMutableData *bodyData=[[NSMutableData alloc]init];
    [bodyNoPic appendString:@"\r\n"];
    int i = 0;
    for (NSString *key in [self allKeys])
    {
        if (![picArr containsObject:key])
        {
            //添加分界线，换行
            [bodyNoPic appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [bodyNoPic appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [bodyNoPic appendFormat:@"%@\r\n",[self objectForKey:key]];
        }
        else
        {
            NSMutableString *bodyPic = [[NSMutableString alloc] init];
            
            ////添加分界线，换行
            [bodyPic appendFormat:@"%@\r\n",MPboundary];
            //声明pic字段，文件名为boris.png
            [bodyPic appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"boris.png\"\r\n",key];
            //声明上传文件的格式
            [bodyPic appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
            //image Data转换为String
            NSMutableData *picTempData = [[NSMutableData alloc] init];
            [picTempData appendData:[bodyPic dataUsingEncoding:NSUTF8StringEncoding]];
            [picTempData appendData:[self objectForKey:key]];
            [picTempData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [bodyData appendData:picTempData];
            
        }
        i ++;
    }
    NSMutableData *noPicData = [[NSMutableData alloc] init];
    [noPicData appendData:[bodyNoPic dataUsingEncoding:NSUTF8StringEncoding]];
    [noPicData appendData:bodyData];
    [noPicData appendData:[lastStr dataUsingEncoding:NSUTF8StringEncoding]];
    return noPicData;
}
/*
- (NSData *)toHttpBodyWithSeparator:(NSString *)separator
{
    // 结束符 --BM--
    NSString *lastStr = [[NSString alloc]initWithFormat:@"--%@--",separator];
    NSMutableString *body = [[NSMutableString alloc]init];
    [body appendString:@"\r\n"];
    
    for (NSString *key in [self allKeys])
    {
        [body appendFormat:@"%@\r\n", [[NSString alloc]initWithFormat:@"--%@",separator]];
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\";\r\n", key];
        NSString *data = [self valueForKey:key];
        
 
         if ([[data substringToIndex:22] isEqualToString:@"data:image/png;base64,"])
         {
             png
             [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
             image Data转换为String
             NSMutableData *picTempData = [[NSMutableData alloc] init];
             [picTempData appendData:[bodyPic dataUsingEncoding:NSUTF8StringEncoding]];
             [picTempData appendData:[self objectForKey:key]];
             [picTempData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
             [bodyData appendData:picTempData];
         }
 
        [body appendFormat:@"%@\r\n", data];
    }
    NSMutableData *noPicData = [[NSMutableData alloc] init];
    [noPicData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [noPicData appendData:[lastStr dataUsingEncoding:NSUTF8StringEncoding]];
    return noPicData;
}
*/


- (void)bmSetValue:(nullable id)value forKey:(NSString * _Nonnull)key;
{
    @try {
        [self setValue:value forKey:key];
    } @catch (NSException *exception) {
        BMLOG(@"%@", exception);
    }
}

- (nullable id)bmValueForKey:(NSString *)key;
{
    @try {
       return [self valueForKey:key];
    } @catch (NSException *exception) {
        BMLOG(@"%@", exception);
    }
    return nil;
}

@end
