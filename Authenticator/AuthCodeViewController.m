//
//  AuthCodeViewController.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 8/23/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthCodeViewController.h"

@implementation AuthCodeViewController

-(instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

- (void)awakeFromNib {
    
}

-(void)setDisplayName:(NSString *)name code:(NSString *)code{
    [nameField setStringValue:name];
    [codeField setStringValue:code];
    [self.view setNeedsDisplay:YES];
    
}

-(IBAction)copyButton:(id)sender {
    NSString* code = [codeField stringValue];
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:code  forType:NSStringPboardType];
}


@end