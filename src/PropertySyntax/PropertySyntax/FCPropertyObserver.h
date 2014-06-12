// FCPropertyObserver.h
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

#import <Foundation/Foundation.h>
#import "FCDisposable.h"
#import "FCProperty.h"

/*! \class FCPropertyObserver
 *  \brief An internal class that registers for KVO notification of the specified object and keypath using the 
 *  supplied NSKeyValueObservingOptions.
 *
 *  When KVO notifications are received, the specified FCPropertyObserverWithOptionsBlock callback is executed.
 */
@interface FCPropertyObserver : NSObject<FCDisposable>
{
@private
	id _observedObject;
	NSObject *_observer;
	NSString *m_keyPath;
	FCPropertyObserverWithOptionsBlock m_block;
}

- (id)initWithObject:(id)object observer:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(FCPropertyObserverWithOptionsBlock)block;
@end
