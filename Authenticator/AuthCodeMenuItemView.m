
//
//  AuthCodeMenuItemView.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 8/26/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthCodeMenuItemView.h"

@implementation AuthCodeMenuItemView

- (void)drawRect:(NSRect)rect {
    
    [super drawRect:rect];
    
    NSButton *copyButton = [self viewWithTag:2];
    
    if([[self enclosingMenuItem] isHighlighted]){
        copyButton.hidden = NO;
    } else {
        copyButton.hidden = YES;
    }
}
@end