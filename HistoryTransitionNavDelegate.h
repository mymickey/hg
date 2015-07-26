//
//  HistoryTransitionNavDelegate.h
//  hg
//
//  Created by mickey on 14-9-21.
//  Copyright (c) 2014年 mickey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistorySceneTransitionAnimator.h"
#import "HistoryViewController.h"
@protocol HistoryNavDelegate<NSObject>
@required
-(void)didPop:(UINavigationController *)nav;
-(UIViewController *)didPush:(UINavigationController *)nav;
-(NSInteger) getColumnBackIndex;
@end
@interface HistoryTransitionNavDelegate : NSObject<UINavigationControllerDelegate>

-(instancetype)initWithNavCtrl:(UINavigationController *)nv;
-(void)clear;
@property (nonatomic,strong) UINavigationController *nav;
@property(nonatomic,assign) BOOL enablePushAndPopInterractive;
@property(nonatomic,assign) id<HistoryNavDelegate> delegate;
@property(nonatomic,assign) BOOL canSwipe;
@end
