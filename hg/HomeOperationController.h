//
//  HomeOperationController.h
//  hg
//
//  Created by mickey on 15/2/18.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingTimeViewController.h"
#import "TimeStore.h"
@interface HomeOperationController : NSObject<SettingTimeViewControllerDelegate,TimeStoreDelegate>
@property (strong,nonatomic) IBOutlet UINavigationController * navigationController;
-(void)hideBtns;
-(void)showBtns;
@end
