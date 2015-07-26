//
//  HistorySceneTransitionAnimator.m
//  hg
//
//  Created by mickey on 14-9-21.
//  Copyright (c) 2014年 mickey. All rights reserved.
//

#import "HistorySceneTransitionAnimator.h"

@implementation HistorySceneTransitionAnimator
-(instancetype)init
{
    self = [super init];
    self.direction = HistorySceneTransitionAnimator_LEFT;
    return self;
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .5;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewCtrl = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewCtrl = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *ct = [transitionContext containerView];
    toViewCtrl.view.transform = CGAffineTransformMakeScale(.9, .9);
    [ct addSubview:toViewCtrl.view];
    [ct sendSubviewToBack:toViewCtrl.view];
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat w = self.direction == HistorySceneTransitionAnimator_LEFT ? rect.size.width : -rect.size.width;
    //NSLog(@"animateTransition");
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewCtrl.view.transform = CGAffineTransformIdentity;
        fromViewCtrl.view.frame = CGRectMake(w, 0, rect.size.width, rect.size.height);
    } completion:^(BOOL finished){
        toViewCtrl.view.transform = CGAffineTransformIdentity;
        fromViewCtrl.view.frame = rect;
        if (![transitionContext transitionWasCancelled]) {
            [ct bringSubviewToFront:toViewCtrl.view];
        }
        //NSLog(@"is complete:%d",![transitionContext transitionWasCancelled]);
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
@end
