//
//  AuthenticatorTests.m
//  AuthenticatorTests
//
//  Created by Nico Schlumprecht on 4/14/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "Utils.h"
#import "NSData+Crypto.h"

@interface AuthenticatorTests : XCTestCase

@end

@implementation AuthenticatorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}


@end
