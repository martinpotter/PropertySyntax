// FCDisposables.h
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

@class FCDisposableShim;

/*! \class FCDisposables
 *  \brief A class that exists to store references to Disposable objects. When the collection is deallocated,
 *  dispose will be called on the items in the collection in reverse order..
 */
@interface FCDisposables : NSObject
{
@private
	FCDisposableShim *m_collectionShim;
	NSMutableArray *m_disposables;
}
/*! Adds the specified FCDisposable object to this FCDisposables collection.
 *  \param disposable The FCDisposable object to add to this FCDisposables collection.
 *  \returns An FCDisposable object that will dipose of the specified FCDisposable and remove it from this FCDisposables
 *  collection when it is disposed.
 */
- (id<FCDisposable>)add:(id<FCDisposable>)disposable;
@end
