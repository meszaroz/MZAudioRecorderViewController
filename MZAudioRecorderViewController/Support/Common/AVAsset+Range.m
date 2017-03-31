//
//  AVAsset+Range.m
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 05..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import "AVAsset+Range.h"

static const NSUInteger kDefaultTimeScale = 44100;

@implementation AVAsset(Range)

+ (CMTimeRange)timeRangeOfAsset:(AVAsset *)asset fromRelativeRange:(NSDoubleRange)range withTimescale:(int)timescale {
    return asset && (range.location >= 0) && ((range.location+range.length) <= 1) ?
        [asset timeRangeFromRelativeRange:range withTimescale:timescale] :
        CMTimeRangeMake(kCMTimeZero, kCMTimePositiveInfinity);
}

- (CMTimeRange)timeRangeFromRelativeRange:(NSDoubleRange)range {
    return [self timeRangeFromRelativeRange:range withTimescale:kDefaultTimeScale];
}

- (CMTimeRange)timeRangeFromRelativeRange:(NSDoubleRange)range withTimescale:(int)timescale {
    Float64 duration = CMTimeGetSeconds(self.duration);
    return CMTimeRangeMake(CMTimeMakeWithSeconds(duration * range.location, kDefaultTimeScale),
                           CMTimeMakeWithSeconds(duration * range.length  , kDefaultTimeScale));
}

@end
