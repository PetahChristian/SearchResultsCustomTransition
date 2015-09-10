//
//  ModalNavigationController.m
//  SearchResultsCustomTransition
//
//  Created by Peter Jensen on 9/6/15.
//  Copyright (c) 2015 Peter Christian Jensen.
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
//

#import "ModalNavigationController.h"

@interface ModalNavigationController ()

@end

@implementation ModalNavigationController

// Hack to dismiss presented modal navigation from its root view controller
// This is fragile, and shouldn't serve as an example of how to do this
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)__unused item
{
    if (navigationBar.items.count > 2)
    {
        // Pop another view controller that was pushed onto our stack
        return YES;
    }
    
    // Back should dismiss us, since there's nothing to pop
    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

@end
