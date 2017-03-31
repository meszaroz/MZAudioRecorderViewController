//
//  MZAudioRecorderController.m
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 08..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <TransitionKit/TransitionKit.h>
#import "MZAudioRecorderControllerProtocol.h"
#import "MZAudioRecorderHandlerProtocol.h"
#import "MZAudioRecorderController.h"
#import "MZAudioRecorderController_p.h"
#import "MZAudioRecorderHandler.h"
#import "MZAudioRecorderConstants.h"
#import "MZControlTimer.h"
#import "MZAudioPower.h"
#import "MZId.h"
#import "NSDictionary+AVAudio.h"
#import "AVAsset+Range.h"
#import "AVAudioProtocol.h"
#import "UIRangeSelector.h" /* move out ??? */

@interface MZAudioRecorderController () <MZControlTimerDelegate> {
    MZControlTimer *_timer;
    TKStateMachine *_stateMachine;
    NSDoubleRange _relativePlayRange;
}
@end

@implementation MZAudioRecorderController

- (instancetype)init {
    return [self initWithDelegate:nil andHandler:nil];
}

- (instancetype)initWithDelegate:(id<MZAudioRecorderControllerDelegate>)delegate
                      andHandler:(id<MZAudioRecorderControllerHandler> _Nullable)handler {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _handler  = handler;
        [self initialize];
    }
    return self;
}

# pragma mark - Setup Components
- (void)initialize {
    [self setupTimer       ];
    [self setupPlayRange   ];
    [self setupStateMachine];
}

- (void)setupTimer {
    _timer = [MZControlTimer timer];
    _timer.delegate = self;
}

- (void)setupPlayRange {
    _relativePlayRange = kDefaultRelativeRange;
}

- (void)setupStateMachine {
    TKState *state;
    
    /* create states */
    state = [TKState stateWithName:kStateIdle     ];
    [state setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self handleStateTransitionToIdle    :transition];
        [self notifyDelegateOfStateTransition:transition toState:state];
    }];
    TKState *idle = state;
    
    state = [TKState stateWithName:kStatePaused   ];
    [state setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self handleStateTransitionToPause   :transition];
        [self notifyDelegateOfStateTransition:transition toState:state];
    }];
    TKState *paused = state;
    
    state = [TKState stateWithName:kStateRecording];
    [state setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self handleStateTransitionToRecording:transition];
        [self notifyDelegateOfStateTransition :transition toState:state];
    }];
    TKState *recording = state;
    
    state = [TKState stateWithName:kStatePlaying  ];
    [state setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self handleStateTransitionToPlaying :transition];
        [self notifyDelegateOfStateTransition:transition toState:state];
    }];
    TKState *playing = state;
    
    /* create state machine with idle initial state */
    _stateMachine = [TKStateMachine new];
    [_stateMachine addStates:@[idle, paused, recording, playing]];
    _stateMachine.initialState = idle;
    
    /* create events */
    [_stateMachine addEvents:@[[TKEvent eventWithName:kEventStop   transitioningFromStates:@[      paused, recording, playing] toState:idle     ],
                               [TKEvent eventWithName:kEventPause  transitioningFromStates:@[              recording, playing] toState:paused   ],
                               [TKEvent eventWithName:kEventRecord transitioningFromStates:@[idle, paused                    ] toState:recording],
                               [TKEvent eventWithName:kEventPlay   transitioningFromStates:@[idle, paused                    ] toState:playing  ]]];
    
    /* activate the state machine */
    [_stateMachine activate];
}

#pragma mark - Needed Properties
- (NSString*)currentState {
    return _stateMachine ?
        _stateMachine.currentState.name :
        nil;
}

- (void)updateMeters {
    id<AVAudioProtocol> audioObject = self.activeAudioObject;
    if (_delegate && [_delegate respondsToSelector:@selector(audioRecorderController:powerMetersDidChange:forChannel:)]
     && audioObject && [audioObject isMeteringEnabled]) {
        [audioObject updateMeters];
        NSUInteger numberOfChannels = audioObject.numberOfChannels;
        for (NSUInteger channel = 0; channel < numberOfChannels; ++channel) {
            MZAudioPower *power = [MZAudioPower pairWithAveragePower:[audioObject averagePowerForChannel:channel]
                                                        andPeakPower:[audioObject peakPowerForChannel   :channel]];
            [_delegate audioRecorderController:self
                          powerMetersDidChange:power
                                    forChannel:channel];
        }
    }
}

- (void)updateElapsedTime {
    id<AVAudioProtocol> audioObject = self.activeAudioObject;
    if (audioObject
     && _delegate && [_delegate respondsToSelector:@selector(audioRecorderController:elapsedTimeDidChange:)]) {
        [_delegate audioRecorderController:self
                      elapsedTimeDidChange:audioObject.currentTime];
    }
}

