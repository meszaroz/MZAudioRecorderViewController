//
//  MZAudioRecorderConstants.h
//
//  Created by Mészáros Zoltán on 2016. 12. 05..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#include <Foundation/Foundation.h>

/* State Machine Constants - States */
extern NSString * _Nonnull kStateIdle;
extern NSString * _Nonnull kStatePaused;
extern NSString * _Nonnull kStateRecording;
extern NSString * _Nonnull kStatePlaying;

typedef NS_ENUM(NSUInteger, MZAudioRecorderState) {
    MZAudioRecorderStateIdle = 0,
    MZAudioRecorderStatePaused,
    MZAudioRecorderStateRecording,
    MZAudioRecorderStatePlaying,
};

/* State Machine Constants - Events */
extern NSString * _Nonnull kEventStop;
extern NSString * _Nonnull kEventPause;
extern NSString * _Nonnull kEventRecord;
extern NSString * _Nonnull kEventPlay;

typedef NS_ENUM(NSUInteger, MZAudioRecorderEvent) {
    MZAudioRecorderEventStop = 0,
    MZAudioRecorderEventPause,
    MZAudioRecorderEventRecord,
    MZAudioRecorderEventPlay,
};

/* Timer Constants */
extern const NSTimeInterval kTimerInterval;
extern const NSUInteger     kTimerFrequency;
extern const NSUInteger     kTimescale;
extern const NSTimeInterval kAnimationDuration;

/* Other */
typedef NS_ENUM(NSUInteger, MZAudioObjectType) {
    MZAudioObjectTypeUnknown = 0,
    MZAudioObjectTypeRecorder,
    MZAudioObjectTypePlayer
};

/* Helper */
@interface MZAudioRecorderConstants : NSObject

+ (NSArray * _Nonnull)stateMachineStates;
+ (NSArray * _Nonnull)stateMachineEvents;

@end

