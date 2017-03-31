//
//  AVAsset+NumberOfChannels.m
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 10..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import "AVAsset+NumberOfChannels.h"

@implementation AVAsset(NumberOfChannels)

- (NSUInteger)numberOfChannels {
    NSUInteger out = 0;
    AVAssetTrack* songTrack = self.tracks ? self.tracks[0] : nil;
    NSArray* formatDesc = songTrack ? songTrack.formatDescriptions : @[];
    for (NSUInteger i = 0; i < formatDesc.count; ++i) {
        CMAudioFormatDescriptionRef item = (__bridge CMAudioFormatDescriptionRef)formatDesc[i];
        const AudioStreamBasicDescription* streamDesc = CMAudioFormatDescriptionGetStreamBasicDescription(item);
        if (streamDesc) {
            out = streamDesc->mChannelsPerFrame;
        }
    }
    return out;
}

@end
