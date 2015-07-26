//
//  HistoryViewController.m
//  hg
//
//  Created by mickey on 14-9-21.
//  Copyright (c) 2014年 mickey. All rights reserved.
//

#import "HistoryViewController.h"
#import "ColumnViewController.h"
#import "ViewController.h"
#import "HistoryTransitionNavDelegate.h"
#import "HColumnViewController.h"
#import "G_Config.h"
static NSTimeInterval EXPAND_ANIMA_DURATION = .4;
static CGFloat HEADER_TOP = 33;

@interface HistoryViewController ()
{
    UIView *container;
    UIView *header;
    UIView *contentCt;
    NSMutableArray *columns;
    NSMutableArray *hcolumns;
    BOOL initOnHideHeader;
    BOOL isOpen;
    NSLayoutConstraint *ctWidthContstraint;
    NSLayoutConstraint *ctLeftContstraint;
    NSLayoutConstraint *headerTopConstraint;
    NSInteger currentColumnIndex;
    NSInteger initExpandIndex;
    NSMutableArray *columnDatas;
    BOOL initOnExpand;
    BOOL isDisableTapExpand;
    HistoryTransitionNavDelegate<UINavigationControllerDelegate> *navDelegate;
}

@end

@implementation HistoryViewController
-(instancetype)init
{
    self = [super init];
    columns = [NSMutableArray new];
    hcolumns = [[NSMutableArray alloc] init];
    isOpen = NO;
    
    return self;
}
-(instancetype)initWithDates:(NSMutableArray *)arr
{
    self = [self init];
    columnDatas = arr;
    return self;
}
-(instancetype)initWithColumnIndex:(NSInteger)index andHidenHeader:(BOOL)hideHeader andDatas:(NSMutableArray *)arr
{
    self = [self init];
    initExpandIndex = index;
    initOnExpand = YES;
    initOnHideHeader = hideHeader == YES;
    columnDatas = arr;
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createColumnContainer];
    [self initColumns];
    [self performSelector:@selector(bindTapEvent) withObject:self afterDelay:.5];
    //[self addColumnsDataItems:columnDatas];
    self.view.backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:64.0f/255.0f blue:77.0f/255.0f alpha:1.0f];
    // Do any additional setup after loading the view.
}
-(void)bindTapEvent
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tap];
}
-(void)addColumnsDataItems:(NSMutableArray *)arr
{
    ColumnViewController *c;
    NSDictionary *item;
    for (NSInteger i = 0; [arr count]>i; i++) {
        c = [columns objectAtIndex:i];
        item = [arr objectAtIndex:i];
        [c addData:item];
    }
}
-(void)disableTapExpand:(BOOL)dis
{
    isDisableTapExpand = dis;
}
-(void)onTap:(UITapGestureRecognizer *)tap
{
    if (isDisableTapExpand) {
        return;
    }
    CGPoint point = [tap locationInView:self.view];
    BOOL has = NO;
    NSInteger i ;
    if (isOpen) {
        i = currentColumnIndex;
        has = YES;
    }
    else{
        for (i = 0; [columns count] > i; i++) {
            ColumnViewController *column = columns[i];
            UIView *v = column.view;
            has = CGRectContainsPoint(v.frame, point);
            if (has) {
                break;
            }
        }
    }
    if (has) {
        currentColumnIndex = i;
        [self toggleColumn:i duration:EXPAND_ANIMA_DURATION callback:nil];
    }
}
-(void)addLabel
{
//    ColumnViewController *c1 = (ColumnViewController *)columns[0];
//    NSInteger c = [self.navigationController.childViewControllers count];
//    self.view.tag = c;
//    [c1 addLabel:@"10:24" andText:@"t"];
//    [c1 addLabel:@"10:25" andText:@"t1"];
//    ColumnViewController *c2 = (ColumnViewController *)columns[1];
//    [c2 addLabel:@"10:34" andText:@"te2"];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (initExpandIndex >= 0 && initOnExpand) {
        HistoryViewController * __weak me = self;
        initOnExpand = NO;//避免再次显示的时候重复执行动画
        [self toggleColumn:initExpandIndex duration:0 callback:^{}];
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5);
        dispatch_after(delay, dispatch_get_main_queue(), ^(void){
            [me toggleColumn:initExpandIndex duration:EXPAND_ANIMA_DURATION callback:^{
                if (initOnHideHeader) {
                    [self toggleHeader:nil];
                }
            }];
        });
     }
}
-(UIViewController *)getPushCtrl
{
    return [[HistoryViewController alloc] init];
}
-(UIView *)getEventView
{
    return  self.view;
}

