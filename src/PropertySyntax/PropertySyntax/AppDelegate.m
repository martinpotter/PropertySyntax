// AppDelegate.m
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

#import "AppDelegate.h"
#import "FCProperty.h"
#import "TestObject.h"

@interface AppDelegate ()
@property (nonatomic, readonly, copy) FCPropertyObserverWithOptionsBlock didChangeCallback;
@end

@implementation AppDelegate
@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	@autoreleasepool
	{
		TestObject *testObject = [[TestObject alloc] init];
		id willsubscriber = [testObject.property(@"property1").onWillChange(self, ^(id observer) {
			NSLog(@"willChange: %@ | %@", observer, testObject.property1);
		}) retain];

		id subscriber = [testObject.property(@"property1").onDidChange(self, ^(id observer) {
			NSLog(@"%@ | %@", observer, testObject.property1);
		}) retain];

		id p2subscriber = [testObject.property(@"property2").onDidChange(self, ^(id observer) {
			NSLog(@"property2: %@ | %@", observer, testObject.property2);
		}) retain];

		NSLog(@"---- setting property1 to 'one'");
		testObject.property1 = @"one";

		NSLog(@"---- setting property2 to 'p2'");
		testObject.property2 = @"p2";

		NSLog(@"---- setting property1 to 'two'");
		testObject.property1 = @"two";


		[willsubscriber dispose];
		[willsubscriber release];
		[subscriber dispose];
		[subscriber release];
		subscriber = nil;
		[p2subscriber dispose];
		[p2subscriber release];

		NSLog(@"---- setting property1 to 'three'");
		testObject.property1 = @"three";

		testObject.property(@"property1").onDidChangeWithOptions(self, 0, self.didChangeCallback);
		NSLog(@"---- setting property1 to 'four'");
		testObject.property1 = @"four";
		[testObject release];
	}
}

- (FCPropertyObserverWithOptionsBlock)didChangeCallback
{
	return [[^(id observer, NSString *keyPath, id object, NSDictionary *change) {
		// TODO: Do something interesting with didChange event here.
		NSLog(@"%@ | %@.%@ | %@", observer, [object className], keyPath, [object valueForKeyPath:keyPath]);
	} copy] autorelease];
}
@end
