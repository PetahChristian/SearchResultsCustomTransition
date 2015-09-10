//
//  NavigationControllerDelegate.m
//  SearchResultsCustomTransition
//
//  Created by Peter Jensen on 9/5/15.
//  Copyright (c) 2014 Visnu Pitiyanuvath. All rights reserved.
//  Copyright (c) 2015 Peter Jensen.
//
//  Based on SlideAnimatedTransitioning.m gist <https://gist.github.com/visnup/10944972>
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

#import "NavigationControllerDelegate.h"
#import "TransitionAnimator.h"

@interface NavigationControllerDelegate () <UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;

@end

@implementation NavigationControllerDelegate

@synthesize navigationController = _navigationController;
@synthesize interactionController = _interactionController;

- (void)awakeFromNib
{
    UIScreenEdgePanGestureRecognizer *panGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGestureRecognizer.edges = UIRectEdgeLeft;

    [self.navigationController.view addGestureRecognizer:panGestureRecognizer];
}

#pragma mark - Actions

- (void)handlePan:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer
{
    UIView *view = self.navigationController.view;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (!self.interactionController)
        {
            self.interactionController = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat percent = [gestureRecognizer translationInView:view].x / CGRectGetWidth(view.bounds);
        [self.interactionController updateInteractiveTransition:percent];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGFloat percent = [gestureRecognizer translationInView:view].x / CGRectGetWidth(view.bounds);
        if (percent > 0.5 || [gestureRecognizer velocityInView:view].x > 50)
        {
            [self.interactionController finishInteractiveTransition];
        }
        else
        {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }
}

#pragma mark - <UIViewControllerAnimatedTransitioning>

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)__unused presented presentingController:(UIViewController *)__unused presenting sourceController:(UIViewController *)__unused source
{
    TransitionAnimator *animator = [TransitionAnimator new];
    animator.appearing = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)__unused dismissed
{
    TransitionAnimator *animator = [TransitionAnimator new];
    return animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)__unused animator
{
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)__unused animator
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu-conditional-omitted-operand"
    return self.interactionController ?: nil;
#pragma clang diagnostic pop
}

@end
