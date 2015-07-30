//
//  ViewController.m
//  hg
//
//  Created by mickey on 14-9-20.
//  Copyright (c) 2014年 mickey. All rights reserved.
//

#import "ViewController.h"
#import "ColumnViewController.h"
#import "DataModel.h"
#import "HistoryStore.h"
#import "TimeTool.h"
#import "HomeItemTapCtrl.h"

//#import "HistoryTransitionNavDelegate.h"
//#import "HistoryViewController.h"
//#import "BackFirstNavDelegate.h"
@interface ViewController ()<HistoryStoreDelegate>
{
//    HistoryTransitionNavDelegate *navDelegate;
//    BackFirstNavDelegate *backFirstNavDelegate;
//    UIButton* backBtn ;
    BOOL isInitView;
    ColumnViewController *column;
    HomeItemTapCtrl *homeTap;
    NSDate *startDate;
}



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)initView
{

    NSDictionary *dict = [HistoryStore getDataWithDate:[NSDate date]];
    column = [[ColumnViewController alloc] initWithDataItems:dict lastColorToBgColor:NO];
    column.view.translatesAutoresizingMaskIntoConstraints = YES;
    column.view.frame = [UIScreen mainScreen].bounds;
    homeTap = [HomeItemTapCtrl new];
    [homeTap enableItemTapEvent:column.view];
    [homeTap addObserver:self forKeyPath:@"opening" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    column.enabelTapItemStatus = YES;
    [self.view addSubview:column.view];
    [self addChildViewController:column];
    [column didMoveToParentViewController:self];
    [column.backgroundCtrl setColorWithIndex:[column.view.subviews count]];
    [HistoryStore setDelegate:self];
    startDate = [NSDate date];
    //轮询检查 是否过了今天 如果过了则刷新首页记录
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(waitRefresh) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
}
//隔天后需要刷新首页
-(void)waitRefresh
{
    if (![self isToday]) {
        [self refreshView];
        startDate = [NSDate date];
    };
}
-(void)refreshView
{
    [column clearData];
    NSDictionary *dict = [HistoryStore getDataWithDate:[NSDate date]];
    [column addData:dict dynamic:YES];
    [column.backgroundCtrl setColorWithIndex:[column.view.subviews count]];
}
-(UIColor *)getViewBgColor
{
    return column.view.backgroundColor;
}
-(BOOL)isToday
{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comp1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:startDate];
    NSDateComponents *comp2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:currentDate];
    return [comp1 day] == [comp2 day];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == homeTap && [keyPath  isEqual: @"opening"] &&
            ([change objectForKey:NSKeyValueChangeNewKey] != [change objectForKey:NSKeyValueChangeOldKey])
        ) {
        BOOL isOpen = [[change objectForKey:NSKeyValueChangeNewKey]  isEqual: @"1"];
        NSLog(@"open :%i",isOpen);
        isOpen ? [self.homeOpCtrl hideBtns] : [self.homeOpCtrl showBtns];
    }
}
-(void)testAdd
{
    [column addData:@{@"20150201":@{@"1424428526":@"aaaa"}} dynamic:YES];
    //[HistoryStore saveDataWithDate:[NSDate date] andDesc:@"add new data2"];
}
-(void)onHistoryStoreAddData:(NSDictionary *)dict
{
    [column addData:dict dynamic:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (isInitView != YES) {
        [self initView];
        isInitView = YES;
        [column expandWithDuration:0];
    }
    
}
//-(void)onTap:(UITapGestureRecognizer *)tap
//{
//    [self initNavDelegate];
//    navDelegate.enablePushAndPopInterractive = YES;
//    UINavigationController *nav = self.navigationController;
//    HistoryViewController *hi = [[HistoryViewController alloc] initWithColumnIndex:0 andHidenHeader:YES];
//    [nav pushViewController:hi animated:NO];
//    backBtn.hidden = NO;
//  
//}
//-(void)initNavDelegate
//{
//    [backFirstNavDelegate clear];
//    backFirstNavDelegate = nil;
//    navDelegate = [[HistoryTransitionNavDelegate alloc] initWithNavCtrl:self.navigationController];
//    self.navigationController.delegate = navDelegate;
//}
//-(void)initBackFirstNavDelegate
//{
//    [navDelegate clear];
//    navDelegate = nil;
//    backFirstNavDelegate = [[BackFirstNavDelegate alloc] initWithNavCtrl:self.navigationController];
//    self.navigationController.delegate = backFirstNavDelegate;
//}
//-(void)createBackBtn
//{
//    UINavigationController *nav = self.navigationController;
//    CGRect frame = self.view.frame;
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height - 50, 50, 50)];
//    [btn setImage:[UIImage imageNamed:@"resouces.bundle/images/back"] forState:UIControlStateNormal];
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(8,8,8,8)];
//    [nav.view addSubview:btn];
//    [nav.view bringSubviewToFront:btn];
//    [btn addTarget:self action:@selector(onBackBtnTap:) forControlEvents:UIControlEventTouchUpInside];
//    backBtn = btn;
//    backBtn.hidden = YES;
//}
//-(void)onBackBtnTap:sender
//{
//    [self initBackFirstNavDelegate];
//    backBtn.hidden = YES;
//    [backFirstNavDelegate toFirstViewCtrl];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
