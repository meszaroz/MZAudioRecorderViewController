//
//  MZAudioRecorderHandler.h
//  MZAudioRecorderViewController
//
//  Created by Mészáros Zoltán on 2017. 02. 07..
//  Copyright © 2017. Mészáros Zoltán. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MZAudioRecorderHandlerProtocol.h"

extern NSString * _Nonnull kPlayerRelativeStartTime;
extern NSString * _Nonnull kPlayerRelativeDuration;

@interface MZAudioRecorderHandler : NSObject <MZAudioRecorderControllerHandler>

@property(nullable, nonatomic, copy) __kindof NSDictionary<NSString *, id> *audioRecordSettings;

@end
