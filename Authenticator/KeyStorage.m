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
        [self loadData];
    }
    return self;
}

-(void)addKey:(NSString*)name key:(NSString*)secret{
    if ([_keys objectForKey:name] != nil){
        NSLog(@"%@", @"already in keystorage");
        return;
    }
    
    if([KeyStorage verifyKey:secret]){
        NSLog(@"add success %lu", (unsigned long)[_keys count]);
        [_keys setObject:secret forKey:name];
        [self saveData];
    } else {
        NSLog(@"add failure");

    }
}

-(void)removeKey:(NSString*)name{
    [_keys removeObjectForKey:name];
    [self saveData];
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
    [NSKeyedArchiver archiveRootObject:_keys toFile:[self pathForDataFile]];
}

-(void)loadData{
    NSString* path = [self pathForDataFile];
    NSDictionary* keys;
    _keys = [NSMutableDictionary new];
    keys = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if(keys != nil){
        for(id name in keys){
            if([KeyStorage verifyKey:keys[name]]){
                [_keys setObject:keys[name] forKey:name];
            }
        }
    }
}

- (NSString *) pathForDataFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *folder = @"~/Library/Application Support/MacAuthenticator/";
    folder = [folder stringByExpandingTildeInPath];
    
    if ([fileManager fileExistsAtPath: folder] == NO) {
        [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *fileName = @"MacAuthenticator.secrets";
    return [folder stringByAppendingPathComponent: fileName];
}

+(BOOL)verifyKey:(NSString*)key{
    return key && [OTPAuthURL base32Decode:key] != nil;
}

@end
