//
//  KeyStorage.h
//  Authenticator
//
//  Created by Nico Schlumprecht on 4/26/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TOTPLib/TOTPGenerator.h"
#import "TOTPLib/OTPAuthURL.h"

@interface KeyStorage : NSObject

-(instancetype)init;

/*
 Adds a new entry with the given name and secret.
 */
-(void)addKey:(NSString*)name key:(NSString*) key;

/*
 Removes an entry based on the name
 */
-(void)removeKey:(NSString*)name;

/*
 Returns a dictionary containing each entry's name mapped to
 the current auth code.
 */
-(NSDictionary*)getAllAuthCodes;

/*
 Save data locally
 */
-(void)saveData;

/*
 Load data from local storage
 */
-(void)loadData;

@end
