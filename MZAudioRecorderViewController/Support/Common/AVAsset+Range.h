//
//  AVAsset+Range.h
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 05..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "NSDoubleRange.h"

@interface AVAsset(Range)

- (CMTimeRange)timeRangeFromRelativeRange:(NSDoubleRange)range;
- (CMTimeRange)timeRangeFromRelativeRange:(NSDoubleRange)range withTimescale:(int)timescale;
+ (CMTimeRange)timeRangeOfAsset:(AVAsset*)asset fromRelativeRange:(NSDoubleRange)range withTimescale:(int)timescale;

@end
