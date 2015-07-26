//
//  Notification.h
//  hg
//
//  Created by mickey on 15/7/11.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject
-(NSDate *)addTask:(NSTimeInterval)time;
-(void)removeTask;
@end
