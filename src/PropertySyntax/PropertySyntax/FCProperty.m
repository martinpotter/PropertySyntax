// FCProperty.m
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

#import "FCProperty.h"
#import "FCPropertyObserver.h"
#import "NSObject+FCDisposables.h"

@interface FCProperty ()
@property (nonatomic, strong) id object;
@property (nonatomic, copy) id property;
@end

@implementation FCProperty
@synthesize object = m_object;
@synthesize property = m_property;

- (id)initWithObject:(id)object property:(NSString *)property
{
	self = [super init];
	if (self == nil)
		return nil;

	self.object = object;
	self.property = property;

	return self;
}

- (void)dealloc
{
	self.object = nil;
	self.property = nil;

	[super dealloc];
}

- (FCPropertyObserverSyntaxAddBlock)onWillChange
{
	FCPropertyObserverSyntaxAddBlock willChangeBlock = ^id (id observer, FCPropertyObserverBlock block) {
		@autoreleasepool
		{
			FCPropertyObserverWithOptionsBlock optionsBlock = ^(id observer, NSString *keyPath, id object, NSDictionary *change) {
				if (block != nil && [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue])
					block(observer);
			};

			FCPropertyObserver *propertyObserver = [[FCPropertyObserver alloc] initWithObject:self.object observer:observer forKeyPath:self.property options:NSKeyValueObservingOptionPrior block:optionsBlock];
			id<FCDisposable> scope = [self.object registerDisposable:propertyObserver];
			[propertyObserver release];

			return scope;
		}
	};

	return [[willChangeBlock copy] autorelease];
}

- (FCPropertyObserverSyntaxAddBlock)onDidChange
{
	FCPropertyObserverSyntaxAddBlock didChangeBlock = ^id(id observer, FCPropertyObserverBlock block) {
		@autoreleasepool
		{
			FCPropertyObserverWithOptionsBlock optionsBlock = ^(id observer, NSString *keyPath, id object, NSDictionary *change) {
				if (block != nil)
					block(observer);
			};

			FCPropertyObserver *propertyObserver = [[FCPropertyObserver alloc] initWithObject:self.object observer:observer forKeyPath:self.property options:0 block:optionsBlock];
			id<FCDisposable> scope = [self.object registerDisposable:propertyObserver];
			[propertyObserver release];

			return scope;
		}
	};

	return [[didChangeBlock copy] autorelease];
}

- (FCPropertyObserverSyntaxAddWithOptionsBlock)onDidChangeWithOptions
{
	FCPropertyObserverSyntaxAddWithOptionsBlock didChangeBlock = ^id(id observer, NSKeyValueObservingOptions options, FCPropertyObserverWithOptionsBlock block) {
		@autoreleasepool
		{
			FCPropertyObserver *propertyObserver = [[FCPropertyObserver alloc] initWithObject:self.object observer:observer forKeyPath:self.property options:options block:block];
			id<FCDisposable> scope = [self.object registerDisposable:propertyObserver];
			[propertyObserver release];

			return scope;
		}
	};

	return [[didChangeBlock copy] autorelease];
}
@end

@implementation NSObject (PropertyObserver)
- (FCPropertySyntaxBlock)property
{
	FCPropertySyntaxBlock block = ^FCProperty *(NSString *property) {
		return [[[FCProperty alloc] initWithObject:self property:property] autorelease];
	};

	return [[block copy] autorelease];
}
@end
