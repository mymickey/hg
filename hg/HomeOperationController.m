//
//  HomeOperationController.m
//  hg
//
//  Created by mickey on 15/2/18.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "HomeOperationController.h"
#import "HistoryTransitionNavDelegate.h"
#import "BackFirstNavDelegate.h"
#import "G_Config.h"
#import "HistoryNavStackOperation.h"
#import "SettingTimeViewController.h"
#import "TaskViewController.h"
#import "HBSGenerator.h"
#import "HistoryStore.h"
#import "DataModel.h"
#import "UIButton+Easy.h"
#import "TimeStore.h"
#import "ViewController.h"

static NSString * DEFALT_TASK_TEXT = @"";

@interface HomeOperationController()<TaskViewControllerDelegate>
{
    HistoryTransitionNavDelegate *navDelegate;
    BackFirstNavDelegate *backFirstNavDelegate;
    UIButton* backBtn ;
    UIButton* historyBtn;
    UIButton* settingBtn;
    UIButton* playBtn;
    UIButton* countdownBtn;
    UIButton* puaseBtn;
    UIButton* restartBtn;
    BOOL puaseing;
    UIBackgroundTaskIdentifier bgId;
    ViewController *rootViewCtrl;
    NSTimer *taskCountdownTimer;
    NSTimeInterval timeRemainning;
    NSDate *pauseTime;
    NSDate *startDate;
    HistoryNavStackOperation *navStackOperation;
    SettingTimeViewController *timeSetting;
    TaskViewController *taskCtrl;
}
@end
@implementation HomeOperationController

-(instancetype)init
{
    self = [super init];
    navStackOperation = [HistoryNavStackOperation new];
    [TimeStore setDelegate:self];
    return self;
}
-(void)awakeFromNib
{
    rootViewCtrl = (ViewController *)[self.navigationController.viewControllers objectAtIndex:0];
    rootViewCtrl.homeOpCtrl = self;
    [self initPanel];
}
-(void)initPanel
{
    [self createBackBtn];
    [self createHistoryBtn];
    [self createSettingBtn];
    [self createPlayBtn];
    [self createCountdownBtn];
    [self createRestartBtn];
    [self createPuaseBtn];
}
-(void)bindExpandColumnEvent
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onColumnTap:) name:EVENT_COLUMN_ON_TOGGLE object:nil];
}
-(void)unbindExpandColumnEvent
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_COLUMN_ON_TOGGLE object:nil];
}
-(void)onColumnTap:(NSNotification*)notification
{
    //列展开后隐藏back 按钮
    backBtn.hidden = !backBtn.hidden;
    HistoryTransitionNavDelegate *d = (HistoryTransitionNavDelegate *)self.navigationController.delegate;
    d.canSwipe = !backBtn.hidden;
}

