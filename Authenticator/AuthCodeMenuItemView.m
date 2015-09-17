
//
//  AuthCodeMenuItemView.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 8/26/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthCodeMenuItemView.h"

@implementation AuthCodeMenuItemView{
    BOOL removing;
}

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
        if(removing){
            [copyButton setTitle:@"✘"];
        } else {
            [copyButton setTitle:@"Copy"];
        }
    }
}

-(void)setRemoving:(BOOL)r{
    NSButton *copyButton = [self viewWithTag:2];
    
    removing = r;
    if(removing){
        [copyButton setTitle:@"✘"];
    } else if(![[copyButton title] isEqualToString:@"✔︎"]){
        NSLog(@"set to copy");
        [copyButton setTitle:@"Copy"];
    }
}
@end