//
//  MenuViewController.h
//  Authenticator
//
//  Created by Nico Schlumprecht on 8/29/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MenuViewController : NSViewController{
@private
    IBOutlet NSButton* addButton;
    IBOutlet NSButton* removeButton;
}

-(IBAction)addPressed:(id)sender;

-(IBAction)removePressed:(id)sender;

-(IBAction)sourcePressed:(id)sender;

@end
