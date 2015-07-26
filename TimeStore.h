//
//  TimeStore.h
//  hg
//
//  Created by mickey on 15/2/16.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TimeStoreDelegate <NSObject>

-(void)onTimeStoreCountdownChange:(NSTimeInterval)time;

@end

@interface TimeStore : NSObject
+(NSTimeInterval)getCountdown;
+(void)setCountdown:(NSTimeInterval)time;
+(void)setDelegate:(id<TimeStoreDelegate>)de;
@end
