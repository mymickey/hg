//
//  UIView+ItemDate.m
//  hg
//
//  Created by mickey on 15/4/19.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "UIView+ItemDate.h"
#import <objc/runtime.h>
NSString const *key = @"my.very.unique.key";
@implementation UIView (ItemDate)

-(void)setSeconds:(NSString *)se
{
    objc_setAssociatedObject(self,&key,se,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)seconds
{
    return objc_getAssociatedObject(self, &key);
}
@end
