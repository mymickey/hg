//
//  NSArray+slice.h
//  hg
//
//  Created by mickey on 15/2/21.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (slice)
- (NSArray *)WSS_arrayBySlicingFrom:(NSInteger)start to:(NSInteger)stop;
@end
