//
//  TimeTool.h
//  hg
//
//  Created by mickey on 15/2/20.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTool : NSObject
+(NSArray *)getCurrentWeekInterval:(NSDate *)date;
+(NSArray *)getPreviousWeek:(NSDate *)d andInterval:(NSInteger)i;
+(NSInteger)weekday:(NSDate *)date;
@end
