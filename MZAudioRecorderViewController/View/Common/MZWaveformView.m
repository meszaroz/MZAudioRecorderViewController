//
//  MZWaveformView.m
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2016. 12. 17..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <PureLayout.h>
#import "SCWaveformView+Reset.h"
#import "MZWaveformView.h"
#import "UIRangeSelector.h"

@implementation MZWaveformView

- (void)setAsset:(AVAsset *)asset animated:(BOOL)animated {
    [self resetProgress];
    
    void (^block)(void) = ^{ self.alpha = !asset ? 0.0 : 1.0; };
    if (animated) { [UIView animateWithDuration:0.4 animations:block]; }
    else          { block();                                           }
    
    [super setAsset:asset];
}

- (void)setAsset:(AVAsset *)asset {
    [self setAsset:asset animated:NO];
}

@end
