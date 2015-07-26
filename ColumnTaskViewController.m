//
//  ColumnStakViewController.m
//  hg
//
//  Created by mickey on 15/2/27.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "ColumnTaskViewController.h"
#import "HBSGenerator.h"

@interface ColumnTaskViewController ()
{
    NSLayoutConstraint *constraintHeight;
    NSLayoutConstraint *labelLeft;
    UIButton *pullViewLabel;
}
@end

@implementation ColumnTaskViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ColumnViewController" bundle:nibBundleOrNil];//否则backgroundCtrl 就为nil
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addData:(NSDictionary *)dict
{
    //[self addData:dict dynamic:YES];
}
-(void)executeDoneTaskAnimaWithIndex:(NSInteger)index delay:(NSTimeInterval)delayTime
{
    [self executeDoneTaskAnimaWithIndex:[NSString stringWithFormat:@"%li",(long)index]];
    //[self performSelector:@selector(executeDoneTaskAnimaWithIndex:) withObject:[NSString stringWithFormat:@"%li",(long)index] afterDelay:delayTime];
}
-(void)executeDoneTaskAnimaWithIndex:(id)arg
{
    NSInteger index = [(NSString *)arg integerValue];
    HBSGenerator *hbs = [HBSGenerator new];
    UIColor *oldColor = [hbs getViewHBS:index];
    [self createPullViewWithColor:oldColor andIndex:index];
    //[self.backgroundCtrl setColorWithIndex:index+1];
    [self execPullAnima:2];
}
-(void)execPullAnima:(NSTimeInterval)delayTime
{
    constraintHeight.constant = LABEL_HEIGHT;
    ColumnTaskViewController __weak * me = self;
    [UIView animateWithDuration:1.4 delay:delayTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [me.view layoutIfNeeded];
    } completion:^(BOOL isOver){
        [me executePullViewLabelAnim];
    }];
}
//创建拉起窗帘动画层
-(void)createPullViewWithColor:(UIColor *)color andIndex:(NSInteger)index
{
    UIView *pullView = [[UIView alloc] init];
    pullView.translatesAutoresizingMaskIntoConstraints = NO;
    pullView.backgroundColor = color;
    [self.view addSubview:pullView];
    [self createPullViewConstraint:pullView andIndex:index];
    [self createPullViewLabel:pullView];
    [self.view bringSubviewToFront:pullView];
    [self.view layoutIfNeeded];
}
-(void)createPullViewConstraint:(UIView *)pullView andIndex:(NSInteger)index
{
    CGRect viewRect = [UIScreen mainScreen].bounds;
    CGFloat top = LABEL_HEIGHT * index;
    CGFloat h = viewRect.size.height - top;
    pullView.frame = viewRect;
    NSDictionary *viewDict = @{@"view":pullView};
    NSArray *layout = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:viewDict];
    NSArray *layout2 = [NSLayoutConstraint
                        constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[view]",top]
                        options:0
                        metrics:nil
                        views:viewDict];
    NSLayoutConstraint *height = [NSLayoutConstraint
                                  constraintWithItem:pullView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                  constant:h];
    [self.view addConstraints:layout];
    [self.view addConstraints:layout2];
    [self.view addConstraint:height];
    constraintHeight = height;
}
-(void)createPullViewLabel:(UIView *)pullView
{
    UIButton *btn = [[UIButton alloc] init];
    btn.userInteractionEnabled = NO;
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitle:@"Well begun is half done" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    [pullView addSubview:btn];
    [self.view layoutIfNeeded];
    CGFloat left = pullView.frame.size.width/2 - btn.frame.size.width/2;
    NSDictionary *viewDict = @{@"view":btn};
    NSArray *centerX = [NSLayoutConstraint
                                   constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[view]",left]
                                   options:0 metrics:nil views:viewDict];

    NSLayoutConstraint *centerY = [NSLayoutConstraint
                                   constraintWithItem:btn
                                   attribute:NSLayoutAttributeCenterY
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:pullView
                                   attribute:NSLayoutAttributeCenterY
                                   multiplier:1
                                   constant:0];
    [pullView addConstraints:centerX];
    [pullView addConstraint:centerY];
    labelLeft = centerX[0];
    pullViewLabel = btn;
}
-(void)executePullViewLabelAnim
{
    //return;
    labelLeft.constant = 10;
    ColumnTaskViewController __weak * me = self;
    UIButton __weak * label = pullViewLabel;
    [UIView animateWithDuration:1 animations:^{
        label.alpha = 0;
        [me.view layoutIfNeeded];
    } completion:^(BOOL finished){
        [me didDone];
    }];
}
-(void)didDone
{
    ColumnTaskViewController  * me = self;
    if(
       [me.delegate respondsToSelector:@selector(onAnimaComplete:)]
       ){
        [me.delegate onAnimaComplete:me];
    }
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
