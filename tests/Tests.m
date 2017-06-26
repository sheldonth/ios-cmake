#import <XCTest/XCTest.h>

#import "CppInterface.h"

@interface Tests : XCTestCase
@end

@implementation Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    CppInterface* i = [[CppInterface alloc] init];
    XCTAssert(i);
}

@end
