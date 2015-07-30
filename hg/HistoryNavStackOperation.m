//
//  HistoryNavStackOperation.m
//  hg
//
//  Created by mickey on 15/2/22.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "HistoryNavStackOperation.h"
#import "HistoryViewController.h"
#import "DataModel.h"
#import "HistoryStore.h"
#import "TimeTool.h"
@interface HistoryNavStackOperation()
{
    NSInteger currentIndex;
    NSInteger backIndex;//返回时候从这个index进行展开
}
@end
@implementation HistoryNavStackOperation
-(instancetype)init
{
    self = [super init];
    currentIndex = 0;
    return self;
}
-(void)didPop:(UINavigationController *)nav
{


}
-(void)didCancel:(UINavigationController *)nav
{
    
}
-(UIViewController *)didPush:(UINavigationController *)nav
{
    NSDate *date = [NSDate date];
    NSArray * period = [TimeTool getPreviousWeek:date andInterval:[nav.viewControllers count]-1];
    NSMutableArray *arr = [HistoryStore getDataWithPeriod:period];
    NSInteger day = [TimeTool weekday:date];
    backIndex = day - 1;
    HistoryViewController *hi;
    if ([nav.viewControllers count] == 1) {
        hi = [[HistoryViewController alloc] initWithColumnIndex:backIndex andHidenHeader:YES andDatas:arr];
    }
    else{
        hi = [[HistoryViewController alloc] initWithDates:arr];
    }

    currentIndex++;
    return hi;
}
-(NSInteger) getColumnBackIndex
{
    return backIndex;
}
@end
