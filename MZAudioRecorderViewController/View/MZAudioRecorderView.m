//
//  MZAudioRecorderView.m
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 09..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import <PureLayout.h>
#import <SCWaveformView.h>
#import "MZAudioRecorderConstants.h"
#import "MZAudioRecorderController.h"
#import "MZAudioRecorderController_p.h"
#import "MZAudioRecorderView.h"
#import "MZViewButtonLayers.h"
#import "MZTimeLabel.h"
#import "MZAudioPower.h"
#import "MZCircularMeterLayer.h"
#import "UIView+Layout.h"
#import "UIRangeSelector.h"
#import "AVAsset+Range.h"
#import "SCWaveformView+Reset.h"

@implementation MZTimeLabel(DefaultAnimation)

+ (CABasicAnimation*)defaultAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @(0.0);
    animation.toValue   = @(1.0);
    animation.autoreverses = YES;
    animation.duration = 0.5;
    animation.repeatCount = HUGE_VAL;
    return animation;
}

- (void)startAnimation {
    [self startAnimation:[self.class defaultAnimation]];
}

@end

/* typedefs */
typedef NSArray<MZCircularMeterLayer*>             LayerArray;
typedef NSMutableArray<MZCircularMeterLayer*>      LayerMutableArray;
typedef NSMutableDictionary<NSString*,LayerArray*> LayerMutableDictionary;

/* private */
@interface MZAudioRecorderView() {
    NSArray<MZViewButtonLayers*> *_buttons;
    UIView *_waveformPlaceholderView;
}

@property (strong, nonatomic, readonly) SCWaveformView *waveformView;
@property (strong, nonatomic, readonly) MZTimeLabel *elapsedTimeLabel;

@property (nonatomic) BOOL timerUpdateEnabled;

@end

/* UI Button Constants */
static const CGFloat  kDefaultButtonCornerRadius = 45.0;
static       UIColor* kDefaultTintColor() { return [UIColor darkGrayColor]; };

/* Size Constants */
static const CGFloat kWaveformViewHeight = 80.0;

@implementation MZAudioRecorderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    self.tintColor = self.tintColor;
    [super willMoveToWindow:newWindow];
}

- (void)dealloc {
    if (_waveformView) {
        [_waveformView removeObserver:self forKeyPath:@"asset" context:nil];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    _recordButton.color = tintColor;
    _playButton  .color = tintColor;
    
    _waveformView.progressColor = tintColor;
    _waveformView.normalColor   = [tintColor colorWithAlphaComponent:0.7];
    
    [super setTintColor:tintColor];
}

# pragma mark - notifications
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(SCWaveformView*)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"asset"]) {
        [UIView animateWithDuration:kAnimationDuration
                         animations:^{ _waveformPlaceholderView.alpha = !object.asset ? 0.0 : 1.0; }];
    }
}

# pragma mark - Setup Components
- (void)initialize {
    [self setupControlButtons];
    [self setupWaveformView  ];
    [self setupTimeLabel     ];
    
    _timerUpdateEnabled = YES;
    self.tintColor = kDefaultTintColor();
}

- (void)setupControlButtons {
    _recordButton = [self createControlButton];
    _playButton   = [self createControlButton];
    
    [self autoDistributeSubviews:@[_recordButton,_playButton] onAxis:UIViewDistributeAxisHorizontal];
    [self audioRecorderController:nil didChangeStateWithTransitionFromState:nil toState:kStateIdle];
    
    _buttons = @[_recordButton, _playButton];
}

- (MZViewButtonLayers*)createControlButton {
    MZViewButtonLayers *out = [MZViewButtonLayers new];
    out.cornerRadius = kDefaultButtonCornerRadius;
    
    [self addSubview:out];
    [out autoConstrainAttribute:(ALAttribute)ALAxisHorizontal
                    toAttribute:(ALAttribute)ALAxisHorizontal
                         ofView:self
                     withOffset:-kSelectorViewInsets.top*2];
    
    return out;
}

- (void)setupWaveformView {
    _waveformPlaceholderView = [UIView new];
    _waveformPlaceholderView.alpha = 0.0;
    
    [self addSubview:_waveformPlaceholderView];
    [_waveformPlaceholderView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_waveformPlaceholderView autoPinEdgeToSuperviewEdge:ALEdgeLeft  ];
    [_waveformPlaceholderView autoPinEdgeToSuperviewEdge:ALEdgeRight ];
    [_waveformPlaceholderView autoSetDimension:ALDimensionHeight toSize:kWaveformViewHeight];
    
    _waveformView = [SCWaveformView new];
    _waveformView.precision       = 1;
    _waveformView.lineWidthRatio  = 1;
    _waveformView.channelsPadding = 10;
    [_waveformView addObserver:self forKeyPath:@"asset" options:NSKeyValueObservingOptionNew context:nil];
    
    [_waveformPlaceholderView addSubview:_waveformView];
    [_waveformView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2*kSelectorViewInsets.bottom];
    [_waveformView autoPinEdgeToSuperviewEdge:ALEdgeLeft   withInset:2*kSelectorViewInsets.left  ];
    [_waveformView autoPinEdgeToSuperviewEdge:ALEdgeRight  withInset:2*kSelectorViewInsets.right ];
    [_waveformView autoSetDimension:ALDimensionHeight toSize:kWaveformViewHeight];
    
    _rangeSelector = [UIRangeSelector new];
    [_waveformPlaceholderView addSubview:_rangeSelector];
    [_rangeSelector autoPinEdge:ALEdgeTop    toEdge:ALEdgeTop    ofView:_waveformView withOffset:-kSelectorViewInsets.top   ];
    [_rangeSelector autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_waveformView withOffset: kSelectorViewInsets.bottom];
    [_rangeSelector autoPinEdge:ALEdgeLeft   toEdge:ALEdgeLeft   ofView:_waveformView withOffset:-kSelectorViewInsets.left  ];
    [_rangeSelector autoPinEdge:ALEdgeRight  toEdge:ALEdgeRight  ofView:_waveformView withOffset: kSelectorViewInsets.right ];
    
    [_waveformView reloadAsset];
}

