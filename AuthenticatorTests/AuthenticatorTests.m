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

-(void) testDecodeBase32 {
    NSArray *strings = @[@"121GHKLEI", @"83ADRA48GVG", @"2JTEQGD2C"];
    NSArray *results = @[@"1169860220370", @"9124223494931440", @"2883494360140"];
    
    for(int i = 0; i < strings.count; i++) {
        long long result = [Utils decodeBase32:strings[i]];
        NSString *stringResult = [NSString stringWithFormat:@"%lli", result];
        XCTAssert([stringResult isEqualToString:results[i]]);
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
