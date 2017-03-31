//
//  NSDictionary+AVAudio.m
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 10..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "NSDictionary+AVAudio.h"
#import "NSDictionary+AVFormat.h"

@implementation NSDictionary(Audio)

- (AudioFormatID)AVFormatID {
    NSNumber *value = [self valueForKey:AVFormatIDKey];
    return value ?
        (AudioFormatID)value.integerValue :
        0;
}

- (NSString*)AVFormatExtension {
    return [[NSDictionary AVFormatDictionary] objectForKey:@(self.AVFormatID)];
}

- (CGFloat)AVSampleRage {
    NSNumber *value = [self valueForKey:AVSampleRateKey];
    return value ?
        value.doubleValue :
        0;
}

- (NSUInteger)AVNumberOfChannels {
    NSNumber *value = [self valueForKey:AVNumberOfChannelsKey];
    return value ?
        value.integerValue :
        0;
}

@end

@implementation NSMutableDictionary(Audio)

- (BOOL)setAVFormatID:(AudioFormatID)formatID {
    AudioFormatID value = self.AVFormatID;
    BOOL out = value == 0 || value != formatID;
    if (out) {
        [self setValue:@(formatID) forKey:AVFormatIDKey];
    }
    return out;
}

- (BOOL)setAVSampleRate:(CGFloat)sampleRate {
    CGFloat value = self.AVSampleRage;
    BOOL out = value < 0.5 || value != sampleRate;
    if (out) {
        [self setValue:@(sampleRate) forKey:AVSampleRateKey];
    }
    return out;
}

- (BOOL)setAVNumberOfChannels:(NSUInteger)numberOfChannels {
    CGFloat value = self.AVNumberOfChannels;
    BOOL out = value == 0 || value != numberOfChannels;
    if (out) {
        [self setValue:@(numberOfChannels) forKey:AVNumberOfChannelsKey];
    }
    return out;
}

@end
