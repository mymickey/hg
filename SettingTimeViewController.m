//
//  SettingTimeViewController.m
//  hg
//
//  Created by mickey on 15/2/16.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "SettingTimeViewController.h"
#import "TimeStore.h"
@interface SettingTimeViewController ()
{
    UIColor *bgColor;
}
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation SettingTimeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    [self createBackBtn];
    [self.datePicker addTarget:self action:@selector(onDatepickerValueChange:) forControlEvents:UIControlEventValueChanged];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[TimeStore getCountdown]];
    [self.datePicker setDate:date];
    dispatch_async(dispatch_get_main_queue(), ^{//修复官方bug timePiker bug 需要修改两次才触发事件
        self.datePicker.countDownDuration = [TimeStore getCountdown] ;
    });
    //self.datePicker.countDownDuration = [TimeStore getCountdown];
}

-(void)dealloc
{
    [self.datePicker removeTarget:self action:@selector(onDatepickerValueChange:) forControlEvents:UIControlEventValueChanged];
}
-(void)onDatepickerValueChange:sender
{
    [TimeStore setCountdown:self.datePicker.countDownDuration];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)createBackBtn
{
    CGRect frame = self.view.frame;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height - 50, 50, 50)];
    [btn setImage:[UIImage imageNamed:@"resouces.bundle/images/back"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(8,8,8,8)];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)onClose:sender
{
    NSLog(@"close");
    SettingTimeViewController * ctrl = self;
    BOOL has = [self.delegate respondsToSelector:@selector(onSettingTimeViewCtrlClose:)];
    if (has) {
        [ctrl.delegate onSettingTimeViewCtrlClose:ctrl];
    }
    [ctrl.navigationController popViewControllerAnimated:YES];
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
