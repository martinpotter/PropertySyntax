// TestObject.h
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

/*! \class TestObject
 *  \brief An object with two properties used for testing purposes. A TestObject can be initialized with a callback
 *  block that will be called when it is deallocated.
 */
@interface TestObject : NSObject
{
	void (^m_block)(void);
	id m_property1;
	id m_property2;
}
@property (nonatomic, strong) id property1;
@property (nonatomic, strong) id property2;

/*! Initializes a TestObject with the specified dealloc callback block.
 *  \param block The dealloc callback block for this TestObject instance.
 *  \returns An initialized TestObject instance
 */
- (id)initWithBlock:(void(^)(void))block;
@end