-(void)expandColumnWithIndex:(NSInteger)i callback:(handler)cb
{
    [self toggleColumn:i duration:EXPAND_ANIMA_DURATION callback:cb];
}
-(void)createColumnContainer
{
    container = [UIView new ];
    header = [UIView new];
    contentCt = [UIView new];
    contentCt.translatesAutoresizingMaskIntoConstraints = header.translatesAutoresizingMaskIntoConstraints = container.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:header];
    [container addSubview:contentCt];
    [self.view addSubview:container];
}
-(void)initHeaderColumns
{
    NSInteger columnsCount = 7;
    UIView *ct = header;
    for (NSInteger i = 0; i<columnsCount; i++) {
        HColumnViewController *hc = [[HColumnViewController alloc] initWithLabelData:columnDatas[i]];
        UIView *v = hc.view;
        //[hc addLabel:[NSString stringWithFormat:@"%li",(long)i]];
        [hcolumns addObject:hc];
        [self addChildViewController:hc];
        [header addSubview:v];
        [hc didMoveToParentViewController:self];
    }
    NSDictionary *layoutDict = @{
                                 @"v1":((HColumnViewController *)hcolumns[0]).view,
                                 @"v2":((HColumnViewController *)hcolumns[1]).view,
                                 @"v3":((HColumnViewController *)hcolumns[2]).view,
                                 @"v4":((HColumnViewController *)hcolumns[3]).view,
                                 @"v5":((HColumnViewController *)hcolumns[4]).view,
                                 @"v6":((HColumnViewController *)hcolumns[5]).view,
                                 @"v7":((HColumnViewController *)hcolumns[6]).view
                                 };

    
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:@"H:|[v1][v2(==v1)][v3(==v1)][v4(==v1)][v5(==v1)][v6(==v1)][v7(==v1)]|"
                            options:0
                            metrics:nil
                            views:layoutDict];//左右靠边 ， 列纵向无间距， 列宽度相等
    //垂直间距约束
    NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v1]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v2]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v3]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v4]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints5 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v5]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints6 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v6]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints7 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v7]|" options:0 metrics:nil views:layoutDict];
    
    [ct addConstraints:constraints];
    [ct addConstraints:constraints1];
    [ct addConstraints:constraints2];
    [ct addConstraints:constraints3];
    [ct addConstraints:constraints4];
    [ct addConstraints:constraints5];
    [ct addConstraints:constraints6];
    [ct addConstraints:constraints7];
}
-(void)initColumns
{
    NSInteger columnsCount = 7;
    CGFloat headTopPadding = initOnHideHeader ? -HEADER_TOP : 0;
   
    for (NSInteger i = 0; i<columnsCount; i++) {
        ColumnViewController *c1 = [[ColumnViewController alloc] initWithDataItems:columnDatas[i] lastColorToBgColor:NO];
        [columns addObject:c1];
        [self addChildViewController:c1];
        [contentCt addSubview:c1.view];
        [c1 didMoveToParentViewController:self];
        c1.view.tag = i;
    }
    NSLog(@"columns[0]).view:%@",columns[0]);
    NSDictionary *layoutDict = @{
                                 @"container":container,
                                 @"header":header,
                                 @"content":contentCt,
                                 @"v1":((ColumnViewController *)columns[0]).view,
                                 @"v2":((ColumnViewController *)columns[1]).view,
                                 @"v3":((ColumnViewController *)columns[2]).view,
                                 @"v4":((ColumnViewController *)columns[3]).view,
                                 @"v5":((ColumnViewController *)columns[4]).view,
                                 @"v6":((ColumnViewController *)columns[5]).view,
                                 @"v7":((ColumnViewController *)columns[6]).view
                                 };
    NSArray *headerConstraints1 = [NSLayoutConstraint
                                  constraintsWithVisualFormat:@"H:|[header]|"
                                  options:0
                                  metrics:nil
                                  views:layoutDict
                                  ];
    NSLayoutConstraint *headerConstraints2 = [NSLayoutConstraint
                                              constraintWithItem:header
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                              multiplier:1.0
                                              constant:HEADER_TOP];
//    NSArray *headerConstraints3 = [NSLayoutConstraint
//                                   constraintsWithVisualFormat:@"V:|-20-[header]|"
//                                   options:0
//                                   metrics:nil
//                                   views:layoutDict
//                                   ];

    //headerTopConstraint = headerConstraints1[0];
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:@"H:|[v1][v2(==v1)][v3(==v1)][v4(==v1)][v5(==v1)][v6(==v1)][v7(==v1)]|"
                            options:0
                            metrics:nil
                            views:layoutDict];//左右靠边 ， 列纵向无间距， 列宽度相等
    //垂直间距约束
    NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v1]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v2]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v3]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints4 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v4]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints5 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v5]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints6 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v6]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints7 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v7]|" options:0 metrics:nil views:layoutDict];
    
    NSArray *constraints8 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[container]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints9 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[container]-0-|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints10 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[content]|" options:0 metrics:nil views:layoutDict];
    NSArray *constraints11 = [NSLayoutConstraint
                              constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[header][content]|",headTopPadding]
                              options:0
                              metrics:nil
                              views:layoutDict];
    headerTopConstraint = constraints11[0];
    ctWidthContstraint = [
                          NSLayoutConstraint
                          constraintWithItem:container
                          attribute:NSLayoutAttributeWidth
                          relatedBy:NSLayoutRelationEqual
                          toItem:nil
                          attribute:NSLayoutAttributeNotAnAttribute
                          multiplier:1.0
                          constant:self.view.frame.size.width
                          ];
    [self.view addConstraints:constraints];
    [self.view addConstraints:constraints1];
    [self.view addConstraints:constraints2];
    [self.view addConstraints:constraints3];
    [self.view addConstraints:constraints4];
    [self.view addConstraints:constraints5];
    [self.view addConstraints:constraints6];
    [self.view addConstraints:constraints7];
    [self.view addConstraints:constraints8];
    [self.view addConstraints:constraints9];
    [self.view addConstraints:constraints10];
    [self.view addConstraints:constraints11];
    [self.view addConstraint:ctWidthContstraint];//如果约束了宽度 而且也约束左右间距的话会有警告提示
    [self.view addConstraints:headerConstraints1];
    [self.view addConstraint:headerConstraints2];
    //[self.view addConstraints:headerConstraints3];
    
    ctLeftContstraint = (NSLayoutConstraint *)constraints9[0];
    [self initHeaderColumns];
}

