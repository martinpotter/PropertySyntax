// PropertySyntaxTests.m
//
// Copyright (c) 2014 Martin Potter
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <XCTest/XCTest.h>
#import "FCProperty.h"
#import "TestObject.h"

@interface PropertySyntaxTests : XCTestCase
{
	TestObject *m_testObject;
	BOOL m_testObjectDeallocated;
}
@property (nonatomic, retain) TestObject *testObject;
@property (nonatomic, assign) BOOL testObjectDeallocated;
@end

@implementation PropertySyntaxTests
@synthesize testObject = m_testObject;
- (void)setUp
{
	[super setUp];

	TestObject *testObject = [[TestObject alloc] initWithBlock:^{
		self.testObjectDeallocated = YES;
	}];
	self.testObjectDeallocated = NO;
	self.testObject = testObject;
	[testObject release];
}

- (void)tearDown
{
	self.testObject = nil;
	XCTAssertEqual(self.testObjectDeallocated, YES, @"TestObject was not deallocated as expected.");

	[super tearDown];
}

/*! Test for expected behavior when explicitly disposing of a property willChange subscriber.
 */
- (void)testWillChangeWithExplicitDispose
{
	@autoreleasepool
	{
		__block NSString *previousValue = nil;
		id<FCDisposable> subscriber = [self.testObject.property(@"property1").onWillChange(self, ^(PropertySyntaxTests *observer) {
			[previousValue release];
			previousValue = [observer.testObject.property1 retain];
		}) retain];

		self.testObject.property1 = @"one";
		XCTAssertEqualObjects(previousValue, nil, @"Previous value changed unexpectedly.");
		self.testObject.property2 = @"p2";
		XCTAssertEqualObjects(previousValue, nil, @"Previous value changed when setting property2.");

		self.testObject.property1 = @"two";
		XCTAssertEqualObjects(previousValue, @"one", @"Previous value should have been 'one' after setting property1 to 'two'.");

		[subscriber dispose];
		[subscriber release];

		self.testObject.property1 = @"three";
		XCTAssertEqualObjects(previousValue, @"one", @"Previous value changed after disposing of the subscriber.");

		[previousValue release];
	}
}

/*! Test for expected behavior when explicitly disposing of a property willChange subscriber that creates a retain cycle between
 *  TestObject instance and the subscriber.
 */
- (void)testWillChangeWithExplicitDisposeAndRetainCycle
{
	@autoreleasepool
	{
		TestObject *testObject = [self.testObject retain];
		__block NSString *previousValue = nil;

		// Reference the local variable inside the change block to create a retain cycle, which should be broken when subscriber is disposed.
		id<FCDisposable> subscriber = [testObject.property(@"property1").onWillChange(self, ^(PropertySyntaxTests *observer) {
			[previousValue release];
			previousValue = [testObject.property1 retain];
		}) retain];

		self.testObject.property1 = @"one";
		XCTAssertEqualObjects(previousValue, nil, @"Previous value changed unexpectedly.");
		self.testObject.property2 = @"p2";
		XCTAssertEqualObjects(previousValue, nil, @"Previous value changed when setting property2.");

		self.testObject.property1 = @"two";
		XCTAssertEqualObjects(previousValue, @"one", @"Previous value should have been 'one' after setting property1 to 'two'.");

		[subscriber dispose];
		[subscriber release];

		testObject.property1 = @"three";
		XCTAssertEqualObjects(previousValue, @"one", @"Previous value changed after disposing of the subscriber.");

		[testObject release];
		[previousValue release];
	}
}

/*! Test for expected behavior when not disposing of a property willChange subscriber, verifying that there is not an
 *  exception for being deallocated with observers still attached.
 */
- (void)testWillChange
{
	@autoreleasepool
	{
		__block NSString *previousValue = nil;
		self.testObject.property(@"property1").onWillChange(self, ^(PropertySyntaxTests *observer) {
			[previousValue release];
			previousValue = [observer.testObject.property1 retain];
		});

		self.testObject.property1 = @"one";
		XCTAssertEqualObjects(previousValue, nil, @"Previous value changed unexpectedly.");
		self.testObject.property2 = @"p2";
		XCTAssertEqualObjects(previousValue, nil, @"Previous value changed when setting property2.");

		self.testObject.property1 = @"two";
		XCTAssertEqualObjects(previousValue, @"one", @"Previous value should have been 'one' after setting property1 to 'two'.");

		[previousValue release];
	}
}

/*! Test for expected behavior when leaking a property willChange subscriber, verifying that there is not an
 *  exception for being deallocated with observers still attached.
 */
