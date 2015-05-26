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

NSMenu *menu;
NSTimer *timer;
int secondsPassed;
int timeOut = 120;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    _keyStorage = [[KeyStorage alloc] init];
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
    menu = [[NSMenu alloc] init];
    [_statusItem setAction:@selector(openMenu:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addKey:) name:@"KeyAddedNotification" object:nil];
    


    
}

-(void)setStatusBarMenu:(id)sender {
    NSLog(@"%@", @"update");
    //menu = [[NSMenu alloc] init];
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
    
    [menu addItem:[NSMenuItem separatorItem]];
    
    for(NSString *key in authCodes){
        NSMutableString *menuItem = [NSMutableString new];
        [menuItem appendString:key];
        [menuItem appendString:@"\t\t"];
        [menuItem appendString:authCodes[key]];
        
        [menu addItemWithTitle:menuItem action:nil keyEquivalent:@""];
        
        NSLog(@"%@ %@", key, authCodes[key]);
    }
    
    //_statusItem.menu = menu;

    secondsPassed++;
    if(secondsPassed > timeOut){
        [timer invalidate];
        secondsPassed = 0;
        timer = nil;
    }
}

-(void)openMenu:(id)sender{
    NSLog(@"%@", @"openMenu");
    [self setStatusBarMenu:nil];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setStatusBarMenu:) userInfo:nil repeats:YES];
    [runLoop addTimer:timer forMode:NSEventTrackingRunLoopMode];
    [_statusItem popUpStatusItemMenu:menu];
    [timer invalidate];
    NSLog(@"%@", @"done");
}

-(void)openAddKeyWindow:(id)sender {
    self.addKeyController = [[NSWindowController alloc] initWithWindowNibName:@"AddKeyWindow"];
    [_addKeyController showWindow:self];
    [[_addKeyController window] makeKeyAndOrderFront:self];
}

-(void)openRemoveKeyWindow:(id)sender {
    
}

-(void)addKey:(NSNotification *) notification{
    NSString *name = notification.userInfo[@"name"];
    NSString *secret = notification.userInfo[@"secret"];
    
    NSLog(@"%@ %@", name, secret);
    
    [_keyStorage addKey:name key:secret];
}



- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
