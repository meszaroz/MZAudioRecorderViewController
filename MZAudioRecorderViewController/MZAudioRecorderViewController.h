//
//  MZAudioRecorderViewController.h
//  Custom Memory Game
//
//  Created by Mészáros Zoltán on 2016. 12. 05..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZAudioRecorderViewControllerProtocol.h"
#import "NSDoubleRange.h"

@protocol MZAudioRecorderControllerDelegate;

@interface MZAudioRecorderViewController : UIViewController

@property(nonatomic) BOOL showsAudioRecorderControls;
@property(nullable, nonatomic, strong) __kindof UIView<MZAudioRecorderControllerDelegate> *audioRecorderOverlayView;

@property(nullable, nonatomic, weak)  id <MZAudioRecorderViewControllerDelegate> delegate;

- (BOOL)isInState:( NSString* _Nonnull )name;

- (IBAction)startAudioCapture;
- (IBAction)stopAudioCaptureAndPlay;
- (IBAction)pauseAudioCaptureAndPlay;
- (IBAction)proceedAudioCaptureOrPlay;
- (IBAction)playCapturedAudio;

@end
