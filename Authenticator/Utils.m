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

+(NSArray*)formatMenuItems:(NSDictionary *)items{
    uint maxLength = 0;
    for(NSString* name in items){
        if([name length] > maxLength){
            maxLength = (int)[name length];
        }
    }
    NSString* formatString = [NSString stringWithFormat:@"%@%d%@  %@", @"%", maxLength, @"@", @"%@"];
    // %4@    %@
    NSMutableArray *menuItems = [NSMutableArray new];
    
    for(NSString* name in items){
        //NSString* item = [NSString stringWithFormat:<#(NSString *), ...#>]
    }

    return menuItems;
}

@end