-(void)toggleColumn:(NSInteger)i duration:(NSTimeInterval)time callback:(handler) cb
{
    i = i ? i : 0;
    ColumnViewController *column = (ColumnViewController *)columns[i];
    HColumnViewController *hcolumn = (HColumnViewController *)hcolumns[i];
    HistoryViewController * __weak me = self;
    BOOL notAnim = time == 0 ;
    time = notAnim ? 0 : EXPAND_ANIMA_DURATION;
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat screenWidth = rect.size.width;
    CGFloat leftOffset = 0 - (screenWidth * i);
    CGFloat containerWidth =  [columns count] * screenWidth;
    if (isOpen) {
        containerWidth = rect.size.width;
        leftOffset = 0;
    }
    isOpen = !isOpen;
    ctWidthContstraint.constant = containerWidth;
    ctLeftContstraint.constant = leftOffset;
    [column expandWithDuration:time];
    [hcolumn expandWithDuration:time];
    [UIView animateWithDuration:time animations:^{
        [me.view layoutIfNeeded];
    } completion:^(BOOL finished){
        if (cb != nil && finished) {
            cb();
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_COLUMN_ON_TOGGLE object:nil];
}
-(void)toggleHeader:(handler)cb
{
    CGFloat top = headerTopConstraint.constant;
    headerTopConstraint.constant = top == 0-HEADER_TOP ? 0:0-HEADER_TOP;
    [UIView animateWithDuration:EXPAND_ANIMA_DURATION animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        if (cb != nil && finished) {
            cb();
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
