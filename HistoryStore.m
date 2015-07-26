//
//  HistoryStore.m
//  hg
//
//  Created by mickey on 15/2/20.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "HistoryStore.h"
static NSString *const LOCAL_STORAGE_KEY = @"HG-HISTORY";
static NSMutableDictionary *store ;
static id<HistoryStoreDelegate> delegate;
@interface HistoryStore()
{
    //NSMutableDictionary *store;
    //NSArray *sorted_keys;
}
@end

@implementation HistoryStore
+(void)initialize
{
    NSLog(@"initialize HistoryStore");
    [HistoryStore initStore];
}
+(void)initStore
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *oldDict = [userDefaults dictionaryForKey:LOCAL_STORAGE_KEY];
    if (oldDict) {
        store = [NSMutableDictionary dictionaryWithDictionary:oldDict];
    }else{
        store = [NSMutableDictionary dictionaryWithDictionary:@{}];
    }
}
+(void)setDelegate:(id<HistoryStoreDelegate>)de
{
    delegate = de;
}
//必须测试
+(NSMutableArray *)getDataWithStartTime:(NSDate *)startDate andEndTime:(NSDate *)endDate
{
    NSString *startStr = [HistoryStore getDayQueryKeyWithDate:startDate];
    NSString *endStr = [HistoryStore getDayQueryKeyWithDate:endDate];
    NSInteger firstQueryKey = [startStr integerValue];
    NSInteger lastQueryKey = [endStr integerValue];
    NSString *queryKey;
    NSMutableArray *dicts = [NSMutableArray array];
    NSDictionary *item;
    NSDictionary *itemDict;
    NSDictionary * nothing = @{};
    for (NSInteger i = firstQueryKey; i<=lastQueryKey; i++) {
        queryKey = [NSString stringWithFormat:@"%ld",(long)i];
        queryKey = [HistoryStore justifyQueryKey:queryKey];
        item = [store objectForKey:queryKey];
        itemDict = @{queryKey:item ? item : nothing};
        [dicts addObject:itemDict];
    }
    DLog(@"start:%@ ,end:%@",startStr,endStr);
    return dicts;
}
//转换20150801这样的字符串成真实时间 如20150332转成20150401
+(NSString *)justifyQueryKey:(NSString *)str
{
    const char *c = [str UTF8String];
    NSString *year = [NSString stringWithFormat:@"%c%c%c%c", c[0],c[1],c[2],c[3]];
    NSString *month = [NSString stringWithFormat:@"%c%c",c[4],c[5]];
    NSString *day = [NSString stringWithFormat:@"%c%c",c[6],c[7]];
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    [components setMonth:[month integerValue]];
    [components setDay:[day integerValue]];
    [components setYear:[year integerValue]];
    
    NSDate *newDate = [gregorian dateFromComponents: components];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyyMMdd"];
    NSString *result = [df stringFromDate:newDate];
    return result;
}
+(NSDictionary *)getDataWithDate:(NSDate *)date
{
    NSString * queryKey = [HistoryStore getDayQueryKeyWithDate:date];
    NSDictionary * dict = [store objectForKey:queryKey];
    return @{
             queryKey:dict ?dict:@{}
             };
//    return @{
//             @"20150220":@{
//                     @"1424428526":@"text",
//                     @"1424434651":@"text2"
//                     }
//             };
}
+(NSMutableArray *)getDataWithPeriod:(NSArray *)arr
{
    return [self getDataWithStartTime:arr[0] andEndTime:arr[1]];
}
//保存数据
+(void)saveDataWithDate:(NSDate *)date andDesc:(NSString *)text
{
    NSString * queryStr = [HistoryStore getDayQueryKeyWithDate:date];
    NSInteger t = [date timeIntervalSince1970];
    NSString * timestamp = [NSString stringWithFormat:@"%i",(int)t];
    [HistoryStore saveDataWithKey:queryStr andTimestamp:timestamp andText:text];
    if (delegate && [delegate respondsToSelector:@selector(onHistoryStoreAddData:)]) {
        [delegate onHistoryStoreAddData:@{queryStr:@{timestamp:text}}];
    }
}
+(void)saveDataWithKey:(NSString *)key andTimestamp:(NSString *)timestamp andText:(NSString *)text
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *oldDict = [userDefaults dictionaryForKey:LOCAL_STORAGE_KEY];
    if (!oldDict) {
        oldDict = @{};
    }
    NSMutableDictionary *rootDict = [NSMutableDictionary dictionaryWithDictionary:oldDict];
    NSMutableDictionary *dayDict ;
    id thatDayDict = [rootDict objectForKey:key];
    if (thatDayDict) {
        dayDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)thatDayDict];
    }
    if (dayDict) {
        [dayDict setValue:text forKey:timestamp];
        [rootDict setObject:dayDict forKey:key];
    }
    else{
        [rootDict setObject:@{timestamp:text} forKey:key];
    }
    //rootDict  = [NSMutableDictionary dictionaryWithDictionary:mockData];
    [userDefaults setObject:rootDict forKey:LOCAL_STORAGE_KEY];
    [userDefaults synchronize];
    store = rootDict;
}

//通过日期获得查询key
+(NSString *)getDayQueryKeyWithDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    return [df stringFromDate:date];
}
+(BOOL)modifyTxt:(NSString *)txt seconds:(NSString *)seconds date:(NSDate *)date
{
    NSDictionary *dict = [HistoryStore getDataWithDate:date];
    NSString *queryKey = [HistoryStore getDayQueryKeyWithDate:date];
    NSDictionary *dayDict = [[dict objectEnumerator] nextObject];
    NSString *oldKey = [dayDict objectForKey:seconds];
    if (oldKey) {
        [self saveDataWithKey:queryKey andTimestamp:seconds andText:txt];
        return YES;
    }
    return NO;
}
+(NSInteger)getTodayCount
{
    NSDictionary *dict = [HistoryStore getDataWithDate:[NSDate date]];
    NSDictionary *itemDict = [[dict objectEnumerator] nextObject];
    NSInteger count = [[itemDict allKeys] count];
    return count;
}
@end
