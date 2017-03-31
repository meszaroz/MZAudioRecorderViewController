//
//  MZWaveformView.h
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2016. 12. 17..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import "SCWaveformView.h"

@interface MZWaveformView : SCWaveformView

- (void)setAsset:(AVAsset *)asset animated:(BOOL)animated;

@end
