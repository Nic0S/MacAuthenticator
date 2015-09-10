//
//  AddKeyController.h
//  Authenticator
//
//  Created by Nico Schlumprecht on 5/25/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface AddKeyController : NSWindowController <NSTextFieldDelegate> {
@private
    IBOutlet NSTextField *keyBox;
    IBOutlet NSTextField *nameBox;
}

- (IBAction) addKeyButtonPressed:(id)sender;

- (IBAction) cancelButtonPressed:(id)sender;

@end