- (void)setupTimeLabel {
    _elapsedTimeLabel = [MZTimeLabel new];
    [self addSubview:_elapsedTimeLabel];
    [_elapsedTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0];
    [_elapsedTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft ];
    [_elapsedTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
}

@end

/* Layout */
@implementation MZAudioRecorderView(Layout)

- (void)invalidateLayoutBegin {
    _timerUpdateEnabled = NO;
    [self clearStrokeLayers];
    [_waveformView reloadAsset];
}

- (void)invalidateLayoutEnd {
    _timerUpdateEnabled = YES;
}

@end

/* Range */
@implementation MZAudioRecorderView(Range)

- (CMTimeRange)timeRange {
    return self.waveformView.progressTimeRange;
}

@end

/* Control */
@implementation MZAudioRecorderView(Control)

- (CMTimeRange)progressTimeRange {
    return _waveformView ?
        _waveformView.progressTimeRange :
        kCMTimeRangeZero;
}

- (void)setProgressTimeRange:(CMTimeRange)progressTimeRange {
    if (_waveformView) {
        _waveformView.progressTimeRange = progressTimeRange;
    }
}

- (NSTimeInterval)elapsedTime {
    return _elapsedTimeLabel.elapsedTime;
}

- (void)setElapsedTime:(NSTimeInterval)elapsedTime {
    _elapsedTimeLabel.elapsedTime = elapsedTime;
    if (_waveformView) {
        _waveformView.progressTime = CMTimeMakeWithSeconds(elapsedTime, (int32_t)kTimescale);
    }
}

- (AVAsset*)asset {
    return _waveformView ?
        _waveformView.asset :
        nil;
}

- (void)setAsset:(AVAsset *)asset {
    if (_waveformView) {
        _waveformView.asset = asset;
    }
}

- (void)setAngle:(CGFloat)angle forButton:(MZViewButtonLayers*)button atChannel:(NSUInteger)channel withAnimationDuration:(CGFloat)duration {
    if (_timerUpdateEnabled && button && channel < button.layers.count) {
        [button.layers[channel] animateStrokeToAngle:angle
                                        withDuration:duration];
    }
}

- (void)prepare {
    _recordButton.enabled = YES ; _recordButton.filled = YES; _recordButton.titleLabel.text = @"RECORD";
    _playButton  .enabled = NO  ; _playButton  .filled = NO ; _playButton  .titleLabel.text = @"PLAY";
    
    [self clearStrokeLayers];
    [self resetProgress];
    
    [_rangeSelector setSelectionEnabled:YES animated:YES];
}

- (void)stop {
    _recordButton.enabled = YES ; _recordButton.filled = YES; _recordButton.titleLabel.text = @"RECORD";
    _playButton  .enabled = YES ; _playButton  .filled = NO ; _playButton  .titleLabel.text = @"PLAY";
    
    [self resetStrokeLayers];
    [self resetProgress];
    
    [_rangeSelector setSelectionEnabled:YES animated:YES];
}

- (void)pause {
    _recordButton.enabled = YES ; _recordButton.filled = YES; _recordButton.titleLabel.text = @"CONTINUE";
    _playButton  .enabled = YES ; _playButton  .filled = NO ; _playButton  .titleLabel.text = @"STOP";
    [self resetStrokeLayers];
}

- (void)play {
    _recordButton.enabled = YES ; _recordButton.filled = NO ; _recordButton.titleLabel.text = @"PAUSE";
    _playButton  .enabled = YES ; _playButton  .filled = YES; _playButton  .titleLabel.text = @"STOP";
    [_rangeSelector setSelectionEnabled:NO animated:YES];
    self.progressTimeRange = [self.asset timeRangeFromRelativeRange:_rangeSelector.relativeValue];
}

- (void)record {
    _recordButton.enabled = YES ; _recordButton.filled = NO ; _recordButton.titleLabel.text = @"PAUSE";
    _playButton  .enabled = YES ; _playButton  .filled = YES; _playButton  .titleLabel.text = @"STOP";
    self.asset = nil;
    [_elapsedTimeLabel startAnimation];
}

@end

/* Support */
@implementation MZAudioRecorderView(Support)

- (void)clearStrokeLayers {
    for (MZViewButtonLayers *button in _buttons) {
        [button clearLayers];
    }
}

- (void)resetStrokeLayers {
    for (MZViewButtonLayers *button in _buttons) {
        for (NSUInteger i = 0; i < button.layers.count; ++i) {
            [self setAngle:0.0 forButton:button atChannel:i withAnimationDuration:kAnimationDuration];
        }
    }
}

- (void)resetProgress {
    [self setElapsedTime:0.0];
    [_elapsedTimeLabel stopAnimation];
}

@end
