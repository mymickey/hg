//
//  HistorySceneTransitionAnimator.h
//  hg
//
//  Created by mickey on 14-9-21.
//  Copyright (c) 2014年 mickey. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, HistorySceneTransitionAnimator_DIRE) {
    HistorySceneTransitionAnimator_RIGHT,
    HistorySceneTransitionAnimator_LEFT,
};


@interface HistorySceneTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property HistorySceneTransitionAnimator_DIRE direction;
@end
