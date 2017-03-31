//
//  AVAudioObject.m
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 10..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import "AVAudioObject.h"
#import "NSDictionary+AVAudio.h"

/* Recorder */
@implementation AVAudioRecorder(Protocol)

- (void)setActive:(BOOL)active {
    if (active) {
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    else {
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }
}

- (BOOL)isRunning {
    return self.isRecording;
}

- (BOOL)prepareToStart {
    return [self prepareToRecord];
}

- (BOOL)start {
    return [self record];
}

- (BOOL)startAtTime:(NSTimeInterval)time {
    return[self recordAtTime:time];
}

- (NSTimeInterval)duration {
    return self.currentTime;
}

- (NSUInteger)numberOfChannels {
    return self.settings.AVNumberOfChannels;
}

- (MZAudioObjectType)type {
    return MZAudioObjectTypeRecorder;
}

@end

/* Player */
@implementation AVAudioPlayer(Protocol)

- (void)setActive:(BOOL)active {
}

- (BOOL)isRunning {
    return self.isPlaying;
}

- (BOOL)prepareToStart {
    return [self prepareToPlay];
}

- (BOOL)start {
    return [self play];
}

- (BOOL)startAtTime:(NSTimeInterval)time {
    return [self playAtTime:time];
}

- (MZAudioObjectType)type {
    return MZAudioObjectTypePlayer;
}

@end
