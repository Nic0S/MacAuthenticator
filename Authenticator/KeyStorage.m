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
    NSLog(@"%@", @"called addkey");
    if ([_keys objectForKey:name] != nil){
        NSLog(@"%@", @"already in keystorage");
        //return NO;
    }
    
    [_keys setObject:secret forKey:name];
    NSLog(@"add success %lu", (unsigned long)[_keys count]);
    //return YES;
}

-(void)removeKey:(NSString*)name{
    [_keys removeObjectForKey:name];
}

-(NSDictionary*)getAllAuthCodes{
    int pid = [[NSProcessInfo processInfo] processIdentifier];
    
    
    
    NSMutableDictionary* codes = [NSMutableDictionary new];
    
    for(id name in _keys){
        NSPipe *pipe = [NSPipe pipe];
        NSFileHandle *file = pipe.fileHandleForReading;
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath:@"/bin/bash"];
        NSString *arg = [NSString stringWithFormat:@"/usr/local/Cellar/oath-toolkit/2.4.1/bin/oathtool --totp -b %@", _keys[name]];
        [task setArguments:@[@"-c", arg]];
        NSLog(@"Command: %@", task.arguments);
        task.standardOutput = pipe;
        
        [task launch];
        
        NSData *data = [file readDataToEndOfFile];
        [file closeFile];
        
        NSString *code = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        codes[name] = code;
    }
    
    
    return codes;
}

-(void)saveData{
    
}

-(void)loadData{
    
}



@end
