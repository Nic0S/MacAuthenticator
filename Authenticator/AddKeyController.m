//
//  AddKeyController.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 5/25/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import "AddKeyController.h"

@implementation AddKeyController


- (IBAction) addKeyButtonPressed:(id)sender{
    NSDictionary *userInfo = @{ @"name" : [nameBox stringValue], @"secret" : [keyBox stringValue]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KeyAddedNotification" object:nil userInfo:userInfo];
    [window close];
}


@end
