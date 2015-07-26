//
//  TaskViewController.m
//  hg
//
//  Created by mickey on 15/2/17.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "TaskViewController.h"
#import "HistoryStore.h"
#import "Notification.h"
static NSString * ANIMA_NAME = @"backgroundColor";
@interface TaskViewController ()
{
    UIColor * currentEndColor;
    UIColor * currentStartColor;
    BOOL isEnd;
    BOOL lastStop;
    BOOL isCleaned;
    BOOL isPause;
    NSInteger columnIndex;
    Notification *notif;
    NSTimer *onOverTimer;
    NSDate *doneDate;
    ColumnTaskViewController *column;
    NSDate *startDate;
    BOOL doneOnToday;
}
@property UIView *columnCt;
@end

@implementation TaskViewController
-(void)colorStart:(UIColor *)start colorEnd:(UIColor *)end
{
    currentStartColor = start;
    currentEndColor = end;
}
-(void)beforeStartAnimaWithDuration:(NSTimeInterval)durationTime andIndex:(NSInteger)index cb:(void (^)(void))cb
{
    TaskViewController * __weak me = self;
    me.view.alpha = 0;
    me.view.backgroundColor = currentStartColor;
    [UIView animateWithDuration:.4 animations:^{
        me.view.alpha = 1;
    } completion:^(BOOL finished){
        cb();
    }];
}
-(void)startAnimaWithDuration:(NSTimeInterval)durationTime andIndex:(NSInteger)index
{
    TaskViewController * __weak me = self;
    [self beforeStartAnimaWithDuration:durationTime andIndex:index cb:^{
        lastStop = NO;
        [me executeAnima:currentStartColor colorEnd:currentEndColor andDuration:durationTime andIndex:index];
    }];
}
-(void)execTaskWithTime:(NSTimeInterval)time andIndex:(NSInteger)index
{
    
    [self startAnimaWithDuration:time andIndex:index];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self setOverTime:time andIndex:index];
}
-(void)setOverTime:(NSTimeInterval)time andIndex:(NSInteger)index
{
    notif = [[Notification alloc] init];
    doneDate = [notif addTask:time];
    columnIndex = index;
    startDate = [NSDate date];
    //[self performSelector:@selector(onTaskComplete:) withObject:[NSString stringWithFormat:@"%f",time ] afterDelay:time];

        
    onOverTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self  selector:@selector(onCountdown:) userInfo:@{@"time":[NSString stringWithFormat:@"%f",time ]} repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:onOverTimer forMode:NSRunLoopCommonModes];
    [onOverTimer fire];
}
-(void)onCountdown:(NSTimer *)timer
{
    NSTimeInterval timeRemainning =  [timer.userInfo[@"time"] doubleValue];
    NSTimeInterval startTime = [[NSDate date] timeIntervalSinceDate:startDate];
    NSTimeInterval timeLeft = timeRemainning - startTime;
    if (timeLeft <= 0) {
        [timer invalidate];
        doneOnToday = [self isToday:startDate];
        if ([self isActive]) {
            [self onTaskComplete:timeRemainning];
        }
        else{
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self  selector:@selector(activeOnDone:) userInfo:@{@"time":[NSString stringWithFormat:@"%f",timeRemainning ]} repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            [timer fire];
        }

    }
}
-(void)activeOnDone:(NSTimer *)timer
{
    NSLog(@"activeOnDone");
    if ([self isActive]) {
        NSTimeInterval timeRemainning =  [timer.userInfo[@"time"] doubleValue];
        [timer invalidate];
        [self onTaskComplete:timeRemainning];
    }
}
-(BOOL)isToday:(NSDate *)date
{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comp1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSDateComponents *comp2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:currentDate];
    NSLog(@"is today:%li,%li",(long)[comp2 day],(long)[comp1 day]);
    return [comp1 day] == [comp2 day];
}
-(BOOL)isActive
{
    UIApplication *app = [UIApplication sharedApplication];
    return app.applicationState == UIApplicationStateActive;
}
-(void)onTaskComplete:(NSTimeInterval )t
{
    [self endOnBackgroundHide];
    //如果是在当天完成的话 执行动画
    if (doneOnToday) {
        
        [column executeDoneTaskAnimaWithIndex:columnIndex delay:0];
    }
    else
    {
        [column didDone];
    }
    if(
       [self.delegate respondsToSelector:@selector(onTaskComplete:withTime:doneDate:)]
       ){
        [self.delegate onTaskComplete:self withTime:t doneDate:doneDate];
    }

}


