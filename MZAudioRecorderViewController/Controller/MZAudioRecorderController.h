//
//  MZAudioRecorderController.h
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 08..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import "NSDoubleRange.h"

@protocol MZAudioRecorderControllerDelegate;
@protocol MZAudioRecorderControllerHandler;

@interface MZAudioRecorderController : NSObject

@property(nullable, nonatomic, readonly) NSString *currentState;

@property(nullable, weak, nonatomic) id<MZAudioRecorderControllerDelegate> delegate;
@property(nullable, weak, nonatomic) id<MZAudioRecorderControllerHandler > handler;

- (instancetype _Nonnull)initWithDelegate:(id<MZAudioRecorderControllerDelegate> _Nullable)delegate
                               andHandler:(id<MZAudioRecorderControllerHandler > _Nullable)handler;

- (BOOL)isInState:(NSString* _Nonnull)name;

- (void)startAudioCapture;
- (void)stopAudioCaptureAndPlay;
- (void)pauseAudioCaptureAndPlay;
- (void)proceedAudioCaptureOrPlay;
- (void)playCapturedAudio;

@end

@interface MZAudioRecorderController(Range)

- (void)playCapturedAudioWithRelativeRange:(NSDoubleRange)range;

@end
