//
//  TaskViewController.h
//  hg
//
//  Created by mickey on 15/2/17.
//  Copyright (c) 2015年 mickey. All rights reserved.
//
#import "ColumnTaskViewController.h"

#import <UIKit/UIKit.h>

@protocol TaskViewControllerDelegate <NSObject>

-(void)onTaskViewCtrlAnimaComplete:(UIViewController *)ctrl;
-(void) onTaskComplete:(UIViewController *)ctrl withTime:(NSTimeInterval )t doneDate:(NSDate *)date;

@end

@interface TaskViewController : UIViewController<ColumnTaskViewControllerDelegate>
-(void)colorStart:(UIColor *)start colorEnd:(UIColor *)end ;
-(void)execTaskWithTime:(NSTimeInterval)time andIndex:(NSInteger)index;
-(void)clearTask;
-(void)puaseOnRetart:(NSTimeInterval)time andIndex:(NSInteger)index;
-(void)puase;
@property (nonatomic,assign) id<TaskViewControllerDelegate> delegate;
@end
