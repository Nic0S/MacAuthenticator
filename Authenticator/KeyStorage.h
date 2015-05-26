//
//  KeyStorage.h
//  Authenticator
//
//  Created by Nico Schlumprecht on 4/26/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyStorage : NSObject

-(instancetype)init;

-(void)addKey:(NSString*)name key:(NSString*) key;

-(void)removeKey:(NSString*)name;

-(NSDictionary*)getAllAuthCodes;

-(void)saveData;

-(void)loadData;

@end
