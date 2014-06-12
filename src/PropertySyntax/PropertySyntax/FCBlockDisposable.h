// FCBlockDisposable.h
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

/*! Defines the signature for a block object that takes no parameters and does not return a value.
 */
typedef void (^FCActionBlock)(void);

/*! \class FCBlockDisposable
 *  \brief A class that implements the FCDisposable protocol and executes the provided block when it is disposed. The 
 *  dispose method must be called explicitly, dispose will not be called when the object is deallocated.
 */
@interface FCBlockDisposable : NSObject<FCDisposable>
{
	FCActionBlock m_block;
}

/*! Initializes a new instance of the FCBlockDisposable class.
 *  \param block The FCActionBlock to execute when this instance is disposed.
 *  \returns An initialized FCBlockDisposable instance.
 */
- (id)initWithBlock:(FCActionBlock)block;
@end

