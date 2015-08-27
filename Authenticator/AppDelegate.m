//
//  AppDelegate.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 4/14/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

NSMenu *menu = nil;
NSTimer *timer;
int secondsPassed;
int timeOut = 120;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    
    _keyStorage = [[KeyStorage alloc] init];
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.title = @"";
    _statusItem.image = [NSImage imageNamed:@"icon.png"];
    
    //highlighted image
    _statusItem.alternateImage = [NSImage imageNamed:@"icon.png"];
    
    // The image gets a blue background when the item is selected
    _statusItem.highlightMode = YES;
    menu = [[NSMenu alloc] init];
    [_statusItem setAction:@selector(openMenu:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addKey:) name:@"KeyAddedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeKey:) name:@"KeyRemovedNotification" object:nil];

    
    
}

/*
 refreshes the the data in the statusbar menu. Called once per second while status menu is open.
 */
-(void)setStatusBarMenu:(id)sender {
    NSLog(@"%@", @"update");
    [menu removeAllItems];
    [menu addItemWithTitle:@"Add Key..." action:@selector(openAddKeyWindow:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Remove Key..." action:@selector(openRemoveKeyWindow:) keyEquivalent:@""];
    [menu addItem:[NSMenuItem separatorItem]];
    [menu setAutoenablesItems:NO];
    NSDictionary *authCodes = [_keyStorage getAllAuthCodes];
    
    NSDate* now = [NSDate date];
    NSCalendar *gCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gCalendar components:(NSSecondCalendarUnit) fromDate:now];
    NSInteger second = 30 - [dateComponents second] % 30;
    [menu addItemWithTitle:[NSString stringWithFormat:@"Time:\t\t%ld", (long)second] action:nil keyEquivalent:@""];
    
    if([authCodes count] > 0){
        [menu addItem:[NSMenuItem separatorItem]];
    }
    
    NSDictionary* items = [Utils formatMenuItems:authCodes];
    
    for(NSString *key in authCodes) {
        //[menu addItemWithTitle:items[key] action:@selector(menuItemClicked:) keyEquivalent:key];
        AuthCodeViewController *viewController = [[AuthCodeViewController alloc] initWithNibName:@"AuthCodeView" bundle:nil];
        [viewController loadView];
        [viewController setDisplayName:key code:authCodes[key]];
        
        NSMenuItem *menuItem = [[NSMenuItem alloc] init];
        [menuItem setView:[viewController view]];
        [menu addItem:menuItem];
    }
}

-(void)menuItemClicked:(NSNotification *)notification{
    NSArray* ar = [NSArray arrayWithObject:@"_keyEquivalent"];
    NSString* selectedCode = [notification dictionaryWithValuesForKeys:ar][@"_keyEquivalent"];
    if(selectedCode != nil){
        NSPasteboard* pasteBoard = [NSPasteboard generalPasteboard];
        [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
        [pasteBoard setString:selectedCode forType:NSStringPboardType];
    }
}

/*
 Refreshes the menu, sets the timer for 1/sec refreshes, and then removes timer when menu is closed.
 
 the NSEventTrackingRunLoopMode is necessary because having the menu open blocks the main thread.
 */
-(void)openMenu:(id)sender{
    NSLog(@"%@", @"openMenu");
    [self setStatusBarMenu:nil];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setStatusBarMenu:) userInfo:nil repeats:YES];
    [runLoop addTimer:timer forMode:NSEventTrackingRunLoopMode];
    [_statusItem popUpStatusItemMenu:menu];
    [timer invalidate];
}

/*
 Creates an instance of the "Add Key" window and shows it
*/
-(void)openAddKeyWindow:(id)sender {
    self.addKeyController = [[NSWindowController alloc] initWithWindowNibName:@"AddKeyWindow"];
    [_addKeyController showWindow:self];
    [[_addKeyController window] makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

/*
 Creates an instance of the "Remove Key" window and shows it
*/
-(void)openRemoveKeyWindow:(id)sender {
    self.removeKeyController = [[NSWindowController alloc] initWithWindowNibName:@"RemoveKeyWindow"];
    [_removeKeyController showWindow:self];
    [[_removeKeyController window] makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];

    
    [self updateRemoveKeyNames];
}

-(void)updateRemoveKeyNames {
    NSDictionary *userInfo = _keyStorage.getAllAuthCodes;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Names" object:nil userInfo:userInfo];
}

/*
 Called when "Add" button is pressed, receives the name and secret, adds entry
 to key storage.
 */
-(void)addKey:(NSNotification *) notification{
    NSString *name = notification.userInfo[@"name"];
    NSString *secret = notification.userInfo[@"secret"];
    
    NSLog(@"%@ %@", name, secret);
    
    [_keyStorage addKey:name key:secret];
}

-(void)removeKey:(NSNotification *) notification{
    NSString *name = notification.userInfo[@"name"];
    [_keyStorage removeKey:name];
    [self updateRemoveKeyNames];
}



- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
