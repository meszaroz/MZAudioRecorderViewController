//
//  MZAudioRecorderControllerProtocol.h
//
//  Created by Mészáros Zoltán on 2016. 12. 05..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDoubleRange.h"

@class MZAudioRecorderController;
@class MZAudioPower;

@protocol MZAudioRecorderControllerDelegate <NSObject>
@optional
- (void)audioRecorderController:(MZAudioRecorderController* _Nullable)controller
didChangeStateWithTransitionFromState:(NSString* _Nullable)fromState
                        toState:(NSString* _Nonnull)toState;
- (void)audioRecorderController:(MZAudioRecorderController* _Nullable)controller
           powerMetersDidChange:(MZAudioPower* _Nonnull)power
                     forChannel:(NSUInteger)channel;
- (void)audioRecorderController:(MZAudioRecorderController* _Nullable)controller
           elapsedTimeDidChange:(NSTimeInterval)time;
- (void)audioRecorderController:(MZAudioRecorderController* _Nullable)controller
activeAudioObjectElapsedTimeDidChange:(NSTimeInterval)elapsedTime
                        inState:(NSString* _Nonnull)state;
@end