-(void)_executeAnima:(UIColor *)start colorEnd:(UIColor *)end andDuration:(NSTimeInterval)time andIndex:(NSInteger)index
{
    if (isPause) {
        return;
    }
    NSLog(@"123");
    self.view.backgroundColor = start;
    TaskViewController * __weak me = self;
    BOOL isDone = isEnd;
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(){
        NSLog(@"animateWithDuration");
        me.view.backgroundColor = end;
    } completion:^(BOOL finished){
        if (!isDone) {
            [me executeAnima:end colorEnd:start andDuration:time andIndex:index];
        }
        else if(end != currentStartColor){
            lastStop = YES;
            [me executeAnima:currentEndColor colorEnd:currentStartColor andDuration:time andIndex:index];
            [me endOnBackgroundHide];
            if (!isCleaned) {
                [column executeDoneTaskAnimaWithIndex:index delay:0];
            }
        }else if(!lastStop){
            [me endOnBackgroundHide];
            if (!isCleaned) {
                [column executeDoneTaskAnimaWithIndex:index delay:0];
            }
        }
    }];
}
-(void)executeAnima:(UIColor *)start colorEnd:(UIColor *)end andDuration:(NSTimeInterval)time andIndex:(NSInteger)index
{
    CALayer *layer = self.view.layer;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:ANIMA_NAME];
    anim.toValue = (id)end.CGColor;
    anim.fromValue = (id)start.CGColor;
    anim.repeatDuration = time;
    anim.duration = 1;
    anim.autoreverses = YES;
    anim.removedOnCompletion = NO;//解决on background 之后动画暂停的问题
    [layer addAnimation:anim forKey:ANIMA_NAME];
}
-(void)endOnBackgroundHide
{
    
    [UIView animateWithDuration:!isCleaned ? 1:1 animations:^{
        self.view.backgroundColor = nil;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    [self createColumn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) createColumn
{
    NSDictionary *dict = [HistoryStore getDataWithDate:[NSDate date]];
    column = [[ColumnTaskViewController alloc] initWithDataItems:dict lastColorToBgColor:NO];
    column.view.translatesAutoresizingMaskIntoConstraints = YES;
    column.view.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:column.view];
    [self addChildViewController:column];
    [column didMoveToParentViewController:self];
    column.delegate = self;
    //[column.backgroundCtrl setColorWithIndex:[column.view.subviews count]];
}
-(void)onAnimaComplete:(UIViewController *)ctrl
{
    if(
       [self.delegate respondsToSelector:@selector(onTaskViewCtrlAnimaComplete:)]
       ){
        [self.delegate onTaskViewCtrlAnimaComplete:self];
    }
}
-(void)puaseOnRetart:(NSTimeInterval)time andIndex:(NSInteger)index
{
    isPause = NO;
    [self resumeAnim];
    //[self executeAnima:currentStartColor colorEnd:currentEndColor andDuration:time andIndex:index];
    [self setOverTime:time andIndex:index];
}
-(void)puase
{
    [self puaseAnim];
    [notif removeTask];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [onOverTimer invalidate];
    isPause = YES;
}
-(void)clearTask
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [onOverTimer invalidate];
    [notif removeTask];
    [self endOnBackgroundHide];
    isPause = NO;
    isCleaned = YES;
    [self removeAnima];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    self.delegate = nil;
}
-(void)puaseAnim
{
    CALayer *layer = self.view.layer;
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}
-(void)resumeAnim
{
    NSLog(@"resumeAnim");
    CALayer *layer = self.view.layer;
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}
-(void)removeAnima
{
    [self.view.layer removeAnimationForKey:ANIMA_NAME];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
