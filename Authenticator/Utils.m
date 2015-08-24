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

+(NSDictionary*)formatMenuItems:(NSDictionary *)items{
    uint maxLength = 0;
    for(NSString* name in items){
        if([name length] > maxLength){
            maxLength = (int)[name length];
        }
    }
    NSString* formatString = [NSString stringWithFormat:@"%@-%d%@\t\t%@", @"%", maxLength + 5, @"s", @"%s"];
    // %4@    %@
    NSMutableDictionary *menuItems = [NSMutableDictionary new];
    maxLength = maxLength + 3;
    for(NSString* name in items){
//        NSString* item = [NSString stringWithFormat:formatString, name, items[name]];
        //NSString* item = [NSString stringWithFormat:@"%s%*c%s", [name UTF8String], 33, ' ', [items[name] UTF8String]];
        NSString* item = [NSString stringWithFormat:formatString, [name UTF8String], [items[name] UTF8String]];
        menuItems[name] = item;
    }

    return menuItems;
}

@end