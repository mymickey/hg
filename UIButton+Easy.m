//
//  UIButton+Easy.m
//  hg
//
//  Created by mickey on 15/4/17.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "UIButton+Easy.h"

@implementation UIButton (Easy)
-(void)setHidden:(BOOL)hidden andDuration:(NSTimeInterval)time
{
    UIButton * __weak me = self;
    CGFloat i = hidden ? 0 : 1;
    if (me.hidden == YES) {
        me.alpha = 0;
        me.hidden = NO;
    }
    else if (!hidden) {
        me.hidden = NO;
    }
    [UIView animateWithDuration:time animations:^{
        me.alpha = i;
    } completion:^(BOOL finished){
        me.hidden = hidden;
    }];
}
@end
