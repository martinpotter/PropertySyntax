// FCDisposables.m
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

#import "FCDisposables.h"
#import "FCBlockDisposable.h"
#import "FCDisposableShim.h"

@implementation FCDisposables
- (id)init
{
	self = [super init];
	if (self == nil)
		return nil;

	m_disposables = [NSMutableArray new];

	return self;
}

- (void)dealloc
{
	[m_collectionShim dispose];
	[m_collectionShim release];
	NSArray *disposables = m_disposables;
	m_disposables = nil;

	for (id<FCDisposable> disposable in [disposables reverseObjectEnumerator])
		[disposable dispose];

	[disposables release];

	[super dealloc];
}

- (id<FCDisposable>)add:(id<FCDisposable>)disposable
{
	@synchronized(self)
	{
		if (m_collectionShim == nil)
			m_collectionShim = [[FCDisposableShim alloc] initWithTarget:m_disposables];
	}

	FCDisposableShim *collectionShim = m_collectionShim;
	__block FCBlockDisposable *scope = nil;
	scope = [[FCBlockDisposable alloc] initWithBlock:^{
		[disposable dispose];
		[collectionShim.target removeObject:scope];
	}];
	[m_disposables addObject:scope];

	return [scope autorelease];
}
@end
