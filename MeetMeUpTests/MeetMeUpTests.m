//
//  MeetMeUpTests.m
//  MeetMeUpTests
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Event.h"

@interface MeetMeUpTests : XCTestCase

@end

@implementation MeetMeUpTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformSearchWithKeyword
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for event array from JSON file"];
    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events) {
        XCTAssert(events.count == 15);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testGetCommentsWithBlock
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for event array from JSON file"];
    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events) {
        Event *secondEvent = events[1];
        [secondEvent getCommentsWithBlock:^(NSArray *comments)
        {
            XCTAssert(comments.count == 1);
            Comment *comment = [comments firstObject];
            XCTAssert([comment.memberID intValue] == 99045732);
        }];
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testAttendanceCountIncrement
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for comments to return"];

    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events) {

        Event *secondEvent = [events objectAtIndex:1];

        int attendingCount = [[secondEvent RSVPCount] intValue];
        secondEvent.attending = YES;
        XCTAssertEqual(++attendingCount, [[secondEvent RSVPCount] intValue]);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testAttendanceCountDecrement
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for comments to return"];

    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events) {

        Event *secondEvent = [events objectAtIndex:1];

        secondEvent.attending = YES;
        int attendingCount = [[secondEvent RSVPCount] intValue];
        secondEvent.attending = NO;
        XCTAssertEqual(--attendingCount, [[secondEvent RSVPCount] intValue]);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testAttendanceBooleanManagedProperly
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for comments to return"];

    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events) {

        Event *secondEvent = [events objectAtIndex:1];

        secondEvent.attending = YES;

        XCTAssertEqual(secondEvent.attending, YES);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10.0 handler:nil];

}

@end
