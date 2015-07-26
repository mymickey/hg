//
//  BackgroundController.m
//  hg
//
//  Created by mickey on 15/2/18.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "BackgroundController.h"
#import "HBSGenerator.h"
@interface BackgroundController()
{
    HBSGenerator *hbsGenerator;
}
@end
@implementation BackgroundController
-(instancetype)init
{
    self = [super init];
    [self initHBS];
    return self;
}
-(void)initHBS
{
    hbsGenerator = [HBSGenerator new];
}
-(void)setColorWithIndex:(NSInteger)index
{
    self.view.backgroundColor = [hbsGenerator getViewHBS:index];
}
//在历史记录的情况下用最后一条记录的背景色充填视图背景色
-(void)lastColorToBackground
{
    NSArray * subviews = self.view.subviews;
    UIView * lastView = [subviews lastObject];
    UIColor *lastColor;
    if (lastView) {
        lastColor = lastView.backgroundColor;
    }
    else{
        HBSGenerator * generator = [HBSGenerator new];
        lastColor = [generator getViewHBS:0];
    }
    self.view.backgroundColor = lastColor;
}
@end
