//
//  BackgroundController.h
//  hg
//
//  Created by mickey on 15/2/18.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundController : NSObject
@property (strong,nonatomic) IBOutlet UIView * view;
-(void)setColorWithIndex:(NSInteger)index;
-(void)lastColorToBackground;
@end
