//
//  ViewController.h
//  hg
//
//  Created by mickey on 14-9-20.
//  Copyright (c) 2014年 mickey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeOperationController.h"
@interface ViewController : UIViewController
@property (strong, nonatomic) HomeOperationController *homeOpCtrl;
-(UIColor *)getViewBgColor;
@end
