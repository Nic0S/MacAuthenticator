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

NSInteger TIME = 343;
NSInteger FIRST_CODE = 344;
NSInteger ADD_MENU = 345;

NSMenu *menu = nil;
NSTimer *timer;
int secondsPassed;
int timeOut = 120;
BOOL codeMenuNeedsRefresh = YES;
BOOL addMenuOpen = NO;
NSMutableArray *menuViewControllers = nil;
TimeViewController *timeViewController;
MenuViewController *menuViewController;

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
    menuViewController = [[MenuViewController alloc] initWithNibName:@"MenuView" bundle:nil];
    [menuViewController loadView];
    NSMenuItem *menuItem = [[NSMenuItem alloc] init];
    [menuItem setView:[menuViewController view]];
    [menu addItem:menuItem];
    
    [menu addItem:[NSMenuItem separatorItem]];
    timeViewController = [[TimeViewController alloc] initWithNibName:@"TimeView" bundle:nil];
    [timeViewController loadView];
    NSMenuItem *timeItem = [[NSMenuItem alloc] init];
    [timeItem setView:[timeViewController view]];
    [timeItem setTag:TIME];
    [menu addItem:timeItem];
    
    [menu addItem:[NSMenuItem separatorItem]];
    [menu setAutoenablesItems:NO];
    [_statusItem setAction:@selector(openMenu:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addKey:) name:@"KeyAddedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeKey:) name:@"KeyRemovedNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMenuToggled:) name:@"AddMenuToggled" object:nil];
}

/*
 refreshes the the data in the statusbar menu. Called once per second while status menu is open.
 */
-(void)setStatusBarMenu:(id)sender {
    NSLog(@"%@", @"update");
    //NSDictionary *authCodes = [_keyStorage getAllAuthCodes];
    
    NSDate* now = [NSDate date];
    NSCalendar *gCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gCalendar components:(NSSecondCalendarUnit) fromDate:now];
    NSInteger second = 30 - [dateComponents second] % 30;
    //[menu addItemWithTitle:[NSString stringWithFormat:@"Time:\t\t%ld", (long)second] action:nil keyEquivalent:@""];
    //[[menu itemWithTag:TIME] setTitle:[NSString stringWithFormat:@"Time:\t\t\t\t\t\t\t%ld", (long)second]];
    [timeViewController setTime:[NSString stringWithFormat:@"%ld", (long)second]];
     
    NSDictionary *authCodes = [_keyStorage getAllAuthCodes];
    if(codeMenuNeedsRefresh){
        NSInteger codeIndex = [menu indexOfItemWithTag:FIRST_CODE];
        if(codeIndex > -1){
            while([[menu itemArray] count] > codeIndex){
                [menu removeItemAtIndex:codeIndex];
            }
        }
        
        BOOL first = YES;
        
        menuViewControllers = [NSMutableArray new];
        for(NSString *key in authCodes) {
            AuthCodeViewController *viewController = [[AuthCodeViewController alloc] initWithNibName:@"AuthCodeView" bundle:nil];
            [viewController loadView];
            [viewController setDisplayName:key code:authCodes[key]];
            NSMenuItem *menuItem = [[NSMenuItem alloc] init];
            if(first) {
                [menuItem setTag:FIRST_CODE];
                first = NO;
            }
            [menuItem setView:[viewController view]];
            [menuViewControllers addObject:viewController];
            [menu addItem:menuItem];
        }
        codeMenuNeedsRefresh = NO;
    } else {
        NSArray *items = [menu itemArray];
        
        int j = 0;
        for(NSString *key in authCodes) {
            [menuViewControllers[j++] setDisplayName:key code:authCodes[key]];
        }
        for(NSInteger i = [menu indexOfItemWithTag:FIRST_CODE]; i < [items count]; i++){
            [menu itemChanged:items[j]];
        }
    }
    
    //NSDictionary* items = [Utils formatMenuItems:authCodes];
    
    
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
    codeMenuNeedsRefresh = YES;
}

-(void)removeKey:(NSNotification *) notification{
    NSString *name = notification.userInfo[@"name"];
    [_keyStorage removeKey:name];
    [self updateRemoveKeyNames];
    codeMenuNeedsRefresh = YES;
}

-(void)addMenuToggled:(NSNotification *) notification{
    addMenuOpen = !addMenuOpen;
    [self setStatusBarMenu:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
