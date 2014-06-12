// NSObject+FCDisposables.m
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

#import "NSObject+FCDisposables.h"
#import <objc/runtime.h>
#import "FCBlockDisposable.h"
#import "FCDisposables.h"

static void *s_associatedObjectKey = &s_associatedObjectKey;

@implementation NSObject (FCDisposables)
- (id<FCDisposable>)registerDisposable:(id<FCDisposable>)disposable
{
	if (disposable == nil)
		return nil;

	FCDisposables *disposables = nil;
	@synchronized(self)
	{
		disposables = [objc_getAssociatedObject(self, s_associatedObjectKey) retain];
		if (disposables == nil)
		{
			disposables = [FCDisposables new];
			objc_setAssociatedObject(self, &s_associatedObjectKey, disposables, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		}
	}

	id<FCDisposable> scope = [disposables add:disposable];
	[disposables release];

	return scope;
}
@end
