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

@implementation AppDelegate{

    NSInteger TIME;
    NSInteger FIRST_CODE;
    NSInteger ADD_MENU;
    NSInteger DONE_REMOVING;
    
    NSMenu *menu;
    NSTimer *timer;
    int secondsPassed;
    int timeOut;
    BOOL codeMenuNeedsRefresh;
    BOOL addMenuOpen;
    BOOL removeMenuOpen;
    NSMutableArray *authCodeViewControllers;
    AddKeyController *addKeyController;
    TimeViewController *timeViewController;
    MenuViewController *menuViewController;
    DoneRemovingViewController *doneRemovingViewController;
    NSMenuItem *doneRemovingItem;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    codeMenuNeedsRefresh = YES;
    addMenuOpen = NO;
    removeMenuOpen = NO;
    timeOut = 120;
    TIME = 343;
    FIRST_CODE = 344;
    ADD_MENU = 345;
    DONE_REMOVING = 346;
    menu = nil;
    authCodeViewControllers= nil;
    
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
    
    doneRemovingViewController = [[DoneRemovingViewController alloc] initWithNibName:@"DoneRemovingView" bundle:nil];
    doneRemovingItem = [[NSMenuItem alloc] init];
    [doneRemovingItem setView:[doneRemovingViewController view]];
    [doneRemovingItem setTag:DONE_REMOVING];
    [_statusItem setAction:@selector(openMenu:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addKey:) name:@"KeyAddedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeKey:) name:@"KeyRemovedNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openAddKeyWindow:) name:@"AddPressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeToggled:) name:@"RemovePressed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneRemoving:) name:@"DoneRemovingNotification" object:nil];
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
        
        authCodeViewControllers = [NSMutableArray new];
        for(NSString *key in authCodes) {
            AuthCodeViewController *viewController = [[AuthCodeViewController alloc] initWithNibName:@"AuthCodeView" bundle:nil];
            [viewController view];
            [viewController setDisplayName:key code:authCodes[key]];
            [viewController setRemoveMenu:removeMenuOpen];
            
            NSMenuItem *menuItem = [[NSMenuItem alloc] init];
            if(first) {
                [menuItem setTag:FIRST_CODE];
                first = NO;
            }
            [menuItem setView:[viewController view]];
            [authCodeViewControllers addObject:viewController];
            [menu addItem:menuItem];
        }
        codeMenuNeedsRefresh = NO;
    } else {
        NSArray *items = [menu itemArray];
        
        int j = 0;
        for(NSString *key in authCodes) {
            [authCodeViewControllers[j] setRemoveMenu:removeMenuOpen];
            [authCodeViewControllers[j] setDisplayName:key code:authCodes[key]];
            j++;
        }
        for(NSInteger i = [menu indexOfItemWithTag:FIRST_CODE]; i < [items count]; i++){
            [menu itemChanged:items[j]];
            
        }
    }
    
    NSMenuItem *doneItem = [menu itemWithTag:DONE_REMOVING];
    if(doneItem == nil && removeMenuOpen){
        [menu addItem:doneRemovingItem];
    } else if(doneItem != nil && !removeMenuOpen){
        [menu removeItem:doneItem];
    }
}


-(void)menuItemClicked:(NSNotification *)notification{
    [menu cancelTracking];
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
    removeMenuOpen = NO;
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
    if(addKeyController == nil || ![[addKeyController window] isVisible]){
        addKeyController = [[AddKeyController alloc] initWithWindowNibName:@"AddKeyWindow"];
    }
    NSRect frame = [[addKeyController window] frame];
    frame.origin.x = NSMaxX([[NSScreen mainScreen] visibleFrame]) - frame.size.width;
    frame.origin.y = NSMaxY([[NSScreen mainScreen] visibleFrame]) - frame.size.height;
    [[addKeyController window] setFrame:frame display:NO];
    [addKeyController showWindow:self];
    [[addKeyController window] makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

-(void)removeToggled:(id)sender {
    removeMenuOpen = YES;
    [self setStatusBarMenu:nil];
}

-(void)doneRemoving:(id)sender {
    removeMenuOpen = NO;
    [self setStatusBarMenu:nil];
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
    [self setStatusBarMenu:nil];
}

-(void)addMenuToggled:(NSNotification *) notification{
    addMenuOpen = !addMenuOpen;
    [self setStatusBarMenu:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
