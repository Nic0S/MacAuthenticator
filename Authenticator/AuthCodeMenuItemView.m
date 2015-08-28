
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
    
    NSPoint globalLocation = [ NSEvent mouseLocation ];
    NSPoint windowLocation = [ [ self window ] convertScreenToBase: globalLocation ];
    NSPoint viewLocation = [ self convertPoint: windowLocation fromView: nil ];
    if( NSPointInRect( viewLocation, [ self bounds ] ) ) {
        copyButton.hidden = NO;
    } else {
        copyButton.hidden = YES;
        [copyButton setTitle:@"Copy"];
    }
}
@end