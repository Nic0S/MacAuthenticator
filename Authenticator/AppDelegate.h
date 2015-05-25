//
//  AppDelegate.h
//  Authenticator
//
//  Created by Nico Schlumprecht on 4/14/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>{
@private
    IBOutlet NSTextField *keyBox;
}

@property (nonatomic, strong) NSWindowController *addKeyController;
@property (nonatomic, strong) NSWindowController *removeKeyController;

- (IBAction) addKeyButtonPressed:(id)sender;
@end