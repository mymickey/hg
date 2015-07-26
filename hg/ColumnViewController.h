//
//  ColumnViewController.h
//  hg
//
//  Created by mickey on 14-9-20.
//  Copyright (c) 2014年 mickey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundController.h"
static const CGFloat LABEL_HEIGHT = 20;
static const CGFloat LABEL_LEFT_PADDING_ONOPEN = 2;
static const CGFloat LABEL_LEFT_PADDING = 10;


@interface ColumnViewController : UIViewController
-(instancetype)initWithDataItems:(NSDictionary *)dict lastColorToBgColor:(BOOL)require;
-(void)addData:(NSDictionary *)dict;
-(void)addData:(NSDictionary *)dict dynamic:(BOOL)isDynamic;
-(void)clearData;
//-(void)addLabel:(NSString *)time andText:(NSString *)text;
@property (nonatomic,strong) NSMutableArray * timeLabels;
@property (nonatomic,strong) NSMutableArray * timeDescriptions;
@property (nonatomic) BOOL enabelTapItemStatus;//tap之后item状态opaity切换
@property (strong, nonatomic) IBOutlet BackgroundController *backgroundCtrl;
-(void)expandWithDuration:(NSTimeInterval)time;
@end
