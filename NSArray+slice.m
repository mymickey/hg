//
//  NSArray+slice.m
//  hg
//
//  Created by mickey on 15/2/21.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "NSArray+slice.h"


// Python allows skipping any of the indexes of a slice and supplies default
// values. Skipping an argument to a method is not possible, so (ab)use
// NSNotFound as "not specified" index value. The other way to do this would
// be with varargs, which might be even handier if one decided to implement
// the stride functionality.
enum {
    WSS_SliceNoIndex = NSNotFound
};

@implementation NSArray (slice)

- (NSArray *)WSS_arrayBySlicingFrom:(NSInteger)start to:(NSInteger)stop {
    // There's an important caveat here: specifying the parameters as
    // NSInteger allows negative indexes, but limits the method's
    // (theoretical) use: the maximum size of an NSArray is NSUIntegerMax,
    // which is quite a bit larger than NSIntegerMax.
    NSUInteger count = [self count];
    
    // Due to this caveat, bail if the array is too big.
    if( count >= NSIntegerMax ) return nil;
    
    // Define default start and stop
    NSInteger defaultStart = 0;
    NSInteger defaultStop = count;
    
    // Set start to default if not specified
    if( start == WSS_SliceNoIndex ){
        start = defaultStart;
    }
    else {
        // If start is negative, change it to the correct positive index.
        if( start < 0 ) start += count;
        // Correct for out-of-bounds index:
        // If it's _still_ negative, set it to 0
        if( start < 0 ) start = 0;
        // If it's past the end, set it to just include the last item
        if( start > count ) start = count;
    }
    
    // Perform all the same calculations on stop
    if( stop == WSS_SliceNoIndex ){
        stop = defaultStop;
    }
    else {
        if( stop < 0 ) stop += count;
        if( stop < 0 ) stop = 0;
        if( stop > count ) stop = count;
    }
    
    // Calculate slice length with corrected indexes
    NSInteger sliceLength = stop - start;
    
    // If no slice, return a new empty array
    if( sliceLength <= 0 ){
        return [NSArray array];
    }
    else {
        return [self subarrayWithRange:(NSRange){start, sliceLength}];
    }
    
}
@end