//
//  AuthCodeViewController.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 8/23/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthCodeViewController.h"

@implementation AuthCodeViewController{
    BOOL removing;
}

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

-(IBAction)buttonPressed:(id)sender {
    if(removing){
        [self removeButton];
    } else {
        [self copyButton];
    }
}

-(void)copyButton{
    NSString* code = [codeField stringValue];
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:code  forType:NSStringPboardType];
    [copyButton setTitle:@"✔︎"];
    [self.view setNeedsDisplay:YES];
}

-(void)removeButton{
    NSDictionary *userInfo = @{ @"name" : [nameField stringValue]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KeyRemovedNotification" object:nil userInfo:userInfo];
}

-(void)setRemoveMenu:(BOOL)removeOpen{
    removing = removeOpen;
    [self.view setRemoving:removing];
}


@end