#pragma mark - Transitions
- (void)notifyDelegateOfStateTransition:(TKTransition*)transition toState:(TKState*)state {
    if (_delegate && [_delegate respondsToSelector:@selector(audioRecorderController:didChangeStateWithTransitionFromState:toState:)]) {
        [_delegate audioRecorderController:self
     didChangeStateWithTransitionFromState:transition ? transition.sourceState.name : nil
                                   toState:state.name];
    }
}

- (void)handleStateTransitionToIdle:(TKTransition*)transition {
    _relativePlayRange = kDefaultRelativeRange;
    [_timer stop];
}

- (void)handleStateTransitionToPause:(TKTransition*)transition {
    [_timer stop];
}

- (void)handleStateTransitionToRecording:(TKTransition*)transition {
    [_timer start];
}

- (void)handleStateTransitionToPlaying:(TKTransition*)transition {
    [_timer start];
}

#pragma mark - State Getters
- (BOOL)isInState:(NSString*)name {
    return _stateMachine && name && [_stateMachine.currentState.name isEqualToString:name];
}

#pragma mark - Control Actions
- (void)proceedAudioCaptureOrPlay {
    id<AVAudioProtocol> audioObject = self.activeAudioObject;
    if (audioObject) {
        switch (audioObject.type) {
            case MZAudioObjectTypePlayer  : [self playCapturedAudio]; break;
            case MZAudioObjectTypeRecorder: [self startAudioCapture]; break;
            default:                                                  break;
        }
    }
}

- (void)stopAudioCaptureAndPlay {
    [_stateMachine fireEvent:kEventStop   userInfo:nil error:nil];
}

- (void)pauseAudioCaptureAndPlay {
    [_stateMachine fireEvent:kEventPause  userInfo:nil error:nil];
}

- (void)startAudioCapture {
    [_stateMachine fireEvent:kEventRecord userInfo:nil error:nil];
}

- (void)playCapturedAudio {
    [_stateMachine fireEvent:kEventPlay   userInfo:nil error:nil];
}

- (void)playCapturedAudioWithRelativeRange:(NSDoubleRange)range {
    _relativePlayRange = range;
    [self playCapturedAudio];
}

#pragma mark - MZControlTimerDelegate
- (BOOL)controlTimerDidStart:(MZControlTimer*)timer {
    id<AVAudioProtocol> audioObject = self.activeAudioObject;
    BOOL out = audioObject == nil;
    
    /* activate object */
    if (out && _handler) {
        /**/ if ([self isInState:kStatePlaying  ]) {
            audioObject = [_handler audioRecorderController:self
                                activateAudioObjectWithType:MZAudioObjectTypePlayer
                                                    andInfo:@{ kPlayerRelativeStartTime : @(_relativePlayRange.location) }];
        }
        else if ([self isInState:kStateRecording]) {
            audioObject = [_handler audioRecorderController:self
                                activateAudioObjectWithType:MZAudioObjectTypeRecorder
                                                    andInfo:nil];
        }
    }
    
    /* start object */
    out = audioObject != nil;
    if (out) {
        [audioObject start];
    }
    
    return out;
}

- (BOOL)controlTimerDidStop:(MZControlTimer*)timer {
    id<AVAudioProtocol> audioObject = self.activeAudioObject;
    BOOL out = audioObject != nil;
    if (out) {
        /**/ if ([self isInState:kStatePaused]) {
            [audioObject pause];
        }
        else if ([self isInState:kStateIdle  ] && _handler) {
            out = [_handler audioRecorderControllerDeactivateActiveAudioObject:self];
        }
    }
    return out;
}

- (BOOL)controlTimerDidFire:(MZControlTimer*)timer {
    [self checkActiveCondition];
    [self updateMeters     ];
    [self updateElapsedTime];
    return YES;
}

#pragma mark - support
- (void)checkActiveCondition {
    id<AVAudioProtocol> audioObject = self.activeAudioObject;
    if (audioObject
     && (   ( audioObject.currentTime > audioObject.duration*(_relativePlayRange.location+_relativePlayRange.length))
         || (!audioObject.isRunning                                                                                 ))) {
        [self stopAudioCaptureAndPlay];
    }
}

@end

@implementation MZAudioRecorderController(Private)

- (id<AVAudioProtocol>)activeAudioObject {
    return _handler ?
        [_handler audioRecorderControllerActiveAudioObject:self] :
        nil;
}

- (AVURLAsset*)recordedAsset {
    return _handler ?
        [_handler audioRecorderControllerRecordedAsset:self] :
        nil;
}

- (void)recordedAssetWithRelativeRange:(NSDoubleRange)range
                         andCompletion:(AssetWithRangeCompletion _Nullable)completion {
    if (_handler && [_handler respondsToSelector:@selector(audioRecorderController:recordedAssetWithRelativeRange:andCompletion:)]) {
        [_handler audioRecorderController:self
           recordedAssetWithRelativeRange:range
                            andCompletion:completion];
    }
}

@end



