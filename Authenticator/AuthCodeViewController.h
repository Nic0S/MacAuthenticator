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

@interface AuthCodeViewController : NSViewController {
@private
    IBOutlet NSTextField *nameField;
    IBOutlet NSTextField *codeField;
}

-(void) setDisplayName:(NSString*)name code:(NSString*)code;

-(IBAction)copyButton:(id)sender;

@end

#endif
