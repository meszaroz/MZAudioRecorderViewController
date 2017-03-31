//
//  MZAudioRecorderViewController.m
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 05..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <TransitionKit/TransitionKit.h>
#import <PureLayout.h>
#import "MZAudioRecorderConstants.h"
#import "MZAudioRecorderViewController.h"
#import "MZAudioRecorderControllerProtocol.h"
#import "MZAudioRecorderController.h"
#import "MZAudioRecorderController_p.h"
#import "MZAudioRecorderHandler.h"
#import "MZAudioRecorderView.h"
#import "MZViewButtonLayers.h"
#import "MZAudioPower.h"
#import "NSDoubleRange.h"
#import "UIRangeSelector.h"
#import "AVAsset+Range.h"

@interface MZAudioRecorderView(Protocol) <MZAudioRecorderControllerDelegate>
@end

@interface MZAudioRecorderViewController () <MZAudioRecorderControllerDelegate> {
    MZAudioRecorderController *_controller;
    MZAudioRecorderHandler    *_handler;
    MZAudioRecorderView       *_defaultView;
}

/* currently private, because of AssetExport supporting limited outputs */
@property(nullable, nonatomic, copy) __kindof NSDictionary<NSString *, id> *audioRecordSettings;

@property (strong, nonatomic, readonly) UIBarButtonItem *cancelBarButton;
@property (strong, nonatomic, readonly) UIBarButtonItem *doneBarButton;

/* helper properties */
@property(nullable, nonatomic, readonly) NSString *currentState;

@end

/* Title constants */
static NSString *kDefaultTitle = @"Audio Recorder";

@implementation MZAudioRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupComponents];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopAudioCaptureAndPlay];
    [super viewWillDisappear:animated];
}

# pragma mark - Setup Components
- (void)setupComponents {
    [self setupController ];
    [self setupBarButtons ];
    [self setupDefaultView];
}

- (void)setupController {
    _handler = [MZAudioRecorderHandler new];
    _controller = [[MZAudioRecorderController alloc] initWithDelegate:self andHandler:_handler];
}

- (void)setupBarButtons {
    _cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(action:)];
    _doneBarButton   = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone   target:self action:@selector(action:)];
    
    self.navigationItem.rightBarButtonItem = _doneBarButton;
    self.navigationItem.leftBarButtonItem  = _cancelBarButton;
    
    _doneBarButton.enabled = NO;
}

