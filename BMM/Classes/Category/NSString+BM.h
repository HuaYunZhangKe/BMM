//
//  NSString+BM.h
//  BM
//
//  Created by houjue on 2017/6/5.
//  Copyright © 2017年 bm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


#ifndef BMLOG
#define BMLOG(fmt, ...) NSLog((@"\n\n\nBMLOG:\n%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif
@interface NSString (BM)
//JSON字符串转换为字典(jsonString -> dictionary)
- (NSDictionary *)toDictionary;
//字符串UTF-8编码（URLEncode）
- (NSString *)URLEncodedString;
//字符串UTF-8解码(URLDecode)
- (NSString *)URLDecodedString;
//判断是否是纯汉字
- (BOOL)isChinese;
//判断是否含有汉字
- (BOOL)includeChinese;

- (NSString *)getContent;

- (NSAttributedString *)htmlString;

- (NSArray *)regexMatchString:(NSString *)regexStr;

- (NSString *)swiftClassName;

//md5
- (id)MD5;

+ (NSString *)stringWithTime:(CGFloat)time;

- (CGSize)getStringSizeWithfont:(UIFont *)font maxWidth:(CGFloat)width;

- (CGSize)getStringSizeWithlineSpacing:(CGFloat)lineSpacing font:(UIFont*)font width:(CGFloat)width;

- (NSString *)base64;

#pragma mark - Regular
/**
 * 匹配字符串是否为数字
 
 @return 符合 YES 否则 NO
 */
- (BOOL)isNumber;

/**
 * 匹配字符串是否符合手机号或者电话号标准
 
 @return 符合 YES 否则 NO
 */
- (BOOL)validateContactNumber;

/**
 * 匹配字符串是否符合手机号标准
 
 @return 符合 YES 否则 NO
 */
- (BOOL)validateCellPhoneNumber;

/**
 * 匹配字符串是否符合邮箱标准
 
 @return 符合 YES 否则 NO
 */
- (BOOL)isEmail;


/**
 * 匹配字符串是否符合大陆身份证标准
 
 @return 符合 YES 否则 NO
 */
- (BOOL)isIDCardNumber;


/**
 * 获取身份证性别(需要事先校验下是否是正确的身份证)
 
 @return 1男0女，不符合条件者为2
 */
- (NSInteger)getIDCardSex;


/**
 * 获取身份证的年龄(需要事先校验下是否是正确的身份证)
 
 @return 当前身份证的年龄
 */
- (NSInteger)getIDCardAge;



///合法身份证
- (BOOL)isValidPersonIDCardNumber;

///银行卡校验规则(Luhn算法)
- (BOOL)isValidBankCardNumber;

/// 是否是是航班号  车次号
- (BOOL)isFlightOrTrainNumber;

/// 是否全部数字和字母组成
- (BOOL)isAlphanumeric;

///中文 字母等
- (BOOL)isChineseAlphabet;
///手机号码
- (BOOL)isValidMobileNumber;
///邮箱地址
- (BOOL)isValidEmailAddress;
///网页html
- (BOOL)isValidHtmlURL;
///合法密码
- (BOOL)isValidPassword;
///合法IP地址
- (BOOL)isValildIPAddress;
///合法IP端口
- (BOOL)isValidIPPort;
///HTTP类型链接
- (BOOL)isHTTPUrlStr;

#pragma mark -textField
///合法金额输入...用于textField  delegate
- (BOOL)isValidMoneyWithRange:(NSRange)range replacementString:(NSString *)string;
///判断text 最大长度 maxLength = 0 return YES
- (BOOL)isValidMaxLength:(NSUInteger)maxLength WithRange:(NSRange)range replacementString:(NSString *)string;
///将播放器中的CMTime数据转成string
+ (NSString *)getStringWithCMTime:(CMTime)time;

- (NSString *)md5_16;
- (NSString *)md5_32;

//截取银行卡号后四位
- (NSString *)cutoutBankcardLastFourPlace;

#pragma mark - Rich text



@end
