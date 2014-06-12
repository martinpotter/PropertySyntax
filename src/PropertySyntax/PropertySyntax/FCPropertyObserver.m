// FCPropertyObserver.m
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

#import "FCPropertyObserver.h"
#import <objc/runtime.h>
#import "FCDisposables.h"

@interface FCPropertyObserver ()
@property (nonatomic, weak) id observedObject;
@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) FCPropertyObserverWithOptionsBlock block;
@end

@implementation FCPropertyObserver
@synthesize observedObject = _observedObject;
@synthesize observer = _observer;
@synthesize keyPath = m_keyPath;
@synthesize block = m_block;

- (id)initWithObject:(id)object observer:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(FCPropertyObserverWithOptionsBlock)block
{
	self = [super init];
	if (self == nil)
		return self;

	self.observedObject = object;
	self.observer = observer;
	self.keyPath = keyPath;
	self.block = block;

	[self.observedObject addObserver:self forKeyPath:keyPath options:options context:nil];

	return self;
}

- (void)dispose
{
	[self.observedObject removeObserver:self forKeyPath:self.keyPath];
	self.observedObject = nil;
	self.observer = nil;

	self.keyPath = nil;
	self.block = nil;
}

- (void)dealloc
{
	[self dispose];

	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p>\n  Observer: %@\n  KeyPath: %@", [self className], self, self.observer, self.keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	FCPropertyObserverWithOptionsBlock block = [self.block retain];
	if (block != nil)
		block(self.observer, keyPath, object, change);

	[block release];
}
@end
