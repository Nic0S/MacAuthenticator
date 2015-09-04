//
//  AddSecretViewController.h
//  Authenticator
//
//  Created by Nico Schlumprecht on 8/29/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AddSecretViewController : NSViewController{
@private
    IBOutlet NSTextField* nameField;
    IBOutlet NSTextField* codeField;
}

-(IBAction)itemEdited:(id)sender;

-(void)reset;

@end
