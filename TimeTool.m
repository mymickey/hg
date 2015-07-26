//
//  TimeTool.m
//  hg
//
//  Created by mickey on 15/2/20.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "TimeTool.h"

@implementation TimeTool
//根据当前天获得本周的开始时间和结束时间
+(NSArray *)getCurrentWeekInterval:(NSDate *)date
{
    NSDate *weekDate = date;
    NSCalendar *myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *currentComps = [myCalendar components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:weekDate];
    //NSInteger ff = currentComps.weekOfYear;
    
    [currentComps setWeekday:1]; // 1: sunday
    NSDate *firstDayOfTheWeek = [myCalendar dateFromComponents:currentComps];
    [currentComps setWeekday:7]; // 7: saturday
    NSDate *lastDayOfTheWeek = [myCalendar dateFromComponents:currentComps];
    return @[firstDayOfTheWeek,lastDayOfTheWeek];
}
+(NSArray *)getPreviousWeek:(NSDate *)d andInterval:(NSInteger)i
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    comps.weekOfMonth = 0-i;
    NSDate *date = [calendar dateByAddingComponents:comps toDate:d options:0];
    NSArray *arr = [TimeTool getCurrentWeekInterval:date];
    NSDate *last = arr[1];
    NSDate *first = arr[0];
    NSLog(@"fist day: %@",first);
    NSLog(@"last day  : %@",last);
    return @[first,last];
}
//本周第几天
+(NSInteger)weekday:(NSDate *)date
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSCalendarUnitWeekday fromDate:date];
    return [comp weekday];
}
@end
