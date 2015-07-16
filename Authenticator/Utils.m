//
//  Utils.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 7/15/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import "Utils.h"
#import <Foundation/Foundation.h>

@implementation Utils

//UPPERCASE
+(long long)decodeBase32:(NSString *)num{
    
    long long result = 0;
    
    for(int i = 0; i < num.length; i++){
        result = result << 5;
        result += charVal([num characterAtIndex:i]);
    }
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

@end