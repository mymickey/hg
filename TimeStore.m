//
//  TimeStore.m
//  hg
//
//  Created by mickey on 15/2/16.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "TimeStore.h"
static NSTimeInterval COUNTDOWN = 1500;
static id<TimeStoreDelegate> delegate = nil;
@implementation TimeStore
+(NSTimeInterval)getCountdown
{
    NSUserDefaults *userDict = [NSUserDefaults standardUserDefaults];
    NSDictionary * oldTimeDict = [userDict dictionaryForKey:@"COUNTDOWN"];
    NSTimeInterval result = COUNTDOWN;
    if ( oldTimeDict && [oldTimeDict objectForKey:@"value"] ) {
        NSString *t = [oldTimeDict objectForKey:@"value"];
        result = [t doubleValue];
    }
    return result;
}
+(void)setCountdown:(NSTimeInterval)time
{
    COUNTDOWN = time;
    NSUserDefaults *userDict = [NSUserDefaults standardUserDefaults];
    [userDict setObject:@{@"value":[NSString stringWithFormat:@"%f",COUNTDOWN]} forKey:@"COUNTDOWN"];
    if (delegate && [delegate respondsToSelector:@selector(onTimeStoreCountdownChange:)]) {
        [delegate onTimeStoreCountdownChange:COUNTDOWN];
    }
}
+(void)setDelegate:(id<TimeStoreDelegate>)de
{
    delegate = de;
}
@end
