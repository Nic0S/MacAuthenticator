//
//  TimeViewController.h
//  Authenticator
//
//  Created by Nico Schlumprecht on 8/28/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#ifndef Authenticator_TimeViewController_h
#define Authenticator_TimeViewController_h

#import <Cocoa/Cocoa.h>

@interface TimeViewController : NSViewController{
@private
    IBOutlet NSTextField *timeField;
}

-(void)setTime:(NSString*)time;

@end

#endif
