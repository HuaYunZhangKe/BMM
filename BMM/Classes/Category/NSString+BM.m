//
//  NSString+BM.m
//  BM
//
//  Created by houjue on 2017/6/5.
//  Copyright © 2017年 bm. All rights reserved.
//

#import "NSString+BM.h"
#import "NSData+BM.h"
#import "NSBundle+BM.h"
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"
@implementation NSString (BM)

- (NSDictionary *)toDictionary
{
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization
                             JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                             options:NSJSONReadingMutableContainers
                             error:&err];
    if(err)
    {
        BMLOG(@"[json解析失败] string: %@", self);
        return nil;
    }
    return dic;
}

- (NSString *)URLEncodedString
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}


-(NSString *)URLDecodedString
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];

    return [self stringByRemovingPercentEncoding];
}

- (NSString *)getContent
{
    NSArray *d = [self componentsSeparatedByString:@"."];
    if (d.count < 2) {
        return @"";
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:d[0] ofType:d[1]];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return [data toString];
}

- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

- (NSAttributedString *)htmlString
{
    NSDictionary *optoins = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSData *data= [self dataUsingEncoding:NSUnicodeStringEncoding];
    return [[NSAttributedString alloc] initWithData:data
                                            options:optoins
                                 documentAttributes:nil
                                              error:nil];
}

- (NSArray *)regexMatchString:(NSString *)regexStr
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];

    NSArray * matches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        for (int i = 0; i < [match numberOfRanges]; i++) {
            NSString *component = [self substringWithRange:[match rangeAtIndex:i]];
            [array addObject:component];
        }
    }
        
    return array;
}

- (NSString *)swiftClassName {
    return [NSString stringWithFormat:@"%@.%@",NSBundle.bundleName,self];
}


- (id)MD5
 {
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    unsigned int x=(int)strlen(cStr) ;
    CC_MD5( cStr, x, digest );
    // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return  output;
}

+ (NSString *)stringWithTime:(CGFloat)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    
    if (time >= 3600) {
        [dateFmt setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFmt setDateFormat:@"mm:ss"];
    }
    return [dateFmt stringFromDate:date];
}


- (CGSize)getStringSizeWithfont:(UIFont *)font maxWidth:(CGFloat)width {
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize size = [self boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    return  size;
}

- (CGSize)getStringSizeWithlineSpacing:(CGFloat)lineSpacing font:(UIFont*)font width:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpacing;
    NSDictionary *dic = @{ NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle };
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return  size;
}

- (NSString *)base64 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    //NSString *stringBase64 = [data base64Encoding]; // base64格式的字符串(不建议使用,用下面方法替代)
    NSString *stringBase64 = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return stringBase64;
}

// base64格式的字符串

- (BOOL)isNumber
{
    NSString *regex = @"^\\d$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [test evaluateWithObject:self];
}

- (BOOL)validateContactNumber{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,175,176,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|7[56]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:self] == YES)
       || ([regextestcm evaluateWithObject:self] == YES)
       || ([regextestct evaluateWithObject:self] == YES)
       || ([regextestcu evaluateWithObject:self] == YES)
       || ([regextestPHS evaluateWithObject:self] == YES)){
        return YES;
    }else{
        return NO;
    }
}


- (BOOL)validateCellPhoneNumber{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,175,176,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|7[56]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:self] == YES)
       || ([regextestcm evaluateWithObject:self] == YES)
       || ([regextestct evaluateWithObject:self] == YES)
       || ([regextestcu evaluateWithObject:self] == YES)){
        return YES;
    }else{
        return NO;
    }
}




