//
//  AppDelegate.h
//  Authenticator
//
//  Created by Nico Schlumprecht on 4/14/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KeyStorage.h"
#import "RemoveKeyController.h"
#import "Utils.h"
#import "AuthCodeViewController.h"
#import "TimeViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) NSWindowController *addKeyController;
@property (nonatomic, strong) NSWindowController *removeKeyController;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) KeyStorage *keyStorage;

/*
 Called when "Add" button is pressed, receives the name and secret, adds entry
 to key storage.
 */
-(void)addKey:(NSNotification *) notification;

@end