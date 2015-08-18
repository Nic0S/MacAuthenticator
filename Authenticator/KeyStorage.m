//
//  KeyStorage.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 4/26/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import "KeyStorage.h"

@interface KeyStorage ()
@property (nonatomic, strong) NSMutableDictionary *keys;
@end

@implementation KeyStorage


-(instancetype)init
{
    NSLog(@"%@", @"created keystorage");
    self = [super init];
    if(self) {
        _keys = [NSMutableDictionary new];
    }
    return self;
}

-(void)addKey:(NSString*)name key:(NSString*)secret{
    if ([_keys objectForKey:name] != nil){
        NSLog(@"%@", @"already in keystorage");
        return;
    }
    
    if([OTPAuthURL base32Decode:secret] != nil){
        NSLog(@"add success %lu", (unsigned long)[_keys count]);
        [_keys setObject:secret forKey:name];
    } else {
        NSLog(@"add failure");

    }
}

-(void)removeKey:(NSString*)name{
    [_keys removeObjectForKey:name];
}

-(NSDictionary*)getAllAuthCodes{
    NSMutableDictionary* codes = [NSMutableDictionary new];
    
    for(id name in _keys){
        NSData* data = [OTPAuthURL base32Decode:_keys[name]];
        TOTPGenerator* gen = [[TOTPGenerator alloc] initWithSecret:data algorithm:[TOTPGenerator defaultAlgorithm] digits:[TOTPGenerator defaultDigits] period:[TOTPGenerator defaultPeriod]];
        NSString* code = [gen generateOTPForDate:[NSDate date]];
        codes[name] = code;
    }
    return codes;
}

-(void)saveData{
    
}

-(void)loadData{
    
}



@end
