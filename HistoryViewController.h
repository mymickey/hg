//
//  HistoryViewController.h
//  hg
//
//  Created by mickey on 14-9-21.
//  Copyright (c) 2014年 mickey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^handler)();

@interface HistoryViewController : UIViewController
-(instancetype)initWithDates:(NSMutableArray *)arr;
-(instancetype)initWithColumnIndex:(NSInteger)index andHidenHeader:(BOOL)hideHeader andDatas:(NSMutableArray *)arr;
-(void)addColumnsDataItems:(NSMutableArray *)arr;
-(void)expandColumnWithIndex:(NSInteger)i callback:(handler)cb;
-(void)toggleHeader:(handler)cb;
-(void)disableTapExpand:(BOOL)dis;
@end
