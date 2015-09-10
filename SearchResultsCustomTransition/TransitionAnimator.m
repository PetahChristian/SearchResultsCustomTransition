//
//  TransitionAnimator.m
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

#import "TransitionAnimator.h"
#import "MasterViewController.h"

@implementation TransitionAnimator

@synthesize appearing = _appearing;

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)__unused transitionContext
{
    return 3.0; // 0.3 but slowed to illustrate transition
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSString *presentingViewControllerKey =  self.appearing ? UITransitionContextFromViewControllerKey : UITransitionContextToViewControllerKey;
    NSString *presentedViewControllerKey  = !self.appearing ? UITransitionContextFromViewControllerKey : UITransitionContextToViewControllerKey;
    
    UIViewController *presentingViewController = [transitionContext viewControllerForKey:presentingViewControllerKey];
    UIViewController *presentedViewController  = [transitionContext viewControllerForKey:presentedViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    // Add a shadow to the presentedViewController so it appears to slide above the presentingViewController
    
    presentedViewController.view.layer.shadowRadius = 5;
    presentedViewController.view.layer.shadowOpacity = 0.4;

    // The presented view controller slides completely on (or off) screen from the right

    CGRect modalInitialFrame = containerView.frame;
    
    // The presenting controller's content partially slides off (or on) screen to the left,
    // but its navigation bar entirely disappears (or appears)
    
    // Create snapshot views of the presenting controller's content and its navigation bar
    
    CGRect navigationBarInitialFrame = modalInitialFrame;


    // Ugly hack to guess the height of the search bar, which differs depending on orientation
    // Transition animator shouldn't have to know or delve into vc internals

    BOOL isPortrait = modalInitialFrame.size.width < modalInitialFrame.size.height ? YES : NO;

    navigationBarInitialFrame.size.height = isPortrait ? 64 : 44; // FIXME: hardcoded value

    UIView *navigationBarSnapshot = [presentingViewController.view resizableSnapshotViewFromRect:navigationBarInitialFrame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];

    CGRect contentInitialFrame = modalInitialFrame;
    contentInitialFrame.origin.y = CGRectGetHeight(navigationBarInitialFrame);
    contentInitialFrame.size.height -= CGRectGetMinY(contentInitialFrame);
    
    UIView *contentSnapshot = [presentingViewController.view resizableSnapshotViewFromRect:contentInitialFrame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    
    CGRect modalFinalFrame = modalInitialFrame;
    CGRect navigationBarFinalFrame = navigationBarInitialFrame;
    CGRect contentFinalFrame = contentInitialFrame;
    
    if (self.appearing)
    {
        modalInitialFrame.origin.x += CGRectGetWidth(modalInitialFrame);
        navigationBarFinalFrame.origin.x -= CGRectGetWidth(navigationBarFinalFrame);
        contentFinalFrame.origin.x -= CGRectGetWidth(contentFinalFrame) / 3.0;

        [containerView insertSubview:contentSnapshot aboveSubview:presentedViewController.view];
        [containerView insertSubview:presentedViewController.view aboveSubview:contentSnapshot];
        [containerView insertSubview:navigationBarSnapshot aboveSubview:presentingViewController.view];
    }
    else
    {
        modalFinalFrame.origin.x += CGRectGetWidth(modalFinalFrame);
        navigationBarInitialFrame.origin.x -= CGRectGetWidth(navigationBarInitialFrame);
        contentInitialFrame.origin.x -= CGRectGetWidth(contentInitialFrame) / 3.0;

        [containerView insertSubview:navigationBarSnapshot aboveSubview:presentedViewController.view];
        [containerView insertSubview:contentSnapshot belowSubview:presentedViewController.view];
    }

    presentedViewController.view.frame = modalInitialFrame;
    navigationBarSnapshot.frame = navigationBarInitialFrame;
    contentSnapshot.frame = contentInitialFrame;

    // Since the content snapshot won't be opaque, we need to hide the underlying view controller's content
    
    presentingViewController.view.alpha = 0;
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
        presentedViewController.view.frame = modalFinalFrame;
        navigationBarSnapshot.frame = navigationBarFinalFrame;
        contentSnapshot.frame = contentFinalFrame;
        contentSnapshot.layer.opacity = 0.9;
    } completion:^(BOOL __unused finished) {
        // Restore the alpha for the presenting view controller and remove its snapshots
        presentingViewController.view.alpha = 1;
        [navigationBarSnapshot removeFromSuperview];
        [contentSnapshot removeFromSuperview];

        // Remove the shadow from the presented view controller
        presentedViewController.view.layer.shadowOpacity = 0;

        BOOL cancelled = [transitionContext transitionWasCancelled];

        // Remove the presented view controller if it was disappearing and the transition was not cancelled

        if (!cancelled && !self.appearing)
        {
            [presentedViewController.view removeFromSuperview];
            
        }

        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