- (void)setupDefaultView {
    _defaultView = [MZAudioRecorderView new];
    _defaultView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_defaultView];
    [_defaultView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_defaultView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_defaultView autoPinEdgeToSuperviewEdge:ALEdgeLeft  ];
    [_defaultView autoPinEdgeToSuperviewEdge:ALEdgeRight ];
    
    /* setup control */
    [_defaultView.recordButton addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [_defaultView.playButton   addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Needed Properties
- (NSString*)currentState {
    return _controller.currentState;
}

- (__kindof NSDictionary<NSString *,id> *)audioRecordSettings {
    return _handler.audioRecordSettings;
}

- (void)setAudioRecordSettings:(__kindof NSDictionary<NSString *,id> *)audioRecordSettings {
    NSAssert(![self isViewLoaded],@"Property is allowed to be changed before view load!");
    _handler.audioRecordSettings = audioRecordSettings;
}

#pragma mark - overlay view
- (void)setShowsAudioRecorderControls:(BOOL)showsAudioRecorderControls {
    _defaultView.hidden = !showsAudioRecorderControls;
}

- (BOOL)showsAudioRecorderControls {
    return !_defaultView.hidden;
}

- (void)setAudioRecorderOverlayView:(__kindof UIView<MZAudioRecorderControllerDelegate> *)audioRecorderOverlayView {
    if (_audioRecorderOverlayView != audioRecorderOverlayView) {
        if (_audioRecorderOverlayView.superview == self.view) {
            [_audioRecorderOverlayView removeFromSuperview];
        }
        _audioRecorderOverlayView = audioRecorderOverlayView;
        if (_audioRecorderOverlayView) {
            NSAssert(_audioRecorderOverlayView.superview == nil, @"Overlay view must not have a superview!");
            [self.view addSubview:_audioRecorderOverlayView];
            [_audioRecorderOverlayView autoPinEdgesToSuperviewEdges];
        }
    }
}

#pragma mark - Actions
- (void)action:(id)sender {
    /**/ if (sender == _doneBarButton) {
        [_controller recordedAssetWithRelativeRange:_defaultView.rangeSelector.relativeValue
                                      andCompletion:^(AVURLAsset * _Nonnull asset) {
             if (_delegate && [_delegate respondsToSelector:@selector(audioRecorderViewController:willFinishEditingAsset:)]) {
                [_delegate audioRecorderViewController:self willFinishEditingAsset:asset];
            }
            [self dismissViewControllerAnimated:YES completion:^{
                if (_delegate && [_delegate respondsToSelector:@selector(audioRecorderViewController:didFinishEditingAsset:)]) {
                    [_delegate audioRecorderViewController:self didFinishEditingAsset:asset];
                }
            }];
        }];
    }
    else if (sender == _cancelBarButton) {
        if (_delegate && [_delegate respondsToSelector:@selector(audioRecorderViewControllerWillCancel:)]) {
            [_delegate audioRecorderViewControllerWillCancel:self];
        }
        [self dismissViewControllerAnimated:YES completion:^{
            if (_delegate && [_delegate respondsToSelector:@selector(audioRecorderViewControllerDidCancel:)]) {
                [_delegate audioRecorderViewControllerDidCancel:self];
            }
        }];
    }
    else if (sender == _defaultView.recordButton) {
        /**/ if ([self.currentState isEqualToString:kStateIdle     ]) { [self startAudioCapture        ]; }
        else if ([self.currentState isEqualToString:kStatePaused   ]) { [self proceedAudioCaptureOrPlay]; }
        else if ([self.currentState isEqualToString:kStateRecording]) { [self pauseAudioCaptureAndPlay ]; }
        else if ([self.currentState isEqualToString:kStatePlaying  ]) { [self pauseAudioCaptureAndPlay ]; }
    }
    else if (sender == _defaultView.playButton) {
        /**/ if ([self.currentState isEqualToString:kStateIdle     ]) { [self playCapturedAudio        ]; }
        else if ([self.currentState isEqualToString:kStatePaused   ]) { [self stopAudioCaptureAndPlay  ]; }
        else if ([self.currentState isEqualToString:kStateRecording]) { [self stopAudioCaptureAndPlay  ]; }
        else if ([self.currentState isEqualToString:kStatePlaying  ]) { [self stopAudioCaptureAndPlay  ]; }
    }
}

#pragma mark - State Getter
- (BOOL)isInState:(NSString*)name {
    return [_controller isInState:name];
}

#pragma mark - Control Actions
- (void)proceedAudioCaptureOrPlay {
    [_controller proceedAudioCaptureOrPlay];
}

- (IBAction)stopAudioCaptureAndPlay {
    [_controller stopAudioCaptureAndPlay];
}

- (IBAction)pauseAudioCaptureAndPlay {
    [_controller pauseAudioCaptureAndPlay];
}

- (IBAction)startAudioCapture {
    [_controller startAudioCapture];
}

- (IBAction)playCapturedAudio {
    [_controller playCapturedAudioWithRelativeRange:_defaultView.rangeSelector.relativeValue];
}

#pragma mark - AudioRecorderControllerDelegate
- (void)audioRecorderController:(MZAudioRecorderController* _Nullable)controller
didChangeStateWithTransitionFromState:(NSString* _Nullable)fromState
                        toState:(NSString* _Nonnull)toState {
    /* notify default view */
    [_defaultView audioRecorderController:controller
    didChangeStateWithTransitionFromState:fromState
                                  toState:toState];
    /* notify overlay view */
    if ( _audioRecorderOverlayView
     && [_audioRecorderOverlayView respondsToSelector:@selector(audioRecorderController:didChangeStateWithTransitionFromState:toState:)]) {
        [_audioRecorderOverlayView audioRecorderController:controller
                     didChangeStateWithTransitionFromState:fromState
                                                   toState:toState];
    }
    
    /* update UI */
    NSString *title = toState;
    /**/ if ([toState isEqualToString:kStateIdle]) {
        _doneBarButton.enabled = fromState != nil;
        title = kDefaultTitle;
    }
    else if ([toState isEqualToString:kStateRecording]) {
        _doneBarButton.enabled = NO;
    }
    self.title = title;
}

- (void)audioRecorderController:(MZAudioRecorderController* _Nullable)controller
           powerMetersDidChange:(MZAudioPower* _Nonnull)power
                     forChannel:(NSUInteger)channel {
    /* notify default view */
    [_defaultView audioRecorderController:controller
                     powerMetersDidChange:power
                               forChannel:channel];
    /* notify overlay view */
    if ( _audioRecorderOverlayView
     && [_audioRecorderOverlayView respondsToSelector:@selector(audioRecorderController:powerMetersDidChange:forChannel:)]) {
        [_audioRecorderOverlayView audioRecorderController:controller
                                      powerMetersDidChange:power
                                                forChannel:channel];
    }
}

- (void)audioRecorderController:(MZAudioRecorderController* _Nullable)controller
           elapsedTimeDidChange:(NSTimeInterval)time {
    /* notify default view */
    [_defaultView audioRecorderController:controller
                     elapsedTimeDidChange:time];
    
    /* notify overlay view */
    if ( _audioRecorderOverlayView
     && [_audioRecorderOverlayView respondsToSelector:@selector(audioRecorderController:elapsedTimeDidChange:)]) {
        [_audioRecorderOverlayView audioRecorderController:controller
                                      elapsedTimeDidChange:time];
    }
}

#pragma mark - transitions
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [_defaultView invalidateLayoutBegin];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [_defaultView invalidateLayoutEnd  ];
    }];
}

