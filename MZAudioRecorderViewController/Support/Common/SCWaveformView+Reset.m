//
//  SCWaveformView+Reset.m
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 26..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import "SCWaveformView+Reset.h"

@implementation SCWaveformView(Reset)

- (void)resetProgress {
    self.progressTime = kCMTimeZero;
}

- (void)reloadAsset {
    self.asset = self.asset;
}

@end
