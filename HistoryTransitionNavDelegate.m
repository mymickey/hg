//
//  HistoryTransitionNavDelegate.m
//  hg
//
//  Created by mickey on 14-9-21.
//  Copyright (c) 2014年 mickey. All rights reserved.
//

#import "HistoryTransitionNavDelegate.h"
#import "HistorySceneTransitionAnimator.h"
#import "HistoryViewController.h"
@interface HistoryTransitionNavDelegate()
{
    UIPercentDrivenInteractiveTransition *interractive;
    UIPanGestureRecognizer *panGestureRecognizer;
    BOOL canEnd;
    HistorySceneTransitionAnimator<UIViewControllerAnimatedTransitioning>*push;
    BOOL vcShowIsComplete; //防止滑动过快
    BOOL isOver;
    NSInteger currentVCCount;
}
@end
@implementation HistoryTransitionNavDelegate
-(instancetype)initWithNavCtrl:(UINavigationController *)nv
{
    self = [super init];
    push = [HistorySceneTransitionAnimator new];
    self.nav = nv;
    [self addViewEvent];
    return self;
}
-(void)addViewEvent
{
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.nav.view addGestureRecognizer:panGestureRecognizer];
    self.canSwipe = YES;
}
-(BOOL)isLastOrFirst//判断是否是最后一个或者第一个
{
    NSInteger currentViewCtrlCount = [self.nav.viewControllers count];
    return currentViewCtrlCount == 1;
}
-(void)onPan:(UIPanGestureRecognizer *)pan
{
    if (self.canSwipe == NO) {
        return;
    }
    UINavigationController *vc = self.nav;
    isOver = [self isLastOrFirst];
    BOOL isStart = pan.state == UIGestureRecognizerStateBegan;
    BOOL isMove = pan.state == UIGestureRecognizerStateChanged;
    BOOL isEnd = pan.state == UIGestureRecognizerStateEnded;
    BOOL isCancel = pan.state == UIGestureRecognizerStateCancelled;
    CGPoint translationPoint = [pan translationInView:pan.view];//滑动了多远
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UINavigationController *nav = vc;
   
    if (isStart &&  translationPoint.x > 0 && vcShowIsComplete) {//Push
        interractive = [UIPercentDrivenInteractiveTransition new];
        [nav pushViewController:[self.delegate didPush:nav] animated:YES];
        
    }
    else if (isStart && translationPoint.x < 0 && vcShowIsComplete) {//pop
        interractive = [UIPercentDrivenInteractiveTransition new];
        currentVCCount = [self.nav.viewControllers count];
        [nav popViewControllerAnimated:YES];
    }
    else if(isMove){
        CGFloat d = fabs(translationPoint.x / screenSize.width);
        canEnd = d>.3;//超过屏幕的30%则确定可以结束
        if (isOver  ) {
            d = d /2.5;
        }
        [interractive updateInteractiveTransition:d];
    }
    else if((isEnd || isCancel || isOver) && interractive){
        if (canEnd && !isOver) {
            [interractive finishInteractiveTransition];
        } else {
            [interractive cancelInteractiveTransition];
            [self.delegate didCancel:self.nav];
            vcShowIsComplete = YES;
        }
        interractive = nil;
    }
   
}
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return interractive;
}
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        push.direction = HistorySceneTransitionAnimator_LEFT;
        return push;
    }
    else if(operation == UINavigationControllerOperationPop){
        push.direction = HistorySceneTransitionAnimator_RIGHT;
        return push;
    }
    return nil;
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    vcShowIsComplete = NO;
    
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController.viewControllers count] >= 2) {
        UIViewController *vc = navigationController.viewControllers[0];
        vc.view.alpha = 0;//防止 pop到最后一个view的时候看见第一屏root视图
    }
    NSInteger count = [self.nav.viewControllers count];
    if (count < currentVCCount) {
        [self.delegate didPop:self.nav];
    }
    vcShowIsComplete = YES;
}
-(void)clear
{
    [self.nav.view removeGestureRecognizer:panGestureRecognizer];
}
- (void)dealloc
{
    NSLog(@"dealloc,%@",self.delegate);
    [self clear];
    self.delegate=nil;
}
@end
