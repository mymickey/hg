//
//  BackFirstNavDelegate.m
//  hg
//
//  Created by mickey on 14-10-2.
//  Copyright (c) 2014年 mickey. All rights reserved.
//

#import "BackFirstNavDelegate.h"
#import "HistoryViewController.h"
@implementation BackFirstNavDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([navigationController.viewControllers count] == 2){
        [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(toFrist) userInfo:nil repeats:NO];
    }
}
-(void)addViewEvent{}//覆盖父类方法，无需绑定事件
-(void)toFrist
{
    NSLog(@"toFrist");
    UIViewController *viewController =self.nav.viewControllers[1];
    HistoryViewController *hi = (HistoryViewController *)viewController;
    [hi disableTapExpand:YES];
    BackFirstNavDelegate * __weak me = self;
    NSInteger columnBackIndex = [me.delegate getColumnBackIndex];
    [hi expandColumnWithIndex:columnBackIndex callback:^{
        [hi toggleHeader:^{
            [hi.navigationController popToRootViewControllerAnimated:NO];
            [me.delegate didPop:me.nav];
        }];
        
    }];
}
-(void)toFirstViewCtrl
{
    NSArray *ctrls = self.nav.viewControllers;
    if ([ctrls count] == 2) {//如果已经在第二个控制器则直接动画后跳转到首屏
        [self toFrist];
    }
    else{
        HistoryViewController *hi = (HistoryViewController *)self.nav.viewControllers[1];
        [hi disableTapExpand:YES];
        [self.nav popToViewController:hi animated:YES];
        [self.delegate didPop:self.nav];
    }
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.view.alpha = 1;
}
@end