- (void)testWillChangeLeakingSubscriber
{
	@autoreleasepool
	{
		__block NSString *previousValue = nil;
		__unused id<FCDisposable> subscriber = [self.testObject.property(@"property1").onWillChange(self, ^(PropertySyntaxTests *observer) {
			[previousValue release];
			previousValue = [observer.testObject.property1 retain];
		}) retain];

		self.testObject.property1 = @"one";
		XCTAssertEqualObjects(previousValue, nil, @"Previous value changed unexpectedly.");
		self.testObject.property2 = @"p2";
		XCTAssertEqualObjects(previousValue, nil, @"Previous value changed when setting property2.");

		self.testObject.property1 = @"two";
		XCTAssertEqualObjects(previousValue, @"one", @"Previous value should have been 'one' after setting property1 to 'two'.");

		[previousValue release];
	}
}

/*! Test for expected behavior when explicitly disposing of a property didChange subscriber.
 */
- (void)testDidChangeWithExplicitDispose
{
	@autoreleasepool
	{
		__block NSString *changedValue = nil;
		id<FCDisposable> subscriber = [self.testObject.property(@"property1").onDidChange(self, ^(PropertySyntaxTests *observer) {
			[changedValue release];
			changedValue = [observer.testObject.property1 retain];
		}) retain];

		self.testObject.property1 = @"one";
		XCTAssertEqualObjects(changedValue, @"one", @"Changed value was not updated as expected.");
		self.testObject.property2 = @"p2";
		XCTAssertEqualObjects(changedValue, @"one", @"Changed value was updated when setting property2.");

		self.testObject.property1 = @"two";
		XCTAssertEqualObjects(changedValue, @"two", @"Changed value was not updated as expected.");

		[subscriber dispose];
		[subscriber release];

		self.testObject.property1 = @"three";
		XCTAssertEqualObjects(changedValue, @"two", @"Changed value was updated after disposing of the subscriber.");

		[changedValue release];
	}
}

/*! Test for expected behavior when explicitly disposing of a property didChange subscriber that creates a retain cycle between
 *  TestObject instance and the subscriber.
 */
- (void)testDidChangeWithExplicitDisposeAndRetainCycle
{
	@autoreleasepool
	{
		TestObject *testObject = [self.testObject retain];
		__block NSString *changedValue = nil;

		// Reference the local variable inside the change block to create a retain cycle, which should be broken when subscriber is disposed.
		id<FCDisposable> subscriber = [testObject.property(@"property1").onDidChange(self, ^(PropertySyntaxTests *observer) {
			[changedValue release];
			changedValue = [testObject.property1 retain];
		}) retain];

		self.testObject.property1 = @"one";
		XCTAssertEqualObjects(changedValue, @"one", @"Changed value was not updated as expected.");
		self.testObject.property2 = @"p2";
		XCTAssertEqualObjects(changedValue, @"one", @"Changed value was updated when setting property2.");

		self.testObject.property1 = @"two";
		XCTAssertEqualObjects(changedValue, @"two", @"Changed value was not updated as expected.");

		[subscriber dispose];
		[subscriber release];

		self.testObject.property1 = @"three";
		XCTAssertEqualObjects(changedValue, @"two", @"Changed value was updated after disposing of the subscriber.");

		[testObject release];
		[changedValue release];
	}
}

/*! Test for expected behavior when not disposing of a property didChange subscriber, verifying that there is not an
 *  exception for being deallocated with observers still attached.
 */
- (void)testDidChange
{
	@autoreleasepool
	{
		__block NSString *changedValue = nil;
		self.testObject.property(@"property1").onDidChange(self, ^(PropertySyntaxTests *observer) {
			[changedValue release];
			changedValue = [observer.testObject.property1 retain];
		});

		self.testObject.property1 = @"one";
		XCTAssertEqualObjects(changedValue, @"one", @"Changed value was not updated as expected.");
		self.testObject.property2 = @"p2";
		XCTAssertEqualObjects(changedValue, @"one", @"Changed value was updated when setting property2.");

		self.testObject.property1 = @"two";
		XCTAssertEqualObjects(changedValue, @"two", @"Changed value was not updated as expected.");

		[changedValue release];
	}
}

/*! Test for expected behavior when leaking a property didChange subscriber, verifying that there is not an
 *  exception for being deallocated with observers still attached.
 */
- (void)testDidChangeLeakingSubscriber
{
	@autoreleasepool
	{
		__block NSString *changedValue = nil;
		__unused id<FCDisposable> subscriber = [self.testObject.property(@"property1").onDidChange(self, ^(PropertySyntaxTests *observer) {
			[changedValue release];
			changedValue = [observer.testObject.property1 retain];
		}) retain];

		self.testObject.property1 = @"one";
		XCTAssertEqualObjects(changedValue, @"one", @"Changed value was not updated as expected.");
		self.testObject.property2 = @"p2";
		XCTAssertEqualObjects(changedValue, @"one", @"Changed value was updated when setting property2.");

		self.testObject.property1 = @"two";
		XCTAssertEqualObjects(changedValue, @"two", @"Changed value was not updated as expected.");

		[changedValue release];
	}
}
@end
