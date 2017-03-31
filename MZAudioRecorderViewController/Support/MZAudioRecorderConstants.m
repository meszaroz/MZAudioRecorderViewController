//
//  MZAudioRecorderConstants.m
//
//  Created by Mészáros Zoltán on 2016. 12. 05..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#include "MZAudioRecorderConstants.h"

/* State Machine Constants - State */
NSString * _Nonnull kStateIdle      = @"Idle";
NSString * _Nonnull kStatePaused    = @"Paused";
NSString * _Nonnull kStateRecording = @"Recording";
NSString * _Nonnull kStatePlaying   = @"Playing";

/* State Machine Constants - Event */
NSString * _Nonnull kEventStop   = @"Stop";
NSString * _Nonnull kEventPause  = @"Pause";
NSString * _Nonnull kEventRecord = @"Record";
NSString * _Nonnull kEventPlay   = @"Play";

/* Timer Constants */
const NSTimeInterval kTimerInterval     = 0.1;
const NSUInteger     kTimerFrequency    = 1/kTimerInterval;
const NSUInteger     kTimescale         = 1000000;
const NSTimeInterval kAnimationDuration = 4*kTimerInterval;

/* Helper */
@implementation MZAudioRecorderConstants : NSObject

+ (NSArray *  _Nonnull)stateMachineStates {
    static NSArray* out = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        out = @[kStateIdle,
                kStatePaused,
                kStateRecording,
                kStatePlaying];
    });
    return out;
}

+ (NSArray *  _Nonnull)stateMachineEvents {
    static NSArray* out = nil;
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        out = @[kEventStop,
                kEventPause,
                kEventRecord,
                kEventPlay];
    });
    return out;
}

@end
