//
//  HColumnViewController.h
//  hg
//  列头
//  Created by mickey on 14/11/2.
//  Copyright (c) 2014年 mickey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HColumnViewController : UIViewController
-(instancetype)initWithLabelData:(NSDictionary *)dict;
-(void)expandWithDuration:(NSTimeInterval)t;
@end
