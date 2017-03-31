//
//  AVAsset+NumberOfChannels.h
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 10..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAsset(NumberOfChannels)

- (NSUInteger)numberOfChannels;

@end
