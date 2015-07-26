//
//  HistoryStore.h
//  hg
//
//  Created by mickey on 15/2/20.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HistoryStoreDelegate <NSObject>

-(void)onHistoryStoreAddData:(NSDictionary *)dict;

@end

@interface HistoryStore : NSObject
+(NSInteger)getTodayCount;
+(NSDictionary *)getDataWithDate:(NSDate *)date;
+(NSMutableArray *)getDataWithPeriod:(NSArray *)arr;
+(void)saveDataWithDate:(NSDate *)date andDesc:(NSString *)text;
+(void)setDelegate:(id<HistoryStoreDelegate>)de;
+(BOOL)modifyTxt:(NSString *)txt seconds:(NSString *)seconds date:(NSDate *)date;

@end
