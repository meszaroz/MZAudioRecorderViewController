//
//  AVAudioProtocol.h
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 07..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MZAudioRecorderConstants.h"

@protocol AVAudioProtocol <NSObject>

/* common */
@property(nonatomic, readonly, getter=isRunning) BOOL running;
- (void)setActive:(BOOL)active;

- (BOOL)prepareToStart;
- (BOOL)start;
- (BOOL)startAtTime:(NSTimeInterval)time;

/* control */
- (void)pause;
- (void)stop;

/* info */
@property(readonly, nullable) NSURL *url;
@property(readonly, nonnull) NSDictionary<NSString *, id> *settings;
@property(readonly, nonnull) AVAudioFormat *format;
#if TARGET_OS_IPHONE
@property(nonatomic, copy, nullable) NSArray<AVAudioSessionChannelDescription *> *channelAssignments;
#endif

@property(readonly) MZAudioObjectType type;
@property(readonly) NSUInteger numberOfChannels;
@property(readonly) NSTimeInterval duration;

/* current time */
@property(readonly) NSTimeInterval currentTime;
@property(readonly) NSTimeInterval deviceCurrentTime;

/* metering */
@property(getter=isMeteringEnabled) BOOL meteringEnabled;

- (void)updateMeters;
- (float)peakPowerForChannel:(NSUInteger)channelNumber;
- (float)averagePowerForChannel:(NSUInteger)channelNumber;

@end




