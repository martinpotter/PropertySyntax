// FCDisposableShim.h
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

/*! \class FCDisposableShim
 *  \brief An object that is used as a shim to an object as a weak reference. Disposing of the FCDisposableShim will set
 *  the target property to nil.
 */
@interface FCDisposableShim : NSObject <FCDisposable>
{
	id _target;
}
/*! Gets the target of this FCDisposableShim instance.
 *
 *  \returns A reference to the target of this FCDisposableShim instance.
 */
@property (nonatomic, readonly, assign) id target;

/*! Initializes an FCDisposableShim for the specified target object.
 *  \param target The target to create the FCDisposableShim for
 *  \returns An initialized FCDisposableShim instance
 */
- (id)initWithTarget:(id)target;
@end
