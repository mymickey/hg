//
//  ColumnViewController.m
//  hg
//
//  Created by mickey on 14-9-20.
//  Copyright (c) 2014年 mickey. All rights reserved.
//

#import "ColumnViewController.h"
#import "HBSGenerator.h"
#import "UIView+ItemDate.h"
#import "DataModel.h"


@interface ColumnViewController ()
{
    NSMutableArray *viewLefts;
    BOOL isOpen;
    HBSGenerator *hbsGenerator ;
    NSDictionary *dataDict;
    BOOL lastColorToBgColor;
    UIView *currentTapView;
}

@end

@implementation ColumnViewController

-(instancetype)initWithDataItems:(NSDictionary *)dict lastColorToBgColor:(BOOL)require
{
    self = [super init];
    dataDict = dict;
    lastColorToBgColor = require;
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    hbsGenerator = [HBSGenerator new];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.timeLabels = [NSMutableArray new];
    self.timeDescriptions = [NSMutableArray new];
    viewLefts = [NSMutableArray new];
    [self addData:dataDict];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self toggleTapViewOpacity:touches];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentTapView.alpha = 1;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentTapView.alpha = 1;
}
-(void)toggleTapViewOpacity:(NSSet *)touches
{
    if (self.enabelTapItemStatus != YES) {
        return;
    }
    UITouch *touch1 = [touches anyObject];
    UIView *view = self.view;
    CGPoint point = [touch1 locationInView:view];
    BOOL has = NO;
    NSArray *views = [view subviews];
    NSInteger i ;
    for (i = 0; [views count] > i; i++) {
        UIView *v = views[i];
        has = CGRectContainsPoint(v.frame, point);
        if (has) {
            break;
        }
    }
    
    if (has) {
        UIView *v = views[i];
        currentTapView = v;
        currentTapView.alpha = .5;
    }
    
}
-(void)clearData
{
    NSArray * arr = self.view.subviews;
    UIView *v ;
    for (NSInteger i = 0; [arr count] > i; i++) {
        v = arr[i];
        [v removeFromSuperview];
    }
    viewLefts = [NSMutableArray new];
    self.timeDescriptions = [NSMutableArray new];
    self.timeLabels = [NSMutableArray new];
}
//任务完成后动态添加时间使用这个方法
-(void)addData:(NSDictionary *)dict dynamic:(BOOL)isDynamic
{
    [self _addData:dict dynamic:isDynamic];
}
-(void)addData:(NSDictionary *)dict
{
    [self _addData:dict dynamic:NO];
}
-(void)_addData:(NSDictionary *)dict dynamic:(BOOL)isDynamic
{
    NSDictionary * newDict = [DataModel formatDataWithDict:dict];
    NSArray * arr = [[newDict objectEnumerator] nextObject];
    if ([arr count] ) {
        NSString *timeKey = @"time";
        arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDictionary *d = (NSDictionary *)obj1;
            NSDictionary *d2 = (NSDictionary *)obj2;
            NSString *hours1 = [d objectForKey:timeKey];
            hours1 = [hours1 stringByReplacingOccurrencesOfString:@":" withString:@""];
            int time1 = [hours1 intValue];
            NSString *hours2 = [d2 objectForKey:timeKey];
            hours2 = [hours2 stringByReplacingOccurrencesOfString:@":" withString:@""];
            int time2 = [hours2 intValue];
            return time1 > time2;
        }];
    }
    
    //arr = [[arr reverseObjectEnumerator] allObjects];
    for (int i = 0; [arr count] > i; i++) {
        NSDictionary *item_dict = arr[i];
        [self addLabel:item_dict dynamic:isDynamic];
    }
    if (lastColorToBgColor) {//是否使用最后一个颜色填充容器背景色
        [self.backgroundCtrl lastColorToBackground];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //NSLog(@"viewDidAppear");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addLabel:(NSDictionary *)item_dict dynamic:(BOOL)isDynamic
{
    NSString *time = [item_dict objectForKey:@"time"];
    NSString *text = [item_dict objectForKey:@"desc"];
    NSString *seconds = [item_dict objectForKey:@"seconds"];
    UIView *view = [self createItemCt];
    view.seconds = seconds;
    [self createItemTime:time andView:view dynamic:isDynamic];
    [self createItemLabel:text andView:view];
    [self.backgroundCtrl setColorWithIndex:[self.view.subviews count]];
}
-(CGFloat)getItemTop
{
    NSInteger itemCount = [self.view.subviews count];
    CGFloat topPadding = 0;//self.parentViewController.topLayoutGuide.length;
    CGFloat top = itemCount * (topPadding + LABEL_HEIGHT);
    return  top;
}

//创建项目容器
-(UIView *)createItemCt
{
    UIView *view = [[UIView alloc] init];
    CGFloat topPadding = [self getItemTop];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewDict = @{@"view":view};
    [self.view addSubview:view];
    view.backgroundColor = [hbsGenerator getViewHBS:[viewLefts count]];
    NSArray *layout = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]|" options:0 metrics:nil views:viewDict];
    NSArray *layout2 = [NSLayoutConstraint
                        constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[view]",topPadding]
                        options:0
                        metrics:nil
                        views:viewDict];
    NSLayoutConstraint *height = [NSLayoutConstraint
                                  constraintWithItem:view
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                  constant:LABEL_HEIGHT];
    [self.view addConstraints:layout];
    [self.view addConstraints:layout2];
    [self.view addConstraint:height];
    //[viewLefts addObject:layout[0]];

    return view;
}
//在容器中添加一个按钮 用于显示时间
-(void)createItemTime:(NSString *)text andView:(UIView *)itemView dynamic:(BOOL)isDynamic
{
    UIButton *btn = [[UIButton alloc] init];
    NSString * btnLeft = [NSString stringWithFormat:@"H:|-%f-[btn]|",
                          isDynamic ? LABEL_LEFT_PADDING : LABEL_LEFT_PADDING_ONOPEN];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitle:text forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    btn.titleLabel.lineBreakMode = NSLineBreakByClipping;
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *btnDict = @{@"btn":btn};
    [itemView addSubview:btn];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSArray *layout = [NSLayoutConstraint constraintsWithVisualFormat:btnLeft options:0 metrics:nil views:btnDict];
    NSArray *layout2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btn]|" options:0 metrics:nil views:btnDict];
    NSLayoutConstraint *height = [NSLayoutConstraint
                                  constraintWithItem:btn
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                  constant:LABEL_HEIGHT];
    [self.view addConstraints:layout];
    [self.view addConstraints:layout2];
    [self.view addConstraint:height];
    btn.userInteractionEnabled = NO;
    [self.timeLabels addObject:btn];
    
    [viewLefts addObject:layout[0]];
}
//在容器中添加一个按钮 用于显示描述
-(void)createItemLabel:(NSString *)text andView:(UIView *)itemView
{
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitle:text forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *btnDict = @{@"btn":btn};
    [itemView addSubview:btn];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSArray *layout = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[btn]|" options:0 metrics:nil views:btnDict];
    NSArray *layout2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[btn]|" options:0 metrics:nil views:btnDict];
    NSLayoutConstraint *height = [NSLayoutConstraint
                                  constraintWithItem:btn
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:1
                                  constant:LABEL_HEIGHT];
    [self.view addConstraints:layout];
    [self.view addConstraints:layout2];
    [self.view addConstraint:height];
    btn.userInteractionEnabled = NO;
    [self.timeDescriptions addObject:btn];
}
-(void)expandWithDuration:(NSTimeInterval)time{
    CGFloat left = isOpen == YES ? LABEL_LEFT_PADDING_ONOPEN : LABEL_LEFT_PADDING;
    NSInteger i ;
    NSLayoutConstraint *layout;
    for (i = 0; i < [viewLefts count]; i++) {
        layout = (NSLayoutConstraint *)viewLefts[i];
        layout.constant = left;
    }
    isOpen =  isOpen == YES ? NO : YES;
    [UIView animateWithDuration:time animations:^{
        [self.view layoutIfNeeded];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
