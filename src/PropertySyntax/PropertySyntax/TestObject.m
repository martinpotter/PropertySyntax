// TestObject.m
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

#import "TestObject.h"

@interface TestObject ()
@property (nonatomic, copy) void (^block)(void);
@end

@implementation TestObject
@synthesize property1 = m_property1;
@synthesize property2 = m_property2;

- (id)init
{
	NSString *logMessage = [NSString stringWithFormat:@"TestObject %p deallocated.", self];
	return [self initWithBlock:^{
		NSLog(@"%@", logMessage);
	}];
}

- (id)initWithBlock:(void(^)(void))block
{
	self = [super init];
	if (self == nil)
		return nil;

	self.block = block;

	return self;
}

- (void)dealloc
{
	self.property1 = nil;
	self.property2 = nil;
	void (^block)(void) = self.block;
	if (block != nil)
		block();

	self.block = nil;

	[super dealloc];
}
@end