-(void)showHistoryBtn
{
    settingBtn.hidden = NO;
    historyBtn.hidden = NO;
}
-(void)showBackBtn
{
    backBtn.hidden = NO;
}
-(void)onBackHome
{
    [self showBtns];
    //playBtn.hidden = historyBtn.hidden = settingBtn.hidden = NO;
}
-(void)initNavDelegate
{
    [backFirstNavDelegate clear];
    backFirstNavDelegate = nil;
    navDelegate = [[HistoryTransitionNavDelegate alloc] initWithNavCtrl:self.navigationController];
    self.navigationController.delegate = navDelegate;
    navDelegate.delegate = navStackOperation;
}
-(void)initBackFirstNavDelegate
{
    [navDelegate clear];
    navDelegate = nil;
    backFirstNavDelegate = [[BackFirstNavDelegate alloc] initWithNavCtrl:self.navigationController];
    self.navigationController.delegate = backFirstNavDelegate;
    backFirstNavDelegate.delegate = navStackOperation;
}
-(void)createPlayBtn
{
    UINavigationController *nav = self.navigationController;
    CGRect frame = rootViewCtrl.view.frame;
    CGFloat height = frame.size.width / 3;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(nav.view.center.x-(height/2), nav.view.center.y-(height/2), height, height)];
    [btn setImage:[UIImage imageNamed:@"resouces.bundle/images/play"] forState:UIControlStateNormal];
    //[btn setImageEdgeInsets:UIEdgeInsetsMake(8,8,8,8)];
    [nav.view addSubview:btn];
    [nav.view bringSubviewToFront:btn];
    [btn addTarget:self action:@selector(onPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    playBtn = btn;
    //btn.hidden =true;
}
-(void)createBackBtn
{
    UINavigationController *nav = self.navigationController;
    CGRect frame = rootViewCtrl.view.frame;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height - 50, 50, 50)];
    [btn setImage:[UIImage imageNamed:@"resouces.bundle/images/back"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(8,8,8,8)];
    [nav.view addSubview:btn];
    [nav.view bringSubviewToFront:btn];
    [btn addTarget:self action:@selector(onBackBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    backBtn = btn;
    backBtn.hidden = YES;
}
-(void)createSettingBtn
{
    UINavigationController *nav = self.navigationController;
    CGRect frame = rootViewCtrl.view.frame;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 50, frame.size.height - 50, 50, 50)];
    [btn setImage:[UIImage imageNamed:@"resouces.bundle/images/setting"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(8,8,8,8)];
    [nav.view addSubview:btn];
    [nav.view bringSubviewToFront:btn];
    [btn addTarget:self action:@selector(onSettingBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    settingBtn = btn;
}
-(void)createHistoryBtn
{
    UINavigationController *nav = self.navigationController;
    CGRect frame = rootViewCtrl.view.frame;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height - 50, 50, 50)];
    [btn setImage:[UIImage imageNamed:@"resouces.bundle/images/history"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(8,8,8,8)];
    [nav.view addSubview:btn];
    [nav.view bringSubviewToFront:btn];
    [btn addTarget:self action:@selector(onHistoryBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    historyBtn = btn;
}
-(void)createRestartBtn
{
    UINavigationController *nav = self.navigationController;
    CGRect frame = rootViewCtrl.view.frame;
    CGFloat height = frame.size.width / 3;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(nav.view.center.x-(height/2),
                                                               nav.view.center.y-(height/2)+height*2, height, 30)];
    [btn setTitle:@"restart" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    [nav.view addSubview:btn];
    [nav.view bringSubviewToFront:btn];
    btn.hidden = YES;
    btn.layer.cornerRadius = 3;
    [btn.layer setMasksToBounds:YES];
    btn.layer.borderColor=[UIColor whiteColor].CGColor;
    btn.layer.borderWidth=1.0f;
    restartBtn = btn;
    [btn addTarget:self action:@selector(onRestartBtnTap:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)createCountdownBtn
{
    UINavigationController *nav = self.navigationController;
    CGRect frame = rootViewCtrl.view.frame;
    CGFloat height = frame.size.width / 3;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(nav.view.center.x-(height/2), nav.view.center.y-(height/2), height, height)];
    
    [nav.view addSubview:btn];
    [nav.view bringSubviewToFront:btn];
    [btn addTarget:self action:@selector(onCountdownBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    countdownBtn = btn;
    [btn setTitle:@"25:00" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40.0f];
    btn.hidden = YES;
}
-(void)createPuaseBtn
{
    UINavigationController *nav = self.navigationController;
    CGRect frame = rootViewCtrl.view.frame;
    CGFloat height = frame.size.width / 3;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(nav.view.center.x-(height/2), nav.view.center.y-(height/2), height, height)];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"resouces.bundle/images/play"]  forState:UIControlStateNormal];
    [nav.view addSubview:btn];
    [nav.view bringSubviewToFront:btn];
    [btn addTarget:self action:@selector(onPuaseBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    puaseBtn = btn;
    [btn setTitle:@"25:00" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0f];
    btn.hidden = YES;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, -12, 0.0f, 0.0f)];
    //btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30.0f];
}
//回复时间继续
-(void)onPuaseBtnTap:sender
{
    if (pauseTime) {
        NSTimeInterval coundedTime = [pauseTime timeIntervalSinceDate:startDate];
        timeRemainning = timeRemainning - coundedTime;
        pauseTime = nil;
    }
    [taskCtrl puaseOnRetart:timeRemainning andIndex:[HistoryStore getTodayCount]];
    [self startTask:timeRemainning];
    puaseing = NO;
    [restartBtn setHidden:YES andDuration:.1];
}
//清除任务
-(void)onRestartBtnTap:sender
{
    [taskCtrl clearTask];
    [puaseBtn setHidden:YES andDuration:.5];
    [countdownBtn setHidden:YES andDuration:.5];
    [restartBtn setHidden:YES andDuration:.5];
    [self resetToMain:0];
    [taskCountdownTimer invalidate];
}
//点击倒数时后暂停
-(void)onCountdownBtnTap:sender
{
    //[countdownBtn setImage:[UIImage imageNamed:@"resouces.bundle/images/play"] forState:UIControlStateHighlighted];
    pauseTime = [NSDate date];
    countdownBtn.hidden = YES;
    [puaseBtn setHidden:NO andDuration:1.5];
    NSTimeInterval coundedTime = [pauseTime timeIntervalSinceDate:startDate];
    NSTimeInterval leftTime = timeRemainning - coundedTime;
    [puaseBtn setTitle:[self formatCountdown:leftTime] forState:UIControlStateNormal];
    [restartBtn setHidden:NO andDuration:1.5];
    [taskCtrl puase];
    [taskCountdownTimer invalidate];
    puaseing = YES;
}
//返回按钮
-(void)onBackBtnTap:sender
{
    [self initBackFirstNavDelegate];
    [self unbindExpandColumnEvent];
    backBtn.hidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onBackHome) userInfo:nil repeats:NO];
    [backFirstNavDelegate toFirstViewCtrl];
}
-(void)onHistoryBtnTap:(UITapGestureRecognizer *)tap
{
    playBtn.hidden = historyBtn.hidden = settingBtn.hidden = YES;
    [self initNavDelegate];
    navDelegate.enablePushAndPopInterractive = YES;
    UINavigationController *nav = self.navigationController;
    UIViewController *hi = [navStackOperation didPush:nav];
    [nav pushViewController:hi animated:NO];
    [self performSelector:@selector(showBackBtn) withObject:self afterDelay:1];
    [self performSelector:@selector(bindExpandColumnEvent) withObject:self afterDelay:1];
}
-(void)onSettingBtnTap:sender
{
    //释放 否则跳转到 setting面板会报错
    self.navigationController.delegate = nil;
    //释放
    [playBtn setHidden:YES andDuration:.2];
    [historyBtn setHidden:YES andDuration:.2];
    [settingBtn setHidden:YES andDuration:.2];
    UINavigationController *nav = self.navigationController;
    timeSetting = [[SettingTimeViewController alloc] init];
    timeSetting.view.backgroundColor = [[rootViewCtrl getViewBgColor] copy];
    [nav pushViewController:timeSetting animated:YES];
    timeSetting.delegate = self;
    
}
//任务开始按钮点击
-(void)onPlayBtn:sender
{
    [self execStartTask:0];
    
}
-(void)execStartTask:(NSTimeInterval)seconds
{
    taskCtrl = [TaskViewController new];
    [rootViewCtrl.view addSubview:taskCtrl.view];
    [rootViewCtrl addChildViewController:taskCtrl];
    [taskCtrl didMoveToParentViewController:rootViewCtrl];
    [rootViewCtrl.view bringSubviewToFront:taskCtrl.view];
    NSArray *tasks = [self getTodayDoneTasks];
    NSInteger count = [tasks count];
    HBSGenerator *hbs = [HBSGenerator new];
    UIColor *colorStart = [hbs getViewHBS:count];
    UIColor *colorEnd = [hbs getViewHBS:count+1];
    [taskCtrl colorStart:colorStart colorEnd:colorEnd];
    NSTimeInterval t =  seconds == 0 ? [TimeStore getCountdown] :seconds;
    [taskCtrl execTaskWithTime:t andIndex:[HistoryStore getTodayCount] ];
    [self startTask:t];
    taskCtrl.delegate = self;
}
-(void)startTask:(NSTimeInterval) countdownTime
{
    puaseing = NO;
    timeRemainning = countdownTime;
    [taskCountdownTimer invalidate];
    taskCountdownTimer = nil;
    startDate = [NSDate date];

    taskCountdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onCountdown:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:taskCountdownTimer forMode:NSRunLoopCommonModes];

    [self hideBtns];
    puaseBtn.hidden = YES;
    [countdownBtn setHidden:NO andDuration:1];
    [taskCountdownTimer fire];
}
-(NSString *)formatCountdown:(NSTimeInterval)time
{
    NSUInteger t = (NSUInteger)time;
    //NSUInteger h = t / 3600;
    NSUInteger m = (t / 60) % 60;
    NSUInteger s = t % 60;
    
    NSString *formattedTime = [NSString stringWithFormat:@"%02lu:%02lu",  (unsigned long)m, (unsigned long)s];
    return formattedTime;
}
-(void)onCountdown:(NSTimer *)timer
{
    NSTimeInterval startTime = [[NSDate date] timeIntervalSinceDate:startDate];
    NSLog(@"onCountdown:%f,%f",timeRemainning,startTime);
    NSTimeInterval timeLeft = timeRemainning - startTime;
    [self setCountdownText:UIControlStateNormal andTime:timeLeft];
    if (timeLeft <= 0) {
        [timer invalidate];
    }
}
-(void)setCountdownText:(UIControlState)state andTime:(NSTimeInterval)timeLeft
{
    [countdownBtn setTitle:[self formatCountdown:timeLeft] forState:state];
}
-(void)showBtns
{
    [playBtn setHidden:NO andDuration:.2];
    [historyBtn setHidden:NO andDuration:.2];
    [settingBtn setHidden:NO andDuration:.2];
}
-(void)hideBtns
{
    [playBtn setHidden:YES andDuration:.2];
    [historyBtn setHidden:YES andDuration:.2];
    [settingBtn setHidden:YES andDuration:.2];
}
-(void)onTaskComplete:(UIViewController *)ctrl withTime:(NSTimeInterval)t doneDate:(NSDate *)date
{
    NSLog(@"onTaskComplete");
    puaseing = NO;
    [HistoryStore saveDataWithDate:date andDesc:DEFALT_TASK_TEXT];
    [countdownBtn setHidden:YES andDuration:1];
}

-(void)onTaskViewCtrlAnimaComplete:(UIViewController *)ctrl
{
    
    [self resetToMain:1];
}
-(void)resetToMain:(NSTimeInterval)t
{
    [taskCountdownTimer invalidate];
    UIViewController __weak *ctrl1 = taskCtrl;
    UIButton __weak *btn1 = playBtn;
    UIButton __weak *btn2 = historyBtn;
    UIButton __weak *btn3 = settingBtn;
    [UIView animateWithDuration:t animations:^{
        ctrl1.view.alpha = 0;
    } completion:^(BOOL finished){
        [ctrl1 removeFromParentViewController];
        [ctrl1.view removeFromSuperview];
        taskCtrl.delegate = nil;
        taskCtrl = nil;
        [btn1 setHidden:NO andDuration:.3];
        [btn2 setHidden:NO andDuration:.3];
        [btn3 setHidden:NO andDuration:.3];
    }];
}
-(void)onSettingTimeViewCtrlClose:(UIViewController *)ctrl
{
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onBackHome) userInfo:nil repeats:NO];
    timeSetting = nil;
}
-(NSArray *)getTodayDoneTasks
{
    NSDictionary *dict = [HistoryStore getDataWithDate:[NSDate date]];
    NSDictionary *itemsDict = [DataModel formatDataWithDict:dict];
    NSEnumerator *e = [itemsDict objectEnumerator];
    NSArray * arr = [e nextObject];
    return arr;
}
-(void)onTimeStoreCountdownChange:(NSTimeInterval)time
{
    NSLog(@"onTimeStoreCountdownChange:%f",time);
}
@end
