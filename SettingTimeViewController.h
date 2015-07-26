//
//  SettingTimeViewController.h
//  hg
//
//  Created by mickey on 15/2/16.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingTimeViewControllerDelegate<NSObject>
-(void)onSettingTimeViewCtrlClose:(UIViewController *)ctrl;
@end

@interface SettingTimeViewController : UIViewController
@property (nonatomic,assign) id<SettingTimeViewControllerDelegate> delegate;

@end
