//
//  DataModel.m
//  hg
//
//  Created by mickey on 15/2/20.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel
+(NSDictionary *)formatDataWithDict:(NSDictionary *)dict
{
//    @{
//      @"20150220":@{
//              @"1424428526":@"text",
//              @"1424434651":@"text2"
//              }
//      };
    NSMutableDictionary *result = [NSMutableDictionary new];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"HH:mm";
    NSString * keyDesc = @"desc";
    NSString * keyTime = @"time";
    NSString * keySeconds = @"seconds";
    for (NSString * timeRootKey in dict) {
        [result setObject:[[NSMutableArray alloc] init] forKey:timeRootKey];
        for (NSString * timestamp in dict[timeRootKey]) {
            NSMutableArray *arr = result[timeRootKey];
            NSInteger _timestamp = [timestamp integerValue];
            NSString *timeItem = [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:_timestamp]];
            [arr addObject:@{keyDesc:dict[timeRootKey][timestamp],keyTime:timeItem,keySeconds:timestamp}];
        }
    }
    return result;
}
@end
