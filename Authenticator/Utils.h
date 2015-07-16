//
//  Utils.h
//  Authenticator
//
//  Created by Nico Schlumprecht on 7/15/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#ifndef Authenticator_Utils_h
#define Authenticator_Utils_h
#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(long long)decodeBase32:(NSString*)num;

@end

#endif
