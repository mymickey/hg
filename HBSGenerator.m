//
//  HBSGenerator.m
//  hg
//
//  Created by mickey on 15/2/17.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "HBSGenerator.h"
typedef struct
{
    double h;       // angle in degrees [0 - 360]
    double s;       // percent [0 - 1]
    double b;       // percent [0 - 1]
} HSB;
@interface HBSGenerator()
{
    HSB hsb;
}
@end

@implementation HBSGenerator
-(instancetype)init
{
    self = [super init];
    [self initHSB];
    return self;
}
-(void)initHSB
{
    hsb.b = .80;
    hsb.s = .55;
    hsb.h = 186;
}
//-(UIColor *)getViewHBS:(NSInteger) i
//{
//    if (i == 0) {
//        return [UIColor colorWithHue:hsb.h / 360 saturation:hsb.s brightness:hsb.b alpha:1];;
//    }
//    CGFloat h = hsb.h;
//    if (h - 20 < 0) {
//        h = 360;
//    }
//    h -= 20;
//    hsb.h = h;
//    return [UIColor colorWithHue:hsb.h / 360 saturation:hsb.s brightness:hsb.b alpha:1];
//}
-(UIColor *)getViewHBS:(NSInteger)i
{
    HSB hsb2;
    hsb2.b = .80;
    hsb2.s = .55;
    hsb2.h = 186;
    HSB resultHSB;
    if (i == 0) {
        resultHSB = hsb2;
    }
    else{
        for (NSInteger j = 0; j<i; j++) {
            CGFloat h = hsb2.h;
            if (h - 20 < 0) {
                h = 360;
            }
            h -= 20;
            hsb2.h = h;
            
        }
        resultHSB = hsb2;
    }
    return [UIColor colorWithHue:resultHSB.h / 360 saturation:resultHSB.s brightness:resultHSB.b alpha:1];
}
@end
