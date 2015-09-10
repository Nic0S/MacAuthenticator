//
//  AuthCodeViewController.h
//  Authenticator
//
//  Created by Nico Schlumprecht on 8/23/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#ifndef Authenticator_AuthCodeViewController_h
#define Authenticator_AuthCodeViewController_h

#import <Cocoa/Cocoa.h>
#import "AuthCodeMenuItemView.h"

@interface AuthCodeViewController : NSViewController {
@private
    IBOutlet NSTextField *nameField;
    IBOutlet NSTextField *codeField;
    IBOutlet NSButton *copyButton;
}

@property (atomic, strong) IBOutlet AuthCodeMenuItemView *view;

-(void) setDisplayName:(NSString*)name code:(NSString*)code;

-(IBAction)buttonPressed:(id)sender;

-(void)setRemoveMenu:(BOOL)removeOpen;

@end

#endif
