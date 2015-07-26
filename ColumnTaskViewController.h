//
//  ColumnStakViewController.h
//  hg
//  可进行动画的任务列
//  Created by mickey on 15/2/27.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "ColumnViewController.h"

@protocol ColumnTaskViewControllerDelegate <NSObject>

-(void)onAnimaComplete:(UIViewController *)ctrl;

@end

@interface ColumnTaskViewController : ColumnViewController
-(void)executeDoneTaskAnimaWithIndex:(NSInteger)index delay:(NSTimeInterval)delayTime;
-(void)didDone;
@property (nonatomic,assign) id<ColumnTaskViewControllerDelegate> delegate;
@end

