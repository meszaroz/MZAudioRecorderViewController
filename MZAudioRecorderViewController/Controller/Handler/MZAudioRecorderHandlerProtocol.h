//
//  MZAudioRecorderHandlerProtocol.h
//
//  Created by Mészáros Zoltán on 2016. 12. 05..
//  Copyright © 2016. Mészáros Zoltán. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "NSDoubleRange.h"
#import "MZAudioRecorderConstants.h"

@class MZAudioRecorderController;
@class MZAudioPower;

@protocol AVAudioProtocol;

typedef void (^AssetWithRangeCompletion)(AVURLAsset* _Nonnull);

@protocol MZAudioRecorderControllerHandler <NSObject>
@required
- (AVURLAsset* _Nullable)audioRecorderControllerRecordedAsset:(MZAudioRecorderController* _Nullable)controller;

- (id<AVAudioProtocol> _Nullable)audioRecorderControllerActiveAudioObject:(MZAudioRecorderController* _Nullable)controller;
- (id<AVAudioProtocol> _Nullable)audioRecorderController:(MZAudioRecorderController* _Nullable)controller
    activateAudioObjectWithType:(MZAudioObjectType)type
                        andInfo:(NSDictionary<NSString*,id>* _Nullable)info;
- (BOOL)audioRecorderControllerDeactivateActiveAudioObject:(MZAudioRecorderController* _Nullable)controller;

@optional
- (void)audioRecorderController:(MZAudioRecorderController* _Nullable)controller
 recordedAssetWithRelativeRange:(NSDoubleRange)range
                  andCompletion:(AssetWithRangeCompletion _Nullable)completion;
@end
