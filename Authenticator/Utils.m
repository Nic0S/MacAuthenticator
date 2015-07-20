//
//  Utils.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 7/15/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import "Utils.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@implementation Utils

//UPPERCASE
+(long long)decodeBase32:(NSString *)num{
    
    long long result = 0;
    
    for(int i = 0; i < num.length; i++){
        result = result << 5;
        result += [self charVal:[num characterAtIndex:i]];
    }
    return result;
}

+(long long)decodeBase32_2:(const char*)s{
    unsigned int len = strlen(s) - 1;
    long long result = 0;
    char start_ch = 0, ch;
    while(*s != '\0') {
        ch = *s;
        if (ch >= 'a') {
            start_ch = 'a' - 10;
        } else if (ch >= 'A') {
            start_ch = 'A' - 10;
        } else {
            start_ch = '0';
        }
        
        if(len >= 0)
            result += (ch - start_ch) * pow(32, len);
        else
            result += (ch - start_ch);
        ++s;
        --len;
    }
    
    return result;
}

+(NSString*)intToBase32String:(long long)number{
    NSMutableString *result = [NSMutableString new];
    
    //for(int i = 0; i < 32)
    
    return result;
}

+(int) charVal:(char)c{
    if(c <= '9' && c >= '0'){
        return c - '0';
    } else if(c >= 'A' && c <= 'V'){
        return c - 'A' + 10;
    } else {
        return -1;
    }
}

+(NSString*) sha1:(NSString*)input {
    NSData *data = [input dataUsingEncoding:NSUTF32StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end