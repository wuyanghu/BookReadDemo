//
//  BookReadDemoTests.m
//  BookReadDemoTests
//
//  Created by ruantong on 2019/4/26.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BookReadDemoTests : XCTestCase

@end

@implementation BookReadDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString * formatTime = [self timeFormat:100000];
    XCTAssertTrue([@"01:40" isEqualToString:formatTime],"成功");
    
    formatTime = [self timeFormat:59000];
    XCTAssertTrue([@"00:59" isEqualToString:formatTime],"成功");
    
    formatTime = [self timeFormat:6000000];
    XCTAssertTrue([@"100:00" isEqualToString:formatTime],"成功");
    
    formatTime = [self timeFormat:6010000];
    XCTAssertTrue([@"100:10" isEqualToString:formatTime],"成功");
}

- (NSString *)timeFormat:(NSInteger)time{
    NSInteger newTime = time/1000;
    NSInteger minute = newTime/60;
    NSInteger second = newTime%60;
    
    NSString * minuteString;
    if (minute<10) {
        minuteString = [NSString stringWithFormat:@"0%ld",minute];
    }else{
        minuteString = [NSString stringWithFormat:@"%ld",minute];
    }

    NSString * secondString;
    if (second<10) {
        secondString = [NSString stringWithFormat:@"0%ld",second];
    }else{
        secondString = [NSString stringWithFormat:@"%ld",second];
    }
    
    return [NSString stringWithFormat:@"%@:%@",minuteString,secondString];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
