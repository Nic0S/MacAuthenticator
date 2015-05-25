//
//  AppDelegate.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 4/14/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (strong, nonatomic) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSLog(@"%@", @"helo");
    // Insert code here to initialize your application
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    // The text that will be shown in the menu bar
    _statusItem.title = @"";
    
    // The image that will be shown in the menu bar, a 16x16 black png works best
    _statusItem.image = [NSImage imageNamed:@"icon.png"];
    
    // The highlighted image, use a white version of the normal image
    _statusItem.alternateImage = [NSImage imageNamed:@"icon.png"];
    
    // The image gets a blue background when the item is selected
    _statusItem.highlightMode = YES;
    
    //[_window close];
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Add Key..." action:@selector(openAddKeyWindow:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Remove Key..." action:@selector(openRemoveKeyWindow:) keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]];
    
    _statusItem.menu = menu;
    
    self.addKeyController = [[NSWindowController alloc] initWithWindowNibName:@"AddKeyWindow"];
}

-(void)openAddKeyWindow:(id)sender {
    [_addKeyController showWindow:self];
}

-(void)openRemoveKeyWindow:(id)sender {
}

-(IBAction)addKeyButtonPressed:(id)sender{
    NSLog(@"%@", [keyBox stringValue]);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
