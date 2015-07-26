//
//  Notification.m
//  hg
//
//  Created by mickey on 15/7/11.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "Notification.h"

@implementation Notification
-(NSDate *)addTask:(NSTimeInterval)time
{
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    notif.alertBody = @"done";
    notif.alertTitle = @"title";
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.applicationIconBadgeNumber = 1;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    notif.fireDate = [NSDate dateWithTimeIntervalSinceNow:time];
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    return notif.fireDate;
}
-(void)removeTask
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
@end
