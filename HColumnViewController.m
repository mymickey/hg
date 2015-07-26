//
//  HColumnViewController.m
//  hg
//  列头
//  Created by mickey on 14/11/2.
//  Copyright (c) 2014年 mickey. All rights reserved.
//

#import "HColumnViewController.h"

@interface HColumnViewController()
{
    UIView *miniTimeLabel;
    UILabel *timeLabel;
    NSDictionary *labelData;
}
@end
@implementation HColumnViewController
-(instancetype)initWithLabelData:(NSDictionary *)dict
{
    self = [super init];
    labelData = dict;
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *text = [labelData allKeys][0];
    NSDateFormatter *format = [NSDateFormatter new];
    format.dateFormat = @"yyyyMMdd";
    NSDate *date = [format dateFromString:text];
    format.dateFormat = @"   yyyy/MM/dd EEE";
    NSString * timeLabelText = [format stringFromDate:date].uppercaseString;
    format.dateFormat = @"  MM/dd";
    NSString * miniLabelDateText = [format stringFromDate:date];
    format.dateFormat = @"   EEE";
    NSString * miniLabelDayText = [format stringFromDate:date].uppercaseString;
    [self addLabel:timeLabelText andMiniLabelDateText:miniLabelDateText andMiniLabelDayText:miniLabelDayText];
}
-(void)addLabel:(NSString *)timeLabelText andMiniLabelDateText:(NSString *)miniLabelDateText andMiniLabelDayText:(NSString *)miniLabelDayText
{
    timeLabel = [UILabel new];
    miniTimeLabel = [[[NSBundle mainBundle] loadNibNamed:@"HCMiniLabel" owner:self options:nil] lastObject];
    timeLabel.translatesAutoresizingMaskIntoConstraints = miniTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    timeLabel.text = timeLabelText;//@"   2014/09/18 WED";
    timeLabel.textColor = [UIColor colorWithRed:110.0f/255.0f green:136.0f/255.0f blue:147.0f/255.0f alpha:1];
    [self.view addSubview:miniTimeLabel];
    [self.view addSubview:timeLabel];
    NSDictionary *layoutDict = @{@"v1":timeLabel};
    NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v1]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v1]" options:0 metrics:nil views:layoutDict];
    NSDictionary *layoutDict2 = @{@"v2":miniTimeLabel};
    NSArray *constraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[v2]-3-|" options:0 metrics:nil views:layoutDict2];
    NSArray *constraints4 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v2]|" options:0 metrics:nil views:layoutDict2];
    [self.view addConstraints:constraints1];
    [self.view addConstraints:constraints2];
    [self.view addConstraints:constraints3];
    [self.view addConstraints:constraints4];
    timeLabel.alpha = 0;
    UILabel *date = miniTimeLabel.subviews[0];
    UILabel *day = miniTimeLabel.subviews[1];
    date.text = miniLabelDateText;
    day.text = miniLabelDayText;
}

-(void)expandWithDuration:(NSTimeInterval)t
{
    CGFloat miniOpacity = 0;
    CGFloat opacity = 0;
    if (miniTimeLabel.alpha == 0) {
        miniOpacity = 1;
    }
    if (timeLabel.alpha == 0) {
        opacity = 1;
    }
    [UIView animateWithDuration:t animations:^{
        miniTimeLabel.alpha = miniOpacity;
        timeLabel.alpha = opacity;
    }];
    
}
@end
