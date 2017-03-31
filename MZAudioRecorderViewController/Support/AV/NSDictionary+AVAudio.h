//
//  NSDictionary+AVAudio.h
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 10..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDictionary(AVAudio)

- (AudioFormatID)AVFormatID;
- (NSString*)AVFormatExtension;
- (CGFloat)AVSampleRage;
- (NSUInteger)AVNumberOfChannels;

@end

@interface NSMutableDictionary(AVAudio)

- (BOOL)setAVFormatID:(AudioFormatID)formatID;
- (BOOL)setAVSampleRate:(CGFloat)sampleRate;
- (BOOL)setAVNumberOfChannels:(NSUInteger)numberOfChannels;

@end
