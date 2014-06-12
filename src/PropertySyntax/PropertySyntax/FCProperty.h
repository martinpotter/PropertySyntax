// FCProperty.h
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

/*! Defines the signature for a simple block used as the callback for block-based KVO.
 */
typedef void (^FCPropertyObserverBlock)(id observer);

/*! Defines the signature for a block used as the callback for block-based KVO.
 */
typedef void (^FCPropertyObserverWithOptionsBlock)(id observer, NSString *keyPath, id object, NSDictionary *change);

/*! Defines the signature for a block used to register observers for simple block-based KVO.
 */
typedef id<FCDisposable> (^FCPropertyObserverSyntaxAddBlock)(id observer, FCPropertyObserverBlock block);

/*! Defines the signature for a block used to register observers for block-based KVO.
 */
typedef id<FCDisposable> (^FCPropertyObserverSyntaxAddWithOptionsBlock)(id observer, NSKeyValueObservingOptions options, FCPropertyObserverWithOptionsBlock block);

/*! \class FCProperty
 *  \brief A class that allows for block-based KVO registration for the supplied object and property.
 */
@interface FCProperty : NSObject
{
	id m_object;
	NSString *m_property;
}
/*! Gets an FCPropertyObserverSyntaxAddBlock which can be used to register an FCPropertyObserverBlock that is called 
 *  when will-change messages are sent for the object and property that this FCProperty represents.
 *
 *  \returns An FCPropertyObserverSyntaxAddBlock which can be used to register an FCPropertyObserverBlock.
 */
@property (nonatomic, readonly, copy) FCPropertyObserverSyntaxAddBlock onWillChange;

/*! Gets an FCPropertyObserverSyntaxAddBlock which can be used to register an FCPropertyObserverBlock that is called
 *  when did-change messages are sent for the object and property that this FCProperty represents.
 *
 *  \returns An FCPropertyObserverSyntaxAddBlock which can be used to register an FCPropertyObserverBlock.
 */
@property (nonatomic, readonly, copy) FCPropertyObserverSyntaxAddBlock onDidChange;

/*! Gets an FCPropertyObserverSyntaxAddWithOptionsBlock which can be used to register an FCPropertyObserverWithOptionsBlock
 *  that is called when change messages are sent for the object and property that this FCProperty represents.
 *
 *  NSKeyValueObservingOptions can be passed to this block which control which KVO messages are sent to the supplied
 *  FCPropertyObserverWithOptionsBlock.
 *
 *  \returns An FCPropertyObserverSyntaxAddWithOptionsBlock which can be used to register an FCPropertyObserverWithOptionsBlock.
 */
@property (nonatomic, readonly, copy) FCPropertyObserverSyntaxAddWithOptionsBlock onDidChangeWithOptions;

/*! Initializes a new instance of the FCProperty class.
 *  \param object The object which this FCProperty represents.
 *  \param property The property which this FCProperty represents.
 *  \returns An initialized FCProperty instance.
 */
- (id)initWithObject:(id)object property:(NSString *)property;
@end

/*! Defines the signature for a block used to obtain an FCProperty for the specified property.
 */
typedef FCProperty *(^FCPropertySyntaxBlock)(NSString *property);

@interface NSObject (PropertyObserver)
/*! Gets an FCPropertySyntaxBlock which can be used to register block-based observations for this object.
 *
 *  \returns An FCPropertySyntaxBlock which can be used to register block-based observations for this object.
 */
@property (nonatomic, readonly, copy) FCPropertySyntaxBlock property;
@end