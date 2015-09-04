//
//  MenuViewController.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 8/29/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

-(IBAction)addPressed:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddMenuToggled" object:nil userInfo:nil];
}

-(IBAction)removePressed:(id)sender{
    
}

@end
