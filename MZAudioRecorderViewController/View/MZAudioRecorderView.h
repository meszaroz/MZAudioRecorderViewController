//
//  MZAudioRecorderView.h
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 09..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZAudioRecorderControllerProtocol.h"

@class MZViewButtonLayers;
@class UIRangeSelector;

@interface MZAudioRecorderView : UIView <MZAudioRecorderControllerDelegate>

@property (strong, nonatomic, readonly) MZViewButtonLayers *recordButton;
@property (strong, nonatomic, readonly) MZViewButtonLayers *playButton;
@property (strong, nonatomic, readonly) UIRangeSelector *rangeSelector;

@end

@interface MZAudioRecorderView(Layout)

- (void)invalidateLayoutBegin;
- (void)invalidateLayoutEnd;

@end

@interface MZAudioRecorderView(Range)

- (CMTimeRange)timeRange;

@end

@interface MZAudioRecorderView(Control)

@property (nonatomic) CMTimeRange progressTimeRange;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic) AVAsset* asset;

- (void)setAngle:(CGFloat)angle forButton:(MZViewButtonLayers*)button atChannel:(NSUInteger)channel withAnimationDuration:(CGFloat)duration;

- (void)prepare;
- (void)stop;
- (void)pause;
- (void)play;
- (void)record;

@end

@interface MZAudioRecorderView(Support)

- (void)clearStrokeLayers;
- (void)resetStrokeLayers;
- (void)resetProgress;

@end