- (BOOL)isEmail
{
    NSString *regex = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [test evaluateWithObject:self];
}
/***************************************************************************/
- (BOOL)isIDCardNumber
{
    NSString *idCard = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    int length =0;
    if (!idCard) {
        return NO;
    }else {
        length = (int)idCard.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [idCard substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return NO;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [idCard substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:idCard
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, idCard.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [idCard substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19|20[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19|20[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:idCard
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, idCard.length)];
            
            
            if(numberofMatch >0) {
                int S = ([idCard substringWithRange:NSMakeRange(0,1)].intValue + [idCard substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([idCard substringWithRange:NSMakeRange(1,1)].intValue + [idCard substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([idCard substringWithRange:NSMakeRange(2,1)].intValue + [idCard substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([idCard substringWithRange:NSMakeRange(3,1)].intValue + [idCard substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([idCard substringWithRange:NSMakeRange(4,1)].intValue + [idCard substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([idCard substringWithRange:NSMakeRange(5,1)].intValue + [idCard substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([idCard substringWithRange:NSMakeRange(6,1)].intValue + [idCard substringWithRange:NSMakeRange(16,1)].intValue) *2 + [idCard substringWithRange:NSMakeRange(7,1)].intValue *1 + [idCard substringWithRange:NSMakeRange(8,1)].intValue *6 + [idCard substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[idCard substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}
- (NSInteger)getIDCardSex
{
    NSString *card = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([card length] == 18) {
        NSInteger number = [[card substringWithRange:NSMakeRange(16,1)] integerValue];
        if (number % 2 == 0) {  //偶数为女
            return 0;
        } else {
            return 1;
        }
    }
    if ([card length] == 15) {
        NSInteger number = [[card substringWithRange:NSMakeRange(14,1)] integerValue];
        if (number % 2 == 0) {  //偶数为女
            return 0;
        } else {
            return 1;
        }
    }
    
    return 2;
}

- (NSInteger)getIDCardAge
{
    NSString *idCard = self;
    NSInteger length = (NSInteger)[idCard length];
    NSInteger age = 0;
    NSInteger year = 0;
    
    switch (length) {
        case 15:
        {
            year = [idCard substringWithRange:NSMakeRange(6,2)].integerValue + 1900;
            NSString *birthDay = [NSString stringWithFormat:@"%li%@%@", (long)year, [idCard substringWithRange:NSMakeRange(8,2)], [idCard substringWithRange:NSMakeRange(10,2)]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            NSString *nowDay = [dateFormatter stringFromDate:[NSDate date]];
            
            age = ([nowDay integerValue] - [birthDay integerValue]) / 10000;
        }
            break;
        case 18:
        {
            year = [idCard substringWithRange:NSMakeRange(6,4)].integerValue;
            NSString *birthDay = [NSString stringWithFormat:@"%li%@%@", (long)year, [idCard substringWithRange:NSMakeRange(10,2)], [idCard substringWithRange:NSMakeRange(12,2)]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            NSString *nowDay = [dateFormatter stringFromDate:[NSDate date]];
            
            age = ([nowDay integerValue] - [birthDay integerValue]) / 10000;
        }
            break;
            
        default:
            break;
    }
    
    return age;
}

///合法身份证
- (BOOL)isValidPersonIDCardNumber
{
    NSString *number = self;
    
    if(number.length != 18 && number.length != 15){
        return NO;
    }
    
    if(number.length == 15){
        
        NSArray *area = @[@"11",@"12",@"13",@"14",@"15",@"21",@"22",@"23",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"41",@"42",@"43",@"44",@"45",@"46",@"50",@"51",@"52",@"53",@"54",@"61",@"62",@"63",@"64",@"65",@"71",@"81",@"82",@"91"];
        
        
        if(![self isNumber]){
            //不是纯数字
            return NO;
        }
        
        if(![area containsObject:[self substringWithRange:NSMakeRange(0, 2)]]) {
            //前两位位置不对
            return NO;
        }
        
        NSInteger year = [@"19" stringByAppendingString:[self substringWithRange:NSMakeRange(6, 2)]].integerValue;
        
        NSInteger month = [self substringWithRange:NSMakeRange(8, 2)].integerValue;
        NSInteger day = [self substringWithRange:NSMakeRange(10, 2)].integerValue;
        
        switch (month) {
            case 1:
            case 3:
            case 5:
            case 7:
            case 8:
            case 10:
            case 12:
                if(day > 31){
                    return NO;
                }
                break;
            case 4:
            case 6:
            case 9:
            case 11:
                if(day > 30){
                    return NO;
                }
                break;
            case 02:
                if((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
                    if(day>29) {
                        return NO;
                    }
                } else {
                    if(day>28) {
                        
                        return NO;
                    }
                }
                
                break;
                
            default:
                return NO;
                break;
        }
    }
    
    
    if(number.length == 18){
        
        //验证因子
        
        NSString *sChecker = @"1,0,X,9,8,7,6,5,4,3,2";
        NSArray *chekerArray = [sChecker componentsSeparatedByString:@","];
        
        //相乘因子
        NSString *r = @"7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2";
        NSArray *rArray = [r componentsSeparatedByString:@","];
        
        NSInteger sum = 0;
        
        for(int i = 0; i < 17; i++){
            NSString *character = [number substringWithRange:NSMakeRange(i, 1)];
            sum += character.integerValue * [[rArray objectAtIndex:i] integerValue];
        }
        
        NSInteger last = sum%11;
        
        if([[number substringWithRange:NSMakeRange(17, 1)] isEqualToString:[chekerArray objectAtIndex:last]])
        {
            return YES;
        }else{
            return NO;
        }
        
        
    }
    
    
    return NO;
}


//银行卡校验规则(Luhn算法)
- (BOOL)isValidBankCardNumber
{
    NSInteger len = [self length];
    
    NSInteger sumNumOdd = 0;
    NSInteger sumNumEven = 0;
    BOOL isOdd = YES;
    
    for (NSInteger i = len - 1; i >= 0; i--) {
        
        NSInteger num = [self substringWithRange:NSMakeRange(i, 1)].integerValue;
        if (isOdd) {//奇数位
            sumNumOdd += num;
        }else{//偶数位
            num = num * 2;
            if (num > 9) {
                num = num - 9;
            }
            sumNumEven += num;
        }
        isOdd = !isOdd;
    }
    
    return ((sumNumOdd + sumNumEven) % 10 == 0);
    
}

- (BOOL)isFlightOrTrainNumber
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z0-9]+$"];
    return ([pred evaluateWithObject:self] && self.length <= 10);
}



- (BOOL)isAlphanumeric
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[a-zA-Z0-9]+$"];
    return [pred evaluateWithObject:self];
}
- (BOOL)isChineseAlphabet
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^([A-Za-z]|[\u4E00-\u9FA5])+$"];
    return [pred evaluateWithObject:self];
}

- (BOOL)isValidMobileNumber
{
    NSString * regex = @"^1(3[0-9]|4[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regextestmobile evaluateWithObject:self];
}

- (BOOL)isValidEmailAddress
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,8}";
    NSPredicate *emailMatch = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    if (![emailMatch evaluateWithObject:self]) {
        return NO;
    }
    return YES;
}


- (BOOL)isValidHtmlURL
{
    NSString *emailRegex = @"(([a-zA-Z0-9._-]+.[a-zA-Z]{2,6})|([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9&%_./-~-]*)?";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidPassword
{
    if (self.length < 6 || self.length > 20) {
        return NO;
    }
    
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:self];
    //    NSString *pwsRegex = @"^[@A-Za-z0-9!#$%^&*.~]{6,20}$";
    //    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwsRegex];
    //    return [pwdTest evaluateWithObject:self];
}


- (BOOL)isValildIPAddress
{
    BOOL ret = NO;
    
    NSArray *ipList = [self componentsSeparatedByString:@"."];
    
    if (ipList.count == 4) {
        
        NSString *ip1 = [ipList objectAtIndex:0];
        NSString *ip2 = [ipList objectAtIndex:1];
        NSString *ip3 = [ipList objectAtIndex:2];
        NSString *ip4 = [ipList objectAtIndex:3];
        
        if ([ip1 isNumber] && [ip2 isNumber] && [ip3 isNumber] && [ip4 isNumber]) {
            if (ip1.integerValue >= 0 && ip1.integerValue <= 255 &&
                ip2.integerValue >= 0 && ip2.integerValue <= 255 &&
                ip3.integerValue >= 0 && ip3.integerValue <= 255 &&
                ip4.integerValue >= 0 && ip4.integerValue <= 255) {
                ret = YES;
            }
        }
        
        
    }
    
    return ret;
}

- (BOOL)isValidIPPort
{
    BOOL ret = NO;
    
    if ([self isNumber] && self.integerValue >= 0 && self.integerValue <= 65535) {
        ret = YES;
    }
    
    return ret;
    
}

- (BOOL)isHTTPUrlStr{
    if (self.length>4 && ([[self substringToIndex:4] isEqualToString:@"www."] || [[self substringToIndex:4] isEqualToString:@"http"])) {
        return YES;
    }
    return NO;
}

- (BOOL)isValidMoneyWithRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [self stringByReplacingCharactersInRange:range withString:string];
    
    BOOL isMatch= YES;
    if (text.length > 0) {
        NSString * regex = @"(((^[0-9])|(^[1-9][0-9]{0,12}))(\\.[0-9]{0,2})?$)";
        
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        isMatch = [pred evaluateWithObject:text];
    }
    
    return isMatch;
}

- (BOOL)isValidMaxLength:(NSUInteger)maxLength WithRange:(NSRange)range replacementString:(NSString *)string
{
    if (maxLength > 0) {
        //这里默认是最多输入xx位
        NSString *aText = self;
        
        aText = [aText stringByReplacingCharactersInRange:range withString:string];
        if (aText.length > maxLength)
            
            return NO; // return NO to not change text
    }
    
    return YES;
}

+ (NSString *)getStringWithCMTime:(CMTime)time{
    NSUInteger dTotalSeconds = CMTimeGetSeconds(time);
    NSUInteger dHours = floor(dTotalSeconds / 3600);
    NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
    NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
    NSString *videoDurationText = [NSString stringWithFormat:@"%i:%02i:%02i",dHours, dMinutes, dSeconds];
    return videoDurationText;
}

- (NSString *)md5_16
{
    NSString *string32 = [self md5_32];
    NSString *string16 = [string32 substringWithRange:NSMakeRange(8, 16)];
    return string16;
}

- (NSString *)md5_32
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    
    
    NSString *string32 = [NSString stringWithFormat:
                          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          result[0], result[1], result[2], result[3],
                          result[4], result[5], result[6], result[7],
                          result[8], result[9], result[10], result[11],
                          result[12], result[13], result[14], result[15]
                          ];
    
    return string32;
}

- (NSString *)cutoutBankcardLastFourPlace{
    if (self.length > 3) {
        return [self substringFromIndex:self.length - 4];
    }
    return self;
}
@end