@end

/* DefaultView Control */
@implementation MZAudioRecorderView(Protocol)

- (NSDictionary<NSString*,MZViewButtonLayers*>*)buttons {
    return @{ kStateRecording : self.recordButton,
              kStatePlaying   : self.playButton   };

}

- (void)audioRecorderController:(MZAudioRecorderController* _Nullable)controller
didChangeStateWithTransitionFromState:(NSString* _Nullable)fromState
                        toState:(NSString* _Nonnull)toState {
    /**/ if ([toState isEqualToString:kStateIdle]) {
        if (!fromState) {
            [self prepare];
        }
        else {
            if ([fromState isEqualToString:kStateRecording]) {
                self.asset = controller.recordedAsset;
                [self.rangeSelector reset];
            }
            [self stop];
        }        
    }
    else if ([toState isEqualToString:kStatePaused]) {
        [self pause ];
    }
    else if ([toState isEqualToString:kStateRecording]) {
        [self record];
    }
    else if ([toState isEqualToString:kStatePlaying]) {
        [self play  ];
    }
}

- (void)audioRecorderController:(MZAudioRecorderController* _Nullable)controller
           powerMetersDidChange:(MZAudioPower* _Nonnull)power
                     forChannel:(NSUInteger)channel {
    [self setAngle:power.averageAngle
         forButton:self.buttons[controller.currentState]
         atChannel:channel
withAnimationDuration:kTimerInterval];
}

- (void)audioRecorderController:(MZAudioRecorderController* _Nullable)controller
           elapsedTimeDidChange:(NSTimeInterval)time {
    self.elapsedTime = time;
}

@end
