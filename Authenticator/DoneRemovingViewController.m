//
//  DoneRemovingViewController.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 9/17/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//


#import "DoneRemovingViewController.h"

@implementation DoneRemovingViewController

-(IBAction)doneRemoving:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DoneRemovingNotification" object:nil userInfo:nil];
}

@end

