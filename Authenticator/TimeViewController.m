//
//  TimeViewController.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 8/28/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeViewController.h"

@implementation TimeViewController

-(void)setTime:(NSString *)time{
    [timeField setStringValue:time];
    [self.view setNeedsDisplay:YES];
}

@end