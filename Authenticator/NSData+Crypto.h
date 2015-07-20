//
//  NSData+Crypto.h
//  Authenticator
//
//  Created by Nico Schlumprecht on 7/19/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Crypto)

- (NSData *)SHA1Hash;

- (NSData *)HMACUsingSHA1_withSecretKey:(NSData *)secretKey;

- (NSString *)base32String;
+ (id)dataWithBase32String:(NSString *)base32String;
@end
